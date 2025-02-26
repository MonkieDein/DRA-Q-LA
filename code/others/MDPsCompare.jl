include("../TabMDP.jl")
include("../utils.jl")
using DataFrames
using CSV

mdp_dir = "experiment/domain/MDP/"
mdp2_dir = "experiment/domain/MDP2/"
domains = readdir(mdp_dir)

for d in domains
    println(d)
    mdp = load_jld(mdp_dir * d)["MDP"]
    mdp2 = load_jld(mdp2_dir * d)["MDP"]
    all(mdp.P .== mdp2.P) ||  error("($d) Transition not equal")
    all(mdp.R .== mdp2.R) ||  error("($d) Reward not equal")
end
