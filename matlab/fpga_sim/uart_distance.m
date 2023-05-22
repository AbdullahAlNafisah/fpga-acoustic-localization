clc;
clear;
close all;
 
%% Collecting Data
device = serialport("COM9",115200);
flush(device)
total_samples = 500;
num = zeros(total_samples,1);
% tStart = tic;           % pair 2: tic
tic
for i = 1:total_samples
    data = read(device,4,"uint8");
    bits = int2bit(data,8);
    num(i,1) = bin2dec(strjoin(string([bits(:,1); bits(:,2); bits(:,3); bits(:,4)])));
    disp('Measurement #');
    disp(i);
    disp('Distance = ');
    disp(num(i,1));
end
toc
%%
load num25cm.mat num
measured_num = num*1e-6;
plot(measured_num)
ylim([0.5, 1])
xlabel("Measurement No.")
ylabel("Measured Distance")

var_num = var(measured_num);
sd_num = sqrt(var_num);
disp(['Standard deviation is ', num2str(sd_num*1e3), ' mm'])
% tEnd = toc(tStart);      % pair 2: toc
% disp(total_samples/(tEnd - tStart));
%%
stds = [6.9931, 6.6833, 3.6422, 2.9766, 7.2815, 3.016, 3.7208, 3.576,2.9835, 2.892]; 
x = 1:length(stds);
figure,
plot(x, stds)
xlabel("Experiment No.")
ylabel("Standard Deviation (mm)")
%%
% 
% Visualizing Data
% 
% % wired
% load wiredNRF_wiredSignal\num0m.mat num
% num0_wired = num;
% load wiredNRF_wiredSignal\num0.05m.mat num
% num0_05_wired = num;
% load wiredNRF_wiredSignal\num0.1m.mat num
% num0_1_wired = num;
% load wiredNRF_wiredSignal\num0.25m.mat num
% num0_25_wired = num;
% load wiredNRF_wiredSignal\num0.5m.mat num
% num0_5_wired = num;
% load wiredNRF_wiredSignal\num0.75m.mat num
% num0_75_wired = num;
% load wiredNRF_wiredSignal\num1m.mat num
% num1_wired = num;
% load wiredNRF_wiredSignal\num3m.mat
% num3_wired = num;
% load wiredNRF_wiredSignal\num5m.mat
% num5_wired = num;
% load wiredNRF_wiredSignal\num7m.mat
% num7_wired = num;
% 
% figure,
% subplot(2,2,1)
% plot(num0_1_wired*1e-6)
% title("Distance = 0.1m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,2)
% plot(num0_25_wired*1e-6)
% title("Distance = 0.25m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,3)
% plot(num1_wired*1e-6)
% title("Distance = 1m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,4)
% plot(num7_wired*1e-6)
% title("Distance = 7m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% 
% 
% 
% % wireless
% 
% 
% load wirelessNRF_wirelessSignal\num0.25m.mat
% num0_25_wireless = num;
% load wirelessNRF_wirelessSignal\num0.50m.mat
% num0_50_wireless = num;
% load wirelessNRF_wirelessSignal\num0.75m.mat
% num0_75_wireless = num;
% load wirelessNRF_wirelessSignal\num1m.mat
% num1_wireless = num;
% load wirelessNRF_wirelessSignal\num1.5m.mat
% num1_5_wireless = num;
% 
% figure,
% subplot(2,2,1)
% plot(num0_25_wireless*1e-6)
% title("Distance = 0.05m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,2)
% plot(num0_50_wireless*1e-6)
% title("Distance = 0.25m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,3)
% plot(num0_75_wireless*1e-6)
% title("Distance = 0.75m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% subplot(2,2,4)
% plot(num1_5_wireless*1e-6)
% title("Distance = 5m")
% xlabel("Sample No.")
% ylabel("Measured Distance [m]")
% 
% 
% %% Mean without Outliers
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% Wired Experiment %%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Define the threshold for identifying outliers (can be adjusted as needed)
% threshold = 0.5;
% % Calculate the mean without outliers
% no_outliers_num0_wired = (num0_wired(abs(num0_wired-mean(num0_wired)) < threshold*std(num0_wired)))*1e-6;
% no_outliers_num0_05_wired = (num0_05_wired(abs(num0_05_wired-mean(num0_05_wired)) < threshold*std(num0_05_wired)))*1e-6;
% no_outliers_num0_1_wired = (num0_1_wired(abs(num0_1_wired-mean(num0_1_wired)) < threshold*std(num0_1_wired)))*1e-6;
% no_outliers_num0_25_wired = (num0_25_wired(abs(num0_25_wired-mean(num0_25_wired)) < threshold*std(num0_25_wired)))*1e-6;
% no_outliers_num0_5_wired = (num0_5_wired(abs(num0_5_wired-mean(num0_5_wired)) < threshold*std(num0_5_wired)))*1e-6;
% no_outliers_num0_75_wired = (num0_75_wired(abs(num0_75_wired-mean(num0_75_wired)) < threshold*std(num0_75_wired)))*1e-6;
% no_outliers_num1_wired = (num1_wired(abs(num1_wired-mean(num1_wired)) < threshold*std(num1_wired)))*1e-6;
% no_outliers_num3_wired = (num3_wired(abs(num3_wired-mean(num3_wired)) < threshold*std(num3_wired)))*1e-6;
% no_outliers_num5_wired = (num5_wired(abs(num5_wired-mean(num5_wired)) < threshold*std(num5_wired)))*1e-6;
% no_outliers_num7_wired = (num7_wired(abs(num7_wired-mean(num7_wired)) < threshold*std(num7_wired)))*1e-6;
% 
% 
% mean_no_outliers_num0_wired = mean(no_outliers_num0_wired);
% mean_no_outliers_num0_05_wired = mean(no_outliers_num0_05_wired);
% mean_no_outliers_num0_1_wired = mean(no_outliers_num0_1_wired);
% mean_no_outliers_num0_25_wired = mean(no_outliers_num0_25_wired);
% mean_no_outliers_num0_5_wired = mean(no_outliers_num0_5_wired);
% mean_no_outliers_num0_75_wired = mean(no_outliers_num0_75_wired);
% mean_no_outliers_num1_wired = mean(no_outliers_num1_wired);
% mean_no_outliers_num3_wired = mean(no_outliers_num3_wired);
% mean_no_outliers_num5_wired = mean(no_outliers_num5_wired);
% mean_no_outliers_num7_wired = mean(no_outliers_num7_wired);
% 
% % Plot
% means_no_outliers_wired = [mean_no_outliers_num0_wired; mean_no_outliers_num0_05_wired; mean_no_outliers_num0_1_wired; ...
%     mean_no_outliers_num0_25_wired; mean_no_outliers_num0_5_wired; mean_no_outliers_num0_75_wired; mean_no_outliers_num1_wired; ...
%     mean_no_outliers_num3_wired; mean_no_outliers_num5_wired; mean_no_outliers_num7_wired];
% distances_wired = [0 0.05 0.1 0.25 0.5 0.75 1 3 5 7]';
% 
% figure,
% plot(distances_wired', means_no_outliers_wired', 'r-*', "MarkerEdgeColor","k");
% 
% xlabel("Actual Distance [m]")
% ylabel("Measured Distance Mean [m]")
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% Wireless Experiment %%%%%%%%%%%%%%%%%%%%%%%%%
% threshold = 0.3;
% 
% no_outliers_num0_25_wireless = (num0_25_wireless(abs(num0_25_wireless-mean(num0_25_wireless)) < threshold*std(num0_25_wireless)))*1e-6;
% no_outliers_num0_50_wireless = (num0_50_wireless(abs(num0_50_wireless-mean(num0_50_wireless)) < threshold*std(num0_50_wireless)))*1e-6;
% no_outliers_num0_75_wireless = (num0_75_wireless(abs(num0_75_wireless-mean(num0_75_wireless)) < threshold*std(num0_75_wireless)))*1e-6;
% no_outliers_num1_wireless = (num1_wireless(abs(num1_wireless-mean(num1_wireless)) < threshold*std(num1_wireless)))*1e-6;
% no_outliers_num1_5_wireless = (num1_5_wireless(abs(num1_5_wireless-mean(num1_5_wireless)) < threshold*std(num1_5_wireless)))*1e-6;
% 
% 
% mean_no_outliers_num0_25_wireless = mean(no_outliers_num0_25_wireless);
% mean_no_outliers_num0_50_wireless = mean(no_outliers_num0_50_wireless);
% mean_no_outliers_num0_75_wireless = mean(no_outliers_num0_75_wireless);
% mean_no_outliers_num1_wireless = mean(no_outliers_num1_wireless);
% mean_no_outliers_num1_5_wireless = mean(no_outliers_num1_5_wireless);
% 
% % Plot
% means_no_outliers_wireless = [mean_no_outliers_num0_25_wireless; ...
%     mean_no_outliers_num0_50_wireless; mean_no_outliers_num0_75_wireless; mean_no_outliers_num1_wireless; mean_no_outliers_num1_5_wireless];
% distances_wireless = [0.25 0.5 0.75 1 1.5]';
% 
% figure,
% plot(distances_wireless', means_no_outliers_wireless', 'r-*', "MarkerEdgeColor","k");
% xlabel("Actual Distance [m]")
% ylabel("Measured Distance Mean [m]")
% 
% 
% %% Error Calculations
% 
% % wired
% 
% highValues_wired = [max(no_outliers_num0_wired) - mean_no_outliers_num0_wired, max(no_outliers_num0_05_wired)-mean_no_outliers_num0_05_wired, ...
%     max(no_outliers_num0_1_wired) - mean_no_outliers_num0_1_wired, max(no_outliers_num0_25_wired)-mean_no_outliers_num0_25_wired, ...
%     max(no_outliers_num0_5_wired) - mean_no_outliers_num0_5_wired, max(no_outliers_num0_75_wired) - mean_no_outliers_num0_75_wired, ...
%     max(no_outliers_num1_wired) - mean_no_outliers_num1_wired, max(no_outliers_num3_wired) - mean_no_outliers_num3_wired, ...
%     max(no_outliers_num5_wired) - mean_no_outliers_num5_wired, max(no_outliers_num7_wired) - mean_no_outliers_num7_wired];
% 
% lowValues_wired = [mean_no_outliers_num0_wired - min(no_outliers_num0_wired), mean_no_outliers_num0_05_wired - min(no_outliers_num0_05_wired),...
%     mean_no_outliers_num0_1_wired - min(no_outliers_num0_1_wired), mean_no_outliers_num0_25_wired - min(no_outliers_num0_25_wired), ...
%     mean_no_outliers_num0_5_wired - min(no_outliers_num0_5_wired), mean_no_outliers_num0_75_wired - min(no_outliers_num0_75_wired) ...
%     mean_no_outliers_num1_wired - min(no_outliers_num1_wired), mean_no_outliers_num3_wired - min(no_outliers_num3_wired), ...
%     mean_no_outliers_num5_wired - min(no_outliers_num5_wired), mean_no_outliers_num7_wired - min(no_outliers_num7_wired)];
% 
% figure,
% plot(distances_wired,means_no_outliers_wired,'r-')
% hold on  % <--Put this outside of your loop)
% er_wired = errorbar(distances_wired,means_no_outliers_wired,lowValues_wired,highValues_wired, 'LineStyle','none', 'Color', 'k'); 
% xlabel("Actual Distance [m]")
% ylabel("Measured Distance Mean [m]")                        
% 
% 
% % wireless
% highValues_wireless = [max(no_outliers_num0_25_wireless) - mean_no_outliers_num0_25_wireless; max(no_outliers_num0_50_wireless)-mean_no_outliers_num0_50_wireless; ...
%     max(no_outliers_num0_75_wireless) - mean_no_outliers_num0_75_wireless; max(no_outliers_num1_wireless) - mean_no_outliers_num1_wireless; ...
%     max(no_outliers_num1_5_wireless) - mean_no_outliers_num1_5_wireless];
% 
% lowValues_wireless = [mean_no_outliers_num0_25_wireless - min(no_outliers_num0_25_wireless), mean_no_outliers_num0_50_wireless - min(no_outliers_num0_50_wireless), ...
%     mean_no_outliers_num0_75_wireless - min(no_outliers_num0_75_wireless), mean_no_outliers_num1_wireless - min(no_outliers_num1_wireless), ...
%     mean_no_outliers_num1_5_wireless - min(no_outliers_num1_5_wireless)];
% 
% figure,
% plot(distances_wireless,means_no_outliers_wireless,'r-')
% hold on  % <--Put this outside of your loop)
% er_wireless = errorbar(distances_wireless,means_no_outliers_wireless,lowValues_wireless,highValues_wireless, 'LineStyle','none', 'Color', 'k');  
% xlabel("Actual Distance [m]")
% ylabel("Measured Distance Mean [m]")
% 
% 
