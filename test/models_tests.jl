using Test
using RxInferServer.Models

@testitem "parse_default_arguments_from_config" begin
    import RxInferServer.Models: parse_default_arguments_from_config

    # Test with empty config
    empty_config = Dict()
    @test parse_default_arguments_from_config(empty_config) == Dict{String, Any}()
    
    # Test with config that has no default arguments
    no_defaults_config = Dict(
        "arguments" => [
            Dict("name" => "arg1", "type" => "int"),
            Dict("name" => "arg2", "type" => "float")
        ]
    )
    @test parse_default_arguments_from_config(no_defaults_config) == Dict{String, Any}()
    
    # Test with config that has default arguments
    with_defaults_config = Dict(
        "arguments" => [
            Dict("name" => "prior_a", "type" => "int", "default" => 1),
            Dict("name" => "prior_b", "type" => "int", "default" => 1),
            Dict("name" => "no_default", "type" => "string")
        ]
    )
    expected = Dict{String, Any}(
        "prior_a" => 1,
        "prior_b" => 1
    )
    @test parse_default_arguments_from_config(with_defaults_config) == expected
    
    # Test with mixed types of default values
    mixed_types_config = Dict(
        "arguments" => [
            Dict("name" => "int_arg", "type" => "int", "default" => 42),
            Dict("name" => "float_arg", "type" => "float", "default" => 3.14),
            Dict("name" => "string_arg", "type" => "string", "default" => "hello"),
            Dict("name" => "bool_arg", "type" => "boolean", "default" => true)
        ]
    )
    expected_mixed = Dict{String, Any}(
        "int_arg" => 42,
        "float_arg" => 3.14,
        "string_arg" => "hello",
        "bool_arg" => true
    )
    @test parse_default_arguments_from_config(mixed_types_config) == expected_mixed
end
