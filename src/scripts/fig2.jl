# find the project file and instantiate environment from manifest
using Pkg
Pkg.activate(".")
Pkg.instantiate()

# package imports
using GRASS
using Statistics

# showyourwork imports
using PyCall
py"""
from showyourwork.paths import user as Paths

paths = Paths()
"""

py"""
import os
from pathlib import Path
os.environ["PATH"] += os.pathsep + str(Path.home() / "bin")
"""

# plotting imports
using LaTeXStrings
import PyPlot; plt = PyPlot; mpl = plt.matplotlib; plt.ioff()
mpl.style.use(py"""str(paths.scripts)""" * "/fig.mplstyle")

# define directories
const plotdir = py"""str(paths.figures)""" * "/"
const datadir = py"""str(paths.data)""" * "/"
const staticdir = py"""str(paths.static)""" * "/"

# figure 2 -- cleaned + extrapolated input data
function fig2ab()
    # set number of curves to plot
    ncurves = 25

    # get input data
    bisinfo = GRASS.SolarData(relative=true, extrapolate=true)
    key = (:c, :mu10)
    bis = bisinfo.bis[key]
    wav = bisinfo.wav[key]
    dep = bisinfo.dep[key]
    wid = bisinfo.wid[key]

    # create colormap and colorbar
    nstp = round(Int, size(bis,2) / ncurves)
    iter = 1:nstp:size(bis,2)
    iter = 1:2:30
    cmap = plt.get_cmap("Blues", length(iter))
    cols = [cmap(1*i/length(iter)) for i in 1:length(iter)]
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=mpl.colors.Normalize(vmin=0, vmax=15 * iter[end]/60.0))

    # plot the bisectors
    fig = plt.figure()
    ax1 = fig.add_subplot()
    for (i, t) in enumerate(iter)
        ax1.plot(wav[:,t][2:end].*1000, bis[:,t][2:end], c=cols[i], alpha=0.75)
    end

    # shade upper region
    xlims = ax1.get_xlim()
    ax1.fill_between(range(xlims..., step=0.1), 0.8, 1.0, hatch="/",
                     fc="black", ec="white", alpha=0.15, zorder=0)

    # set axis limits + labels
    ax1.set_xlim(xlims...)
    ax1.set_ylim(0.1, 1.0)
    ax1.set_xlabel(L"{\rm Relative\ Wavelength\ (m\AA)}")
    ax1.set_ylabel(L"{\rm Normalized\ Intensity}")

    # set color bar
    cb = fig.colorbar(sm)
    cb.set_label(L"{\rm Time\ from\ first\ observation\ (min)}")

    # save the plot
    fig.savefig(plotdir * "fig2a.pdf")
    plt.clf(); plt.close()
    println(">>> Figure written to: " * plotdir * "fig2a.pdf")

    # plot the widths
    fig = plt.figure()
    ax1 = fig.add_subplot()
    for (i, t) in enumerate(iter)
        ax1.plot(dep[:,t], wid[:,t], c=cols[i], alpha=0.75)
    end

    # set axis limits + labels
    ax1.set_xlabel(L"{\rm Normalized\ Intensity}")
    ax1.set_ylabel(L"{\rm Width\ across\ line\ (\AA)}")

    # set color bar
    cb = fig.colorbar(sm)
    cb.set_label(L"{\rm Time\ from\ first\ observation\ (min)}")

    # save the plot
    fig.savefig(plotdir * "fig2b.pdf")
    plt.clf(); plt.close()
    println(">>> Figure written to: " * plotdir * "fig2b.pdf")
    return nothing
end

fig2ab()
