function [Population,CrowdDis] = UpdateAuxiPop(Population,Problem)

LocalC = LocalConvergence(Population);

dist = sort(pdist2(Population.decs,Population.decs));
CrowdDis = sum(dist(1:3,:));

[~,index] = sortrows([LocalC' -CrowdDis']);
Population = Population(index);

if length(Population)>Problem.N
    Population = Population(1:Problem.N);
end

CrowdDis = CrowdingH(Population.decs);

end