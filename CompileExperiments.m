More=1;
c=0;

waitfor(msgbox('When the image pops up, please move the first box to the NEW objects position and double click. When the second box pops up, move it to the OLD objects position and double click','Instructions'));


while More==1
    
    disp('Pick CSV file')
    [cfile, cpath] = uigetfile('*.csv');
    
    disp('Pick Video file (m4v format)');
    [mfile, mpath] = uigetfile('*.m4v');
    
    [scores] = ROI_Object_v1(cfile, cpath, mfile, mpath);
  c=c+1;
ExpName{c,1} = mfile(1:end-4);
TimeNew(c,1) = scores(1);
TimeOld(c,1) = scores(2);
TotalTime(c,1)=scores(3);
DI(c,1) = scores(4);

    
    answer = questdlg('Are there more experiments?', 'Keep Adding?',...
        'Yes','No','Cancel','Cancel');
    % Handle response
    switch answer
        case 'Yes'
            %disp([answer ' coming right up.'])
            More = 1;
        case 'No'
            %disp([answer ' coming right up.'])
            More = 0;
        case 'Cancel'
            error('User canceled data analysis')
    end
    
    
end

T = table(ExpName, TimeNew, TimeOld,TotalTime,DI);
tablename = inputdlg('Output File Name',num2str(datestr(now, 'yyyymmddTHHMM')));
oname = strcat(mpath, tablename,'.xls');
writetable(T, oname{1});
clear all

