%Test_AircraftLinearModel.m
% Nisar Ahmed, ASEN 3128, Spring 2016
clc, clear
close all
recuv_tempest;

%%This file will test the AircraftLinearModel function at the following
%%trim conditions for the recuv_tempest a/c model:
% % V_trimTest = 25;
% % gamma_trimTest = 0*pi/180;
% % h_trimTest = 2300; 
% % trim_definitionTest = [V_trimTest; gamma_trimTest; h_trimTest];
% % [trim_variablesTest, fval] = CalculateTrimVariables([V_trimTest; gamma_trimTest; h_trimTest], aircraft_parameters);
% % [aircraft_stateTest, control_surfacesTest] = TrimConditionFromDefinitionAndVariables(trim_variablesTest, trim_definitionTest);
% % [AadTest, BadTest, AyawTest, ByawTest] = ...
% %     AircraftLinearModel(aircraft_stateTest, control_surfacesTest, aircraft_parameters);
% % [VadTest,DadTest] = eig(AadTest); %long dyn augmented with air density vertical gradient
% % [VyawTest,DyawTest] = eig(AyawTest); %lat dyn augmented with yaw and y-pos'n perturbations
% % save TestVariables_Lab5 trim_definitionTest trim_variablesTest ...
% %      aircraft_stateTest control_surfacesTest ...
% %      AadTest BadTest AyawTest ByawTest VadTest DadTest VyawTest DyawTest

load TestVariables_Lab5
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
if(any(Byaw(:)))
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
   disp('All your base are belong to us...')
end

%%%**********************************
% %%% Compare eigenvalues for test case
% [~,DadTest] = eig(AadTest);
% [~,DyawTest] = eig(AyawTest);
% [~,Dad] = eig(Aad); %long dyn augmented with air density vertical gradient
% [~,Dyaw] = eig(Ayaw); %lat dyn augmented with yaw and y-pos'n perturbations
% 
% disp('Comparing eigenvalues for test case:')
% disp('Correct Longitudinal state e''vals: ')
% diag(DadTest)
% disp('Your Longitudinal state e''vals: ')
% diag(Dad)
% disp('******************')
% disp('Correct Lateral state e''vals: ')
% diag(DyawTest)
% disp('Your Lateral state e''vals:')
% diag(Dyaw)

%%%**********************************
%%% Correct eigenvalues for part 1 with Tempest model at trim conditions
%%% of V = 22 ms/, gamma_a = 0 deg, h = 2438.5:

% % ******Aad e'vals:
% % Pole              Damping       Frequency       Time Constant  
% %                                        (rad/TimeUnit)     (TimeUnit)    
% %                                                                         
% %   0.00e+00                -1.00e+00       0.00e+00               Inf    
% %  -5.51e+00 + 6.91e+00i     6.24e-01       8.84e+00          1.81e-01    
% %  -5.51e+00 - 6.91e+00i     6.24e-01       8.84e+00          1.81e-01    
% %  -7.83e-02 + 5.12e-01i     1.51e-01       5.18e-01          1.28e+01    
% %  -7.83e-02 - 5.12e-01i     1.51e-01       5.18e-01          1.28e+01    
% %  -6.95e-04                 1.00e+00       6.95e-04          1.44e+03


% % ******Ayaw e'vals:
% % Pole              Damping       Frequency       Time Constant  
% %                                        (rad/TimeUnit)     (TimeUnit)    
% %                                                                         
% %   0.00e+00                -1.00e+00       0.00e+00               Inf    
% %   0.00e+00                -1.00e+00       0.00e+00               Inf    
% %  -1.79e+01                 1.00e+00       1.79e+01          5.57e-02    
% %  -6.01e-01 + 4.36e+00i     1.36e-01       4.40e+00          1.66e+00    
% %  -6.01e-01 - 4.36e+00i     1.36e-01       4.40e+00          1.66e+00    
% %   6.54e-02                -1.00e+00       6.54e-02         -1.53e+01  