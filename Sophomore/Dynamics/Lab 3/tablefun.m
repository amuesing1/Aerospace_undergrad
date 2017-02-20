function [std_res, mean_res, std_mean_res, obs, num_res_3] = tablefun( res )

std_res = std(res);
mean_res = mean(res);
std_mean_res = std(res)/sqrt(length(res));
obs = length(res);
num_res_3 = length(find((res-(3*std_res)) > 0));

end

