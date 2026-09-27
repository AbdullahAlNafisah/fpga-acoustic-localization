"""Regenerate the README figures from the data in this repo.

    python docs/make_figures.py

Writes light and dark SVGs to docs/img/.
"""
import glob
import os
import re

import matplotlib
import matplotlib.ticker
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "docs", "img")

THEMES = {
    "light": dict(text="#0b0b0b", muted="#52514e", grid="#e4e3df", s1="#2a78d6", s2="#eb6834", ref="#8a8984"),
    "dark": dict(text="#f0f6fc", muted="#c3c2b7", grid="#30363d", s1="#3987e5", s2="#d95926", ref="#8b949e"),
}

# Signal parameters from matlab/experiments/FPGA_Sim.m
FS = 200_000
F_CARR = 20_000
N_ZC = 16
SPB = 256
C_SOUND = 343.0

# Results are plotted up to 1 m
MAX_D = 1.0
OUTLIER_RUN = 0.75


def style(ax, t):
    ax.set_facecolor("none")
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(t["grid"])
    ax.tick_params(colors=t["muted"], labelsize=9, length=0, pad=6)
    ax.grid(True, color=t["grid"], linewidth=0.8)
    ax.set_axisbelow(True)
    ax.xaxis.label.set_color(t["muted"])
    ax.yaxis.label.set_color(t["muted"])


def title(ax, t, text):
    ax.set_title(text, loc="left", color=t["text"], fontsize=11, fontweight="bold", pad=10)


def save(fig, name, mode):
    os.makedirs(OUT, exist_ok=True)
    fig.savefig(os.path.join(OUT, f"{name}-{mode}.svg"), transparent=True, bbox_inches="tight")
    plt.close(fig)


def load_runs(folder):
    runs = []
    for f in glob.glob(os.path.join(ROOT, "data", "measurements", folder, "*.mat")):
        m = re.search(r"num([\d.]+)(c?m)\.mat$", f)
        d = float(m.group(1)) / (100 if m.group(2) == "cm" else 1)
        runs.append((d, sio.loadmat(f)["num"].ravel().astype(float) * 1e-6))
    return sorted(runs)


def keep(x, k):
    """Outlier rule from matlab/fpga_sim/uart_distance.m: within k std of the mean."""
    return x[np.abs(x - x.mean()) < k * x.std()]


def signal_chain(mode):
    t = THEMES[mode]
    k = np.arange(N_ZC)
    zc = np.exp(1j * np.pi * k**2 / N_ZC)
    base = np.repeat(zc, SPB)
    n = np.arange(base.size)
    tx = base.real * np.cos(2 * np.pi * F_CARR * n / FS) - base.imag * np.sin(2 * np.pi * F_CARR * n / FS)

    true_d = 1.0
    lag = int(round(true_d / C_SOUND * FS))
    rng = np.random.default_rng(7)
    rx = np.concatenate([np.zeros(lag), 0.4 * tx, np.zeros(2 * base.size - lag - tx.size)])
    rx = rx + 0.15 * rng.standard_normal(rx.size)
    m = np.arange(rx.size)
    bb = rx * np.exp(-2j * np.pi * F_CARR * m / FS)
    kernel = np.ones(40) / 40
    bb = np.convolve(bb, kernel, mode="same")
    ref = np.concatenate([base, np.zeros(rx.size - base.size)])
    corr = np.abs(np.fft.ifft(np.fft.fft(bb) * np.conj(np.fft.fft(ref))))
    corr /= corr.max()
    peak = int(np.argmax(corr))

    fig, axes = plt.subplots(3, 1, figsize=(8, 7.2), gridspec_kw=dict(hspace=0.75))
    ms = 1e3 / FS

    ax = axes[0]
    style(ax, t)
    ax.step(n * ms, base.real, where="post", color=t["s1"], lw=2, label="I")
    ax.step(n * ms, base.imag, where="post", color=t["s2"], lw=2, label="Q")
    ax.set_xlim(0, base.size * ms)
    ax.set_xlabel("time (ms)")
    title(ax, t, f"1. Zadoff-Chu code, N = {N_ZC}, {SPB} samples per chip ({base.size * ms:.1f} ms)")
    ax.set_ylim(-1.15, 1.6)
    ax.set_yticks([-1, 0, 1])
    ax.legend(loc="upper right", frameon=False, labelcolor=t["text"], fontsize=9, ncol=2, borderaxespad=0)

    ax = axes[1]
    style(ax, t)
    a, b = int(0.0060 * FS), int(0.0069 * FS)
    ax.plot(n[a:b] * ms, tx[a:b], color=t["s1"], lw=1.5)
    edge = 5 * SPB * ms
    ax.axvline(edge, color=t["ref"], lw=1, ls=(0, (4, 3)))
    ax.text(edge + 0.02, 1.25, "next chip: carrier phase jumps", color=t["muted"], fontsize=9)
    ax.set_xlim(a * ms, b * ms)
    ax.set_ylim(-1.4, 1.6)
    ax.set_yticks([-1, 0, 1])
    ax.set_xlabel("time (ms)")
    title(ax, t, f"2. Modulated onto a {F_CARR // 1000} kHz carrier and played by the transmitter")

    ax = axes[2]
    style(ax, t)
    ax.plot(m * ms, corr, color=t["s1"], lw=1.5)
    ax.axvline(peak * ms, color=t["ref"], lw=1, ls=(0, (4, 3)))
    ax.annotate(
        f"peak at {peak * ms:.2f} ms  →  {peak / FS * C_SOUND:.2f} m",
        xy=(peak * ms, 1), xytext=(peak * ms + 1.5, 0.82),
        color=t["text"], fontsize=9, arrowprops=dict(arrowstyle="-", color=t["ref"], lw=1),
    )
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 1.08)
    ax.set_xlabel("lag (ms)")
    title(ax, t, "3. Receiver: demodulate, FFT cross-correlate with the reference, take the peak")

    save(fig, "signal-chain", mode)


def accuracy(mode):
    t = THEMES[mode]
    series = [("wired", 0.5, "Wired radio, wired audio", t["s1"], "o"),
              ("wireless", 0.3, "Wireless radio, audio over air", t["s2"], "s")]

    fig, (a1, a2) = plt.subplots(1, 2, figsize=(9.6, 4), gridspec_kw=dict(wspace=0.3))
    for ax in (a1, a2):
        style(ax, t)

    a1.plot([0, MAX_D], [0, MAX_D], color=t["ref"], lw=1, ls=(0, (4, 3)))
    a1.text(0.84, 0.74, "ideal", color=t["muted"], fontsize=9)
    for folder, k, label, color, marker in series:
        d, mean, err, sd = [], [], [], []
        for dist, x in load_runs(folder):
            kept = keep(x, k)
            if dist > MAX_D or len(kept) < 0.5 * len(x):
                continue  # run did not lock
            d.append(dist)
            mean.append(kept.mean())
            err.append(abs(kept.mean() - dist) * 1e3)
            sd.append(kept.std() * 1e3)
        a1.plot(d, mean, color=color, lw=2, marker=marker, ms=6, markeredgecolor="none", label=label)
        a2.errorbar(d, err, yerr=sd, color=color, lw=0, elinewidth=1.5, capsize=3,
                    marker=marker, ms=6, markeredgecolor="none", label=label)

    a1.set_xlim(0, MAX_D + 0.05)
    a1.set_ylim(0, MAX_D + 0.05)
    a1.set_xlabel("true distance (m)")
    a1.set_ylabel("measured distance (m)")
    title(a1, t, "Measured vs true distance")

    a2.set_yscale("log")
    a2.set_xlim(-0.03, MAX_D + 0.05)
    a2.set_xticks([0, 0.25, 0.5, 0.75, 1])
    a2.set_xlabel("true distance (m)")
    a2.set_ylabel("|mean error| (mm), bars = ±1 std dev")
    title(a2, t, "Error per distance")
    a1.legend(loc="lower right", frameon=False, labelcolor=t["text"], fontsize=9)

    save(fig, "accuracy", mode)


def outliers(mode):
    t = THEMES[mode]
    runs = dict(load_runs("wired"))
    x = runs[OUTLIER_RUN]
    kept_mask = np.abs(x - x.mean()) < 0.5 * x.std()
    i = np.arange(x.size)
    lo, hi = OUTLIER_RUN - 0.004, OUTLIER_RUN + 0.011

    fig, ax = plt.subplots(figsize=(8, 3.2))
    style(ax, t)
    ax.scatter(i[kept_mask], x[kept_mask], s=18, color=t["s1"], edgecolors="none", label="kept")
    off = ~kept_mask
    ax.scatter(i[off], np.clip(x[off], lo, hi), s=40, marker="^", facecolors="none",
               edgecolors=t["s2"], linewidths=1.5, label="dropped (clipped to the axis)")
    for j in i[off]:
        ax.annotate(f"{x[j]:.2f} m", (j, np.clip(x[j], lo, hi)), xytext=(6, -12 if x[j] > OUTLIER_RUN else 6),
                    textcoords="offset points", color=t["muted"], fontsize=8)
    ax.set_ylim(lo - 0.002, hi + 0.002)
    ax.set_xlim(-2, x.size + 6)
    ax.set_xlabel("reading #")
    ax.set_ylabel("distance (m)")
    title(ax, t, f"100 readings at {OUTLIER_RUN:g} m (wired): {kept_mask.sum()} kept, std dev {x[kept_mask].std() * 1e3:.1f} mm")
    ax.yaxis.set_major_locator(matplotlib.ticker.MultipleLocator(0.005))
    ax.yaxis.set_major_formatter(matplotlib.ticker.FormatStrFormatter("%.3f"))
    ax.legend(loc="upper center", frameon=False, labelcolor=t["text"], fontsize=9, ncol=2)
    save(fig, "outliers", mode)


def resources(mode):
    t = THEMES[mode]
    rows = [("DSP", 164, 240), ("BRAM", 83, 135), ("LUTRAM", 5751, 19000),
            ("LUT", 18736, 63400), ("FF", 26985, 126800), ("IO", 34, 210)]
    fig, ax = plt.subplots(figsize=(8, 2.9))
    style(ax, t)
    ax.grid(axis="y", visible=False)
    y = np.arange(len(rows))[::-1]
    pct = [u / a * 100 for _, u, a in rows]
    ax.barh(y, [100] * len(rows), height=0.55, color=t["grid"], zorder=1)
    ax.barh(y, pct, height=0.55, color=t["s1"], zorder=2)
    for yi, (name, used, avail), p in zip(y, rows, pct):
        ax.text(102, yi, f"{p:.0f}%", va="center", color=t["text"], fontsize=9, fontweight="bold")
        ax.text(110, yi, f"{used:,} / {avail:,}", va="center", color=t["muted"], fontsize=9)
    ax.set_yticks(y)
    ax.set_yticklabels([r[0] for r in rows], color=t["text"], fontsize=10)
    ax.set_xlim(0, 100)
    ax.set_xticks([0, 25, 50, 75, 100])
    ax.set_xticklabels(["0", "25", "50", "75", "100%"])
    ax.spines["left"].set_visible(False)
    title(ax, t, "Receiver utilization on the XC7A100T")
    save(fig, "resources", mode)


if __name__ == "__main__":
    plt.rcParams.update({"font.family": "DejaVu Sans", "font.weight": "normal", "svg.fonttype": "none"})
    for mode in THEMES:
        signal_chain(mode)
        accuracy(mode)
        outliers(mode)
        resources(mode)
    print("wrote", sorted(os.listdir(OUT)))
