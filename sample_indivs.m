% sample_indivs takes in subpop specs and outputs indices and weights for 
% sampled individuals.
% Inputs:
%   N_s: If stratified, Sx1 vector of subpop sizes; else, population size
%   n_s: If stratified, Sx1 vector of subpop sample sizes; else, sample size
%   S: Number of subpops
%   strat: Boolean specifying whether to stratify sampling by subpop
%   Si_pop: vector of subpop assignments for all indivs; Nx1
%   Ci_pop: vector of global class assignments for all indivs; Nx1
%   Li_pop: vector of local class assignments for all indivs; Nx1
%   X_pop: matrix of population consumption data for all indivs and items; Nxp
%   Y_pop: vector of population outcome data for all indivs; Nx1
%   K: Number of global classes
%   sim_data: Structural array with the following fields:
%       true_pi: vector of true global class membership probabilities; Kx1
%       true_lambda: vector of true local class membership probabilities; Lx1
%       true_global_patterns: matrix of true item consumption levels for each global class; pxK
%       true_local_patterns: array of true item consumption levels for each local class; pxSxL
%       true_global_thetas: array of item response probs for global classes; pxKxd
%       true_local_thetas: array of item response probs for local classes; pxSxLxd
%       nu: vector of subpop-specific probs of global assigment for all items; Sx1
%       Gsj: matrix of true assignments to global/local for each subpop and item; Sxp
%       true_xi: vector of true probit model coefficients; (K+S)x1
%       true_Phi: vector of true probit means, P(y_i=1|Q); Nx1
% Outputs: Updated sim_data with the following additional fields:
%   samp_ind: vector of indices of sampled indivs; nx1
%   sample_wt: vector of sampling weights for sampled indivs; nx1
%   norm_const:vector of normalization constants, one per subpop; Sx1   
%   true_Si: vector of subpop assigns for sampled indivs; nx1
%   true_Ci: vector of global class assigns for sampled indivs; nx1
%   true_Li: vector of local class assigns for sampled indivs; nx1
%   X_data: matrix of consumption data for sampled indivs and items; nxp
%   Y_data: vector of outcome data for sampled indivs and items; nx1
%   true_K: Number of global classes
function sim_data = sample_indivs(N_s, n_s, S, strat, Si_pop, Ci_pop, Li_pop, X_pop, Y_pop, K, sim_data) 
    if strat == false                                        % If not stratifying by subpop
        sim_data.samp_ind = randsample(N_s, n_s);            % Indices of randomly sampled indivs
        wt_s = N_s / n_s;                                    % Sampling weight
        pop_wt = ones(N_s, 1) * wt_s;                        % Weights, temp applied to all popn indivs
        sim_data.sample_wt = pop_wt(sim_data.samp_ind);      % Weights for sampled indivs 
        sim_data.norm_const = sum(sim_data.sample_wt / N_s); % Normalization constant. Default is 1

    else 
        sim_data.samp_ind = cell(S, 1);   % Initialize indices of sampled indivs, grouped by subpop
        sim_data.sample_wt = cell(S, 1);  % Initialize sampling weights for sampled indivs, grouped by subpop
        sim_data.norm_const = cell(S, 1); % Initialize normalization constant for each subpop
      
        % Obtain indices and weights for sampled individuals in each subpop
        for s = 1:S  % For each subpopulation
            % Indices of randomly sampled indivs from subpop s
            sim_data.samp_ind{s} = randsample(N_s(s), n_s(s));     
            wt_s = N_s(s) / n_s(s);             % Sampling weight for subpop s
            pop_wt_s = ones(N_s(s), 1) * wt_s;  % Weights for subpop s, temp applied to all popn indivs
            % Weights for sampled indivs in subpop s
            sim_data.sample_wt{s} = pop_wt_s(sim_data.samp_ind{s});        
            % Normalization constant for subpop s weights
            sim_data.norm_const{s} = sum(sim_data.sample_wt{s}) / N_s(s); 
        end
        
        % Convert cell arrays to vectors through vertical concat 
        sim_data.samp_ind = vertcat(sim_data.samp_ind{:});  
        sim_data.sample_wt = vertcat(sim_data.sample_wt{:});
        sim_data.norm_const = vertcat(sim_data.norm_const{:});
    end    

    % Obtain observed sample data
    sim_data.true_Si = Si_pop(sim_data.samp_ind);   % Subpop assignments for sampled indivs
    sim_data.true_Ci = Ci_pop(sim_data.samp_ind);   % True global class assignments for sampled indivs
    sim_data.true_Li = Li_pop(sim_data.samp_ind);   % True local class assignments for sampled indivs
    sim_data.X_data = X_pop(sim_data.samp_ind, :);  % Consumption data for sampled indivs
    sim_data.Y_data = Y_pop(sim_data.samp_ind);     % Outcome data for sampled indivs
    sim_data.true_K = K;                            % Rename variable for number of classes
end