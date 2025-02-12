
# Evaluate all the algorithms performance for each parEval. 

include("../../../utils.jl")
include("../../../experiment.jl")
using DataFrames
using Latexify

lQl = 2^12
lEQl = 10 
pars = collect(LinRange(0, 1, lQl+1))
par_hat= collect(LinRange(0, 1, lQl*2+1)[2:2:end]) # used for QRDQN methods
parEval = collect(LinRange(0, 1, lEQl*2+1))[2:2:end]

T=100
mdp_dir = "experiment/domain/MDP/"

# Combine evaluation
meanObj = Objective(ρ="E", pars=[1.0],parEval=parEval,T = T) # mean
VaRObj = Objective(ρ="VaR", pars=pars[1:end-1], parEval=parEval,T = T) # VaR
ChowObj = Objective(ρ="CVaR", pars=pars, parEval=parEval,T = T) # CVaR
nVaRObj = Objective(ρ="nVaR", pars=parEval, parEval=parEval,T = T) # nVaR
distVaRObj = Objective(ρ="dVaR", pars=par_hat,parEval=parEval,T = T) # distVaR
EVaRObj = Objective(ρ="EVaR", pars=parEval,parEval=parEval,T = T) # EVaR
objs = [ VaRObj ; nVaRObj;distVaRObj ; meanObj;ChowObj ;EVaRObj  ]  #   

# test
MultiEvals = load_jld("experiment/run/test/multi_evals_$T.jld2")
ret = MultiEvals["$lQl"]["ret"]
domains = [domain for (domain, results) in ret]
# generating plots axis 
output_df = DataFrame(domain = domains)
eval_risk = 0.25 # risk of interest to for table generation

# obtained the upper and lower bound of ̲π amd obtain the performance of ̄π
bound = MultiEvals["$lQl"]["bound"]
output_df[!,"\$\\bar{q}^\\discretized\$"] = round.([VaR(distribution(bound[domain]["VaR_over"]["values"]),[eval_risk])[1]  for domain in domains], digits=2)
output_df[!,"\$\\ushort{q}^\\discretized\$"] = round.([VaR(distribution(bound[domain]["VaR"]["values"]),[eval_risk])[1]  for domain in domains], digits=2)
# Evaluate the performance of all the algorithms with VaR metric
risk_name, eval_metric = ("VaR",VaR)
rets = [simplifyEvals(objs,mdp_dir=mdp_dir,testfile="experiment/run/test/evals_$(T)_$(seed).jld2",eval_metric = eval_metric) for seed in 1:5]
for obj in objs
    each_eval = [[ret[domain][obj.ρ]["values"][ret[domain][obj.ρ]["α"] .== eval_risk][1] for domain in domains] for ret in rets]
    output_df[!,obj.ρ] = ["[$(round(a, digits=2)),$(round(b, digits=2))]" for (a,b) in zip(Base.minimum(hcat(each_eval...),dims=2)[:,1],Base.maximum(hcat(each_eval...),dims=2)[:,1])]
end



println("25% quantile performance")
println(latexify(output_df; env=:table, column_format="|c|c|c|c|c|c|c|c|c|c|", latex=false))

# previously computed row (domain) and column (algorithm). Here we fliped the axis of the table.
function bold_max(values)
    max_bool = values .== maximum(values)
    return ifelse.(max_bool,"\\textbf{","") .* string.(values) .* ifelse.(max_bool,"}","")
end

# flipdf = DataFrame(Dict(vcat([("algorithm",names(output_df)[2:end])] ,[(row[1],string.(collect(row[2:end]))) for row in eachrow(output_df)])))
flipdf = DataFrame(Dict(vcat([("algorithm",names(output_df)[2:end])] ,[(row[1],string.(collect(row[2:end]))) for row in eachrow(output_df)])))

println(latexify(flipdf; env=:table, column_format="|c|c|c|c|c|c|c|c|", latex=false))
