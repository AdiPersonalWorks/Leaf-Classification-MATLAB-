function [delta_min,idx,Imagepath] = PCALeafImages(TestImg)

new_str = 'Train';
num_train = 5;

[trn_im tr_famIdx Imagepath] = ReadTrainingImages(new_str,num_train);
im_set = trn_im';

%% PCA decomposition of gradient images
trn_im = trn_im';
Fmatrix = trn_im;
Fmean = mean(Fmatrix,2);
sz = size(Fmatrix);
Fmatrix = double(Fmatrix) - repmat(Fmean,[1 sz(2)]);
[U S V] = svds(Fmatrix,11);

%% Load Test Image
[tst_im tst_famIdx] = ReadTestImage(TestImg);

%% Project Test Images onto the PCA basis and compute its coefficients
tst_im = tst_im';
sz = size(tst_im);
tst_im_mov = double(tst_im) - repmat(Fmean,[1 sz(2)]);
ProjTstIm = [];
for i = 1:sz(2)
    imVec = double(tst_im_mov(:,i));
    temp = U' * imVec;
    ProjTstIm = [ProjTstIm temp];
end

%% Find the training image with the most similar coefficients
ProjTrnIm = S*V'; % Define matrix of training image’s coefficients
szTrn = size(trn_im);
szTst = size(tst_im);
OutIm = [];
OutIdx = [];

for j = 1:szTst(2)
    delta = [];
    for i = 1:szTrn(2)
        delta_temp = (norm(ProjTstIm(:,j) - ProjTrnIm(:,i)))^2;
        delta = [delta delta_temp];
    end
    [delta_min, idx] = min(delta); % Find closest training image
    OutIm = [OutIm im_set(:,idx)];
end
end