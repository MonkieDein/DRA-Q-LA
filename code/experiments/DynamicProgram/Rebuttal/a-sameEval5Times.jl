
# Evaluate all the algorithms performance for each parEval. 

include("../../utils.jl")
include("../../experiment.jl")
using Plots

lQl = 2^12
lEQl = 10 
pars = collect(LinRange(0, 1, lQl+1))
par_hat= collect(LinRange(0, 1, lQl*2+1)[2:2:end]) # used for QRDQN methods
parEval = collect(LinRange(0, 1, lEQl*2+1))[2:2:end]

marker = Dict("E"=>:diamond,"VaR"=>:circle,"CVaR"=>:hexagon,"EVaR"=>:star5,"nVaR"=>:rect,"dVaR"=>:star4)
col = Dict("E"=>:red,"VaR"=>:blue,"CVaR"=>:brown,"EVaR"=>:cyan,"nVaR"=>:green,"dVaR"=>:black)
mdp_dir = "experiment/domain/MDP/"
need_eval = true

# RUN FINITE HORIZON VALUE ITERATION AND EVALUATION
for T in [100] 
    meanObj = Objective(ρ="E", pars=[1.0],parEval=parEval,T = T) # mean
    VaRObj = Objective(ρ="VaR", pars=pars[1:end-1], parEval=parEval,T = T) # VaR
    ChowObj = Objective(ρ="CVaR", pars=pars, parEval=parEval,T = T) # CVaR
    nVaRObj = Objective(ρ="nVaR", pars=parEval, parEval=parEval,T = T) # nVaR
    distVaRObj = Objective(ρ="dVaR", pars=par_hat,parEval=parEval,T = T) # distVaR
    EVaRObj = Objective(ρ="EVaR", pars=parEval,parEval=parEval,T = T) # EVaR

    objs = [ VaRObj ; nVaRObj;distVaRObj ; meanObj;ChowObj ;EVaRObj  ]  #   

    filename = "experiment/run/train/out_$(T).jld2"
    
    # Solve Value Iteartions 
    solveVI(objs,mdp_dir = mdp_dir,filename = filename)
    vf = init_jld(filename)
    for seed_i in 1:5
        testfile = "experiment/run/test/evals_$(T)_$(seed_i).jld2"
        # Monte Carlo Simulate to evaluate policy performance
        evaluations(vf,objs,ENV_NUM = 100000,mdp_dir=mdp_dir,testfile=testfile,seed=seed_i) #,T_inf=100
    end
end
