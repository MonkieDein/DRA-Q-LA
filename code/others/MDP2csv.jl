include("../TabMDP.jl")
include("../utils.jl")
using DataFrames
using CSV

mdp_dir = "experiment/domain/MDP/"
csv_dir = "experiment/domain/csv/"
domains = readdir(mdp_dir)

for d in domains
    println(d)
    mdp = load_jld(mdp_dir * d)["MDP"]
    df = MDP2df(mdp,normalizeTransition=true)
    CSV.write(check_path(csv_dir*d[1:end-4]*"csv"),df)
end
