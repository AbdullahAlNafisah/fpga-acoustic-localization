-- Company: ENGS 31, 18X
-- Engineer: Ben Wolsieffer
--
-- Create Date: 08/14/2018 04:27:27 PM
-- Design Name:
-- Module Name: sd_driver - behavior
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies: sd_cmd.vhd
 

--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--





library IEEE;
use IEEE.std_logic_1164.all; use  IEEE.numeric_std.all; use IEEE.math_real.all;

entity sd_driver is
generic(sample_bits:  positive  :=  12;  --  sample  depth  in  RAM
index_bits:  positive  :=  40;
addr_bits: positive := 17); -- width of RAM address bus (must be fully addressable)
port(sclk: in std_logic; rec: in std_logic; play: in std_logic;
audio_done: in std_logic; done: out std_logic; error: out std_logic;

index_audio: in std_logic_vector(index_bits - 1 downto 0);
-- location of audio controller in recordin
index_sd: out std_logic_vector(index_bits - 1 downto 0); -- location of SD driver in recording

-- SD card
sd_spi_sclk: out std_logic; sd_spi_mosi: out std_logic; sd_spi_miso: in std_logic; sd_spi_cs: out std_logic; sd_wp: in std_logic;
sd_cd: in std_logic;
 


-- RAM
ram_wr_en: out std_logic;
ram_addr: out std_logic_vector(addr_bits - 1 downto 0); ram_din: in std_logic_vector(sample_bits - 1 downto 0); ram_dout: out std_logic_vector(sample_bits - 1 downto 0));
end sd_driver;

architecture behavior of sd_driver is constant  SECTOR_SIZE:  positive  :=  512;
-- don't start at beginning of device
constant  SECTOR_OFFSET:  natural  :=  8192;
constant ADDR_OFFSET: natural := SECTOR_OFFSET * SECTOR_SIZE;

-- hardcoded erase block size
constant  ERASE_SECTORS:  positive  :=  8192;

constant  BYTES_PER_INDEX:  positive  :=  2;
constant INDICES_PER_SECTOR: positive := SECTOR_SIZE / BYTES_PER_INDEX;

constant RAM_SIZE: positive := 2 ** addr_bits;

-- Maximum possible index
constant INDEX_MAX: unsigned(index_bits - 1 downto 0) := (others
=> '1');

component down_counter is generic(bits: positive := 4);
port(clk: in std_logic;
k: in std_logic_vector(bits - 1 downto 0); -- preset
 value


--counter to k
 

CE: in std_logic := '1'; -- count enable
preset: in std_logic := '0'; -- assert to set the

y: out std_logic_vector(bits - 1 downto 0); -- counter
 output
TC: out std_logic); -- terminal count
end component;

component sd_cmd is port(sclk: in std_logic;
cmd: in std_logic_vector(5 downto 0); cmd_arg: in std_logic_vector(31 downto 0);
cmd_start: in std_logic; -- assert to start command
cmd_end: out std_logic;
res_r1: out std_logic_vector(7 downto 0) := x"00"; -- r1 response (first byte of response)
res_data: out std_logic_vector(31 downto 0) := x"00000000"; -- response data/card status
data_index: out std_logic_vector(8 downto 0); data_in: in std_logic_vector(7 downto 0); data_out: out std_logic_vector(7 downto 0); data_out_en: out std_logic;
error: out std_logic; sd_spi_sclk: out std_logic; sd_spi_mosi: out std_logic; sd_spi_miso: in std_logic; sd_spi_cs: out std_logic);
end component;

type state_type is (start, init, go_idle_state, send_if_cond, app_cmd, sd_send_op_cond, read_ocr, set_blocklen, send_csd,
idle, st_done, st_error,
st_play, read_length, read_samples,
play_sector_inc,
st_record, write_samples, record_sector_inc,
erase_wr_blk_start_addr, erase_wr_blk_end_addr, erase, write_length); signal state: state_type := start;
signal next_state: state_type; signal sd_init: std_logic;
-- Command type and argument registers
 

signal cmd: std_logic_vector(5 downto 0); signal cmd_arg: std_logic_vector(31 downto 0); signal cmd_start, cmd_end: std_logic;

-- Response data
signal res_r1: std_logic_vector(7 downto 0); signal res_data: std_logic_vector(31 downto 0);

-- Data block
signal data_index: std_logic_vector(8 downto 0);
signal data_in, data_out: std_logic_vector(7 downto 0); signal data_out_en: std_logic;

type read_dest_type is (dest_length, dest_ram, dest_csd); signal read_dest: read_dest_type;

signal cmd_error: std_logic;

-- card information


-- card specific data (CSD)
subtype  CSD_STRUCTURE  is  natural  range  127  downto  126; subtype  CSD_V1_READ_BL_LEN  is  natural  range  83  downto  80; subtype  CSD_V1_C_SIZE  is  natural  range  73  downto  62; subtype  CSD_V1_C_SIZE_MULT  is  natural  range  49  downto  47; subtype  CSD_V2_C_SIZE  is  natural  range  69  downto  48;
signal csd_reg: std_logic_vector(127 downto 0) := (others => '0');

-- maximum sector index (from CSD)
signal card_sector_max: unsigned(31 downto 0);

-- operation conditions register (indicates that card is SDHC or SDXC)
constant  OCR_CCS:  natural  :=  30;
signal ocr_reg: std_logic_vector(31 downto 0); signal ocr_reg_en: std_logic;
 


-- Audio information

-- current sector
signal sector: unsigned(31 downto 0) := (others => '0'); signal addr: unsigned(40 downto 0);
signal sector_reset, sector_inc: std_logic; signal sector_multiplier: unsigned(9 downto 0);
-- index: logical index in the audio file
signal index: unsigned(index_bits - 1 downto 0);
-- maximum logical index of recorded data
-- stored in first bytes of card (little endian)
signal index_end: unsigned(index_bits - 1 downto 0) := (others => '0');

begin

init_counter: down_counter generic map(bits => 8) port map(clk => sclk,
k => x"64",
TC => sd_init);

sd_cmd_map: sd_cmd
port map(sclk => sclk,
cmd => cmd,
cmd_arg => cmd_arg, cmd_start => cmd_start, cmd_end => cmd_end, res_r1  =>   res_r1, res_data => res_data, data_index => data_index, data_in => data_in, data_out => data_out,
data_out_en => data_out_en, error => cmd_error,
 

sd_spi_sclk => sd_spi_sclk, sd_spi_mosi => sd_spi_mosi, sd_spi_miso => sd_spi_miso, sd_spi_cs => sd_spi_cs);

ocr_proc: process(sclk) begin if rising_edge(sclk) then
if ocr_reg_en = '1' then ocr_reg <= res_data;
end if; end if;
end process;

read_dest_proc: process(sclk, index, index_end, data_index, read_dest, ram_din, data_out, data_out_en)
variable bit_low: natural;
variable unwrapped_index: unsigned(index'range); begin
bit_low  :=  to_integer(unsigned(data_index))  *  8;

ram_wr_en <= '0';
ram_dout <= (others => '0'); data_in <= (others => '0');

-- Every 12 bit sample is stored in two bytes on the SD card
unwrapped_index := index + unsigned(data_index) / BYTES_PER_INDEX;
ram_addr <= std_logic_vector(unwrapped_index(ram_addr'range));

case read_dest is when dest_ram =>
ram_wr_en <= data_out_en;
if data_index(0) = '0' then -- even
data_in <= ram_din(3 downto 0) &  "0000"; ram_dout <= "00000000" & data_out(7 downto 4);
else -- odd
data_in <= ram_din(11 downto 4);
 

ram_dout <= data_out & ram_din(3 downto 0); end if;
when dest_length =>
if unsigned(data_index) < 4 then
data_in <= std_logic_vector(index(bit_low + 7
downto bit_low));
end if;
when others => null; end case;

if rising_edge(sclk) then
if data_out_en = '1' then case read_dest is
when dest_length =>
if unsigned(data_index) < 4 then index_end(bit_low + 7 downto bit_low) <=
 
unsigned(data_out);
 

end if;
when dest_csd => csd_reg(bit_low + 7 downto
 
bit_low) <= data_out;
when others => null; end case;
end if; end if;
end process;

card_size_proc: process(csd_reg) begin
if csd_reg(CSD_STRUCTURE) = "00" then
-- SD v1.xx or MMC
card_sector_max <= (resize(unsigned(csd_reg(CSD_V1_C_SIZE)), card_sector_max'length) +
1) sll
(to_integer(unsigned(csd_reg(CSD_V1_C_SIZE_MULT))) +
2 + to_integer(unsigned(csd_reg(CSD_V1_READ_BL_LEN))) / SECTOR_SIZE); else
-- SD >=v2.00
card_sector_max <= resize(unsigned(csd_reg(CSD_V2_C_SIZE))  *  1024  +  1023,
 

card_sector_max'length); end if;
end process;

sector_proc: process(sclk) begin if rising_edge(sclk) then
if sector_reset = '1' then
sector <= to_unsigned(SECTOR_OFFSET, sector'length); elsif sector_inc = '1' then
sector  <=  sector  +  1; end if;
end if; end process;

sector_multiplier <= "0000000001" when ocr_reg(OCR_CCS) = '1' else "1000000000";

index <= resize((sector - SECTOR_OFFSET) * INDICES_PER_SECTOR, index'length);
addr <= resize(sector * SECTOR_SIZE, addr'length); index_sd <= std_logic_vector(index);
next_state_proc: process(state, sd_init, play, rec, cmd_end, cmd_error, res_r1, res_data, index_audio, index, index_end, sector, card_sector_max, audio_done, sd_wp)
variable index_audio_end: unsigned(index_sd'range); -- end of free RAM space during playback
begin
-- Calculate end of free space (only used when playing)
if unsigned(index_audio) > INDEX_MAX - RAM_SIZE then index_audio_end := INDEX_MAX;
else
index_audio_end := unsigned(index_audio) + RAM_SIZE;
end if;
next_state <= state; case state is
 

when start => next_state <= init; when init =>
if sd_init = '1' then
next_state <= go_idle_state; end if;
when idle =>
if play = '1' then
next_state <= read_length; elsif rec = '1' then
next_state <= st_record; end if;
when st_play =>
-- the index conditions are also checked in play_sector_inc.
-- They are checked here in the unlikely case that
 they are short must also wrapping
 

-- violated before the recording even begins (very

-- recording, card smaller than the offset), but they

-- be checked before the increment occurs to prevent

-- with the largest cards and recordings.
if play = '0' or index + (INDICES_PER_SECTOR - 1) >
 
index_end  or  sector  >  card_sector_max then
next_state   <= st_done;
elsif index_audio_end > index + (INDICES_PER_SECTOR -
 
1) then





out of SD must be
 

next_state <= read_samples; end if;
when play_sector_inc =>
-- handle reaching the end of the recording, running

-- card space, or reaching the maximum index. These

-- handled before they occur to avoid a possible
 
overflow, but
-- after the samples for the sector have been read.
 

if index + (INDICES_PER_SECTOR - 1) >= index_end or sector >= card_sector_max then
next_state <= st_done;
else
next_state <= st_play;
end if;
when st_record =>
-- Like playback, we should handle the boundary
 
conditions both
 

-- here and in record_sector_inc
if sd_wp = '1' then next_state <= st_done;
elsif sector > card_sector_max then next_state <= write_length;
elsif unsigned(index_audio) > index +
 
(INDICES_PER_SECTOR - 1) then
if (sector mod ERASE_SECTORS) = 0 then next_state <= erase_wr_blk_start_addr;
else
next_state <= write_samples;
end if;
elsif audio_done = '1' then next_state <= write_length;
end if;
when record_sector_inc =>
if sector >= card_sector_max then next_state <= write_length;
else
next_state <= st_record;
end if; when st_done =>
if audio_done = '1' then next_state <= idle;
end if;
when st_error => null; when others =>
if cmd_end = '1' then case state is
 

when go_idle_state =>
if res_r1 = x"01"  then next_state <= send_if_cond;
end if;
when send_if_cond =>
if res_data(11 downto 0) = x"1AA" then next_state <= app_cmd;
else
next_state <= st_error;
end if; when app_cmd =>
next_state <= sd_send_op_cond; when sd_send_op_cond =>
if res_r1 = x"01" then
-- retry ACMD41
next_state <= app_cmd;
else
next_state  <= read_ocr;
end if;
when  read_ocr =>
if res_data(OCR_CCS) = '1' then next_state <= send_csd;
else
next_state <= set_blocklen;
 






play_sector_inc; record_sector_inc; erase_wr_blk_end_addr; erase;
 
end if;
when set_blocklen => next_state <= send_csd; when send_csd => next_state <= idle;
when read_length => next_state <= st_play; when read_samples => next_state <=

when write_samples => next_state <=

when erase_wr_blk_start_addr => next_state <= when erase_wr_blk_end_addr => next_state <=
when erase => next_state <= write_samples; when  write_length  =>  next_state  <=  st_done;
 

when others => null; end case;
end if; end case;

-- error catching
if cmd_error = '1' then next_state <= st_error;
end if; end process;

output_proc: process(state, sector, sector_multiplier) begin done <= '0';
error <= '0';
sector_reset <= '0';
sector_inc  <= '0';
ocr_reg_en <= '0';
cmd_start <= '0';
cmd <= "000000";
cmd_arg <= x"00000000"; read_dest <= dest_ram;

case state is
when start => null; when init => null;
when idle => sector_reset <= '1'; when st_play => null;
when play_sector_inc => sector_inc <= '1'; when st_record => null;
when record_sector_inc => sector_inc <= '1'; when st_done => done <= '1';
when st_error => error <= '1'; when others =>
cmd_start <= '1'; case state is
when go_idle_state => null; when send_if_cond =>
cmd   <=  "001000";
 

cmd_arg <= x"000001AA"; when app_cmd =>
cmd   <=  "110111";
when sd_send_op_cond => cmd <= "101001";
cmd_arg <= x"40000000"; when read_ocr =>
cmd   <=  "111010";
ocr_reg_en <= '1'; when set_blocklen =>
cmd   <=  "010000";
cmd_arg <= x"00000200"; when send_csd =>
cmd <= "001001";
read_dest <= dest_csd; when read_length =>
cmd   <=  "010001";
read_dest <= dest_length; when read_samples =>
cmd   <=  "010001";
cmd_arg <= std_logic_vector(resize(sector * sector_multiplier, cmd_arg'length));
read_dest <= dest_ram; when write_samples =>
cmd <= "011000";
cmd_arg <= std_logic_vector(resize(sector * sector_multiplier, cmd_arg'length));
read_dest <= dest_ram;
when erase_wr_blk_start_addr  => cmd <= "100000";
cmd_arg <= std_logic_vector(resize((sector + ERASE_SECTORS) * sector_multiplier + ERASE_SECTORS, cmd_arg'length));
when erase_wr_blk_end_addr => cmd <= "100001";
cmd_arg <= std_logic_vector(resize((sector + ERASE_SECTORS - 1) * sector_multiplier, cmd_arg'length));
when erase =>
cmd <= "100110";
 

when write_length => cmd  <= "011000";
read_dest <= dest_length; when others => null;
end case; end case;
end process;

state_update_proc: process(sclk) begin if rising_edge(sclk) then
state <= next_state; end if;
end process; end behavior;