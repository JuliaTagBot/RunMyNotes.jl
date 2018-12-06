module RunMyNotes

export folder, package

using Literate, Conda

"""
    folder(in, [out])
Runs all files `*.jl` found in folder `in`, generating a Jupyter `.ipynb` notebook for each,
saved in the same folder or in `out` if provided.

Keywords `html=true` then converts this notebook to HTML too,
`throw=true` exits with an error if any errors were encountered in doing this.
Some details about time & computer are printed to the file when 'verbose=true`, and `credit=true` adds links.
"""
function folder(indir::String, outdir::String=normpath(indir);
        html::Bool=true, throw::Bool=true, all::Bool=true, credit::Bool=true, verbose::Bool=true)

    fulldir = normpath(indir)
    @assert isdir(fulldir) && isdir(outdir) "you need to give a directory name"

    pre = verbose ? appendinfo : identity
    post = credit ? appendcredit : identity

    all || @error "all=false is ignored for now"
    list = filter(s->endswith(s,".jl"), readdir(fulldir))

    errs = []

    for name in list
        ran = true
        nb = ""
        try
            nb = Literate.notebook(joinpath(fulldir, name), outdir; credit=credit, preprocess=pre, postprocess=post)
        catch err
            @error "error in running notebook $(name): \n" err
            push!(errs, err)
            ran = false
        end

        if html && ran
            try
                cd(Conda.PYTHONDIR)
                run(`./jupyter nbconvert $nb`)
            catch err
                @error "error in converting notebook $(name): \n" err
                push!(errs, err)
            end
        end
    end

    if throw && length(errs)>0
        error("encountered $(length(errs)) errors executing & converting notebooks, details printed above")
    end

    return length(errs)==0 # for @test
end


"""
    package(ModuleName)
This essentially runs `RunMyNotes.foler("~/.julia/dev/ModuleName/notes/")`.
Change keyword `sub="notes"` to select a different folder.
"""
function package(mod::Module, outdir=nothing; sub::String="notes", kw...)

    indir = joinpath(dirname(pathof(mod)), "..", sub)
    if outdir==nothing
        outdir = normpath(indir)
    end

    return folder(indir, outdir, kw...)
end

using Dates, InteractiveUtils

function infostring()
    io = IOBuffer();
    InteractiveUtils.versioninfo(io)
    s = String(take!(io))
    vinfo = join(split(s, "\n")[[1,4,5]],",") # Julia Version, OS, CPU
    return string(DateTime(now()), ",  ", vinfo)
end

appendinfo(str) = str * string("\n # ----- \n # *", infostring(), "* ") # not entirely happy with \n here

function appendcredit(dict::Dict)
    str = dict["cells"][end]["source"][end]
    rep = replace(str, "/fredrikekre/Literate.jl)" =>
        "/fredrikekre/Literate.jl), called by [RunMyNotes](http://github.com/mcabbott/RunMyNotes.jl)")
    dict["cells"][end]["source"][end] = rep
    return dict
end

end # module
