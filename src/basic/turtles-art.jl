### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/JuliaRegistries/General/assets/6933510/9a925232-6a75-47e7-9ab9-f384bc389602"
#> order = "5.1"
#> title = "Turtles – showcase"
#> date = "2024-08-10"
#> tags = ["turtle", "basic"]
#> description = "🐢 A couple of cool artworks made with simple Julia code"
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Pluto.jl"
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

# ╔═╡ 1ff23021-4eb3-458d-a07e-0c5083eb4c4f
using PlutoTurtles, PlutoUI

# ╔═╡ 86e25a9c-b877-45cb-8a57-4643dd1fc266
md"""
# Turtle art!

This notebook uses [PlutoTurtles.jl](https://github.com/JuliaPluto/PlutoTurtles.jl) to recreate some famous works of art!
"""

# ╔═╡ 0d7fb9e7-3437-4ff9-9de6-1f3f8a93dfff
md"""## "_The Starry Night_" 
Vincent van Gogh (1889)"""

# ╔═╡ abe23881-0354-4068-8115-451f7b3307c7
@bind GO_gogh CounterButton("Another one!")

# ╔═╡ 75b23160-aada-4e48-8b16-ddd2c6c8df1f
function draw_star(turtle, points, size)
	for i in 1:points
		right!(turtle, 360 / points)
		forward!(turtle, size)
		backward!(turtle, size)
	end
end

# ╔═╡ 426a1f52-32dd-4b63-a274-27e1cf139742
md"""## "_Tableau I_"
Piet Mondriaan (1913)"""

# ╔═╡ f30d72d7-7894-4229-8f25-509195563097
@bind GO_mondriaan CounterButton("Another one!")

# ╔═╡ ab4d46eb-d441-47c3-b061-2611b2e44009
function draw_mondriaan(rng, turtle, width, height)
	#propbability that we make a mondriaan split
	p = if width * height < 8
		0
	else
		((width * height) / 900) ^ 0.5
	end

	if rand(rng) < p
		#split into halves
		
		split = rand(rng, width * 0.1 : width * 0.9)

		#draw split
		forward!(turtle, split)
		right!(turtle, 90)
		color!(turtle, "black")
		pendown!(turtle)
		forward!(turtle, height)
		penup!(turtle)

		#fill in left of split
		right!(turtle, 90)
		forward!(turtle, split)
		right!(turtle, 90)
		draw_mondriaan(rng, turtle, height, split)
		
		#fill in right of split
		forward!(turtle, height)
		right!(turtle, 90)
		forward!(turtle, width)
		right!(turtle, 90)
		draw_mondriaan(rng, turtle, height, width - split)
		
		#walk back
		right!(turtle, 90)
		forward!(turtle, width)
		right!(turtle, 180)
		
	else
		#draw a colored square
		square_color = rand(rng, ("white", "white", "white", "red", "yellow", "blue"))
		color!(turtle, square_color)
		for x in (.4:.4:width - .4) ∪ [width - .4]
			forward!(turtle, x)
			right!(turtle, 90)
			forward!(turtle, .2)
			pendown!(turtle)
			forward!(turtle, height - .4)
			penup!(turtle)
			right!(turtle, 180)
			forward!(turtle, height - .2)
			right!(turtle, 90)
			backward!(turtle, x)
		end
	end
end

# ╔═╡ ff2294a6-2bd0-461c-bc38-02f157d86660
md"""## "_Een Boom_"
Luka van der Plas (2020)"""

# ╔═╡ b6b1690b-6427-4ff3-9abf-b499f4661c39
@bind fractal_angle Slider(0:90; default=49)

# ╔═╡ 59963c46-ee42-4989-bff4-90f12606193e
@bind fractal_tilt Slider(0:90; default=36)

# ╔═╡ 5f6beed8-33ae-463c-9d28-09e3a4235936
@bind fractal_base Slider(0:0.01:2; default=1)

# ╔═╡ 18a97ce6-ae85-46a2-b294-830473fe80cd
function lindenmayer(turtle, depth, angle, tilt, base)
	if depth < 10
		old_pos = turtle.pos
		old_heading = turtle.heading

		size = base * .5 ^ (depth * 0.5)

		pendown!(turtle)
		color!(turtle, "hsl($(depth * 30), 80%, 50%)")
		forward!(turtle, size * 8)
		right!(turtle, tilt / 2)
		lindenmayer(turtle, depth + 1, angle, tilt, base)
		left!(turtle, angle)
		lindenmayer(turtle, depth + 1, angle, tilt, base)


		turtle.pos = old_pos
		turtle.heading = old_heading
	end
end

# ╔═╡ 83cd894b-2be0-48c7-b5e7-8db7ed96c13f
fractal = turtle_drawing_fast() do t
	penup!(t)
	backward!(t, 15)
	pendown!(t)
	lindenmayer(t, 0, fractal_angle, fractal_tilt, fractal_base)
end

# ╔═╡ e51d4b19-fa30-4643-8d12-407941a4757d
md"""
## "_Een coole spiraal_" 
fonsi (2020)
"""

# ╔═╡ 6deab6a2-f298-42a8-9c86-db8a2a26ac17
@bind angle Slider(0:90; default=20)

# ╔═╡ c668c791-9c3b-4eed-babe-9a484a88b68e
turtle_drawing() do t
	
	for i in 0:.1:10
		right!(t, angle)
		forward!(t, i)
	end
	
end

# ╔═╡ 897cc639-5ab6-48fe-bdba-19aa4e8bad15
import Random

# ╔═╡ 70402e12-22c2-47fd-99be-aa6cd15ce2c3
starry_night = turtle_drawing_fast(background = "#000088") do t
	rng = Random.MersenneTwister(GO_gogh + 7)
	
	star_count = 100
	
	color!(t, "yellow")
	
	for i in 1:star_count
		#move
		penup!(t)
		random_angle = rand(rng) * 360
		right!(t, random_angle)
		random_distance = rand(rng, 1:8)
		forward!(t, random_distance)
		
		#draw star
		pendown!(t)
		
		draw_star(t, 5, 1)
	end
end

# ╔═╡ d400d8d6-de2c-4886-86b9-ffd9e5f4e073
# turtle_drawing_fast() is the same as turtle_drawing(), but it does not show a little turtle taking the individual steps

mondriaan = turtle_drawing_fast() do t	
	rng = Random.MersenneTwister(GO_mondriaan + 7)
	size = 30
	
	#go to top left corner
	penup!(t)
	forward!(t, size / 2)
	left!(t, 90)
	forward!(t, size / 2)
	right!(t, 180)
		
	#draw painting
	draw_mondriaan(rng, t, size, size)
	
	#white border around painting
	color!(t, "white")
	pendown!(t)
	for i in 1:4
		forward!(t, size)
		right!(t, 90)
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTurtles = "67697473-756c-6b61-6172-6b407461726b"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
PlutoTurtles = "~1.0.1"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [Pkg.extensions]
    REPLExt = "REPL"

    [Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[PlutoTurtles]]
deps = ["AbstractPlutoDingetjes", "Compat", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoUI"]
git-tree-sha1 = "467866275ad02b4abf63c80bad78ad4f92744473"
uuid = "67697473-756c-6b61-6172-6b407461726b"
version = "1.0.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─86e25a9c-b877-45cb-8a57-4643dd1fc266
# ╠═1ff23021-4eb3-458d-a07e-0c5083eb4c4f
# ╟─0d7fb9e7-3437-4ff9-9de6-1f3f8a93dfff
# ╟─abe23881-0354-4068-8115-451f7b3307c7
# ╟─70402e12-22c2-47fd-99be-aa6cd15ce2c3
# ╠═75b23160-aada-4e48-8b16-ddd2c6c8df1f
# ╟─426a1f52-32dd-4b63-a274-27e1cf139742
# ╟─f30d72d7-7894-4229-8f25-509195563097
# ╟─d400d8d6-de2c-4886-86b9-ffd9e5f4e073
# ╟─ab4d46eb-d441-47c3-b061-2611b2e44009
# ╟─ff2294a6-2bd0-461c-bc38-02f157d86660
# ╟─b6b1690b-6427-4ff3-9abf-b499f4661c39
# ╟─59963c46-ee42-4989-bff4-90f12606193e
# ╟─5f6beed8-33ae-463c-9d28-09e3a4235936
# ╟─83cd894b-2be0-48c7-b5e7-8db7ed96c13f
# ╟─18a97ce6-ae85-46a2-b294-830473fe80cd
# ╟─e51d4b19-fa30-4643-8d12-407941a4757d
# ╠═6deab6a2-f298-42a8-9c86-db8a2a26ac17
# ╠═c668c791-9c3b-4eed-babe-9a484a88b68e
# ╠═897cc639-5ab6-48fe-bdba-19aa4e8bad15
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
