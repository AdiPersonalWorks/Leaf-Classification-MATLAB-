function FeatureExtractDatabase()
%% This function is used to store Features of database images.

trn_im = [];
im_set = [];
numImages = [];
fam_idx = [];
Imagepath = {};
Tmp_Cnt = 1;
count = 1;

str = 'Training_Images/';
base = str;
im_dirs = dir(base);
numDirs = size(im_dirs,1)-2;

for i = 1:numDirs
    str = strcat(base,'Species_',int2str(i),'/');
    imDir = dir(str);
    numImgs = size(imDir,1)-2;
    
    for j = 1:numImgs
        % Save family Index
        fam_idx = [fam_idx;i];
        
        % Read in each image
        strTrn = strcat(str,int2str(j),'.jpg');
        Imagepath{Tmp_Cnt} = strTrn;
        Tmp_Cnt = Tmp_Cnt + 1;
        im = imread(strTrn);
        
        % Determine whether or not image is already a grayscale image
        flag = isgray(im);
        
        % If image is not grayscale image make it a grayscale image
        if ~flag
            im = rgb2gray(im);
        end
        
        tmp_im = im;%imresize(im,[240 320]);
        
        %% Noise Removal
        img = tmp_im;
        nhood=[3 3];
        
        classChanged = 0;
        if ~isa(img, 'double')
            classChanged = 1;
            img = im2double(img);
        end
        
        % Estimate the local mean of f.
        localMean = filter2(ones(nhood), img) / prod(nhood);
        
        % Estimate of the local variance of f.
        localVar = filter2(ones(nhood), img.^2) / prod(nhood) - localMean.^2;
        
        noise = mean2(localVar);
        
        noise=max(noise,0.0001);
        
        % Computation is split up to minimize use of memory
        % for temp arrays.
        cleanimg = img - localMean;
        img = localVar - noise;
        img = max(img, 0);
        localVar = max(localVar, noise);
        cleanimg = cleanimg ./ localVar;
        cleanimg = cleanimg .* img;
        cleanimg = cleanimg + localMean;
        
        if classChanged,
            cleanimg = im2uint8(cleanimg);
        end
        
        %% Feature Extraction
        
        % Edge detection using canny
        imageforareaperimeter = cleanimg;
        edgedetectedimg = edge(imageforareaperimeter,'canny');
        
        % Thinning using morphology
        Thinned_Image = bwmorph(edgedetectedimg,'thin');
        
        % Filling the image so as to get one complete blob.
        diskEnt1 = strel('disk',24); % radius of 4
        closedimg = imclose(Thinned_Image,diskEnt1);
        
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
        
        % Gray Level Histogram
        % Computing and plotting the histogram
        grayImage = cleanimg;
        [pixelCount grayLevels] = imhist(grayImage);
        
        % Calculate the grey level average
        meanGL = sum(pixelCount .* grayLevels) / sum(pixelCount);
        meanBinHeight = mean(pixelCount);
        
        % Storing all extracted features in a MAT file.
        feature_ext{count,1} = strTrn;
        feature_ext{count,2} = Area;
        feature_ext{count,3} = Perimeter;
        feature_ext{count,4} = Contrast;
        feature_ext{count,5} = Energy;
        feature_ext{count,6} = Homogeneity;
        feature_ext{count,7} = meanGL;
        count = count + 1;
        
    end
end

save FeaturesExtracted.mat feature_ext;

end