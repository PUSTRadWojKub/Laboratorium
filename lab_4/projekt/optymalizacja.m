clear;

fitness_funPID = @coeffOptim;
fitness_funDMC = @coeffOptimDMC;

options = optimoptions('ga', 'EliteCount', 50, 'MaxGenerations', 10000, 'PopulationSize', 1000, 'FunctionTolerance', 10e-5, 'PlotFcn', @gaplotbestf);
% [x,fval,exitflag,output] = ga(fitness_funDMC, 7);
[x,fval,exitflag,output] = ga(fitness_funPID, 9,[],[],[],[],[0,0,0,0,0,0,0,0,0],[10,100,10,10,100,10,10,100,10],[],options); 