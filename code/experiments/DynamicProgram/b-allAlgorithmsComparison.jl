
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
    testfile = "experiment/run/test/evals_$(T).jld2"
    # Solve Value Iteartions 
    solveVI(objs,mdp_dir = mdp_dir,filename = filename)
    vf = init_jld(filename)
    if need_eval
        # Monte Carlo Simulate to evaluate policy performance
        evaluations(vf,objs,ENV_NUM = 10000,mdp_dir=mdp_dir,testfile=testfile,seed=0) #,T_inf=100
    end

    # Simplify and Plot the Evaluations
    for (risk_name, eval_metric) in [("VaR",VaR)]
        ret = simplifyEvals(objs,mdp_dir=mdp_dir,testfile=testfile,eval_metric = eval_metric)
        for (domain, results) in ret
            plot(title = ( T==-1 ? "infinite" : "$T")*" horizon policy evaluation $domain", xlims=(0,1), xlabel = "Risk level", ylabel = "$risk_name Value",legend=:outerright) # 
            for obj in objs
                ρ = obj.ρ
                result = results[ρ]
                scatter!(result["α"],result["values"], m = marker[ρ],ms=6,color=col[ρ], label=ifelse(ρ=="VaR","Alg 1",ρ),alpha=0.5)
            end
            savefig(check_path("fig/mc_test_result/all_algs/$risk_name/$lQl/$domain-$T.pdf"))
        end
    end
end
