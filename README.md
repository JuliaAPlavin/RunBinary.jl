# Overview

Looking for a simple way to run binaries from the [YggDrasil](https://github.com/JuliaPackaging/Yggdrasil) repo? `RunBinary.jl` has you covered!

Under the hood, it performs the following steps:
- Activate a temporary environment, as in `]activate --temp`.
- Add the required jll package to this env.
- Import the jll and run the target executable.


# Usage from Julia

`RunBinary.jl` exports a single macro, `@run`.

```julia
julia> using RunBinary
```

Most basic usage: run a binary from a jll package with `@run <package>.<binary>`. Here, `package` can be specified either with or without the `_jll` suffix.
For example,
```julia
julia> @run SQLCipher.sqlcipher

julia> @run ImageMagick_jll.identify
```

Can omit the binary name if the package contains only a single binary:
```julia
julia> @run SQLCipher
```

`RunBinary.jl` passes command-line arguments to the binary:

```julia
julia> @run ImageMagick_jll.identify `-version`
```

The binary is started in the current directory by default. The working directory can be set to a temporary directory (same as the activated environment) if desired:

```julia
julia> @run SQLCipher tempdir=true
```

# Command line usage

No separate scripts are provided for now.

`RunBinary.jl` can be executed via Julia CLI in a reasonably convenient way:
```bash
$ julia -e 'using RunBinary; @run ImageMagick_jll.identify `-version`'
```
