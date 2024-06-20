function [trl, event] = trialfun_risk(cfg)

load('risk_marks.mat')
load(behav_filename)

cfg.dataset=filename2;
hdr=ft_read_header(cfg.dataset);
event=ft_read_event(cfg.dataset);

for j=1:length(event)
    sample(j)=event(j).sample;
    vals{j}=event(j).value;
end

vals(1)=[];
sample(1)=[];
sample=round(sample);

if partic==76
    vals(595)=[];
end

for j=1:length(vals)
    valuesv(j)=sscanf(vals{j},'S%d');
end

if partic<=26

Card2=Card;
ext=find(valuesv>=254);
valuesv(ext-1)=[];
sample(ext-1)=[];
sample(valuesv>=254)=[];
valuesv(valuesv>=254)=[];

Card(:,1)=valuesv(valuesv>10 & valuesv<=20);
Bet(:,1)=valuesv(valuesv==31|valuesv==32);
Outcome(:,1)=valuesv(valuesv>40 & valuesv<=50);
sample_begin(:,1)=sample(valuesv>10 & valuesv<=20)-1750;
sample_end(:,1)=sample(valuesv>40 & valuesv<=50)+2750;  
offset(1:length(sample_begin),1)=-1750;
rt1(:,1)=rt;
trlnum(:,1)=1:length(Card);
stim(1:length(sample_begin),1)=1;

trl=[sample_begin sample_end offset sample_begin sample_end Card Bet Outcome rt1 stim trlnum];

elseif partic>=27 && partic<=35

Card2=Card;
clear Card
sample(valuesv==255)=[];
valuesv(valuesv==255)=[];
ext=find(valuesv==223);
valuesv(ext-1)=[];
sample(ext-1)=[];
sample(valuesv==223)=[]; %was 223
valuesv(valuesv==223)=[];
%valuesv(valuesv>160 & valuesv<=170)=valuesv(valuesv>160 & valuesv<=170)-80;
valuesv(valuesv>40 & valuesv<=50)=valuesv(valuesv>40 & valuesv<=50)+40;

Card(:,1)=valuesv(valuesv>10 & valuesv<=20);
Bet(:,1)=valuesv(valuesv==71|valuesv==72)-40;
%Bet(:,1)=valuesv(valuesv==31|valuesv==32);
rt1(:,1)=rt;
sample_begin(:,1)=sample(valuesv>10 & valuesv<=20)-1750;
Outcome(:,1)=valuesv(valuesv>80 & valuesv<=90)-40;
sample_end(:,1)=sample(valuesv>80 & valuesv<=90)+2750;
offset(1:length(sample_begin),1)=-1750;
trlnum(:,1)=1:length(Card);
stim(:,1)=stim_trials;
trl=[sample_begin sample_end offset sample_begin sample_end Card Bet Outcome rt1 stim trlnum];

elseif partic>=36 && partic<69

Card2=Card;
clear Card
sample(valuesv==255)=[];
valuesv(valuesv==255)=[];

if partic<43
ext=find(valuesv==223);
valuesv(ext-1)=[];
sample(ext-1)=[];
sample(valuesv==223)=[]; %was 223
valuesv(valuesv==223)=[];
Bet(:,1)=valuesv(valuesv==71|valuesv==72)-40;
elseif partic>=43
ext=find(valuesv==190);
valuesv(ext-1)=[];
sample(ext-1)=[];
sample(valuesv==190)=[]; %was 223
valuesv(valuesv==190)=[];
Bet(:,1)=valuesv((valuesv==31|valuesv==32));
end
%valuesv(valuesv>160 & valuesv<=170)=valuesv(valuesv>160 & valuesv<=170)-80;
valuesv(valuesv>40 & valuesv<=50)=valuesv(valuesv>40 & valuesv<=50)+40;

Card(:,1)=valuesv(valuesv>10 & valuesv<=20);
rt1(:,1)=rt;
sample_begin(:,1)=sample(valuesv>10 & valuesv<=20)-1750;
Outcome(:,1)=valuesv(valuesv>80 & valuesv<=90)-40;
sample_end(:,1)=sample(valuesv>80 & valuesv<=90)+2750;
offset(1:length(sample_begin),1)=-1750;
trlnum(:,1)=1:length(Card);
stim(:,1)=stim_trials;
trl=[sample_begin sample_end offset sample_begin sample_end Card Bet Outcome rt1 stim trlnum];

elseif partic>=69
    
Card2=Card;
clear Card
sample(valuesv==255)=[];
valuesv(valuesv==255)=[];

if partic==80
valuesv(1:2)=[];
end

ext=find(valuesv==190);
valuesv(ext-1)=[];
sample(ext-1)=[];
ext=find(valuesv==190);
valuesv(ext-1)=[];
sample(ext-1)=[];
sample(valuesv==190)=[];
valuesv(valuesv==190)=[];

ext=find(valuesv==188);
valuesv(ext-1)=[];
sample(ext-1)=[];
ext=find(valuesv==188);
valuesv(ext-1)=[];
sample(ext-1)=[];
% ext=find(valuesv(2:end)==188);
% valuesv(ext-1)=[];
% sample(ext-1)=[];
sample(valuesv==188)=[];
valuesv(valuesv==188)=[];
Bet(:,1)=valuesv((valuesv==31|valuesv==32));


valuesv(valuesv>40 & valuesv<=50)=valuesv(valuesv>40 & valuesv<=50)+40;

Card(:,1)=valuesv(valuesv>10 & valuesv<=20);
rt1(:,1)=rt;
sample_begin(:,1)=sample(valuesv>10 & valuesv<=20)-1750;
Outcome(:,1)=valuesv(valuesv>80 & valuesv<=90)-40;
sample_end(:,1)=sample(valuesv>80 & valuesv<=90)+2750;
offset(1:length(sample_begin),1)=-1750;
trlnum(:,1)=1:length(Card);
stim(:,1)=stim_trials;
trl=[sample_begin sample_end offset sample_begin sample_end Card Bet Outcome rt1 stim trlnum];

end

clearvars -except trl event