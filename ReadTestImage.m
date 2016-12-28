function [tst_im tst_famIdx] = ReadTestImage(TestImg)
% This function is used to read the test image and extract the required
% parameters

%%
im_set = [];
% Determine whether or not image is already a grayscale image
flag = isgray(TestImg);

% If image is not grayscale image make it a grayscale image
if ~flag
    Test_Img = rgb2gray(TestImg);
else
    Test_Img = TestImg;
end

% Reshape grayscale images into array such that each image is a
% column vector to pass back to calling routine
tmp_im = imresize(Test_Img,[240 320]);
sz = size(tmp_im);
tmp_im = reshape(tmp_im,[1 sz(1)*sz(2)]);
im_set = [im_set;tmp_im];

% output vectored image set
tst_im = im_set;

% output image family index
tst_famIdx = 1;
end