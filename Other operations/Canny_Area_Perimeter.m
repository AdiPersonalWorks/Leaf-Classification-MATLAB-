function [Area, Perimeter, Contrast, Energy, Homogeneity] = Canny_Area_Perimeter(imageforareaperimeter)
% This script is used for edge detection and calculating the area and
% perimeter of the leaf.

% imageforareaperimeter = rgb2gray(imread('1.jpg')); %Use this line if you
% want to test this script as a standalone.
figure;

% Edge detection using canny
edgedetectedimg = edge(imageforareaperimeter,'canny');
imshow(edgedetectedimg); title('Edge detected Image');

% Thinning using morphology
Thinned_Image = bwmorph(edgedetectedimg,'thin');

% Filling the image so as to get one complete blob.
diskEnt1 = strel('disk',24); % radius of 4
closedimg = imclose(Thinned_Image,diskEnt1);
figure; imshow(closedimg); title('Filled image');

% Finding out the area and perimeter of the image.
Area_Perimeter = regionprops(closedimg, 'area', 'perimeter');

% Sorting to find the area of the biggest blob in case of small blobs
% appearing on the image.
try
    Area = max(Area_Perimeter.Area);
    Perimeter = max(Area_Perimeter.Perimeter);
catch
    for i = 1:size(Area_Perimeter,1)
        Area_temp(i) = Area_Perimeter(i).Area;
        Peri_temp(i) = Area_Perimeter(i).Perimeter;
    end
    
    Area = max(Area_temp);
    Perimeter = max(Peri_temp);
end

%Texture analysis using glcm
contrast=graycoprops(graycomatrix(closedimg),'contrast');
energy=graycoprops(graycomatrix(closedimg),'energy');
homogeneity=graycoprops(graycomatrix(closedimg),'homogeneity');

% Sorting to find the texture of the biggest blob in case of small blobs
% appearing on the image.

try
    Contrast=max(contrast.Contrast);
    Energy=max(energy.Energy);
    Homogeneity=max(homogeneity.Homogeneity);
catch
    for i=1:size(contrast,1)
        cont_temp(i)=max(contrast(i).Contrast);
        Contrast=max(cont_temp);
    end
    for i=1:size(energy,1)
        ener_temp(i)=max(energy(i).Energy);
        Energy=max(ener_temp);
    end
    for i=1:size(homogeneity,1)
        homo_temp(i)=max(homogeneity.Homogeneity);
        Homogeneity=max(homo_temp);
    end
    
end

%FINDING CENTROID OF THE IMAGE(SHAPE PERIMETER)
closedimg1=closedimg;
measurements = regionprops(closedimg1, 'Centroid');
figure;
imshow(closedimg1);
title('Centroid Image');
centroids = cat(1,measurements.Centroid);
hold on;
plot(centroids(:,1), centroids(:,2), 'r+', 'MarkerSize', 15, 'LineWidth', 1);
hold off;

% disp( sprintf('the image contrast is ' ));
% disp(Contrast);
% 
% disp( sprintf('the image energy '));
% disp(Energy);
% 
% disp(sprintf('the image homogeneity '));
% disp(Homogeneity);
% disp(Area);
% disp(Perimeter);