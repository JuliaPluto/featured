### A Pluto.jl notebook ###
# v0.19.37

#> [frontmatter]
#> image = "https://github.com/JuliaRegistries/General/assets/6933510/9a925232-6a75-47e7-9ab9-f384bc389602"
#> title = "Painting with Turtles"
#> date = "2024-01-23"
#> tags = ["krat", "turtle", "basic"]
#> description = "🐢 Use simple Julia code to make a painting!  of kratje"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ e814a124-f038-11ea-3b22-f109c99dbe03
using PlutoUI

# ╔═╡ 27d2fe04-a582-48f7-8d21-e2db7775f2c2
md"""
# Turtle drawing!

This notebook lets you make drawings with a **Turtle** 🐢! You can use **simple Julia code** to make pretty drawings, so this is a great way to practice some Julia.

## Moving around
Every drawing looks like this:

```julia
turtle_drawing() do t

	# your code here!

end
```

Let's make our first drawing. 
"""

# ╔═╡ 1ac7cee2-4aa7-497e-befe-8135d1d27d8d
md"""
!!! info "🙋 Does this make sense?"
	Take a look at the code above. Can you see how the **code corresponds to the picture**? Which step does what?
"""

# ╔═╡ d3d14186-4182-4187-9670-95b8b886bb74
md"""
TODO: need to explain that you move, and that you leave a trace
"""

# ╔═╡ 71bb4346-7067-4db4-9a70-ab232e7c2ebc
md"""
## Adding color

You can use `color!` to set the color of the turtle. This will determine the color of all future lines that you draw!
"""

# ╔═╡ 553d0488-f03b-11ea-2997-3d82493cd4d7
md"# Some famous artwork"

# ╔═╡ 25dc5690-f03a-11ea-3c59-35ae694b03b5
md"""## "_The Starry Night_" 
Vincent van Gogh (1889)"""

# ╔═╡ 5d345ae8-f03a-11ea-1c2d-03f66115b590
md"""## "_Tableau I_"
Piet Mondriaan (1913)"""

# ╔═╡ b3f5877c-b3e9-11ea-03fe-3f3233ee2e1b
@bind GO_mondriaan CounterButton("Another one!")

# ╔═╡ cd442606-f03a-11ea-3d53-57e83c8cdb1f
md"""## "_Een Boom_"
Luka van der Plas (2020)"""

# ╔═╡ 4c1bcc58-b3ec-11ea-32d1-7f4cd113e43d
@bind fractal_angle Slider(0:90; default=49)

# ╔═╡ a7e725d8-b3ee-11ea-0b84-8d252979e4ef
@bind fractal_tilt Slider(0:90; default=36)

# ╔═╡ 49ce3f9c-b3ee-11ea-0bb5-ed348475ea0b
@bind fractal_base Slider(0:0.01:2; default=1)

# ╔═╡ f132f376-f03a-11ea-33e2-775fc026faca
md"""## "_Een coole spiraal_" 
fonsi (2020)"""

# ╔═╡ 70160fec-b0c7-11ea-0c2a-35418346592e
@bind angle Slider(0:90; default=20)

# ╔═╡ ab083f08-b0c0-11ea-0c23-315c14607f1f
md"# 🐢 definition"

# ╔═╡ 310a0c52-b0bf-11ea-3e32-69d685f2f45e
Drawing = Vector{String}

# ╔═╡ 6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
mutable struct Turtle
	pos::Tuple{Number, Number}
	heading::Number
	pen_down::Bool
	color::String
	history::Drawing
end

# ╔═╡ 5560ed36-b0c0-11ea-0104-49c31d171422
md"## Turtle commands"

# ╔═╡ e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
function forward!(🐢::Turtle, distance::Number)
	old_pos = 🐢.pos
	new_pos = 🐢.pos = old_pos .+ (10distance .* (cos(🐢.heading), sin(🐢.heading)))
	if 🐢.pen_down
		push!(🐢.history, """<line x1="$(old_pos[1])" y1="$(old_pos[2])" x2="$(new_pos[1])" y2="$(new_pos[2])" stroke="$(🐢.color)" stroke-width="4" />""")
	end
	🐢
end

# ╔═╡ 573c11b4-b0be-11ea-0416-31de4e217320
backward!(🐢::Turtle, by::Number) = forward!(🐢, -by)

# ╔═╡ fc44503a-b0bf-11ea-0f28-510784847241
function right!(🐢::Turtle, angle_degrees::Number)
	🐢.heading += angle_degrees * pi / 180
end

# ╔═╡ d88440c2-b3dc-11ea-1944-0ba4a566d7c1
function draw_star(turtle, points, size)
	for i in 1:points
		right!(turtle, 360 / points)
		forward!(turtle, size)
		backward!(turtle, size)
	end
end

# ╔═╡ 47907302-b0c0-11ea-0b27-b5cd2b4720d8
left!(🐢::Turtle, angle::Number) = right!(🐢, -angle)

# ╔═╡ 1fb880a8-b3de-11ea-3181-478755ad354e
function penup!(🐢::Turtle)
	🐢.pen_down = false
end

# ╔═╡ 4c173318-b3de-11ea-2d4c-49dab9fa3877
function pendown!(🐢::Turtle)
	🐢.pen_down = true
end

# ╔═╡ 2e7c8462-b3e2-11ea-1e41-a7085e012bb2
function color!(🐢::Turtle, color::AbstractString)
	🐢.color = color
end

# ╔═╡ 678850cc-b3e4-11ea-3cf0-a3445a3ac15a
function draw_mondriaan(turtle, width, height)
	#propbability that we make a mondriaan split
	p = if width * height < 8
		0
	else
		((width * height) / 900) ^ 0.5
	end
		
	if rand() < p
		#split into halves
		
		split = rand(width * 0.1 : width * 0.9)

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
		draw_mondriaan(turtle, height, split)
		
		#fill in right of split
		forward!(turtle, height)
		right!(turtle, 90)
		forward!(turtle, width)
		right!(turtle, 90)
		draw_mondriaan(turtle, height, width - split)
		
		#walk back
		right!(turtle, 90)
		forward!(turtle, width)
		right!(turtle, 180)
		
	else
		#draw a colored square
		square_color = rand(["white", "white", "white", "red", "yellow", "blue"])
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

# ╔═╡ d1ae2696-b3eb-11ea-2fcc-07b842217994
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

# ╔═╡ 5aea06d4-b0c0-11ea-19f5-054b02e17675
md"## Function to make turtle drawings with"

# ╔═╡ 6dbce38e-b0bc-11ea-1126-a13e0d575339
function turtle_drawing(f::Function; background="white")
	🐢 = Turtle((150, 150), pi*3/2, true, "black", String[])
	
	f(🐢)
	
	image = """<svg version="1.1"
     baseProfile="full"
     width="300" height="300"
     xmlns="http://www.w3.org/2000/svg">
  <rect width="300" height="300" rx="10" fill="$(background)"  />
	""" * join(🐢.history) * "</svg>"
	return PlutoUI.Show(MIME"image/svg+xml"(), image)
end

# ╔═╡ e18d7225-5a06-4fbc-b836-17798c0eb198
turtle_drawing() do t

	# take 5 steps
	forward!(t, 5)

	# turn right, 90 degrees
	right!(t, 90)

	# take 10 steps
	forward!(t, 10)

end

# ╔═╡ 448dc68d-cd0a-4491-82ad-0e7cc00782ad
turtle_drawing() do t

	color!(t, "red")
	forward!(t, 5)

	right!(t, 90)

	color!(t, "pink")
	forward!(t, 10)

end

# ╔═╡ 9dc072fe-b3db-11ea-1568-857a664ce4d2
starry_night = turtle_drawing(background = "#000088") do t
	star_count = 100
	
	color!(t, "yellow")
	
	for i in 1:star_count
		#move
		penup!(t)
		random_angle = rand() * 360
		right!(t, random_angle)
		random_distance = rand(1:8)
		forward!(t, random_distance)
		
		#draw star
		pendown!(t)
		
		draw_star(t, 5, 1)
	end
end

# ╔═╡ e04a9296-b3e3-11ea-01b5-8ff7dc0ced56
mondriaan = turtle_drawing() do t	
	GO_mondriaan
	size = 30
	
	#go to top left corner
	penup!(t)
	forward!(t, size / 2)
	left!(t, 90)
	forward!(t, size / 2)
	right!(t, 180)
		
	#draw painting
	draw_mondriaan(t, size, size)
	
	#white border around painting
	color!(t, "white")
	pendown!(t)
	for i in 1:4
		forward!(t, size)
		right!(t, 90)
	end
end

# ╔═╡ 60b52a52-b3eb-11ea-2e3c-9d185f4fbc2b
fractal = turtle_drawing() do t
	penup!(t)
	backward!(t, 15)
	pendown!(t)
	lindenmayer(t, 0, fractal_angle, fractal_tilt, fractal_base)
end

# ╔═╡ d30c8f2a-b0bf-11ea-0557-19bb61118644
turtle_drawing() do t
	
	for i in 0:.1:10
		right!(t, angle)
		forward!(t, i)
	end
	
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "f64cdffc70331b0a2f407efefd54fd84eb680773"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

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
version = "0.3.23+2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

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
# ╠═e814a124-f038-11ea-3b22-f109c99dbe03
# ╟─27d2fe04-a582-48f7-8d21-e2db7775f2c2
# ╠═e18d7225-5a06-4fbc-b836-17798c0eb198
# ╟─1ac7cee2-4aa7-497e-befe-8135d1d27d8d
# ╟─d3d14186-4182-4187-9670-95b8b886bb74
# ╟─71bb4346-7067-4db4-9a70-ab232e7c2ebc
# ╠═448dc68d-cd0a-4491-82ad-0e7cc00782ad
# ╟─553d0488-f03b-11ea-2997-3d82493cd4d7
# ╟─25dc5690-f03a-11ea-3c59-35ae694b03b5
# ╟─9dc072fe-b3db-11ea-1568-857a664ce4d2
# ╟─d88440c2-b3dc-11ea-1944-0ba4a566d7c1
# ╟─5d345ae8-f03a-11ea-1c2d-03f66115b590
# ╟─b3f5877c-b3e9-11ea-03fe-3f3233ee2e1b
# ╟─e04a9296-b3e3-11ea-01b5-8ff7dc0ced56
# ╟─678850cc-b3e4-11ea-3cf0-a3445a3ac15a
# ╟─cd442606-f03a-11ea-3d53-57e83c8cdb1f
# ╟─4c1bcc58-b3ec-11ea-32d1-7f4cd113e43d
# ╟─a7e725d8-b3ee-11ea-0b84-8d252979e4ef
# ╟─49ce3f9c-b3ee-11ea-0bb5-ed348475ea0b
# ╟─60b52a52-b3eb-11ea-2e3c-9d185f4fbc2b
# ╟─d1ae2696-b3eb-11ea-2fcc-07b842217994
# ╟─f132f376-f03a-11ea-33e2-775fc026faca
# ╟─70160fec-b0c7-11ea-0c2a-35418346592e
# ╟─d30c8f2a-b0bf-11ea-0557-19bb61118644
# ╟─ab083f08-b0c0-11ea-0c23-315c14607f1f
# ╠═6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
# ╠═310a0c52-b0bf-11ea-3e32-69d685f2f45e
# ╟─5560ed36-b0c0-11ea-0104-49c31d171422
# ╠═e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
# ╠═573c11b4-b0be-11ea-0416-31de4e217320
# ╠═fc44503a-b0bf-11ea-0f28-510784847241
# ╠═47907302-b0c0-11ea-0b27-b5cd2b4720d8
# ╠═1fb880a8-b3de-11ea-3181-478755ad354e
# ╠═4c173318-b3de-11ea-2d4c-49dab9fa3877
# ╠═2e7c8462-b3e2-11ea-1e41-a7085e012bb2
# ╟─5aea06d4-b0c0-11ea-19f5-054b02e17675
# ╠═6dbce38e-b0bc-11ea-1126-a13e0d575339
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
