function spindleslfp_carmen(filteredlfpfilename)
% plots rasters & rate histograms for mua and corresponding lfp
% use debuffered lfp file and rethreshold mua file

%%%%%%%%%%%%%%
% get data
%%%%%%%%%%%%%%

% if in home computer
maindir= 'K:\LabComputer92509\';
directory= 'P1Data\DQuijote\';


maindir='/home/carmenv/Desktop/';
directory='P1Data/';  %%%%%temp
day='80909'; %%%%temp

sr=600; % change if sampling rate changes!!!
sint=1/sr;

%%%%%%% remove those points in which the raw lfp was saturating (movement
%%%%%%% artifact)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
rawlfp=load('debufflfpG1_600');
rawlfp=rawlfp.eegTHAL;
drawlfp=diff(rawlfp); % derivative
satrawlfp= (drawlfp==0); 

% tag potential saturation points
% bin raw data over 1 second bins
Fs2=sr; 
siz= floor(length(satrawlfp)/(1*Fs2)); % number of 1sec sections that can be made
part1arp= satrawlfp(1:(1*Fs2*siz));
part2arp= satrawlfp((1*Fs2*siz)+1:end);
rsh= reshape(part1arp,1*Fs2,[]); 
thresh=sum(rsh,1); % if there are only zeros in a column (1sec) the sum will be zero
columns=size(rsh);
columns=columns(1,2);
for i=1:columns;
    if thresh(i)>30; % if artifact for more than 50ms %%% CHANGE if sampling rate or binning changed
%         temp=rsh(:,i); % work with each column otherwise memory problem
%         temp(temp==1)=1;
        rsh(:,i)=1; % if saturation during more than 50msec indicate by using 1
        if i-1>0 % if not in the first column (i.e. the first second)
            rsh(:,i-1)=1; % also discard the second before
        else
        end
        if i+1<columns; % if not in the last column (i.e.  the last second)
            rsh(:,i+1)=1; % also discard the second after
        else 
        end
    else
        rsh(:,i)=0;
    end
end
threshpart2=sum(part2arp);
lon= length(part2arp); % see how long is this portion
if threshpart2>((lon*30)/Fs2); %%% this is for 50ms; CHANGE if sampling rate changed
    part2arp(1,:)=1;
    rsh(:,end)=1; % also discard the second before
else
    part2arp(1,:)=0;
end
zer= zeros(1,length(satrawlfp));
rshback= reshape(rsh,1,[]);
zer(1:length(rshback))=rshback;
zer(length(rshback)+1:end)= part2arp;
artifactlogic=zer;
%%
 % zer has rawlfp with 1 where there was saturation
dirsave=strcat([maindir directory day '/matlab/debufflfpG1artifactlogic']);
save (dirsave, 'artifactlogic');

%%
% LOAD THE FILTERED LFP
% it'd be good to get the epoch from the name of the lfp file
eegd=load('FiltelecG1_6to15.mat');
eegd=eegd.filteredlfp;
% load the corresponding timestamp (thalamic)
eegt= load('zerodtimestamplfpdebuff_k80909');
eegt= eegt.zerodtimeallk;

eeg= [eegd;eegt]; % maybe easier to work with

prompt = {'Enter start time of epoch (s; -zeroed-)','Enter end time of epoch','Enter epoch name'};
dlg_title = 'Input for analysis';
num_lines = 1;
def = {'0','10','pre'}; % defaults 10sec display 
answer = inputdlg(prompt,dlg_title,num_lines,def);

starts=answer{1,1};
starts=str2num(starts);
ends=answer{2,1};
ends=str2num(ends);
epoch=answer{3,1};

% select values (since saved eeg files have the full rec session)
s= binsearch(eegt,starts);
e= binsearch(eegt,ends);

eeg= eeg(:,s:e);

% select what type of criterion in order to pick the sections of the lfp
% that will be used for analysis:
%     - 'theta' will select portions of lfp in which the ripple power is
%     high (low theta), i.e., likely non-rem and quiet wake; since the
%     threshold is quite high (see notes) this criterion is much more
%     restrictive 
%     - 'vel' will select portions of lfp when the animal velocity was
%     <5cm/s, i.e., likely non-rem/rem and quiet wake. Less restrictive
%     criterion (may  have more false positives because of overlap between
%     spindle and theta frequencies).
%     - 'HVS' will also select portions of lfp when the animal velocity was
%     <5cm/s, i.e., likely non-rem/rem and quiet wake. In addition to
%     the criterion for spindles set at 125ms length (saved as spdlall), a more restrictive
%     criterion is set at .5ms (saved as HVS)
%%
prompt = {'What criterion do you want to use for lfp selection? (Enter "theta" or "vel" or "HVS"):'};
dlg_title = 'Criterion to select sections of lfp to be analyzed';
num_lines = 1;
def = {'vel'}; % defaults  
answer = inputdlg(prompt,dlg_title,num_lines,def);

criterion1=answer{1,1};
if strcmp(criterion1, 'vel');
    % get times when rat was quiet and mark lfp that occurred when animal
    % moving as NaN
    movinglogic= load('movingsleepbtimek_1secbin');  
    movinglogic=movinglogic.zer;
    movinglogic= movinglogic(s:e);  
    electrodeV=eeg(1,:);
    allmoving=movinglogic+artifactlogic(s:e); % combine to remove both portions with movement artifact and those when animal moving at vel>criterion
    movinglogic=(allmoving>0);% make it a logical index vector (otherwise problems with next statement) indicating samples where animal moving (>5cm/s) or movement artifact
    electrodeV(movinglogic)=NaN; % lfp with NaN when rat moving or movement artifact present
    quietelectrode= eeg(1,~movinglogic); % separate the ones when animal quiet for stats
 
%     dirsave=strcat([maindir directory day '/matlab/lfpquietH1_5cms' epoch]); % NaN where rat moving
%     save (dirsave, 'electrodeV');
elseif strcmp(criterion1, 'theta');
    movinglogic=load('thetaperiods_5sbin');
    movinglogic=movinglogic.thetap;
    artifactlogic= load('debufflfpB1artifactlogic');
    artifactlogic= artifactlogic.artifactlogic;
    % corresponding timestamps
    timestj=load('zerodtimestamplfpdebuff_j111809');
    timestj= timestj.zerodtimeallj;
    sj= binsearch(timestj,starts); % since timestamps for j and k computers can be displaced with respect to...
    ...each other, the same timestamp may fall in different positions of the vector
    ej= binsearch(timestj,ends);
    movinglogic= movinglogic(sj:ej);
    electrodeV=eeg(1,:);
    electrodeV=eeg(1,:);
    allmoving=movinglogic+artifactlogic(sj:ej);
    movinglogic=(allmoving>0);% make it a logical index vector (otherwise problems with next statement) indicating samples where animal moving (>5cm/s) or movement artifact
    electrodeV(movinglogic)=NaN; % lfp with NaN when rat moving
    quietelectrode= eeg(1,~movinglogic); % separate the ones when animal in sleep or quiet wake for stats
else strcmp(criterion1, 'HVS'); % this portion of the if loop will do exactly the same as with 'vel' criterion -except for saving quiet lfp- the difference
    ...will come later when in addition to 'regular' spindles, hvs spindles will be detected
    % get times when rat was quiet and mark lfp that occurred when animal
    % moving as NaN
    movinglogic= load('movingsleepbtimek_1secbin');  
    movinglogic=movinglogic.zer;
    movinglogic= movinglogic(s:e);  
    electrodeV=eeg(1,:);
    allmoving=movinglogic+artifactlogic(s:e);
    movinglogic=(allmoving>0);% make it a logical index vector (otherwise problems with next statement) indicating samples where animal moving (>5cm/s) or movement artifact
    electrodeV(movinglogic)=NaN; % lfp with NaN when rat moving or movement artifact present
    quietelectrode= eeg(1,~movinglogic); % separate the ones when animal quiet for stats
end

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect and save spindles from LFP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
sqfiltlfp= quietelectrode.^2; % lfp power
m=mean(sqfiltlfp); % mean power while animal not moving
sdev=std(sqfiltlfp);

%spindles=cell(1,1);
durationspdl=cell(1,1);
% to prevent errors with timing, work with the 'electrodeV' vector with the
% original time relations and NaN when rat not moving
electrodeVzeros= electrodeV; % make a copy which will be used to calculate the Hilbert
electrodeVzeros(isnan(electrodeVzeros))=0; % since the Hilbert transform doesn't work with NaN, change them for zeros
hilbertelectrodeV= abs(hilbert(electrodeVzeros));

electrodeV= electrodeV.^2;
electrodeV=reshape(electrodeV,1,length(electrodeV)); % make sure it's in the right shape
hilbertelectrodeV= reshape(hilbertelectrodeV,1,length(hilbertelectrodeV)); % make sure it's in the right shape
m2= mean(hilbertelectrodeV);
stdev2= std(hilbertelectrodeV);

splog=electrodeV>(m+sdev); %%%%% FIRST CRITERION: AT LEAST 1*STD (lfp when quiet) OF FILTERED, SQUARED LFP
pos=find(splog==1);
if isempty(pos)
    spindles{1,1}= 'no spindles in this electrode';
    warndlg('no spindles in this electrode');
else
    difpos=find(diff(pos)>(0.2/sint)); %%%%%%%% SECOND CRITERION: at least a difference of 200ms between the end of a spindle and the beginning of the next to be considered separate spindles (this corresponds to 0.2/sint intervals
    z=zeros(1,length(difpos)+1); % to account for the fact that the beginning of the first spindle and the end of the last one are not included here (since they are not at borders)
    z(1:end-1)=difpos;
    z(end)=length(pos); % now z includes the end position of all spindles
    st= difpos+1; % start positions for all except first spindle
    zst=zeros(1,length(difpos)+1);
    zst(2:end)=st; %
    zst(1)=1; % zst start position of all spindles
    stepspindles= [pos(zst);pos(z)]'; % positions in the lfp vector where candidate spindles start and end

%%%%% THIRD CRITERION: eliminate 'spindle' candidates that last less than the sampling interval (one sample)
    duration= stepspindles(:,2)-stepspindles(:,1);
    stepspindles=stepspindles((~(duration==0)),:);
    
%%%%% FOURTH CRITERION: only take as spindles those events with at least 100ms duration (1burst+1interburst = ~125ms interval which is also aproxx = to 2* 1/15 i.e. 2 periods of an oscillation of 15Hz);...
... I lowered it to 100ms based on visual observation (eventhough 1burst+1interburstinterval = 125ms, the power might not be over 3*stdev for that long...
    ...I also tried based on 3*std only but that gets rid of all 
    duration= stepspindles(:,2)-stepspindles(:,1); % calculate duration again since size of stepspindles has changed        
    stepspindles= stepspindles((duration>(0.100/sint)),:);
    
   % now determine the start and end based on Hilbert transform
    below= stepspindles(:,1)-(1.25/sint); % go back ~1s
    abov= stepspindles(:,2)+(1.25/sint); % and same above
    tama=size(stepspindles);
    tama=tama(1);
    newstepspindles=zeros(tama,2);
    for j=1:tama;
        if below(j)<0 % if by going back 1s we go below time zero
            below(j)=1; % use the first position of the vector instead
        else
        end
        sqfiltlfptemp=hilbertelectrodeV(below(j):stepspindles(j,1));
        for k=length(sqfiltlfptemp):-1:1
           if sqfiltlfptemp(k)<m2; %   
               p=abs(length(sqfiltlfptemp)-k); % calculate how many positions the original starting point has to be moved
               newstepspindles(j,1)=stepspindles(j,1)-p;
               break
           else
               if sqfiltlfptemp(k)<(m2+stdev2); % see if it drops below m2+stdev2    
                   p=abs(length(sqfiltlfptemp)-k);
                   newstepspindles(j,1)=stepspindles(j,1)-p;
                   break
               else
                   newstepspindles(j,1)=NaN; % if spindle start cannot be found within 1.25s, don't use it (this occurs when there are NaN in the vector, i.e., animal moving)
               end
           end
        end
    end
         % same for end of spindles
    for j=1:tama;
        if abov(j)>length(electrodeV) % if by going above 1s it falls outside the lfp vector
            abov(j)=length(electrodeV); % use the last position of the vector instead
        else
        end
        sqfiltlfptemp=hilbertelectrodeV(stepspindles(j,2):abov(j));
        for k=1:length(sqfiltlfptemp);
            if sqfiltlfptemp(k)<m2;%
                p=k-1; % calculate how many positions the original starting point has to be moved
                newstepspindles(j,2)=stepspindles(j,2)+p;
                break
            else
                if sqfiltlfptemp(k)<(m2+stdev2); % see if it drops below m2+stdev2
                   p=k-1;
                   newstepspindles(j,2)=stepspindles(j,2)+p;
                   break
                else
                   newstepspindles(j,2)=NaN; % if spindle start cannot be found within 1s, don't use it (this occurs when there are NaN in the vector, i.e., animal moving)
                end
            end
        end
    end
    rep=diff(newstepspindles(:,1)); % although if there is a diff of >200ms between peaks in the sqfiltlfp...
         ...the peaks are taken as separate spindles it may happen that the activity in between doesn't decrease below...
             ...mean, in which case both spindles will end up with the same start and end points; this is fine since...
             ...if the activity doesn't fall below mean it can be considered as a single spindle, but at this point of the code...
             ...there will be 2 spindles with the same start and end points and the next 2 lines remove one of them         
    newstepspindles(rep==0,:)=[]; % eliminate repited spindles
    incorrect= isnan(newstepspindles(:,1)) | isnan(newstepspindles(:,2)); % any NaN indicate spindle start/end could not be found because of proximity to a moving period
    newstepspindles(incorrect,:)=[];

    duration2= (newstepspindles(:,2)-newstepspindles(:,1))*sint; % duration in sec.
    spindlesidx=newstepspindles;%((duration2>0.15),:);  % only take as spindles those episodes with at least 150ms duration (~1burst+1interburst interval and also aproxx = to 2* 1/15 i.e. 2 periods of an oscillation of 15Hz); I tried...
        ...based on 3*std but that gets rid of all % maybe base this on the statistics of lfp spindles???
    spindletstart= eeg(2,spindlesidx(:,1));
    spindletend= eeg(2,spindlesidx(:,2));
    spindlestimes= [spindletstart; spindletend]';
    durationspdl{1,1}=duration2; %(duration2>0.15);
    if strcmp(criterion1, 'HVS'); % if looking at Cx electrode
        HVSidx= newstepspindles;%((duration2>0.15),:);
        HVSstart= eeg(2,HVSidx(:,1));
        HVSend= eeg(2,HVSidx(:,2));
        HVStimes= [HVSstart; HVSend]';
        durationHVS{1,1}= duration2;%(duration2>0.15);
    else
    end
end

  

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FIFTH CRITERION: Remove false positives by visual inspection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

falsepos=zeros(1,length(spindlestimes));  
for i=1:length(spindlestimes);
    startraw= find(eeg(2,:)==spindletstart(i));
    endraw= find(eeg(2,:)==spindletend(i));
    spindles= eeg(1,(startraw-(0.5*sr)):(endraw+(0.5*sr))); % for better visualization, use also the 500ms before and after of the spindle
    spindlet= eeg(2,(startraw-(0.5*sr)):(endraw+(0.5*sr)));
    figure; plot(spindlet, spindles,'k');
    xlim([spindlet(1) spindlet(end)]);
    ylim([-800 800]);
    hold on;
    text(spindlet(1)+0.05, 600, 'Click here if spindle real');
    text(spindlet(1)+0.05,-600, 'Click here if false positive');
    [x y]= ginput(1);  %
    if (x*y)<0
        falsepos(i)= 1; % tag false positives
    else
    end
    close
end

totalfpos= (sum(falsepos)./length(falsepos)) *100 % display % of false positives
logfp= (falsepos==1);  
spindletstart(logfp)=[];
spindletend(logfp)=[];
if strcmp(criterion1, 'HVS');
    HVStimes(logfp,:)=[];   % get rid of false positives
else
    spindlestimes(logfp,:)=[];  % get rid of false positives
end


%%

% calculate time of peak amplitude from Hilbert

tmaximos= zeros(1,length(spindletstart));

for i=1:length(spindletstart);
    startraw= find(eegt==spindletstart(i));
    endraw= find(eegt==spindletend(i));
    spindle= rawlfp(startraw:endraw);
    tspindle= eegt(startraw:endraw);
    hspindle= abs(hilbert(spindle));
    maximo= tspindle(hspindle==max(hspindle));
    if length(maximo) >1
        warndlg('more than one maximum in this spindle');
    end
    tmaximos(1,i)= maximo;  %times of peak V
end


dirsave=strcat([maindir directory day '/matlab/tspindlemaximosG1' epoch '_' criterion1]);
save (dirsave, 'tmaximos');



% save for further analysis:

dirsave=strcat([maindir directory day '/matlab/spdlall_G1_Hilbert' epoch '_' criterion1]);
save (dirsave, 'spindlestimes');

if strcmp(criterion1, 'HVS');
    dirsave=strcat([maindir directory day '/matlab/spdlHVS_G1_Hilbert' epoch '_' criterion1]);
    save (dirsave, 'HVStimes');
else
end

% initially keep all durations!!! then decide base on distribution if that
% third criterion is needed!!!!!

%%
%%%%%%%%%%%%%%%%%%
% GET THE STATS
%%%%%%%%%%%%%%%%%%

% build a cell array to access the results in a more organized way...
C= cell(2, 7);

RecDuration= ((length(eeg)-1)*sint)/60/60; % total rec time in h
Tnotmovtime= ((length(quietelectrode)-1)*sint)/60/60;
PerNotmov= (Tnotmovtime/RecDuration)*100;
NumSpdl= length(spindlestimes);
Spdlperqh= NumSpdl/Tnotmovtime; 
AverageSpdlDur= mean(durationspdl{1,1});
StdevSpdlDur= std(durationspdl{1,1});
C(1,1)= {'Duration of recording (h)'};
C(1,2)= {'Total time not-moving (h)'};
C(1,3)= {'% time not-moving (with respect to total)'};
C(1,4)= {'Total # of spindles'};
C(1,5)= {'Spindles/h not moving'};
C(1,6)= {'Average spindle duration (s)'};
C(1,7)= {'Standard deviation of spindle duration'};
C(2,1)= {RecDuration};
C(2,2)= {Tnotmovtime};
C(2,3)= {PerNotmov};
C(2,4)= {NumSpdl};
C(2,5)= {Spdlperqh};
C(2,6)= {AverageSpdlDur};
C(2,7)= {StdevSpdlDur};
  
if strcmp(criterion1, 'HVS');

    C2= cell(2, 7);

    RecDuration= ((length(eeg)-1)*sint)/60/60; % total rec time in h
    Tnotmovtime= ((length(quietelectrode)-1)*sint)/60/60;
    PerNotmov= (Tnotmovtime/RecDuration)*100;
    NumSpdl= length(HVStimes);
    Spdlperqh= NumSpdl/Tnotmovtime; 
    AverageSpdlDur= mean(durationHVS{1,1});
    StdevSpdlDur= std(durationHVS{1,1});
    C2(1,1)= {'Duration of recording (h)'};
    C2(1,2)= {'Total time not-moving (h)'};
    C2(1,3)= {'% time not-moving (with respect to total)'};
    C2(1,4)= {'Total # of spindles'};
    C2(1,5)= {'Spindles/h not moving'};
    C2(1,6)= {'Average spindle duration (s)'};
    C2(1,7)= {'Standard deviation of spindle duration'};
    C2(2,1)= {RecDuration};
    C2(2,2)= {Tnotmovtime};
    C2(2,3)= {PerNotmov};
    C2(2,4)= {NumSpdl};
    C2(2,5)= {Spdlperqh};
    C2(2,6)= {AverageSpdlDur};
    C2(2,7)= {StdevSpdlDur};
else
end

%%%%%%%%%%
% PLOTS 
%%%%%%%%%%
%%
prompt = {'Enter start time for display (seconds):','Enter end time for display:'};
dlg_title = 'Input for plots';
num_lines = 1;
def = {'0','10'}; % default 10sec display 
answer = inputdlg(prompt,dlg_title,num_lines,def);
timestart=answer{1,1};
timestart=str2num(timestart);
timeend=answer{2,1};
timeend=str2num(timeend);


% plot the LFP
%%%%%%%%%%%%%%%
% plot also the raw
rawlfp=load('debufflfpH1_600');
rawlfp=rawlfp.eegTHAL;
rawlfp=rawlfp(s:e);
ztempeeg= eeg(2,:); % have a subplot with all, not only the 'quiet' lfp

loci= ztempeeg>timestart & ztempeeg<timeend;
% if plotting the velocity
vvel= load('velsleepbk_600Hz');
vel= vvel.newvelcms2;
vel= vel(s:e);

scrsz=get(0,'screensize'); 
figure('Position',[80 80 scrsz(3) scrsz(4)/1.2])
hold on;
set(gcf, 'color', 'white');
set(gca, 'Box','off','fontsize',14, 'fontweight', 'bold');
set(gca,'linewidth',2.1); % thickness of the axes    
subplot(4,2,[1 2]); 
    % plot state of the animal (moving/not)  
% % plot(ztempeeg(loci),movinglogic(loci),'.k','markerfacecolor','k','markersize', 10); 
% % ylim([-1 2]);  
% or plot the velocity instead
hold off; plot(ztempeeg(loci),vel(loci),'.k','markerfacecolor','k','markersize', 10); 

set(gcf, 'color', 'white');
set(gca, 'Box','off','fontsize',14, 'fontweight', 'bold');
set(gca, 'xcolor','w'); % no xaxis
text(0.5,-0.5,'0= VEL<5cm/s','fontsize',12); 
    % plot raw lfp
subplot(4,2,[3 4]);
rawlfpplot= rawlfp(1,loci);
plot(eeg(2,loci),rawlfpplot,'k');
hold on;

%plot spindles in same subplot
spdl= spindlestimes;
inrange= spdl(:,1)>timestart & spdl(:,1)<timeend; % find spindles that start within the range to plot
spdlplot= spdl(inrange,:); % select spindles within the range to be plotted
ta=size(spdlplot);
ta=ta(1);
for i=1:ta;
    line([spdlplot(i,1) spdlplot(i,2)], [900 900],'color','r','linestyle','-','linewidth',8);
end

ylim([-1500 1500]);
xlim([timestart timeend]);
set(gca, 'Box','off','fontsize',14, 'fontweight', 'bold');
set(gca,'linewidth',2.1); % thickness of the axes   
set(gca, 'xcolor','w'); % no xaxis   

    % plot filtered lfp   
subplot(4,2,[5 6]);
lfpplot= eeg(1,loci);
plot(eeg(2,loci),lfpplot,'k');
hillfpplot=abs(hilbert(lfpplot));
hold on; plot(eeg(2,loci), hillfpplot,'r');
ylim([-500 500]);
xlim([timestart timeend]);
set(gca, 'Box','off','fontsize',14, 'fontweight', 'bold');
set(gca,'linewidth',2.1); % thickness of the axes   
set(gca, 'xcolor','w'); % no xaxis
    % plot squared lfp and spindles
subplot(4,2,[7 8]);    
plot(ztempeeg(loci), electrodeV(loci),'k');
hold on;
plot(ztempeeg(electrodeV>(m+sdev)),electrodeV(electrodeV>(m+sdev)),'.g');
% line([timestart timeend], [m m],'color','r','linestyle','--','linewidth',3);
set(gcf, 'color', 'white');
ylabel( 'Amplitude', 'fontsize', 20,  'fontName'   , 'Times' , 'fontweight','bold','color','k', 'Rotation', 90 );
xlim([timestart timeend]);
set(gca, 'Box','off','fontsize',14, 'fontweight', 'bold');
set(gca,'linewidth',2.1); % thickness of the axes  
% plot spindles in same subplot
spdl= spindlestimes;
inrange= spdl(:,1)>timestart & spdl(:,1)<timeend; % find spindles that start within the range to plot
spdlplot= spdl(inrange,:); % select spindles within the range to be plotted
ta=size(spdlplot);
ta=ta(1);
for i=1:ta;
    line([spdlplot(i,1) spdlplot(i,2)], [max(electrodeV)+50 max(electrodeV)+50],'color','r','linestyle','-','linewidth',8);
end
