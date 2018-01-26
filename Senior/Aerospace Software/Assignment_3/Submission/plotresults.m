%Simple script to plot the results of the bistatic processing of the
%direct channel;  create two figures and plot important aspects
function plotresults(e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq,handles)

axes(handles.correlation);
plot(handles.correlation,p_i .^2 + p_q .^ 2, 'g.-')
hold on
grid
plot(handles.correlation,e_i .^2 + e_q .^ 2, 'bx-')
plot(handles.correlation,l_i .^2 + l_q .^ 2, 'r+-')
hold off
xlabel(handles.correlation,'milliseconds')
ylabel(handles.correlation,'amplitude')
title(handles.correlation,'Correlation Results')
legend(handles.correlation,'prompt','early','late')
axes(handles.prompt_I_channel);
plot(handles.prompt_I_channel,p_i)
grid
xlabel(handles.prompt_I_channel,'milliseconds')
ylabel(handles.prompt_I_channel,'amplitude')
title(handles.prompt_I_channel,'Prompt I Channel')
axes(handles.prompt_Q_channel);
plot(handles.prompt_Q_channel,p_q)
grid
xlabel(handles.prompt_Q_channel,'milliseconds')
ylabel(handles.prompt_Q_channel,'amplitude')
title(handles.prompt_Q_channel,'Prompt Q Channel')

axes(handles.code_freq);
plot(handles.code_freq,1.023e6 - codefq)
grid
xlabel(handles.code_freq,'milliseconds')
ylabel(handles.code_freq,'Hz')
title(handles.code_freq,'Tracked Code Frequency (Deviation from 1.023MHz)')
axes(handles.intermediate_freq);
plot(handles.intermediate_freq,carrierfq)
grid
xlabel(handles.intermediate_freq,'milliseconds')
ylabel(handles.intermediate_freq,'Hz')
title(handles.intermediate_freq,'Tracked Intermediate Frequency')
