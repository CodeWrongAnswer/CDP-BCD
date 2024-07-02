classdef CDPBCD < ALGORITHM
% <multi> <real> <multimodal>
% A dual-population coevolutionary algorithm for balancing convergence and 
% diversity in the decision space in multimodal multi-objective optimization

%------------------------------- Reference --------------------------------
% Li Z, Rong H, Yang S, et al. A dual-population coevolutionary algorithm for
% balancing convergence and diversity in the decision space in multimodal 
% multi-objective optimization[J]. Applied Soft Computing, 2024: 111770.
%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    methods
        function main(Algorithm,Problem)
            
            %% Generate random population
            Population1 = Problem.Initialization();
            Population2 = Problem.Initialization();
            [~,CrowdDis1] = UpdateAuxiPop(Population1,Problem);
            [Population2,D_dec] = UpdateMainPop(Population2,Problem);
          
            %% Optimization
            while Algorithm.NotTerminated(Population2)
                if length(Population2) < Problem.N
                    MatingPool1 = TournamentSelection(2,round(Problem.N),CrowdDis1);
                    Offspring  = OperatorGA([Population1(MatingPool1)]);
                else
                    MatingPool1 = TournamentSelection(2,round(Problem.N),CrowdDis1);
                    Offspring1  = OperatorGAhalf([Population1(MatingPool1)]);
                    MatingPool2 = TournamentSelection(2,round(Problem.N),D_dec);
                    Offspring2  = OperatorGAhalf([Population2(MatingPool2)]);
                    Offspring = [Offspring1 Offspring2];
                end
                [Population1,CrowdDis1] = UpdateAuxiPop([Population1,Offspring],Problem);
                [Population2,D_dec] = UpdateMainPop([Population2,Offspring],Problem);

                length(Population2)
            end
        end
    end
end
