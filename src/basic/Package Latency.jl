### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/main/LICENSES/Unlicense"
#> image = "https://github.com/user-attachments/assets/3a5e8899-791b-441b-acd4-9399e697fb51"
#> title = "Package Latency in Julia"
#> date = "2025-04-23"
#> license = "Unlicense"
#> description = "How long does it take to install and load a package?"
#> tags = ["basic"]
#> 
#>     [[frontmatter.author]]
#>     name = "Fons van der Plas"
#>     url = "https://github.com/fonsp"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 3265a982-1803-4812-b240-6c839f3971ed
using ObservablePlotExperiment, PlutoUI, HypertextLiteral

# ╔═╡ d91be120-aa1e-4f90-9f40-b92514b5281e
using TOML, Dates

# ╔═╡ 59123b46-fcf1-4a45-9db5-48bbd7b84351
using Memoization, Intervals, OrderedCollections

# ╔═╡ 4cbcddbb-530a-4619-b024-bc95512a1ee4
md"""
# Package Latency in Julia

How long does it take to install and load a package?

### What is package latency?
Julia is a fast language once running, but initial startup can be slow due to its Just-In-Time (JIT) compiler. For example, the first time you run `Plots.plot(...)` might take several seconds, though subsequent calls run instantly. However, when restarting Julia, everything requires JIT compilation again.

To address this, Julia implements **precompilation**, which occurs automatically after installation. Precompilation compiles certain package methods in advance, allowing them to run instantly when used. These precompile files are saved to disk, benefiting you each time Julia restarts. Precompilation typically takes 1-10 seconds for small packages and a few minutes for larger ones. Multiple packages can precompile in parallel, improving efficiency.


#### Four parts
When discussing **package latency**, we're concerned with four key waiting periods:

One-time waits:
1. **Installation**: Downloading package code and binary dependencies
2. **Precompilation**: Compiling package code into cached machine code

Waits during each Julia session:
3. **Load**: Time required to execute `import Example` as the package loads into memory
4. **First use**: Initial function calls may still trigger some JIT compilation

These latency factors significantly impact user experience, particularly for interactive workflows like notebooks!

### About this project
The package loading mechanism changes with every Julia version. Some (big) improvements are made, but things can also get worse. 

Tracking these changes can be challenging, so I created [a script](https://github.com/fonsp/package-loading-times) that measures installation, precompilation, and loading times for the 1000 most downloaded packages. Here are the results!
"""

# ╔═╡ 1e0749e9-fea0-4641-8cb2-3d77d925fbdc
md"""
### Which packages?
"""

# ╔═╡ 5bf562c7-3c47-404e-9d42-0dc8b381e2c5
@htl """
<p><label>$(@bind dash_recursive CheckBox(default=true)) Should we <strong>include dependencies</strong> of packages in the timings? 
"""

# ╔═╡ 4fd232bf-95c1-4d15-be0a-2bb8a5653edd
@htl """
<p><label>$(@bind dash_old_julia_versions CheckBox(default=true)) Include Julia versions <strong>before 1.10</strong>. <em>Comparing with old Julia versions might not be valid, since different package versions might be loaded.</em>
"""

# ╔═╡ 0311da05-e1ba-4fd5-9a7f-a6739266c0c1
@htl """
<p><label>$(@bind dash_log_scale CheckBox(default=false)) Use a <strong>log scale</strong>.
"""

# ╔═╡ 34b62394-f580-476e-89e9-c92b7db38d49
@htl """<div style="height: 6rem">"""

# ╔═╡ bb1ff0fe-0097-46a0-90eb-0a4359d9e42c
md"""
> # How does this notebook work?
> 
> **This is a reactive [Pluto.jl](https://plutojl.org/) notebook.** Pluto notebooks are reproducible, which means that you can run this notebook yourself! Click the button "Edit or Run" in the top right.
>
> Package loading data is from [fonsp/package-loading-times](https://github.com/fonsp/package-loading-times).
> 
> The interactive elements are built with [PlutoUI.jl](https://featured.plutojl.org/basic/plutoui.jl) and Pluto's reactivity. Layout and markup is done with Markdown and [HypertextLiteral.jl](https://github.com/JuliaPluto/HypertextLiteral.jl). Styling is Pluto's default. 
> 
> The graphs are made with [Observable Plot](https://observablehq.com/plot/), a JavaScript plotting library. Pluto has [built-in JavaScript support](https://featured.plutojl.org/web/javascript), so you can use JavaScript libraries directly. In this case, I wrote [ObservablePlotExperiment.jl](https://github.com/fonsp/ObservablePlotExperiment.jl), a small wrapper package to use it with Julia. 
> 
> _See the [Pluto docs](https://plutojl.org/en/docs/advanced-widgets/) for more info about writing custom widgets and advanced UI._
"""

# ╔═╡ 1b9da276-1d54-41e9-b507-6fad0bdedecf
@htl """<div style="height: 6rem">"""

# ╔═╡ 3675aabe-647b-435e-ba90-16fbb6c3ed7e
md"""
# Appendix
"""

# ╔═╡ fc8b68fc-a001-4df6-b9be-3a64fd7237d3
@htl """<label style="font-size: 1.3em;">Show <strong>Table of Contents</strong>? $(@bind show_toc CheckBox(default=false))"""

# ╔═╡ 2cf75cd0-05f2-4f61-84ac-efc6a66d21d6
if show_toc
	TableOfContents()
end

# ╔═╡ dd5745a4-4900-4de3-a317-2728a80bc274
const curated_list_of_packages = [
    "CSV",
    "ChainRules",
    "Colors",
    "Compat",
    "DataFrames",
    "DataStructures",
    # "DelimitedFiles",
    "DifferentialEquations",
    "Distributions",
    "Flux",
    "ForwardDiff",
    "Gadfly",
    "Genie",
    "Graphs",
    "HTTP",
    "IJulia",
    "JuMP",
    # "LinearAlgebra",
    "Makie",
    # "Markdown",
    "ModelingToolkit",
    # "Optim",
    "Plots",
    # "Preferences",
    # "Printf",
    "ProgressMeter",
    "PyCall",
	"PythonCall",
    # "Random",
    "Reexport",
    "Revise",
    # "Serialization",
    "SparseArrays",
    # "Statistics",
    "StatsBase",
	"Symbolics",
    # "Test",
    "Turing",
    "Unitful",
    # "UUIDs",
    "Zygote",
	"Pluto",
	"PlutoUI",
] |> sort

# ╔═╡ c29e7ba4-697b-4afa-aabe-fe1fbe15b4dc
@bind dash_curated_pkgs MultiCheckBox(
	# sort(all_package_names)
	sort(curated_list_of_packages)
	; default=["DataFrames", "DifferentialEquations", "Flux", "ForwardDiff", "HTTP", "Makie", "ModelingToolkit", "Optim", "PythonCall", "Symbolics", "Turing"],
	select_all=true
)

# dash_pkgs = all_package_names[1:500]

# ╔═╡ 5d28dd6d-77d4-4427-8fbe-422331c02416
@htl """
<style>
figure {

margin: 0;
}
</style>
"""

# ╔═╡ 568be985-fd75-4fe6-8c6c-f5f7b4a51a95
begin
	include_installation_bond = @bind include_installation CheckBox(default=true)
	include_precompilation_bond = @bind include_precompilation CheckBox(default=true)
	include_loading_bond = @bind include_loading CheckBox(default=true)
end;

# ╔═╡ f086c250-5165-4e20-8478-b92616732811
@htl """
<h3>Settings</h3>

<p>The three times we measured are:</p>
<ol>

<li><p><label> $(include_installation_bond) <strong>Installation</strong> (downloading the package source code)
<li><p><label> $(include_precompilation_bond) <strong>Precompilation</strong>
<li><p><label> $(include_loading_bond) <strong>Load</strong> (how long it takes to run <code>import SomePackage</code>)
</ol>

<p><em>Click to include/not include these times.</em>
"""

# ╔═╡ 334a99cf-7b75-4b85-ba58-b7092394fc11
replacenan(x, v) = isnan(x) ? v : x

# ╔═╡ 05c5e5bc-3c25-4155-9901-923267fe69a0
mymean(xs) = let
	vals = filter(!isnan, xs)
	isempty(vals) ? 
		NaN : 
		sum(vals) / length(vals)
end

# ╔═╡ 68921f66-f298-4618-a368-76f57cb0de3d
myminimum(xs) = let
	vals = filter(!isnan, xs)
	isempty(vals) ? 
		NaN : 
		minimum(vals)
end

# ╔═╡ d21275d8-f22a-4acc-9f9f-b865fd7d6edb
mean_minimum_legend = @htl """
<svg viewBox="0 0 150 30" xmlns="http://www.w3.org/2000/svg" font-family="system-ui"  fill="currentColor" height=30>
  <!-- Semi-transparent group for mean (line and marker) -->
  <g opacity="0.2">
    <path d="M5,10 Q25,6 45,5" stroke="currentColor" stroke-width="2" fill="none"/>
    <!-- Mean marker -->
    <circle cx="25" cy="7" r="3" fill="currentColor" stroke="white" stroke-width="1"/>
  </g>
  <text x="50" y="10" font-size="12" opacity=".8">mean</text>
  
  <!-- Solid curved line for minimum -->
  <path d="M5,25 Q25,20 45,18" stroke="currentColor" stroke-width="2" fill="none"/>
  <!-- Minimum marker -->
  <circle cx="25" cy="21" r="3" fill="currentColor" stroke="white" stroke-width="1"/>
  <text x="50" y="25" font-size="12">minimum</text>
</svg>
"""

# ╔═╡ 1cd5d136-4f4d-436f-9651-e1f077936a0b
md"""
## Part 1: data download and read
"""

# ╔═╡ 3dc6f154-d5dd-42ca-bb4c-71cf44da822d
index_url = "https://julia-loading-times-v2.netlify.app/"

# ╔═╡ 1dbb0071-286e-4a03-b7e1-c0149c57d8b3
const toml_path_regex = r"^(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}-\d{3})_.*\.toml$"

# ╔═╡ 91bb3940-b492-42de-bf27-5ef417a63eb3
function parse_filename(filename::AbstractString)
    # Extract date and time part and version part
    date_part, time_part, julia_version_part = match(r"^(\d{4}-\d{2}-\d{2}_)(\d{2}-\d{2}-\d{2}-\d{3})_julia_(.+)$", filename).captures
    
    # Parse date and time
    date_str = replace(date_part, "_" => "T")
    time_str = replace(replace(time_part, "-" => ":", count=2), "-" => ".")

    dt = DateTime(date_str * time_str)
    
    # Parse version
    v = VersionNumber(julia_version_part)
	# i did some measurements right before the upgrade from Julia 1.11.4 to Julia 1.115. To save some time running them again, I just patch this here... But I checked and the results from these two versions are very similar.
	v = v == v"1.11.4" ? v"1.11.5" : v
    
    return (dt, v)
end

# ╔═╡ 0bcdc199-6dae-4043-a5d8-b6c51068f0b8


# ╔═╡ 279ddfa5-4761-4023-b560-7440e3af808d


# ╔═╡ 1e1d90f7-2017-45ba-9c24-893d8d3b9134
const anytime = DateTime(2000)..DateTime(2100);

# ╔═╡ f41fe5cb-e8a8-4798-91a8-4a3c55449359


# ╔═╡ 28e559fe-6c84-48c4-a9a1-01e98405753f
struct MeasurementResults
	toml_path::String
	data::Dict
end

# ╔═╡ a2e35056-fed0-4d1b-b324-9766ff19d492
results(data::MeasurementResults) = data.data["results"]

# ╔═╡ 6c286a14-882e-48f1-bf09-0fba10019064
function results(data::MeasurementResults, package_name::AbstractString, key::String)
	d = data.data["results"]

	if haskey(d, package_name)
		get(d[package_name], key, NaN)
	else
		NaN
	end
end

# ╔═╡ 517c7f5d-97c2-4e6f-971d-3b0dde6c4689
# source_selector = @bind source Select([
# 	p => let
# 		d, v = parse_filename(split(p, "/")[1])
# 		"Julia $v @ $(Date(d))"
# 	end
# 	for p in toml_paths
# ])

# ╔═╡ 548acfbc-6814-436b-ad96-524aca576ff6
md"""
## Part 2: list of packages
"""

# ╔═╡ 4cf59b3e-4a84-4788-88ca-8aa52516ff78
const julia_1_10 = v"1.10.9"

# ╔═╡ 3e32980b-c131-4357-82c9-e34a6f90c02c
md"""
## Part 3: calculating
"""

# ╔═╡ b0c80bbd-e17f-4b7b-86ef-6ba27ab09455
recursive_deps(input::String; kwargs...) = recursive_deps([input]; kwargs...)

# ╔═╡ 94fa6b37-fe15-436f-80f1-c2ee249b2952


# ╔═╡ 40b934a6-34d5-458c-a7a7-8f5ce3de81cc
md"""
### Parallel precompilation time

Given the precompilation time of each package, what is the precompilation time of a given dependency tree of packages? This is a bit tricky because precompilation happens in parallel, in dependency order. I wrote a rough estimate: total time divided by three.

In the plotting function [`total_time`](#total_time), we also assume take the "heavy tail" into account: the direct dependencies can only start compiling once all indirect deps have compiled.
"""

# ╔═╡ 95a2dc77-8a56-4bd8-b24e-989904b65fcf
function estimate_parallel_precompilation_time(
	dataset::MeasurementResults, 
	packages::Vector{<:AbstractString},
)
	isempty(packages) ? 0.0 :
	sum((results(dataset, n, "precompile_time") for n in packages)) / clamp(length(packages), 1, 3)
end

# ╔═╡ 57de1558-9ccd-498e-86d1-2480ae02ffa9
md"""
# Packages
"""

# ╔═╡ d040f4b8-506b-11ed-3435-69c4255897b9
import JSON, Downloads

# ╔═╡ 89cbd7fd-29e3-4a09-9693-a95027d23433
fetch(url) = sprint() do io
	Downloads.request(url; output=io)
end

# ╔═╡ ece35d8d-8c25-47ec-aa1a-b7b56f20fa35
begin
	struct PackageDependencyTree
		data::OrderedDict{SubString{String}, Vector{SubString{String}}}
	end

	@memoize function PackageDependencyTree(toml_path::AbstractString)
		path = "$(split(toml_path, "/")[1])/top_packages_sorted_with_deps.txt"
		url = index_url * path
		lines = split(fetch(url), "\n")
		map(lines) do line
			package, deps... = split(line,",")
			package => deps
		end |> OrderedDict |> PackageDependencyTree
	end

	PackageDependencyTree(dataset::MeasurementResults) = PackageDependencyTree(dataset.toml_path)
end

# ╔═╡ e16b2da4-6522-49ea-b834-52ecc1d5215c
function recursive_deps!(found::Set{String}, inputs::Vector{<:AbstractString}; dep_tree::PackageDependencyTree)
	union!(found, inputs)
	for pkg_name in inputs
		deps = get(dep_tree.data, pkg_name, String[])
		newdeps = setdiff(deps, found)
		union!(found, deps)
		recursive_deps!(found, newdeps; dep_tree)
	end
	return found
end

# ╔═╡ c3b08572-ddee-440c-a894-0fd3499e571a
recursive_deps(inputs::Vector{<:AbstractString}; kwargs...) = recursive_deps!(Set{String}(), inputs; kwargs...)

# ╔═╡ 4b685607-16d3-45f7-9886-c999f7cb956c
function total_time(dataset::MeasurementResults, names::Vector{<:AbstractString}; 
	include_installation::Bool=true, 
	include_precompilation::Bool=true, 
	include_loading::Bool=true, 
	include_deps::Bool=false,
	dep_tree::PackageDependencyTree=PackageDependencyTree(dataset),
)

	deps = include_deps ? setdiff(collect(recursive_deps(names; dep_tree)),  ("julia",)) : names


	# This takes the "heavy tail" into account: the direct dependencies can only start compiling once all indirect deps have compiled.
	precomp = let
		precompiling_at_the_end = names
		precompiling_before = setdiff(deps, names)

		
		estimate_parallel_precompilation_time(dataset, precompiling_at_the_end) +
		estimate_parallel_precompilation_time(dataset, precompiling_before)
	end
	
	
	ifelse(include_precompilation, precomp, 0.0) + 
		sum((
			ifelse(include_installation, results(dataset, name, "install_time"), 0.0) + 
			ifelse(include_loading, results(dataset, name, "load_time1"), 0.0)
			for name in deps
		); init=0.0)

end

# ╔═╡ cdfe5a02-96d8-4fb8-b730-e79e6417338f
file_listing = JSON.parse(fetch(index_url))["files"]

# ╔═╡ 6d370d22-2c62-4b12-8d50-f75101e8f8ef
toml_paths = filter(file_listing) do path
	occursin(toml_path_regex, path)
end

# ╔═╡ 4d197227-b213-4706-8116-d541a84d2520
parse_filename(toml_paths[1] |> dirname)

# ╔═╡ 602102b4-31b1-4f66-bed7-2f4439a3a9e4
dates_and_versions = map(toml_paths) do p
	parse_filename(split(p, "/")[1])
end

# ╔═╡ d347ce74-67fe-42a4-86d0-7bd2f20b6eae
all_julia_versions = sort(unique(last.(dates_and_versions)))

# ╔═╡ fd1c0e44-72c9-4121-afce-3fc7a0a5557c
begin
	local dnv = @bind dash_normalizer_version Select([
		v => "Julia $(v)"
		for v in all_julia_versions]; default=julia_1_10)
	
	@htl """
	<p><label>$(@bind dash_normalize CheckBox(default=false)) Should we <strong>normalize</strong> relative to $(dnv)? 
	"""
end

# ╔═╡ a25b49a5-f6ee-4cba-aeb9-97821675e1e4
let




	joinnice(xs) = join(xs, ", ", " and ")
	
	yay(M) = map(last, filter(first, eachrow(M)))


	plot_description = "$(dash_recursive ? "" : "not ")including dependencies$(
		dash_normalize ? ", normalized relative to Julia $(dash_normalizer_version)" : ""
	). " |> uppercasefirst


	plot_title = 
	[
		include_installation "install"
		include_precompilation "precompile"
		include_loading "load"
	] |> yay |> joinnice |> uppercasefirst

	md"""
	## $(plot_title) times compared
	
	 $(plot_description) _(Lower is better.)_
	"""
end

# ╔═╡ 27c2f8e7-8949-4197-b32f-6a4682e7553c
dash_julia_versions = dash_old_julia_versions ? all_julia_versions : filter(>=(v"1.10.0"), all_julia_versions)

# ╔═╡ d71fe9e3-f639-4cfa-98a7-1d982aa37ea0
all_dates = sort(unique(first.(dates_and_versions)))

# ╔═╡ a8f31c5c-4c01-4327-8e64-5c742a63ca5c
@htl """
<div style="display: flex; align-items: flex-end;">

$(mean_minimum_legend)

<p style="margin-left: auto; font-family: system-ui; opacity: .8; ">Measurements taken between <strong style="font-family: inherit;">$(Date(minimum(all_dates)))</strong> and <strong style="font-family: inherit;">$(Date(maximum(all_dates)))</strong>.
</div>
"""

# ╔═╡ 612a7743-a20a-4c00-abc0-f3e186e5e2e1
all_dates_range = Interval(extrema(all_dates)...);

# ╔═╡ 1f687012-75a8-4d10-8edc-564c8c6f17b6
function get_matching_toml_paths(
	julia_version::VersionNumber, 
	time_range::Interval{Dates.DateTime}=anytime,
)
	filter(toml_paths) do p
		date, ver = parse_filename(split(p, "/")[1])

		ver == julia_version && date ∈ time_range
	end
end

# ╔═╡ 536bc112-6a25-4dbc-b944-53374e29b9d4
@memoize function get_data_for(
	julia_version::VersionNumber, 
	time_range::Interval{Dates.DateTime}=anytime,
)::Vector{MeasurementResults}
	possibles = get_matching_toml_paths(julia_version, time_range)

	results = map(possibles) do path
		MeasurementResults(path, TOML.parse(fetch(index_url * path)))
	end

	filter!(results) do mr
		get(mr.data, "os", "") == "Linux" &&
		get(mr.data, "version", "") == 1
	end
end

# ╔═╡ 67803beb-0e15-4be7-b628-2cc21cd6b255
test_datas = get_data_for(v"1.10.9")

# ╔═╡ ecdd381b-33c0-4e61-ad58-4a9f4fdbcf52
results(test_datas[1])

# ╔═╡ f07e6221-c9d1-4412-a841-17d113478c04
results(test_datas[1], "Pluto", "precompile_time")

# ╔═╡ 97cafcec-49c9-48ca-8cc3-0e347fd9e40a
results(test_datas[1], "Pluto", "version")

# ╔═╡ c8a7adb2-2e29-4e84-8a72-14e672b58581
const test_results_julia_1_10 = get_data_for(julia_1_10)[1]

# ╔═╡ daf70353-d13b-4590-bb67-2ebe6db1a345
estimate_parallel_precompilation_time(test_results_julia_1_10, ["HTTP"])

# ╔═╡ 3b9f8268-0a6f-432f-8809-39e457a9d375
estimate_parallel_precompilation_time(test_results_julia_1_10, ["HTTP", "HTTP"])

# ╔═╡ 2f82bcc3-e8e9-4731-ae6b-435dc3cb94af
estimate_parallel_precompilation_time(test_results_julia_1_10, ["HTTP", "HTTP", "HTTP", "HTTP"])

# ╔═╡ 3eb3ca5d-bbd1-43b5-8de4-b105555437fc
all_package_names_julia_1_10 = let
	t = get_matching_toml_paths(julia_1_10)[1]
	collect(keys(PackageDependencyTree(t).data))
end

# ╔═╡ 366ca6a1-7d39-4194-86d6-473f76d8cbec
begin
	dash_selection_none = "-- none --"
	bonus_package_selector() = Select([
		dash_selection_none, 
		filter(x -> length(x) < 20, # removing packages with long names 🙈
		   sort(all_package_names_julia_1_10)
	  	)...
	])


	@htl "<p>Add to selection: 
	
		$(@bind dash_bonus_pkg_1 bonus_package_selector())
		$(@bind dash_bonus_pkg_2 bonus_package_selector())
		$(@bind dash_bonus_pkg_3 bonus_package_selector())
	"
end

# ╔═╡ 6199a504-0b5f-4efd-ab88-9c5c9a79c11b
dash_bonus_selection = filter(
	!isequal(dash_selection_none), 
	[dash_bonus_pkg_1, dash_bonus_pkg_2, dash_bonus_pkg_3]
)

# ╔═╡ 5936fa62-dd55-4763-a6c5-bd9c53bb52c8
dash_pkgs = unique(union(dash_bonus_selection, dash_curated_pkgs))
# dash_pkgs = all_package_names_julia_1_10

# ╔═╡ d7d10cef-c958-411f-bec4-91b414873004
plot_data = let


	function data_for_package(p)
		function get_times(ver)
			datasets = get_data_for(ver)
			get(dataset, p) = total_time(dataset, [p]; include_installation, include_precompilation, include_loading, include_deps=dash_recursive)
			
			times = map(enumerate(datasets)) do (i,data)
				# dep_tree = PackageDependencyTree(data)

				get(data, p)
			end

		end

		normalizer_times = dash_normalize ? get_times(dash_normalizer_version) : [1.0]
		normalizer_factor = minimum(normalizer_times)
		
		(
			let
				times = get_times(v)
				(
					time_min=myminimum(times) / normalizer_factor,
					time_mean=mymean(times) / normalizer_factor,
					version=string(v), 
					package="$p",
				)
			end
			for v in dash_julia_versions
		)
			
	end



	Iterators.flatten(Iterators.map(data_for_package, isempty(dash_pkgs) ? String[] : dash_pkgs)) |> collect
	
end

# ╔═╡ 02bf58a2-4337-466b-a69d-3fc7641e9a75
ObservablePlotExperiment.plot(
	line(
		plot_data;
		y="time_min",
		x="version",
		z="package",
		# stroke=@jsl("datum => datum.package.split(' ')[0]"),
		stroke="package",
		marker=true,
		curve="catmull-rom",
		sort=(
			color="y",
			order="descending",
		),
	),
	
	line(
		plot_data;
		y="time_mean",
		x="version",
		z="package",
		opacity=.2,
		stroke=@jsl("datum => datum.package.split(' ')[0]"),
		# stroke="package",
		marker=true,
		curve="catmull-rom",
		sort=(
			color="y",
			order="descending",
		),
	),
	ObservablePlotExperiment.ObservableMarkLiteral(
		@jsl("Plot.ruleY([$(dash_normalize ? 1.0 : 0.0)])")
	);
	color=(
		legend=length(plot_data) > 0,
	),
	grid=true,
	x=(
		domain=string.(dash_julia_versions), 
		label="Julia version",
	),
	y=(
		type=dash_log_scale && !dash_normalize ? "log" : nothing,
		# domain=(0,maximum((replacenan(x.time, 0.0) for x in plot_data); init=0.0)),
		label=dash_normalize ? 
			"relative to Julia $(dash_normalizer_version)" : 
			"time (s)",
		tickFormat = dash_normalize ? 
			@jsl("val => val === 1.0 ? '' : (val > 1 ? '+' : '-') + (100*Math.abs(val-1)).toFixed(0) + '%'") : 
			nothing,

	),
)

# ╔═╡ 36ccf632-99fa-49f0-80c3-25b8a0c47663
all_deps = recursive_deps(["Pluto", "PlutoUI"]; dep_tree=PackageDependencyTree(get_matching_toml_paths(julia_1_10)[1]))

# ╔═╡ cacb82df-d590-4776-9a8f-162877248e11
PackageDependencyTree(toml_paths[1])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Intervals = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Memoization = "6fafb56a-5788-4b4e-91ca-c0cea6611c73"
ObservablePlotExperiment = "216e6a69-7265-646e-696e-656d6d65777a"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
TOML = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[compat]
HypertextLiteral = "~0.9.5"
Intervals = "~1.10.0"
JSON = "~0.21.4"
Memoization = "~0.2.2"
ObservablePlotExperiment = "~0.1.1"
OrderedCollections = "~1.8.0"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "0170e176192ebcc14462283f86e5e8982589f531"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InlineStrings]]
git-tree-sha1 = "6a9fde685a7ac1eb3495f8e812c5a7c3711c2d5e"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.3"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "ac0aaa807ed5eaf13f67afe188ebc07e828ff640"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.10.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Memoization]]
deps = ["MacroTools"]
git-tree-sha1 = "7dbf904fa6c4447bd1f1d316886bfbe29feacf45"
uuid = "6fafb56a-5788-4b4e-91ca-c0cea6611c73"
version = "0.2.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "2c140d60d7cb82badf06d8783800d0bcd1a7daa2"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.8.1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.ObservablePlotExperiment]]
deps = ["AbstractPlutoDingetjes", "Dates", "HypertextLiteral"]
git-tree-sha1 = "a0611a6921fc43d1079d266da82da050da92f540"
uuid = "216e6a69-7265-646e-696e-656d6d65777a"
version = "0.1.1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TZJData]]
deps = ["Artifacts"]
git-tree-sha1 = "72df96b3a595b7aab1e101eb07d2a435963a97e2"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.5.0+2025b"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TimeZones]]
deps = ["Artifacts", "Dates", "Downloads", "InlineStrings", "Mocking", "Printf", "Scratch", "TZJData", "Unicode", "p7zip_jll"]
git-tree-sha1 = "2c705e96825b66c4a3f25031a683c06518256dd3"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.21.3"
weakdeps = ["RecipesBase"]

    [deps.TimeZones.extensions]
    TimeZonesRecipesBaseExt = "RecipesBase"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─4cbcddbb-530a-4619-b024-bc95512a1ee4
# ╟─a25b49a5-f6ee-4cba-aeb9-97821675e1e4
# ╟─02bf58a2-4337-466b-a69d-3fc7641e9a75
# ╟─a8f31c5c-4c01-4327-8e64-5c742a63ca5c
# ╟─1e0749e9-fea0-4641-8cb2-3d77d925fbdc
# ╟─c29e7ba4-697b-4afa-aabe-fe1fbe15b4dc
# ╟─366ca6a1-7d39-4194-86d6-473f76d8cbec
# ╟─f086c250-5165-4e20-8478-b92616732811
# ╟─5bf562c7-3c47-404e-9d42-0dc8b381e2c5
# ╟─fd1c0e44-72c9-4121-afce-3fc7a0a5557c
# ╟─4fd232bf-95c1-4d15-be0a-2bb8a5653edd
# ╟─0311da05-e1ba-4fd5-9a7f-a6739266c0c1
# ╟─34b62394-f580-476e-89e9-c92b7db38d49
# ╟─bb1ff0fe-0097-46a0-90eb-0a4359d9e42c
# ╟─1b9da276-1d54-41e9-b507-6fad0bdedecf
# ╟─3675aabe-647b-435e-ba90-16fbb6c3ed7e
# ╟─fc8b68fc-a001-4df6-b9be-3a64fd7237d3
# ╟─2cf75cd0-05f2-4f61-84ac-efc6a66d21d6
# ╟─6199a504-0b5f-4efd-ab88-9c5c9a79c11b
# ╟─5936fa62-dd55-4763-a6c5-bd9c53bb52c8
# ╟─27c2f8e7-8949-4197-b32f-6a4682e7553c
# ╟─dd5745a4-4900-4de3-a317-2728a80bc274
# ╠═5d28dd6d-77d4-4427-8fbe-422331c02416
# ╠═568be985-fd75-4fe6-8c6c-f5f7b4a51a95
# ╠═d7d10cef-c958-411f-bec4-91b414873004
# ╟─334a99cf-7b75-4b85-ba58-b7092394fc11
# ╟─05c5e5bc-3c25-4155-9901-923267fe69a0
# ╟─68921f66-f298-4618-a368-76f57cb0de3d
# ╟─d21275d8-f22a-4acc-9f9f-b865fd7d6edb
# ╟─4b685607-16d3-45f7-9886-c999f7cb956c
# ╟─1cd5d136-4f4d-436f-9651-e1f077936a0b
# ╟─89cbd7fd-29e3-4a09-9693-a95027d23433
# ╠═3dc6f154-d5dd-42ca-bb4c-71cf44da822d
# ╠═cdfe5a02-96d8-4fb8-b730-e79e6417338f
# ╠═6d370d22-2c62-4b12-8d50-f75101e8f8ef
# ╟─1dbb0071-286e-4a03-b7e1-c0149c57d8b3
# ╟─91bb3940-b492-42de-bf27-5ef417a63eb3
# ╠═4d197227-b213-4706-8116-d541a84d2520
# ╟─0bcdc199-6dae-4043-a5d8-b6c51068f0b8
# ╠═602102b4-31b1-4f66-bed7-2f4439a3a9e4
# ╠═d347ce74-67fe-42a4-86d0-7bd2f20b6eae
# ╠═d71fe9e3-f639-4cfa-98a7-1d982aa37ea0
# ╠═612a7743-a20a-4c00-abc0-f3e186e5e2e1
# ╟─279ddfa5-4761-4023-b560-7440e3af808d
# ╠═1e1d90f7-2017-45ba-9c24-893d8d3b9134
# ╟─1f687012-75a8-4d10-8edc-564c8c6f17b6
# ╟─536bc112-6a25-4dbc-b944-53374e29b9d4
# ╟─f41fe5cb-e8a8-4798-91a8-4a3c55449359
# ╠═28e559fe-6c84-48c4-a9a1-01e98405753f
# ╟─a2e35056-fed0-4d1b-b324-9766ff19d492
# ╟─6c286a14-882e-48f1-bf09-0fba10019064
# ╟─517c7f5d-97c2-4e6f-971d-3b0dde6c4689
# ╠═67803beb-0e15-4be7-b628-2cc21cd6b255
# ╠═ecdd381b-33c0-4e61-ad58-4a9f4fdbcf52
# ╠═f07e6221-c9d1-4412-a841-17d113478c04
# ╠═97cafcec-49c9-48ca-8cc3-0e347fd9e40a
# ╟─548acfbc-6814-436b-ad96-524aca576ff6
# ╠═4cf59b3e-4a84-4788-88ca-8aa52516ff78
# ╠═3eb3ca5d-bbd1-43b5-8de4-b105555437fc
# ╠═ece35d8d-8c25-47ec-aa1a-b7b56f20fa35
# ╠═cacb82df-d590-4776-9a8f-162877248e11
# ╟─3e32980b-c131-4357-82c9-e34a6f90c02c
# ╠═36ccf632-99fa-49f0-80c3-25b8a0c47663
# ╠═e16b2da4-6522-49ea-b834-52ecc1d5215c
# ╠═c3b08572-ddee-440c-a894-0fd3499e571a
# ╠═b0c80bbd-e17f-4b7b-86ef-6ba27ab09455
# ╟─94fa6b37-fe15-436f-80f1-c2ee249b2952
# ╟─40b934a6-34d5-458c-a7a7-8f5ce3de81cc
# ╠═95a2dc77-8a56-4bd8-b24e-989904b65fcf
# ╠═daf70353-d13b-4590-bb67-2ebe6db1a345
# ╠═3b9f8268-0a6f-432f-8809-39e457a9d375
# ╠═2f82bcc3-e8e9-4731-ae6b-435dc3cb94af
# ╟─c8a7adb2-2e29-4e84-8a72-14e672b58581
# ╟─57de1558-9ccd-498e-86d1-2480ae02ffa9
# ╠═3265a982-1803-4812-b240-6c839f3971ed
# ╠═d91be120-aa1e-4f90-9f40-b92514b5281e
# ╠═d040f4b8-506b-11ed-3435-69c4255897b9
# ╠═59123b46-fcf1-4a45-9db5-48bbd7b84351
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
