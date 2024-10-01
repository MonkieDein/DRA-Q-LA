# Distributional Risk-Averse Quantile Q Learning (DRA-Q-LA) 
---
Preliminary: Install Julia and set the folder of this file as directory
---

## Order to run the code
(1) code/others/csv2MDP.jl : Turn MDP domains CSV into MDP objects.
(2) code/experiments/DynamicProgram/a-multipleDiscretizeExperiment.jl :
Run VaR DP for multiple discretizations.
(3) code/experiments/DynamicProgram/b-allAlgorithmsComparison.jl :
Run all other algorithms and compare their performance with VaR-DP.
(4) code/experiments/QLearning/a-qLearning.jl :
Train soft quantile qLearning for different parameter of k.
(5) code/experiments/QLearning/b-evaluateQlearningPolicies.jl :
Evaluate qLearning and compare its value function and policy performance against DP variants.
(6) code/experiments/QLearning/MorePlots/b-QValueW1Distance.jl :
Compute the W1-Distance between qLearning and DP value function.

## File Structure

- **code/**
    - *experiment.jl* : General functions for experiments, includes solveVI, evaluations, simplifyEvals and getTargetVaR.
    - *onlineMDP.jl* : Functions to execute policy in a monte carlo simulation. Type of policies include (Markov, QuantileDependent) as well as their time dependent variant.
    - *riskMeasure.jl* : Functions to create a discrete random variable and compute their risk (mean, min, max, q⁻, VaR, CVaR, ERM, EVaR).
    - *TabMDP.jl* : Define MDP and Objective structure. Solve nested, quantile, ERM, EVaR, and distributional (markovQuantile) Value Iteration / Dynamic Program.
    - *utils.jl* : Commonly used functions for checking directory, decaying coefficient function and multi-dimensions function-applicator.
    - **others/**
        - *csv2MDP.jl* : Code to convert csv MDP files to MDP objects.
    - **experiments/**
        - **DynamicProgram/**
            - *a-multipleDiscretizeExperiment.jl* : For multiple quantile discretization {16,64,256,1024,4096}, run VaR-DP-underApprox and VaR-DP-overApprox, then evaluate their respective policy.
            - *b-allAlgorithmsComparison.jl* : Solve the optimal policy for each of the algorithm with their respective VI, then evaluate their performance.
            - **MorePlots/** : Code to combine multiple plots as subplots to generate a more compact plot.
        - **QLearning/**
            - *a-qLearning.jl* : Run soft quantile Q learning with different kappa parameters {1e-4,1e-8,1e-12,0}.
            - *b-evaluateQlearningPolicies.jl* : Evaluate Q-learning policy, and compare it with the DP variant.
            - **MorePlots/** : Code to combine multiple plots as subplots to generate a more compact plot.
