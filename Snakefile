rule fig2:
    input:
        "src/scripts/fig2.jl"
    output:
        "src/tex/figures/fig2a.pdf"
        "src/tex/figures/fig2b.pdf"
    shell:
        "julia src/scripts/fig2.jl"

rule fig3:
    input:
        "src/scripts/fig3.jl"
    output:
        "src/tex/figures/fig3a.pdf"
        "src/tex/figures/fig3b.pdf"
    shell:
        "julia src/scripts/fig3.jl"

rule fig4:
    input:
        "src/scripts/fig4_sim.jl"
    output:
        "src/data/resolution_sim.jld2"
    cache:
        True
    shell:
        "julia -p 7 src/scripts/fig4_sim.jl"

rule fig5:
    input:
        "src/scripts/fig5_sim.jl"
    output:
        "src/data/depth_sim.jld2"
    cache:
        True
    shell:
        "julia -p 7 src/scripts/fig5_sim.jl"

rule fig6:
    input:
        "src/scripts/fig6_sim.jl"
    output:
        "src/data/inclination_sim.jld2"
    cache:
        True
    shell:
        "julia -p 7 src/scripts/fig6_sim.jl"

rule fig7:
    input:
        "src/scripts/fig7_sim.jl"
    output:
        "src/data/observation_sim.jld2"
    cache:
        True
    shell:
        "julia -p 7 src/scripts/fig7_sim.jl"


# showyourwork build -s Snakefile --cluster "sbatch -A {cluster.account} -t {cluster.time} -N {cluster.nodes} -n {cluster.ntasks} --mem-per-cpu {cluster.mem_per_cpu}" --cluster-config cluster_config.yml --jobs 1  --cluster-cancel "scancel" --cluster-status --cluster-status ./status.py
# showyourwork build -s Snakefile --cluster "sbatch -A ebf11 -t 01:00:00 -N 1 -n 1 --mem-per-cpu 8192" --cluster-config cluster_config.yml --jobs 1  --cluster-cancel "scancel" --cluster-status --cluster-status ./status.py
