clear all
PsychJavaTrouble
Screen('CloseAll');

uiwait(msgbox('First, please fill in some personal information.','Experiment','modal'));

prompt = {'First Name: (e.g. John)','Last Name:  (e.g. Apple)','E-mail address:  (e.g. ja@e.ntu.edu.sg)','Year of Birth: (e.g. 1995)'};
title = 'Personal Info.';
dims = [1 50];
% definput = {'John','Apple','john@e.ntu.edu.sg','1995','',''};
answer1 = inputdlg(prompt,title,dims);

while sum(cellfun(@isempty,answer1)) > 0
    dims = [1 50];
    definput = answer1;
    title = 'Fill in all the questions!';
    answer1 = inputdlg(prompt,title,dims,definput);
end

answer2 = listdlg('ListString',{'Male', 'Female'},'Name','Gender:','SelectionMode','single','ListSize',[200,60]);
answer3 = listdlg('ListString',{'Engineering and Sciences','Humanities and Social Sciences'},'Name','Your Major:','SelectionMode','single','ListSize',[200,60]);
answer4 = listdlg('ListString',{'Chinese','Malay','Indian','Eurasian','Others'},'Name','Your ethnicity:','SelectionMode','single','ListSize',[200,80]);

personal_info=answer1';
if answer2 ==1
    personal_info(5)={'male'};
else
    personal_info(5)={'female'};
end
 
if answer3 ==1
    personal_info(6)={'Engineering and Sciences'};
else
    personal_info(6)={'Humanities and Social Sciences'};
end

if answer4 ==1
    personal_info(7)={'Chinese'};
elseif answer4 ==2
    personal_info(7)={'Malay'};
elseif answer4 ==3
    personal_info(7)={'Indian'};
elseif answer4 ==4
    personal_info(7)={'Eurasian'};
else
    personal_info(7)={'others'};
end
Personal_info=cell2table(personal_info, 'VariableNames',{'FirstName','FamilyName','Email','YearofBirth','Gender','Major','Ethnicity'});

folder_name=strcat('results/',char(answer1(1)),'_',char(answer1(2)));
        if ~exist(folder_name, 'dir')
                        mkdir(folder_name); %create folder, if mkdir folder_name, then the created folder's name is folder_name, rather than the vaule of the folder_name
        end
CN=strcat(char(answer1(1)),'_',char(answer1(2)),'_');
Time_stamp=strcat(datestr(date),'_',datestr(now,'HH_MM_SS'));
filename=[folder_name,'/',CN,Time_stamp,'_personal_info.mat'];
Personal_info_filename=[folder_name,'/',CN,Time_stamp,'_personal_info.xlsx'];
save(filename,'answer1','answer2','answer3','answer4');
writetable(Personal_info,Personal_info_filename);

uiwait(msgbox('Click to start the experiment.','Initiating...','modal'));
   %set resolution at screen 0
%   oldRes=SetResolution(0,1024,768);


   %for possible eyetracking 
%     edfFile=[CN];
%     dirs=dir('eyedata/*.edf');
%     dircell=struct2cell(dirs)';
%     edfFilenames=dircell(:,1);
%     ifexist=strmatch([edfFile, '.edf'], edfFilenames, ',exact');
    
    
try
    %skip sync test and the warning notes
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference','VisualDebugLevel', 0);
    %start the function!
    whichScreen= max(Screen('Screens'));
    white=WhiteIndex(whichScreen);
    [myscreen,rect]=PsychImaging('OpenWindow',whichScreen, white.*0);
    [width, height]=Screen('WindowSize', whichScreen);
    oldTextSize = Screen('TextSize',myscreen, 32);
    oldTextcolor =Screen('TextColor',myscreen, white);
    ifi = 1/ 60;
%     ifi = 1.0 / Screen('NominalFramerate');
%     runFaceAtt_eyelinkSetup;
        HideCursor;
        
        
    str=['Welcome to the experiment! \n\n\n There are two sections in this experiment.\n\n In each section, you will answer a number of questions.\n\n\n\n\n\n Press Space bar to start!'];

    DrawFormattedText(myscreen ,str,'center', 'center',[],[],[],[],1.5);
    Screen('Flip',myscreen);
    FlushEvents('keyDown');
    character = GetChar;
    while (character ~= ' ')
	    character = GetChar;
    end
        
        
        
        %PART 1
    trialnum=40;
    str=[' Section 1\n\n In the following, you will view a number of facial images.\n\n Each image will be shown for 1 second. \n Please indicate which academic discipline the person is in,\n  based on your first impression, after the image disappears. \n\n Press E for Engineering and Sciences, \n Press H for Humanities and Social Sciences. \n\n\n Press Space bar to start!'];
    DrawFormattedText(myscreen ,str,'center', 'center',[],[],[],[],1.4); 
    Screen('Flip',myscreen);
    FlushEvents('keyDown');
    character = GetChar;
    while (character ~= ' ')
	    character = GetChar;
    end
    qq=KbName('e');
    ww=KbName('h');

    responces=zeros(trialnum,1);
    rt=zeros(trialnum,1);
    sizePic=[0,0,201,301]; % this matters
    square3=CenterRect(sizePic, rect);
    para8=[1:1:40];
%     sr=44000;
%     f=1000;
%     d=0.1;
%     tone=sin(2*pi*f*linspace(0,d,sr*d));
    result2=zeros(trialnum,3);
    result_all=[];
%     load('name.mat');
    name=dir('stimuli/*.png');
        for sk=1:length(name)
            c=strsplit(name(sk).name,'-');
            c=cell2mat(c(3));
            c=str2num(c(1));
            if c == 1 | c == 3
                name(sk).datenum=1;
            else
                name(sk).datenum=2;
            end
        end
    face_disp=zeros(trialnum,1);

%dyamic condition
          randRaw1=randperm(trialnum);% randomize all  trials 
          rad=randRaw1';
          result_dummy=zeros(trialnum,4);

          for i=1:trialnum
                    square=square3;
                    truetrial=randRaw1(i);
                    para2=para8([truetrial]);
                    DrawFormattedText(myscreen,'+','center', 'center');
                    Screen('Flip',myscreen);
                    WaitSecs(2);
                    pic.name=name(truetrial).name;
                    face_disp(i)=name(truetrial).datenum;
                    filename4= ['stimuli/' pic.name]; 
                            patch7=imread(filename4);
                            patch8= patch7(:,:,1);
                            Screen('PutImage',myscreen,patch8, square);
%                             DrawFormattedText(myscreen,'+','center', 'center');
                            Screen('Flip',myscreen);
                            WaitSecs(1);
                            quest=[' Press E for Engineering and Sciences, \n Press H for Humanities and Social Sciences.'];
                            DrawFormattedText(myscreen ,quest,'center', 'center',[],[],[],[],1.4); 
                            Screen('Flip',myscreen);
                            t0=GetSecs;
                     
                                        [secs, keyCode]=KbWait;
                                        t1=secs;
                                         while keyCode(qq)==0 && keyCode(ww)==0 
                                              [secs, keyCode]=KbWait;
                                         end
                                        if keyCode(qq)==1
                                             responces(i)=1;
                                        else
                                             responces(i)=2;                                             
                                        end
                                             rt(i)=t1-t0;
                                             eval('clear patch5');
                                             eval('clear patch6');
                                             eval('clear patch7');
                                             eval('clear patch8');
             end
                     result_dummy(:,1)=rad;
                     result_dummy(:,2)=rt;
                     result_dummy(:,3)=responces;
                     result_dummy(:,4)=face_disp;
                     result_all=vertcat(result_all,result_dummy);
                     result_dummy=sortrows(result_dummy,1);
                     Judg_Result=array2table(num2cell(result_dummy),'VariableNames',{'Order','RT','Judgment_1ES2HSS','Major'});
                     Judg_Result{find(result_dummy(:,4) == 1),4}={'ES'};
                     Judg_Result{find(result_dummy(:,4) == 2),4}={'HSS'};
%            runFaceAtt_saveEyelinkResult;
    Time_stamp=strcat(datestr(date),'_',datestr(now,'HH_MM_SS'));
    filename=[folder_name,'/',CN,Time_stamp,'_1_Judg_data.mat'];
    save_Judg_Result_filename=[folder_name,'/',CN,Time_stamp,'_1_Judg_data.xlsx'];
    save(filename,'result_all','result_dummy','Judg_Result');
    writetable(Judg_Result,save_Judg_Result_filename);
    
    %PART 2
    trialnum=16;
    str=[' Section 2 \n\n In the following, you will see a number of terms \n that describe the characteristics of a person. \n\n Please rate how much you feel that each term \n accurately describes the person based on your impression. \n\n There are no "right" or "wrong" answers. \n Please answer the question honestly and openly. \n Your responses will be completely confidential. \n\n\n Press Space bar to start!'];

    DrawFormattedText(myscreen ,str,'center', 'center',[],[],[],[],1.4); 
    Screen('Flip',myscreen);
    FlushEvents('keyDown');
    character = GetChar;
    while (character ~= ' ')
	    character = GetChar;
    end
    qq=KbName('1!');
    ww=KbName('2@');
    ee=KbName('3#');
    rr=KbName('4$');
    tt=KbName('5%');
    yy=KbName('6^');
    uu=KbName('7&');
    responces=zeros(trialnum,1);
    rt=zeros(trialnum,1);
    para8=[1:1:16];
%     para9=[1:1:8;1:1:8];
    para9_1=randperm(8);
    para9_2=randperm(8);
%     para10=[1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2];
    para10=randperm(2);
    

     result2=zeros(trialnum,3);
    result_all=[];
    qst_1={'Enginnering and Sciences','Humanities and Social Sciences'};
    qst_2={'Mature','Attractive','Trustworthy','Dominant','Competent','Sociable','Moral','Masculinity'}
    

%dyamic condition
          randRaw1=randperm(trialnum);% randomize all  trials 
          rad=randRaw1';
          result_dummy=zeros(trialnum,5);
          
          for i=1:trialnum
                    square=square3;
                    truetrial=randRaw1(i);
                    para2=para8([truetrial]);
                    DrawFormattedText(myscreen,' ','center', 'center');
                    Screen('Flip',myscreen);
                    if i <9;
                        para10_2=para10(1);
                        para9=para9_1(i);
                    else 
                        para10_2=para10(2);
                        para9=para9_2(i-8);
                    end
                    WaitSecs(2);
                    quest_str=[' Please indicate how much the following term describes a person \n whose academic discipline is \n\n', char(qst_1(para10_2)), ' \n\n ' char(qst_2(para9)), ' \n\n', ' 1 = Extremely uncharacteristic \n 2 = Highly uncharacteristic \n 3 = Somewhat uncharacteristic \n 4 = Neither characteristic or uncharacteristic \n 5 = Somewhat characteristic \n 6 = Highly characteristic \n 7 = Extremely characteristic  \n\n\n Please press a number key to indicate your answer.'];
                    quest_str=char(quest_str);       
                            DrawFormattedText(myscreen ,quest_str,'center', 'center',[],[],[],[],1.4); 
                            Screen('Flip',myscreen);
                            t0=GetSecs;
                                                               
                                        [secs, keyCode]=KbWait;
                                        t1=secs;
                                         while keyCode(qq)==0 && keyCode(ww)==0 && keyCode(ee)==0 && keyCode(rr)==0 && keyCode(tt)==0 && keyCode(yy)==0 && keyCode(uu)==0
                                              [secs, keyCode]=KbWait;
                                         end
                                        if keyCode(qq)==1
                                             responces(i)=1;
                                        elseif keyCode(ww)==1
                                             responces(i)=2;
                                        elseif keyCode(ee)==1
                                             responces(i)=3;
                                        elseif keyCode(rr)==1
                                             responces(i)=4;                                             
                                        elseif keyCode(tt)==1
                                             responces(i)=5;                                             
                                        elseif keyCode(yy)==1
                                             responces(i)=6;  
                                        elseif keyCode(uu)==1
                                             responces(i)=7;                                             
                                        end
                                             rt(i)=t1-t0;
                                             result_dummy(i,4)=para9;
                                             result_dummy(i,5)=para10_2;
             end
                     result_dummy(:,1)=rad;
                     result_dummy(:,2)=rt;
                     result_dummy(:,3)=responces;
                     result_all=vertcat(result_all,result_dummy);
                     result_all(:,1)=[1:16];
                     Eval_Result=array2table(num2cell(result_all),'VariableNames',{'Order','RT','Answer','Characteristic','Major'});
                     Eval_Result{find(result_all(:,5) == 1),5}={'ES'};
                     Eval_Result{find(result_all(:,5) == 2),5}={'HSS'};
                     for ijk=1:8
                        Eval_Result{find(result_all(:,4) == ijk),4}=qst_2(ijk);
                     end
                     
                     
%            runFaceAtt_saveEyelinkResult;
    Time_stamp=strcat(datestr(date),'_',datestr(now,'HH_MM_SS'));
    filename=[folder_name,'/',CN,Time_stamp,'_3_evaluating_data.mat'];
    save_Eval_Result_filename=[folder_name,'/',CN,Time_stamp,'_3_evaluating_data.xlsx'];
    save(filename,'result_all','result_dummy','Eval_Result');
    writetable(Eval_Result,save_Eval_Result_filename);
     
    %FINISHED!
    DrawFormattedText(myscreen,'Finished! \n Thank you for your time!','center', 'center');
    Screen('Flip',myscreen);
    WaitSecs(4);
    Screen('CloseAll');
    clc;
catch
    Screen('CloseAll')
    rethrow(lasterror)
end 