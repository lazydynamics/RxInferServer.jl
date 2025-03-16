# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


function create_model_read(handler)
    function create_model_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        openapi_params["CreateModelRequest"] = OpenAPI.Servers.to_param_type(CreateModelRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function create_model_validate(handler)
    function create_model_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function create_model_invoke(impl; post_invoke=nothing)
    function create_model_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.create_model(req::HTTP.Request, openapi_params["CreateModelRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function delete_model_read(handler)
    function delete_model_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["model_id"] = OpenAPI.Servers.to_param(String, path_params, "model_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function delete_model_validate(handler)
    function delete_model_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function delete_model_invoke(impl; post_invoke=nothing)
    function delete_model_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.delete_model(req::HTTP.Request, openapi_params["model_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_model_details_read(handler)
    function get_model_details_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["model_name"] = OpenAPI.Servers.to_param(String, path_params, "model_name", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_model_details_validate(handler)
    function get_model_details_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_model_details_invoke(impl; post_invoke=nothing)
    function get_model_details_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_model_details(req::HTTP.Request, openapi_params["model_name"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_model_info_read(handler)
    function get_model_info_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["model_id"] = OpenAPI.Servers.to_param(String, path_params, "model_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_model_info_validate(handler)
    function get_model_info_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_model_info_invoke(impl; post_invoke=nothing)
    function get_model_info_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_model_info(req::HTTP.Request, openapi_params["model_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_models_read(handler)
    function get_models_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_models_validate(handler)
    function get_models_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_models_invoke(impl; post_invoke=nothing)
    function get_models_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_models(req::HTTP.Request;)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end


function registerModelsApi(router::HTTP.Router, impl; path_prefix::String="", optional_middlewares...)
    HTTP.register!(router, "POST", path_prefix * "/models/create", OpenAPI.Servers.middleware(impl, create_model_read, create_model_validate, create_model_invoke; optional_middlewares...))
    HTTP.register!(router, "DELETE", path_prefix * "/models/{model_id}/delete", OpenAPI.Servers.middleware(impl, delete_model_read, delete_model_validate, delete_model_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/{model_name}/details", OpenAPI.Servers.middleware(impl, get_model_details_read, get_model_details_validate, get_model_details_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/{model_id}/info", OpenAPI.Servers.middleware(impl, get_model_info_read, get_model_info_validate, get_model_info_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models", OpenAPI.Servers.middleware(impl, get_models_read, get_models_validate, get_models_invoke; optional_middlewares...))
    return router
end
