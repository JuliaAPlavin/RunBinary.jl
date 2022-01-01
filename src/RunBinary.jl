module RunBinary

import Pkg

export @run

macro run(target, args...)
    aargs = []
    aakws = Pair{Symbol,Any}[]
    for el in args
        if Meta.isexpr(el, :(=))
            push!(aakws, Pair(el.args...))
        else
            push!(aargs, el)
        end
    end
    build_expr(target_to_package_and_binary(target)..., aargs...; aakws...)
end

function target_to_package_and_binary(target::Symbol)
    package = package_name_ensure_jll(target)
    return package, get_func_expr(package)
end
function target_to_package_and_binary(target::Expr)
    @assert Meta.isexpr(target, :., 2)
    package = package_name_ensure_jll(target.args[1]::Symbol)
    binary = target.args[2].value::Symbol
    package, get_func_expr(package, binary)
end

get_func_expr(package::Symbol, binary::Symbol) = :( $(esc(package)).$(binary) )
get_func_expr(package::Symbol) = quote
    fields = map(n -> getfield($(esc(package)), n), names($(esc(package))))
    functions = filter(f -> f isa Function, fields)
    only(functions)
end

function build_expr(package::Symbol, binary::Expr, arguments::Expr=:(``); tempdir=false)
    quote
        tempdir = mktempdir()
        Pkg.activate(tempdir)
        $(tempdir ? :(cd(tempdir)) : :())
        Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
        Pkg.add($(string(package)))
        import $package

        func = $(binary)
        arguments = $(arguments)

        func() do f
            run(`$f $arguments`)
        end
    end
end

package_name_ensure_jll(package) = endswith(string(package), "_jll") ? package : Symbol(string(package) * "_jll")

end
