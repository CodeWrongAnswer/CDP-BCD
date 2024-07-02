function [Population,D_dec] = UpdateMainPop(Population,Problem)

LocalC = LocalConvergence(Population);
% keep the local and global PF
new_pop = Population(LocalC == 0);

%% Separate global and local PF
[FrontNo,MaxFNo] = NDSort(new_pop.objs,length(new_pop));
d_dec = pdist2(new_pop.decs,new_pop.decs,'euclidean'); 
temp = sort(d_dec);
nb = min(length(new_pop),2*Problem.D);
sigma_dec = sum(sum(temp(1:nb,:)))./(nb.*Problem.N);

final_pop = new_pop(FrontNo == 1);
remain_pop = new_pop(FrontNo ~= 1);

while ~isempty(remain_pop)
    dist = min(pdist2(final_pop.decs,remain_pop.decs));
    index = dist<sigma_dec;
    remain_pop(index) = [];

    if isempty(remain_pop)
        break;
    end
    %get the front with the max number of solution
    [FrontNo,MaxFNo] = NDSort(remain_pop.objs,length(remain_pop));
    Front_number = [];
    for i=1:MaxFNo
        Front_number = [Front_number length(find(FrontNo == i))];
    end
    [~,index] = max(Front_number);

    if Front_number(index) <= 5  && Problem.FE > Problem.maxFE * 0.5
        break;
    end

    final_pop = [final_pop remain_pop(FrontNo == index)];
    remain_pop = remain_pop(FrontNo ~= index);
end

%% balance the number of global and local PF
if length(final_pop) > Problem.N
    CD = CrowdingH(final_pop.decs);
    [~,index] = sort(CD);
    NextPop = index(1);

    PopDec = final_pop.decs;
    PopObj = final_pop.objs;


    RemianPop = 1:length(final_pop);
    RemianPop(NextPop) = [];

    while length(NextPop) < Problem.N
        EucDisDec = pdist2(PopDec(RemianPop,:),PopDec(NextPop,:),"minkowski",Problem.D);
        EucDisObj = pdist2(PopObj(RemianPop,:),PopObj(NextPop,:),"minkowski",Problem.D);
        
        EucDis = EucDisDec + EucDisObj;

        minDis = min(EucDis,[],2);
        [~,maxInd] = max(minDis);
        NextPop = [NextPop RemianPop(maxInd)];
        RemianPop(maxInd) = [];
    end
    Population = final_pop(NextPop);
    D_dec = CrowdingH(Population.decs);
else
    Population = final_pop;
    D_dec = CrowdingH(Population.decs);
end