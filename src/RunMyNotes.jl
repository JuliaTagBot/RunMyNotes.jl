module RunMyNotes

using Literate, Conda

"""
    RunMyNotes.folder(in, out=in)
Runs all files `*.jl` found in folder `in`, generating a notebook for each, saved in folder `out`. 
Keywords `html=true` then converts this notebook to HTML too,
`throw=true` exits with an error if any errors were encountered in doing this. 
"""
function folder(indir::String, outdir::String=normpath(indir); 
        html::Bool=true, throw::Bool=true, all::Bool=true, credit::Bool=true)
        
    fulldir = normpath(indir)
    @assert isdir(fulldir) && isdir(outdir) "you need to give a directory name"
    
    all || @error "all=false is ignored for now" 
    list = filter(s->endswith(s,".jl"), readdir(indir))
    
    errs = []

    for name in list
        ran = true
        nb = ""
        try
            # file(joinpath(indir, name), outdir; html=html, run=run, credit=credit)
            nb = Literate.notebook(joinpath(fulldir, name), outdir; credit=credit)
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
    
    return true
end


# function file(fullname::String, outdir; html::Bool=true, run::Bool=true, credit::Bool=true)
#
#
# end

function package(mod::Module, outdir=nothing; sub::String="notes", kw...)

    indir = joinpath(dirname(pathof(mod)), "..", sub)

    if outdir==nothing
        outdir = normpath(indir)
    end

    folder(indir, outdir, kw...)
end

end # module
