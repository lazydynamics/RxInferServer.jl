using RxInferServer
using Documenter
using DocumenterMermaid

DocMeta.setdocmeta!(RxInferServer, :DocTestSetup, :(using RxInferServer); recursive=true)

"""
    parse_openapi_methods()

Parses the openapi/server/src/RxInferServerOpenAPI.jl file to extract API method names
from its documentation header. Returns an array of method names and a list of docfixes.

The docfixes are used to fix weird italic formatting in the generated OpenAPI docs.
"""
function parse_openapi_methods()
    openapi_file = joinpath(@__DIR__, "..", "openapi", "server", "src", "RxInferServerOpenAPI.jl")

    # Check if the file exists
    if !isfile(openapi_file)
        @warn "OpenAPI file not found: $openapi_file"
        return String[]
    end

    # Read the file content
    content = read(openapi_file, String)

    # Find the documentation block
    doc_start = findfirst(r"@doc\s+raw\"\"\"", content)
    if doc_start === nothing
        @warn "Documentation block not found in OpenAPI file"
        return String[], Pair[]
    end

    # Find the module declaration (end of doc block)
    module_start = findfirst("module RxInferServerOpenAPI", content)
    if module_start === nothing
        @warn "Module declaration not found in OpenAPI file"
        return String[], Pair[]
    end

    # Extract the documentation block
    doc_block = content[doc_start.stop:module_start.start-1]

    # Extract method names using regex
    # Pattern: - **method_name**
    method_matches = eachmatch(r"-\s+\*\*([a-zA-Z0-9_]+)\*\*", doc_block)

    # Collect method names
    methods = String[]
    docfixes = Pair[]
    for m in method_matches
        push!(methods, m.captures[1])
        push!(docfixes, m.captures[1] => "`" * m.captures[1] * "`")
    end

    return methods, docfixes
end

# Get API methods
api_methods, docfixes = parse_openapi_methods()
@info "Detected OpenAPI methods:\n" * join(["  • " * method for method in api_methods], "\n")

"""
    copy_openapi_docs()

Copies the autogenerated OpenAPI documentation from openapi/server/docs to docs/src/openapi
and returns a list of pages to be added to the documentation.
"""
function copy_openapi_docs()
    # Create the destination directory if it doesn't exist
    openapi_docs_dir = joinpath(@__DIR__, "src", "openapi")
    mkpath(openapi_docs_dir)

    # Path to the OpenAPI generated docs
    openapi_source_dir = joinpath(@__DIR__, "..", "openapi", "server", "docs")

    # Banner to add at the top of each file
    autogen_banner = """
    !!! info "Auto-generated content"
        This page is automatically generated from the OpenAPI specification.

    """

    # Get a list of all markdown files in the OpenAPI docs
    openapi_files = filter(file -> endswith(file, ".md"), readdir(openapi_source_dir))

    # Copy README.md file as well
    readme_source = joinpath(@__DIR__, "..", "openapi", "server", "README.md")
    readme_dest = joinpath(openapi_docs_dir, "README.md")
    if isfile(readme_source)
        readme_content = read(readme_source, String)

        # Fix the relative links in README file (e.g., docs/ServerInfo.md -> ServerInfo.md)
        readme_content = replace(readme_content, r"docs/([A-Za-z0-9_]+\.md)" => s"\1", docfixes...)

        # Add the auto-generated banner
        readme_content = autogen_banner * readme_content * autogen_banner

        # Write the modified README content
        write(readme_dest, readme_content)
    end

    # Copy each file, fix relative paths, and collect the page entries for the docs
    openapi_pages = []

    for file in openapi_files
        source_path = joinpath(openapi_source_dir, file)
        dest_path = joinpath(openapi_docs_dir, file)

        # Read the file content
        content = read(source_path, String)

        # Replace all relative references to README from ../README.md to README.md
        content = replace(content, "../README.md" => "README.md")

        # Fix the relative links to other docs (e.g., docs/ServerInfo.md -> ServerInfo.md)
        content = replace(content, r"docs/([A-Za-z0-9_]+\.md)" => s"\1", docfixes...)

        # Add the auto-generated banner
        content = autogen_banner * content * autogen_banner

        # Write the modified content to the destination file
        write(dest_path, content)

        # Add to pages array (remove .md extension for the page name)
        page_name = replace(file, ".md" => "")
        push!(openapi_pages, page_name => joinpath("openapi", file))
    end

    # Add README to the pages
    if isfile(readme_dest)
        pushfirst!(openapi_pages, "Overview" => joinpath("openapi", "README.md"))
    end

    return openapi_pages
end

# Get OpenAPI documentation pages
openapi_pages = copy_openapi_docs()

makedocs(;
    modules=[RxInferServer],
    warnonly = false,
    authors="Lazy Dynamics <info@lazydynamics.com>",
    sitename="RxInferServer.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://api.rxinfer.com",
        edit_link="main",
        assets=String[],
        description="A RESTful HTTP server implementation for RxInfer.jl, a reactive message passing inference engine for probabilistic models.",
        footer="Created by [ReactiveBayes](https://github.com/ReactiveBayes), fully sponsored by [LazyDynamics](https://lazydynamics.com/), powered by [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) and the [Julia Programming Language](https://julialang.org/)."
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "getting-started.md",
        "Configuration" => "configuration.md",
        "Implementation" => [
            "Database" => "implementation/database.md",
            "Logging" => "implementation/logging.md",
            "Developers guide" => "implementation/development.md",
        ],
        "Design proposal" => "api/design-proposal.md",
        "OpenAPI Specification" => openapi_pages,
    ],
)

deploydocs(;
    repo="github.com/lazydynamics/RxInferServer.jl",
    devbranch="main",
    forcepush=true,
    cname="api.rxinfer.com"
)
