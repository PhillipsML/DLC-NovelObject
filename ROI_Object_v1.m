function [scores]=ROI_Object_v1(cfile, cpath, mfile, mpath)
% 
% Traindir = dir('*rain*.avi');
% 
% Trainmov = VideoReader(Traindir(1).name);
Testmov = VideoReader(fullfile(mpath, mfile));


for i = 1:50
    readFrame(Testmov);
end
trx = xlsread(fullfile(cpath, cfile));
if size(trx,1)>9000
    trx = trx(end-8999:end,:);
end

proceed = 0
while proceed == 0
    imshow(readFrame(Testmov));

h = imrect(gca,[10 10 265 215]);
New_position = wait(h);
NP = [round(New_position(1)), round(New_position(2));round(New_position(1))+round(New_position(3)),...
    round(New_position(2))+round(New_position(4))];

g = imrect(gca,[10 10 265 215]);
Old_position = wait(g);
OP = [round(Old_position(1)), round(Old_position(2));round(Old_position(1))+round(Old_position(3)),...
    round(Old_position(2))+round(Old_position(4))];
answerbox = questdlg('Are you happy with the boxes?', 'Success?',...
        'Yes','No','Cancel','Cancel');
    % Handle response
    switch answerbox
        case 'Yes'
            %disp([answer ' coming right up.'])
            proceed = 1;
            close all
        case 'No'
            %disp([answer ' coming right up.'])
            proceed = 0;
            close all
        case 'Cancel'
            error('User canceled data analysis')
    end
end

map(:,1) = trx(:,4)<0.5;
map(:,2) = trx(:,7)<0.5;
map(:,3) = trx(:,10)<0.5;
for i = 1:size(trx,1)
    if map(i,1)==1
        if map(i,2)==1
            if map(i,3)==1
                trx_ad(i,1:2) = NaN;
            else
                trx_ad(i,1:2) = [trx(i,8),trx(i,9)];
            end
        else
            trx_ad(i,1:2) = [trx(i,5),trx(i,6)];
        end
    else
        trx_ad(i,1:2) = [trx(i,2),trx(i,3)];
    end
end

n_x = NP(1,1)<trx_ad(:,1)&trx_ad(:,1)<NP(2,1);
n_y = NP(1,2)<trx_ad(:,2)&trx_ad(:,2)<NP(2,2);
n_ip = n_x.*n_y; 
tn = sum(n_ip)/30;

o_x = OP(1,1)<trx_ad(:,1)&trx_ad(:,1)<OP(2,1);
o_y = OP(1,2)<trx_ad(:,2)&trx_ad(:,2)<OP(2,2);
o_ip = o_x.*o_y;
to = sum(o_ip)/30;

scores = [tn, to,(tn+to), ((tn-to)/(tn+to))];


