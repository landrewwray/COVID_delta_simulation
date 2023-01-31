
%%%Init params:
                   % numGroups,popPerGroup, Rmean, Rsd
numGroups=840; 
popPerGroup=10000;
vaxFrac=0.7;
vaxSD=0.2;
Rmean=0.8/(1-vaxFrac); 
Rsd=0.2/(1-vaxFrac);

tstep=5; %days
totalTime=600; %days
bathRate=10; % expected cases per day 
crossR=0.1; % effective R value for inter-group infection
tConst=5; %exponential time constant

%Now init matrices:
theGroups=initGroups(numGroups,popPerGroup, Rmean, Rsd);
   %theGroups=[Rval, S, I, R/immune]
tmp=zeros([size(theGroups), round(totalTime/tstep)]);
tmp(:,:,1)=theGroups;
theGroups=tmp; clear tmp
   
%Create the cross-infection matrix
crossMat=ones(numGroups)*(crossR/((numGroups-1)));
crossMat=crossMat-diag(diag(crossMat));
crossMat=crossMat*tstep/tConst;

%init vaccinations:
vaxRate=normrnd(vaxFrac,vaxSD,numGroups-1,1);
badIndsHigh=find(vaxRate>1); badIndsLow=find(vaxRate<0);
vaxRate(badIndsHigh)=1; vaxRate(badIndsLow)=0;
theGroups(2:end,2,1)=(1-vaxRate)*popPerGroup;
theGroups(2:end,4,1)=(vaxRate)*popPerGroup;

%Create the 'bath' in bin 1
theGroups(1,3,1)=100; %bath with this many cases
theGroups(1,2,1)=theGroups(1,2,1)-1;
theGroups(1,1,1)=1;

for tPl=2:round(totalTime/tstep)
    theGroups(:,1,tPl)=theGroups(:,1,tPl-1); %keep the same R-value
    
    NewInfections=(theGroups(:,2,tPl-1)/popPerGroup).*(crossMat*theGroups(:,3,tPl-1)); %cross-infection
    NewInfections=NewInfections+ (theGroups(:,2,tPl-1)/popPerGroup).*(theGroups(:,3,tPl-1).*(theGroups(:,1,tPl))*tstep/tConst);
    NewInfections=poissrnd(NewInfections);
    
    NewInfections(1)=theGroups(1,3,1); %preserve the bath
    theGroups(1,2,tPl-1)=popPerGroup;
    theGroups(1,4,tPl-1)=0;
    %     NewInfections=floor(NewInfections+rand(numGroups,1)); % treat fractions probabilistically
    
    %now update all numbers
    theGroups(:,2,tPl)=theGroups(:,2,tPl-1)-NewInfections;
    theGroups(:,3,tPl)=NewInfections;
    theGroups(:,4,tPl)=theGroups(:,4,tPl-1)+theGroups(:,3,tPl-1);
    
    overStepList=find(theGroups(:,2,tPl)<0);
    for OSpl=1:length(overStepList)
        theGroups(overStepList(OSpl),3,tPl)=theGroups(overStepList(OSpl),3,tPl)+theGroups(overStepList(OSpl),2,tPl);
        theGroups(overStepList(OSpl),2,tPl)=0;
        theGroups(overStepList(OSpl),4,tPl)=popPerGroup;
    end 
        
    %!NEXT UPDATE: need to set detailed dynamics of recovery, infection, etc
    
end

[SvsTime, IvsTime,ReffvsTime,RvsTime]=getParams(theGroups,popPerGroup);

figure, plot([1:size(theGroups,3)]*tstep/30,sum(IvsTime,1)/tstep)
xlabel('Time (Months)')
ylabel('Cases per day')
set(gca,'fontsize', 14)
figure, plot([1:size(theGroups,3)]*tstep/30,log(sum(IvsTime,1))/log(10))
ylabel('log(Cases per day)')
xlabel('Time (Months)')
set(gca,'fontsize', 14)

EffectiveMeanR=sum((IvsTime(2:end,:).*(SvsTime(2:end,:)/popPerGroup)).*theGroups(2:end,1,1),1)./sum(IvsTime(2:end,:),1);
figure, plot([1:size(theGroups,3)]*tstep/30,EffectiveMeanR)
ylabel('Case-avergaed intra-population R(t)')
xlabel('Time (Months)')
set(gca,'fontsize', 14)
% figure, plot(log(sum(IvsTime,1)-theGroups(1,3,1)))
% figure, hist3(RvsTime)
ReffvsTime(:,1)=ReffvsTime(:,1)*tstep/30;
figure, hist3(ReffvsTime,'Nbins',[20,20],'CDataMode','auto','FaceColor','interp')
view([111,76])
xlabel('Time (Months)')
ylabel('Intra-population R(t)')
set(gca,'fontsize', 16)

sum(sum(IvsTime(2:end,:)))/(popPerGroup*numGroups)