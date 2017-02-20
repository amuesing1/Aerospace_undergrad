%Test_AircraftLinearModel_Lab6.m
% Nisar Ahmed, ASEN 3128, Spring 2016
clc, clear
close all
recuv_tempest;

%%This file will test the AircraftLinearModel function at the following
%%trim conditions for the recuv_tempest a/c model:
% V_trimTest = 25;
% gamma_trimTest = 0*pi/180;
% h_trimTest = 2300; 
% trim_definitionTest = [V_trimTest; gamma_trimTest; h_trimTest];
% [trim_variablesTest, fval] = CalculateTrimVariables([V_trimTest; gamma_trimTest; h_trimTest], aircraft_parameters);
% [aircraft_stateTest, control_surfacesTest] = TrimConditionFromDefinitionAndVariables(trim_variablesTest, trim_definitionTest);
% [AadTest, BadTest, AyawTest, ByawTest] = ...
%     AircraftLinearModel(aircraft_stateTest, control_surfacesTest, aircraft_parameters);
% [VadTest,DadTest] = eig(AadTest); %long dyn augmented with air density vertical gradient
% [VyawTest,DyawTest] = eig(AyawTest); %lat dyn augmented with yaw and y-pos'n perturbations
% save TestVariables_Lab6 trim_definitionTest trim_variablesTest ...
%      aircraft_stateTest control_surfacesTest ...
%      AadTest BadTest AyawTest ByawTest VadTest DadTest VyawTest DyawTest

load TestVariables_Lab6
problems = 0;
outputs = 0;

disp('-')
disp('Testing AircraftLinearModel:')
[Aad, Bad, Ayaw, Byaw] = ...
    AircraftLinearModel(aircraft_stateTest, control_surfacesTest, aircraft_parameters);

disp('---')
disp('checking Aad output')
AadCheckIssues = abs(Aad - AadTest) > 1e-10
if(any(AadCheckIssues(:)))
   problems = problems + sum(AadCheckIssues(:));
   disp('*** problem with Aad @ locations marked by 1s !!!!!')
else
   disp('works') 
   outputs = outputs + 1;
end

disp('---')
disp('checking Aad output')
BadCheckIssues = abs(Bad - BadTest) > 1e-10
if(any(BadCheckIssues(:)))
   problems = problems + sum(BadCheckIssues(:));
   disp('*** problem with Bad @ locations marked by 1s !!!!!')
else
   disp('works')
   outputs = outputs + 1;
end


disp('---')
disp('checking Ayaw output')
AyawCheckIssues = abs(Ayaw - AyawTest) > 1e-10
if(any(AyawCheckIssues(:)))
   problems = problems + sum(AyawCheckIssues(:));
   disp('*** problem with Ayaw @ locations marked by 1s !!!!!')
else
   disp('works') 
   outputs = outputs + 1;
end

disp('---')
disp('checking Byaw output')
ByawCheckIssues = abs(Byaw - ByawTest) > 1e-10
if(any(ByawCheckIssues(:)))
   problems = problems + sum(ByawCheckIssues(:));
   disp('*** problem with Byaw @ locations marked by 1s !!!!!')
else
   disp('works') 
   outputs = outputs + 1;
end

%%%
disp('--------------')
if problems>0
   disp(['only ',num2str(outputs),' of the 4 function outputs are correct']) 
   disp(['there are ',num2str(problems),' problems to still fix !!!!!'])
   disp('see outputs above...')
else
   disp('Good work, all your outputs are correct !')
   disp('why?')
   why
end 