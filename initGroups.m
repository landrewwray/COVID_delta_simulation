function theGroups=initGroups(numGroups,popPerGroup, Rmean, Rsd)
%        theGroups=initGroups(100,       1000,        2,    .5)

theGroups=zeros(numGroups,4); %[Rval, S, I, R/immune]

%start with a gaussian distribution
theGroups(:,1)=normrnd(Rmean,Rsd,numGroups,1);

%do not allow negative R!
theGroups(find(theGroups(:,1)<0),1)=0;
theGroups(:,2)=popPerGroup;

end

