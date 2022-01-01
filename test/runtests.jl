import RunBinary
using Test

@testset begin
    res = RunBinary.target_to_package_and_binary(:SQLCipher)
    @test length(res) == 2
    @test res[1] == :SQLCipher_jll
    @test Meta.isexpr(res[2], :block)
end

@testset begin
    res = RunBinary.target_to_package_and_binary(:(SQLCipher.sqlcipher))
    @test length(res) == 2
    @test res[1] == :SQLCipher_jll
    @test Meta.isexpr(res[2], :., 2)
end
