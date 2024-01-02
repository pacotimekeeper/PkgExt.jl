using PkgExt
using Documenter

DocMeta.setdocmeta!(PkgExt, :DocTestSetup, :(using PkgExt); recursive=true)

makedocs(;
    modules=[PkgExt],
    authors="Paco Ho",
    repo="https://github.com/pacotimekeeper/PkgExt.jl/blob/{commit}{path}#{line}",
    sitename="PkgExt.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pacotimekeeper.github.io/PkgExt.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pacotimekeeper/PkgExt.jl",
    devbranch="main",
)
