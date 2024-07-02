function [CrowdDis]=CrowdingH(Pop)
%%Harmonic average distance of each solution in the decision space
% return: the crowding distance of each individual
    N = size(Pop,1);
    Distance = pdist2(Pop,Pop);
    Distance(logical(eye(length(Distance)))) = inf;
    Distance = sort(Distance,2);
    a = min(floor(sqrt(N)),5);
    CrowdDis = 1./(Distance(:,a)+2);
end