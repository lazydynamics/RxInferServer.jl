# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""ModelDetails

    ModelDetails(;
        details=nothing,
        config=nothing,
    )

    - details::LightweightModelDetails
    - config::Dict{String, Any} : Extended model-specific configuration
"""
Base.@kwdef mutable struct ModelDetails <: OpenAPI.APIModel
    details = nothing # spec type: Union{ Nothing, LightweightModelDetails }
    config::Union{Nothing, Dict{String, Any}} = nothing

    function ModelDetails(details, config, )
        OpenAPI.validate_property(ModelDetails, Symbol("details"), details)
        OpenAPI.validate_property(ModelDetails, Symbol("config"), config)
        return new(details, config, )
    end
end # type ModelDetails

const _property_types_ModelDetails = Dict{Symbol,String}(Symbol("details")=>"LightweightModelDetails", Symbol("config")=>"Dict{String, Any}", )
OpenAPI.property_type(::Type{ ModelDetails }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_ModelDetails[name]))}

function check_required(o::ModelDetails)
    o.details === nothing && (return false)
    o.config === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ ModelDetails }, name::Symbol, val)


end
