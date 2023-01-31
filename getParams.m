function [SvsTime, IvsTime,ReffvsTime,RvsTime]=getParams(theGroups,popPerGroup)
% [SvsTime, IvsTime,ReffvsTime,RvsTime]=getParams(theGroups,popPerGroup);

%ReffDist shows regional Reff.  Maybe plot with a 2D histogram?

IvsTime=zeros(size(theGroups,1),size(theGroups,3));
IvsTime(:,:)=theGroups(:,3,:); %sum over 1st axis for total curve

SvsTime=zeros(size(theGroups,1),size(theGroups,3));
SvsTime(:,:)=theGroups(:,2,:); %sum over 1st axis for total curve

RvsTime=zeros(size(theGroups,1),size(theGroups,3));
RvsTime(:,:)=theGroups(:,1,:);

ReffvsTime=zeros(size(theGroups,1),size(theGroups,3));
ReffvsTime(:,:)=theGroups(:,1,:);
ReffvsTime(:,:)=ReffvsTime(:,:).*(SvsTime/popPerGroup);

%restructure for 2D histogramming:
RvsTime=[kron([1:size(theGroups,3)]',ones(size(theGroups,1),1)), (RvsTime(:))];
ReffvsTime=[kron([1:size(theGroups,3)]',ones(size(theGroups,1),1)), (ReffvsTime(:))];

end


