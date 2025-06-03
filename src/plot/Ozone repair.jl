### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/user-attachments/assets/d3d6ee66-5739-4090-b92a-65cdd36d3939"
#> date = "2025-06-02"
#> tags = ["plotting", "PlutoPlotly", "PlotlyJS", "plotly", "geo", "interactive"]
#> description = "Learn about how the ozone layer was saved! Interactive maps with plotly!"
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "JuliaPluto"
#>     url = "https://github.com/JuliaPluto"

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

# ╔═╡ 59f211b0-9b2c-4efd-a18c-34081416a665
using PlotlyBase, PlutoPlotly, DataFrames, CSV, HTTP, PlutoUI, Missings

# ╔═╡ eb65424e-d5b5-4ccc-8e12-6a0327a8dd6f
md"# 🌐🌤Torn Above, United Below: The Story of Humanity’s Greatest Repair"

# ╔═╡ bb433b38-2fa0-4725-9eba-13901e5162f9
md"""### 🌍 *The Sky That Was Getting Sick*

Once upon a not-so-long-ago time, the Earth had a protective blanket way up high in the sky. It was called the **ozone layer**, and it kept us safe from the Sun’s harsh rays — kind of like invisible sunscreen for the planet.

But slowly, quietly, people started noticing something strange...

Scientists in Antarctica were studying the skies when they found something shocking — a **hole** was forming in the ozone layer! It was getting thinner, especially above the South Pole!"""

# ╔═╡ c076d14b-f6f1-4dcb-978f-8744b8923dbf
md"""
### 🌐 *The World Comes Together*

It turned out that certain chemicals used in **fridges, air conditioners, and spray cans** (called **CFCs**) were floating up and **breaking the ozone** apart. Like little invisible scissors, snip snip snip.

This wasn’t just one country’s problem — it was everyone’s. So, in 1987, leaders from all around the globe gathered and made a pact called the **Montreal Protocol**. It was like a superhero team-up, but instead of capes, they had science and agreements.

They promised to **stop using those harmful chemicals** and find better alternatives.
It took time, but eventually, every country joined the effort! Now, you can see how the countries came together year by year. 

👇 **Move the slider to watch which countries joined each year!** """

# ╔═╡ da37210e-035e-4f37-85ad-88588e58066b
md"""
### 🧪 *Fixing the Future*

Joining the pact was just the first step. Now, the real work began! Companies and scientists worked hard to **invent new, safer materials**. It wasn’t easy. Some things had to be redesigned. Some industries had to change their ways. But slowly… it worked.

👇 **Below, you can see how much of these chemicals each country was using each year**"""

# ╔═╡ 65f6e673-5c76-4d84-8765-a9cf157442fc
the_year = @bind year Slider(1986:1:2020, default=1989, show_value=true)

# ╔═╡ c504a3c2-1f17-433c-85b0-fb3f45da48d9
the_year

# ╔═╡ 10897723-18c4-4d16-be1e-209fa2f11433
md"""### ☀️ *The Sky Smiles Again*

People stuck to the plan and a big effort was made to slowly use less and less. Year by year, the ozone started healing!

Now, decades later, the ozone layer is **on its way to full recovery**. The big hole over Antarctica? Shrinking. The invisible blanket? Stitching itself back together.

And all because humanity — for once — looked up and said, *“Let’s fix this together.”* 💚

👇 **Here you can see a real recording of the ozone levels in the sky over the year**
"""

# ╔═╡ 7f869633-1b29-4c53-9393-9799067b28d7
PlutoUI.Resource("https://ozonewatch.gsfc.nasa.gov/ozone_maps/movies/OZONE_D1979-01%25P1Y_G%5e720X486.IOMPS_PNPP_V21_MMERRA2_LSH.mp4", :legend => md"xm")

# ╔═╡ b157d186-a94f-43f0-b244-8cce87cf275f
md"*Sources:* 

*[1] Montreal Protocol data: UN Environment Programme (2023) – processed by Our World in Data. “Vienna Convention and Montreal Protocol (Parties Subscribing each Year)” [dataset]. UN Environment Programme (2023) [original data].*

*[2] Ozone Chemicals data: UN Environment Programme (2023) – processed by Our World in Data. “Consumption of controlled substance (zero-filled) - Chemical: All (Ozone-depleting)” [dataset]. UN Environment Programme (2023) [original data].*

*[3] Video: NASA Ozone Watch*"

# ╔═╡ 14d8ad7c-9a7d-4ec2-9478-1bb1912f5b94
md"---

## 🗺️ Appendix: How we created the maps

Unfold the cells below to find a step by step guide on how to create the maps we show above :) "

# ╔═╡ 3647ee17-cf0f-4cc6-9fb1-8a569329fa7c
# Step 1: Get the World data in GeoJson format: this defines the borders for each country
GeoUrl= "https://raw.githubusercontent.com/johan/world.geo.json/refs/heads/master/countries.geo.json";

# ╔═╡ 418dc147-30ba-4d76-8b37-19183497065f
# Step 2: Getting the links to the data
begin
	# Consumption of ozone-depleting substances
	substancesDataUrl = "https://ourworldindata.org/grapher/consumption-of-ozone-depleting-substances.csv?v=1&csvType=full&useColumnShortNames=true"
	
	# Montreal Protocol
	protocolDataUrl = "https://ourworldindata.org/grapher/countries-to-montreal-protocol-and-vienna-convention.csv?v=1&csvType=full&useColumnShortNames=true"
end;

# ╔═╡ 99604f5d-1b13-466b-9423-da6085bcd369
# Step 3: Import our data into DataFrames
begin
	subtances_response = HTTP.get(substancesDataUrl)
	ozone_df = CSV.read(IOBuffer(subtances_response.body), DataFrame)

	protocol_response = HTTP.get(protocolDataUrl)
	protocol_df = CSV.read(IOBuffer(protocol_response.body), DataFrame)

	rename!(protocol_df, Symbol("Vienna Convention and Montreal Protocol (Parties Subscribing each Year)") => :Joined) 
	rename!(ozone_df, :consumption_zf__chemical_all__ozone_depleting => :Chemicals) 
end;

# ╔═╡ 92a88ca0-eab9-458e-8f2a-f79ecd636152
# Define a DataFrame with all EU countries and their codes
eu_members = DataFrame(
    Entity = [
        "Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic",
        "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary",
        "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta",
        "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia",
        "Spain", "Sweden", "United Kingdom" 
    ],
    Code = [
        "AUT", "BEL", "BGR", "HRV", "CYP", "CZE",
        "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN",
        "IRL", "ITA", "LVA", "LTU", "LUX", "MLT",
        "NLD", "POL", "PRT", "ROU", "SVK", "SVN",
        "ESP", "SWE", "GBR"
    ]
);

# ╔═╡ d05e6b62-ee2a-40e0-95b5-dae2a011045b
# Step 4: Duplicate the values of the European Union entries by its countries and fix the missing codes 
begin
	# Filter EU-wide entries and collect duplicated entries into a vector
	eu_rows = ozone_df[ozone_df.Entity .== "European Union (28)", :]
	expanded_dfs = []
	for row in eachrow(eu_rows)
	    tmp = deepcopy(eu_members)
	    tmp.Year .= row.Year
	    tmp.Chemicals .= row.Chemicals
	    push!(expanded_dfs, tmp)
	end
	
	# Stack all new rows together and merge with original df
	duplicated_rows = vcat(expanded_dfs...)
	ozone_cleaned_df = vcat(ozone_df, duplicated_rows)
end;

# ╔═╡ f56f9b38-f5a2-4e6d-85f7-ccc3dc1527f9
# Step 5: Drop missing values for the :Code column & Merge into one DataFrame
begin
	filtered_df = dropmissing(ozone_cleaned_df, [:Code])
	filtered_protocol_df = dropmissing(protocol_df, [:Code])
	
	df = outerjoin(
    filtered_df,
    filtered_protocol_df,
    on = [:Entity, :Year, :Code],
    makeunique = true)
	replace!(df.Joined, missing => 0)
end;

# ╔═╡ 21c8c294-a2a4-4ed7-8999-93254c9f169c
# Step 6: Replace missing values for some year by the last recorded value
begin
	# Step 1: Sort DataFrame by Entity and Year
	year_range = 1986:2022
	sort!(df, [:Entity, :Year])

	# Step 2: For each entity, check if every year from 1980 to 2020 exists
	for entity in unique(df.Entity)
    	entity_rows = filter(row -> row.Entity == entity, df)
    	current_years = entity_rows.Year
		code = entity_rows[1, :Code]
		joined = entity_rows[1, :Joined]

    for year in year_range
		row_index = findfirst(row -> row.Year == year, eachrow(entity_rows))
		# Check if the chemical is missing for this year and entity
		if row_index != nothing && ismissing(entity_rows[row_index, :].Chemicals)
            
			# Get the last available value and replace it in the correct row
            previous_row_index = findlast( row -> row.Year < year, 
				eachrow(entity_rows))
            if previous_row_index != nothing
                previous_row = entity_rows[previous_row_index, :]
                last_value = previous_row.Chemicals
            	entity_rows[row_index, :Chemicals] = last_value
				df_index = findfirst(row -> row.Entity == entity && row.Year == year && row.Code == code, eachrow(df))
				if df_index != nothing
				    df[df_index, :Chemicals] = last_value
				end
			end
        end
    end
end
end

# ╔═╡ 654c8c0c-cac7-498a-a812-03d07920ce74
# Step 7: Fix the negative values and filter by year for the final maps and map the values to their logarithms
begin
	df.Chemicals = abs.(df.Chemicals) 
	df_by_year = df[df.Year .== year, :]
	log_chems = map(x -> log10(x), df_by_year.Chemicals)
	df_by_year
end;

# ╔═╡ 4b654926-a9e8-4ed1-bad7-7a807e025908
# Step 8: Finally use the data for the current year to plot the countries who joined
q_protocol = Plot(choroplethmapbox(
    geojson = GeoUrl,
    featureidkey = "id", 
    locations = df_by_year.Code,
    z = df_by_year.Joined,
    zmin = 0, zmax = 1, 
    text = df_by_year.Entity,
    colorscale = [[0, "#d3d3d3"], [1, "#2b83ba"]],
    colorbar = attr(
        tickvals = [0, 1],  # Only two ticks for binary data
        ticktext = ["Not Joined", "Joined"]
    ),
    marker = attr(opacity = 0.75, line = attr(width = 0.3, color = "white"))),
	Layout(mapbox = attr(
	    center = attr(lon = 13.5, lat = 35.65),
	    zoom = 0.2,
	    style = "open-street-map"
	))
) |> PlutoPlot;

# ╔═╡ 78e55a27-669c-4f2c-9121-ac182bfb3abf
q_protocol

# ╔═╡ c16d3fda-4b2f-443a-b353-4384e64627de
# Step 8: And use the data for the current year to plot the current ozone consumption
q_substances = Plot(choroplethmapbox(
	  geojson = GeoUrl,
	  featureidkey = "id", 
	  locations = df_by_year.Code,
	  z=log_chems,
	  zmin=-2, zmax=7, 
	  text=df_by_year.Entity,
	  colorscale = "YlGnBu", #YlOrRd
	  reversescale = true,
	  marker=attr(opacity=0.75, line=attr(width=0.3, color="white"))),
	  Layout(mapbox = attr(
		center = attr(lon = 13.5, lat = 35.65),
		zoom = 0.2,
		style = "open-street-map"
	))
) |> PlutoPlot;

# ╔═╡ ec235a8a-9536-4213-ad75-0faafedff03f
q_substances

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
Missings = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.10.15"
DataFrames = "~1.7.0"
HTTP = "~1.10.15"
Missings = "~1.2.0"
PlotlyBase = "~0.8.21"
PlutoPlotly = "~0.3.4"
PlutoUI = "~0.7.23"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.9"
manifest_format = "2.0"
project_hash = "05323bb5276b8d97fbf6cd16656399924837e3b9"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "deddd8725e5e1cc49ee205a1964256043720a6c3"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.15"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "fb61b4812c49343d7ef0b533ba982c46021938a6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

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

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "f1a7e086c677df53e064e0fdd2c9d0b0833e3f6e"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.5.0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Colors", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "28278bb0053da0fd73537be94afd1682cc5a0a83"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.21"

    [deps.PlotlyBase.extensions]
    DataFramesExt = "DataFrames"
    DistributionsExt = "Distributions"
    IJuliaExt = "IJulia"
    JSON3Ext = "JSON3"

    [deps.PlotlyBase.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PackageExtensionCompat", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "9a77654cdb96e8c8a0f1e56a053235a739d453fe"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.9"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "712fb0231ee6f9120e005ccd56297abbc053e7e0"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.8"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "725421ae8e530ec29bcbdddbe91ff8053421d023"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.1"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

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
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═59f211b0-9b2c-4efd-a18c-34081416a665
# ╟─eb65424e-d5b5-4ccc-8e12-6a0327a8dd6f
# ╟─bb433b38-2fa0-4725-9eba-13901e5162f9
# ╟─c076d14b-f6f1-4dcb-978f-8744b8923dbf
# ╠═c504a3c2-1f17-433c-85b0-fb3f45da48d9
# ╟─78e55a27-669c-4f2c-9121-ac182bfb3abf
# ╟─da37210e-035e-4f37-85ad-88588e58066b
# ╠═65f6e673-5c76-4d84-8765-a9cf157442fc
# ╟─ec235a8a-9536-4213-ad75-0faafedff03f
# ╟─10897723-18c4-4d16-be1e-209fa2f11433
# ╟─7f869633-1b29-4c53-9393-9799067b28d7
# ╟─b157d186-a94f-43f0-b244-8cce87cf275f
# ╟─14d8ad7c-9a7d-4ec2-9478-1bb1912f5b94
# ╟─3647ee17-cf0f-4cc6-9fb1-8a569329fa7c
# ╟─418dc147-30ba-4d76-8b37-19183497065f
# ╟─99604f5d-1b13-466b-9423-da6085bcd369
# ╟─92a88ca0-eab9-458e-8f2a-f79ecd636152
# ╟─d05e6b62-ee2a-40e0-95b5-dae2a011045b
# ╟─f56f9b38-f5a2-4e6d-85f7-ccc3dc1527f9
# ╟─21c8c294-a2a4-4ed7-8999-93254c9f169c
# ╟─654c8c0c-cac7-498a-a812-03d07920ce74
# ╟─4b654926-a9e8-4ed1-bad7-7a807e025908
# ╟─c16d3fda-4b2f-443a-b353-4384e64627de
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
