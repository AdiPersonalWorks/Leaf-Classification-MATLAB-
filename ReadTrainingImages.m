function [imSet famIdx Imagepath] = ReadTrainingImages(new_str,num_train)
% Function to read and store the training images

%% Declaration of variables
trn_im = [];
im_set = [];
numImages = [];
fam_idx = [];
Imagepath = {};
Tmp_Cnt = 1;

%%
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
        
        % Reshape grayscale images into array such that each image is a
        % column vector to pass back to calling routine
        tmp_im = imresize(im,[240 320]);
        sz = size(tmp_im);
        tmp_im = reshape(tmp_im,[1 sz(1)*sz(2)]);
        im_set = [im_set;tmp_im];
    end
end

% output vectored image set
imSet = im_set;

% output image family index
famIdx = fam_idx;

return;