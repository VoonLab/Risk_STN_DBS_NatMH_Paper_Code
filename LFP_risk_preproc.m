ft_defaults

clearvars

for i=33:37

pnums=[12 14 15 16 26 29 30 31 33 35 39 40 43 44 45 46 50 69 70 73 74 76 77 79 80 81 82 85 83 85 90 91 92 93 94 95 96]; %Go back to 70 for EEG

behav_filename=strcat('Patients/Patient_',num2str(pnums(i)),'/Behavioural/Risk_Task_',num2str(pnums(i)),'.mat');
filename2=strcat('Patients/Patient_',num2str(pnums(i)),'/LFP/risk',num2str(pnums(i)),'.eeg');
blink_filename=strcat('Patients/Patient_',num2str(pnums(i)),'/LFP/blink',num2str(pnums(i)),'.eeg');

partic=pnums(i);
save('risk_marks.mat','filename2','behav_filename','partic');

cfg = [];
cfg.dataset=filename2;
datahdr=ft_read_header(cfg.dataset);
dataevent=ft_read_event(cfg.dataset);
[data]=ft_preprocessing(cfg);

cfg = [];
cfg.dataset = blink_filename;
blinkhdr=ft_read_header(cfg.dataset);
blinkevent=ft_read_event(cfg.dataset);
[blink_data]=ft_preprocessing(cfg);

data.label=upper(data.label);
blink_data.label=upper(blink_data.label);
old={'R5','R6','R7','R8'};
newnames={'R0','R1','R2','R3'};
for t=1:4
compl=strcmp(data.label,old(t));
if sum(compl)==1
    data.label{compl}=newnames{t};
    blink_data.label{compl}=newnames{t};
end
end

cfg=[];
cfg.channel=blink_data.label;
data=ft_selectdata(cfg,data);
same=[];
same.labelnew=data.label;
same.labelold=blink_data.label;
same.tra(1:length(data.label),1:length(blink_data.label))=0;
for u=1:length(data.label)
    same.tra(strcmp(blink_data.label,data.label(u)),u)=1;
end
[blink_data]=ft_apply_montage(blink_data,same);

data.trial{1}(:,:)=ft_preproc_highpassfilter(data.trial{1}(:,:),500,1,6,'but','twopass','no');
blink_data.trial{1}(:,:)=ft_preproc_highpassfilter(blink_data.trial{1}(:,:),500,1,6,'but','twopass','no');

cfg=[];
cfg.layout='tentwenty.mat';
cfg.outline='circle';
cfg.channel={'FP1','FP2','F3','F4','F7','F8','FZ'};
layout=ft_prepare_layout(cfg);

clc
bl_g=input('Press 1 for ICA on Blink Data or 2 for ICA on Experimental Data\n\n');

if bl_g==1
cfg=[];
cfg.event=blinkevent;
cfg.preproc.demean='yes';
cfg.viewmode = 'vertical';
cfg.plotevents='yes';
cfg.continuous='yes';
cfg.linewidth=1;
cfg=ft_databrowser(cfg,blink_data);
cfg.artfctdef.reject='partial';
blink_data=ft_rejectartifact(cfg,blink_data);
elseif bl_g==2
cfg=[];
cfg.event=dataevent;
cfg.preproc.demean='yes';
cfg.viewmode = 'vertical';
cfg.plotevents='yes';
cfg.continuous='yes';
cfg.linewidth=1;
cfg=ft_databrowser(cfg,data);
cfg.artfctdef.reject='partial';
blink_data=ft_rejectartifact(cfg,data);
end

blink_dat=blink_data;

cfg=[];
cfg.channel=ft_channelselection({'FP1','FP2','F3','F4','F7','FZ','F8'},data);
cfg.method='runica';
comp_EEG=ft_componentanalysis(cfg,blink_data);

cfg.channel=ft_channelselection({'L0','L1','L2','L3','R0','R1','R2','R3'},data);
comp_LFP_Uni=ft_componentanalysis(cfg,blink_data);

cfg=[];
cfg.viewmode = 'component';
cfg.layout=layout;
cfg.event=blinkevent;
cfg.plotevents='yes';
cfg.continuous='yes';
ft_databrowser(cfg,comp_EEG)

cfg.component=input('Enter blink component numbers to remove in [] brackets:\n\n');

if length(cfg.component)>0;
data=ft_rejectcomponent(cfg,comp_EEG,data);
end

% for h=1:length(data.trial)
%     for l=1:7
%     for p=1:7
%     elec1(p,:)=comp_EEG.unmixing(l,p)*data.trial{h}(strcmp(comp_EEG.topolabel{p},data.label),:);
%     end
%     data_comp_eeg.trial{h}(l,:)=sum(elec1,1);
%     end
% end

% data_comp_eeg.fsample=500;     %For debugging
% data_comp_eeg.time=data.time;
% data_comp_eeg.topo=comp_EEG.topo;
% data_comp_eeg.label=comp_EEG.label;
% data_comp_eeg.topolabel=comp_EEG.topolabel;
% data_comp_eeg.sampleinfo=data.sampleinfo;

% if isempty(component)==0
% for k=1:length(data_comp_eeg.trial)
%     [IMF{k}(:,:) residual]=emd(data_comp_eeg.trial{k}(component,:),'Display',0);
%     IMF_std{k}=std(IMF{k});
%     thresh=1.5*IMF_std{k}(1);
%     c_r{k}=IMF_std{k}<thresh;
%     IMF{k}=IMF{k}';
%     residual=residual';
%     after_rem{k}=sum(IMF{k}(c_r{k},:))+residual;
%     data_comp_eeg.trial{k}(component,:)=after_rem{k};
% end
% 
% for h=1:length(data.trial)
%     elec2=mtimes((inv(comp_EEG.unmixing)),data_comp_eeg.trial{h}(:,:));
%     for l=1:7
%     data.trial{h}(strcmp(comp_EEG.topolabel{l},data.label),:)=elec2(l,:);
%     end
% end
% end

% cfg=[];
% cfg.viewmode='vertical';
% cfg.event=blinkevent;
% cfg.plotevents='yes';
% cfg.continuous='yes';
% ft_databrowser(cfg,comp_LFP_Bi)
% 
% cfg = [];
% cfg.component=input('Enter component numbers to remove in [] brackets:\n\n');
% 
% if length(cfg.component)>0;
% data=ft_rejectcomponent(cfg,comp_LFP_Bi,data);
% end

cfg=[];
cfg.viewmode='vertical';
cfg.event=blinkevent;
cfg.plotevents='yes';
cfg.continuous='yes';
ft_databrowser(cfg,comp_LFP_Uni)

cfg = [];
cfg.component=input('Enter component numbers to remove in [] brackets:\n\n');

if length(cfg.component)>0;
data=ft_rejectcomponent(cfg,comp_LFP_Uni,data);
end

load('refs.mat');

bipolar=[];
lfpold={'L0','L1','L2','L3','R0','R1','R2','R3'};
EEGold={'EOG','VEOG1','HEOG','LOW_VEOG','HVEOG','LVEOG','ECG'};
lfpchannels=ft_channelselection(lfpold,data);
EEGChans=ft_channelselection(EEGold,data)';
EEGChans=repmat(EEGChans,2,1);
EEGChans(3:5,1:size(EEGChans,2))={'Null'};
electrodes=[electrodes EEGChans];
Weights(:,42:45)=[1 1 1 1;1 1 1 1;0 0 0 0;0 0 0 0;0 0 0 0];

bipolar.labelold=data.label;
line=0;

for r=1:length(electrodes)
    H=[];
    for f=1:Weights(1,r)
        H(f)=sum(strcmp(electrodes(f+1,r),data.label));
    end
        if sum(H)==Weights(1,r)
            line=line+1;
            bipolar.labelnew(line)=electrodes(1,r);
            bipolar.tra(line,1:length(data.label))=0;
            for k=1:Weights(1,r)
                J=find(strcmp(electrodes(k+1,r),data.label));
                bipolar.tra(line,J)=Weights(k+1,r);
            end
        end
end

[data]=ft_apply_montage(data,bipolar);
[blink_data]=ft_apply_montage(blink_data,bipolar);

% n=6;
% Wn=.1/250;
% ftype='high';
% [z,p,k]=butter(n,Wn,ftype);
% sos=zp2sos(z,p,k);
% data.trial{1}(:,:)=sosfilt(sos,data.trial{1}(:,:),2);
% blink_data.trial{1}(:,:)=sosfilt(sos,blink_data.trial{1}(:,:),2);

data_cont=data;
dataz=data;
dataz.trial{1}(:,:)=ft_preproc_standardize(dataz.trial{1}(:,:),1,size(dataz.trial{1}(:,:),2));

data_bsfilt=dataz;
data_lpfilt=dataz;

% data.trial{1}(:,:)=ft_preproc_bandstopfilter(data.trial{1}(:,:),500,[49 51],3,'but','twopass','no');
% blink_data.trial{1}(:,:)=ft_preproc_bandstopfilter(blink_data.trial{1}(:,:),500,[49 51],3,'but','twopass','no');
data_bsfilt.trial{1}(:,:)=ft_preproc_bandstopfilter(data_bsfilt.trial{1}(:,:),500,[99 101],3,'but','twopass','no');
data_bsfilt.trial{1}(:,:)=ft_preproc_bandstopfilter(data_bsfilt.trial{1}(:,:),500,[149 151],3,'but','twopass','no');

data_lpfilt.trial{1}(:,:)=ft_preproc_lowpassfilter(data_lpfilt.trial{1}(:,:),500,100,6,'but','twopass','no');
data_lpfilt.trial{1}(:,:)=ft_preproc_lowpassfilter(data_lpfilt.trial{1}(:,:),500,100,6,'but','twopass','no');

cfg=[];
cfg.dataset=filename2;
cfg.trialfun='trialfun_risk';
cfg=ft_definetrial(cfg);

trl=cfg.trl;
cfg=[];
cfg.trl=trl;
final_databs=ft_redefinetrial(cfg,data_bsfilt);
final_datalp=ft_redefinetrial(cfg,data_lpfilt);
final_dataz=ft_redefinetrial(cfg,dataz);

cfg=[];
cfg.event=dataevent;
cfg.artfctdef.feedback='yes';
cfg.plotevents='yes';
cfg.viewmode = 'vertical';
cfg.preproc.demean='yes';
cfg.linewidth=1;
cfg=ft_databrowser(cfg,final_dataz);

nt=1:length(final_dataz.sampleinfo(:,2));
arts=find(ismember(final_dataz.sampleinfo(:,2),cfg.artfctdef.visual.artifact));
nt(arts)=[];
cfg.trials=nt;
final_databs=ft_selectdata(cfg,final_databs);
final_datalp=ft_selectdata(cfg,final_datalp);
final_dataz=ft_selectdata(cfg,final_dataz);

% cfg.artfctdef.reject='complete';
% final_data{i}=ft_rejectartifact(cfg,final_data{i});

clc
EEG_Ok=input('EEG Ok? 1 = Yes 2 = no\n\n');
clc
LFP_Ok=input('LFP Ok? 1 = Yes 2 = no\n\n');
clc
Notes=input('Notes?\n\n','s');

outname=strcat('Pre_Processed/Preproc_',num2str(pnums(i)),'.mat');

save(outname,'final_datalp','final_databs','final_dataz','data','EEG_Ok','LFP_Ok','Notes','blink_dat')

end