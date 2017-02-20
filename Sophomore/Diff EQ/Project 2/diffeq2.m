close all
clear all
clc
%% Problem 1
A = imread('face1.pgm');
A = double(A);
newA = -A+255;
newA = uint8(newA);
figure;
imshow(newA);

%% Problem 2
clear all
A = imread('face1.pgm');
A = double(A);
[U,S,V] = svd(A);
figure
imshow(uint8(A));
for r=[5,10,15]
    % Turn all but the first 10 singular values to 0
    Sreduced = S;
    Sreduced(r:end,r:end) = 0;
    % remultiply to get lower-dimensional version of A
    Areduced = U*Sreduced*V';
    fig=figure;
    imshow(uint8(Areduced));
end

%% Problem 3
clear all
for facenum=[2,4,6]
    filename=sprintf('face%d.pgm',facenum);
    A = imread(filename);
    A = double(A);
    [U,S,V] = svd(A);
    figure
    imshow(uint8(A));
    for r=[4,9,13]
        % Turn all but the first 10 singular values to 0
        Sreduced = S;
        Sreduced(r+1:end,r+1:end) = 0;
        % remultiply to get lower-dimensional version of A
        Areduced = U*Sreduced*V';
        figure;
        imshow(uint8(Areduced));
    end
end

%% Problem 4
clear all
A = imread('face1.pgm');
A = double(A);
[U,S,V] = svd(A);
values=diag(S);
figure
scatter(values,values,'.')
count=0;
for i=1:size(values)
    if values(i)>0.01
        count=count+1;
    end
end
fprintf('There are %d values larger than 0.01\n',count);

%% Problem 5
clear all
for facenum=1:6
    filename=sprintf('face%d.pgm',facenum);
    A = imread(filename);
    A = double(A);
    [U,S,V] = svd(A);
    r=15;
    % Turn all but the first 10 singular values to 0
    Sreduced = S;
    Sreduced(r+1:end,r+1:end) = 0;
    % remultiply to get lower-dimensional version of A
    j=facenum;
    values(:,j)=diag(Sreduced);
    if facenum>=5 && facenum<=6
        fprintf('Face number %d\n',facenum);
        for i=1:size(values)
            if values(i,j)~=0
                fprintf('%d\n',values(i,j));
            end
        end
    end
end
A = imread('newface.pgm');
A = double(A);
[U,S,V] = svd(A);
Sreduced = S;
Sreduced(r+1:end,r+1:end) = 0;
newface=diag(Sreduced);

%% Problem 6
for i=1:6
    comparison(i)=norm(values(:,i)-newface);
end
[row,col]=min(comparison);
fprintf('Face %d is the closest to the new face\n',col)

%% Problem 7
signature=[12830 11258 1100 890 640 580 415 370 333 300 290 250 240 220 215];
for i=1:size(values)
            if values(i,:)~=0
                values_new(:,i)=values(i,:);
            end
        end
for i=1:6
    comparison2(i)=norm(signature-values_new(i,:));
end
[row2,col2]=min(comparison2);
fprintf('Face %d is the closest to the signature vector\n',col2)

A = imread('newface.pgm');
figure
imshow(A)

% Printing with ugly code
print('-f1','problem1','-dpng')
print('-f2','problem2_original','-dpng')
print('-f3','problem2_r-5','-dpng')
print('-f4','problem2_r-10','-dpng')
print('-f5','problem2_r-15','-dpng')
print('-f6','problem3_original_1','-dpng')
print('-f7','problem3_r-5_1','-dpng')
print('-f8','problem3_r-10_1','-dpng')
print('-f9','problem3_r-15_1','-dpng')
print('-f10','problem3_original_2','-dpng')
print('-f11','problem3_r-5_2','-dpng')
print('-f12','problem3_r-10_2','-dpng')
print('-f13','problem3_r-15_2','-dpng')
print('-f14','problem3_original_3','-dpng')
print('-f15','problem3_r-5_3','-dpng')
print('-f16','problem3_r-10_3','-dpng')
print('-f17','problem3_r-15_3','-dpng')
print('-f18','plot','-dpng')
print('-f19','newface','-dpng')