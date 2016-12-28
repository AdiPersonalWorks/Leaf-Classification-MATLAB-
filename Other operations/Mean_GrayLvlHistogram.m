function meanGL = Mean_GrayLvlHistogram(grayImage)
%% This function computes the Grey Level Histogram Average

% grayImage = rgb2gray(imread('1.jpg')); Use this line if you want to test
% the script individually
figure;
subplot(1, 2, 1);
imshow(grayImage, []);
title('Original Grayscale Image after Noise Removal');

% Computing and plotting the histogram
[pixelCount grayLevels] = imhist(grayImage);
subplot(1, 2, 2);
bar(pixelCount);
title('Histogram of the image');
xlim([0 grayLevels(end)]); % Scale the x-axis.
yRange = ylim;

% Calculate the grey level average
meanGL = sum(pixelCount .* grayLevels) / sum(pixelCount);
meanBinHeight = mean(pixelCount);
line([meanGL meanGL], yRange);
message = sprintf('The mean gray level is %6.2f', meanGL); % Prints the message on the plot
text(meanGL+5, 0.8*yRange(2), message);

% Prints a message box on the screen containing the details
message = sprintf('Done!\nThe mean gray level is %6.2f\nThe mean bin height = %.2f',meanGL, meanBinHeight);
msgbox(message);