# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


function get_server_info_read(handler)
    function get_server_info_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_server_info_validate(handler)
    function get_server_info_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_server_info_invoke(impl; post_invoke=nothing)
    function get_server_info_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_server_info(req::HTTP.Request;)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end


function registerServerApi(router::HTTP.Router, impl; path_prefix::String="", optional_middlewares...)
    HTTP.register!(router, "GET", path_prefix * "/info", OpenAPI.Servers.middleware(impl, get_server_info_read, get_server_info_validate, get_server_info_invoke; optional_middlewares...))
    return router
end
