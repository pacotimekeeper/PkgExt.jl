module PkgExt

import Pkg
# Write your package code here.

export allpkgs, installdep, setpyenv
export pipinstall, pipinstalled, piplist

function allpkgs()
    deps = Pkg.dependencies()
    installs = Dict{String, VersionNumber}()
    for (_, dep) in deps
        dep.is_direct_dep || continue
        dep.version === nothing && continue
        installs[dep.name] = dep.version::VersionNumber
    end
    return installs
end

function installdep(pkgs::AbstractVector{String})
    installedpackages = allpkgs()
    for pkg in pkgs
        if !haskey(installedpackages, pkg)
            println("Package '$pkg' is not installed. Installing...")
            Pkg.add(pkg)
        end
    end
end

function setpyenv(curdir = pwd())
    Pkg.activate(curdir)
    haskey(allpkgs(), "PyCall") || Pkg.add("PyCall")

    # give the path of python executable
    path = Sys.iswindows() ? joinpath(curdir, "Scripts", "python.exe") : joinpath(curdir, "bin", "python")

    ENV["PYTHON"] = path
    ENV["PYCALL_JL_RUNTIME_PYTHON"] = path
    Pkg.build("PyCall")
end

function alldependencies()
    deps = Pkg.dependencies()
    installs = Dict{String, VersionNumber}()
    for (_, dep) in deps
        dep.is_direct_dep || continue
        dep.version === nothing && continue
        installs[dep.name] = dep.version::VersionNumber
    end
    return installs
end

function pipinstall(pkg::String)
    run(`pip install $pkg`)
end

function activatepyenv()
    run(`source bin activate`)
end

function piplist()
    io = IOBuffer()
    cmd = pipeline(`pip list`; stdout=io, stderr=devnull)
    run(cmd)
    str = String(take!(io))
    pkgVersionPairs = split(str)[5:end]
    # return pkgVersionPairs
    # noOfPairs = length(v)/2 |> Int
    pkgVersionDict = Dict{String, String}()
    for i in 1:length(pkgVersionPairs)
        iszero(i%2) && continue
        pkgVersionDict[pkgVersionPairs[i]] = pkgVersionPairs[i+1]
    end
    pkgVersionDict
    # for i in 1:noOfPairs
    #     println(pkgsVersionPairs[1], pkgsVersionPairs[2])
    # end
end

pipinstalled(pkg::String) = haskey(piplist(), "xlrd")

end