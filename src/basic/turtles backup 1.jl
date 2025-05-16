### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/user-attachments/assets/5eb767e4-2f9c-44ff-ace6-eb7bfaee8fcf"
#> order = "5"
#> title = "Turtles – introduction"
#> date = "2024-08-10"
#> tags = ["turtle", "basic"]
#> description = "🐢 Use simple Julia code to make a painting!"
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

# ╔═╡ 30543e65-4cfb-41e0-80a8-fa3250ff0adb
using PlutoTurtles

# ╔═╡ e814a124-f038-11ea-3b22-f109c99dbe03
using PlutoUI

# ╔═╡ 105b069a-9052-49a5-8f0e-61986775ebb4
md"""
# Turtle drawing!

This notebook lets you make drawings with a **Turtle** 🐢! You can use **simple Julia code** to make pretty drawings, so this is a great way to practice some Julia.
"""

# ╔═╡ 1da39e13-45e2-4d27-822a-0bacbd7b416a
md"""
## Moving around
Every drawing is written with `turtle_drawing` like this:

```julia
@steps turtle_drawing() do t

	# your code here!

end
```

This code creates an empty drawing, with a turtle `t` in the middle. The turtle is holding a pencil, and so when the turtle walks around, they leave a trail.

Let's make our first drawing by moving the turtle.
"""

# ╔═╡ e18d7225-5a06-4fbc-b836-17798c0eb198
@steps turtle_drawing() do t

	# take 5 steps
	forward!(t, 5)

	# turn left, 90 degrees
	left!(t, 90)

	# take 10 steps
	forward!(t, 10)

end

# ╔═╡ 1ac7cee2-4aa7-497e-befe-8135d1d27d8d
md"""
!!! info "🙋 Does this make sense?"
	Take a look at the code above. Can you see how the **code corresponds to the picture**? Which step does what?
"""

# ╔═╡ 46eebe4b-340b-468c-97c7-a4b5627b7163
md"""
### Let's make a square!

Your turn! Edit the code below to draw a square. 🟥
"""

# ╔═╡ 90b40abf-caa3-4274-b164-e8c6d2f5b920
@steps turtle_drawing() do t

	forward!(t, 5)

	left!(t, 90)

	forward!(t, 5)

	# what's next?

end

# ╔═╡ d78b93aa-ae37-4588-a975-575dbd9d1070
md"""
Can you make the square bigger? Smaller?
"""

# ╔═╡ 04b3d54b-4e0b-46ad-bc92-f94ddfa890ef
md"""
!!! warning "Bonus exercise!"
	Did you manage to make a square? Can you also make a triangle? 🔺
"""

# ╔═╡ 04ac9226-c32a-4efd-b0b5-b896d218e5a1
md"""
### Turning right

We know two commands, `forward!` and `left!`. You can also use `backward!` and `right!`

Can you make a star? 🤩
"""

# ╔═╡ 3a485abf-8a9c-4ce6-a4a8-49a1be3f6b5f
@steps turtle_drawing() do t

	right!(t, 10)


	forward!(t, 5)
	right!(t, 160)
	forward!(t, 5)

	# what's next?
	
end

# ╔═╡ 3733bed0-5490-4d08-bfa6-45f7cc18051b
md"""
## Seeing the `@steps`

If you want to see which code line corresponds to which step, then you can use our handy `@steps` macro. Put it at the very start of the cell:

Instead of this:


```julia
turtle_drawing() do t

	# your code here!

end
```

You write this:

```julia
@steps turtle_drawing() do t

	# your code here!

end
```

Restart the cell below to see it in action!
"""

# ╔═╡ 15738a72-008d-4fe0-9f31-d0c7a94b9b61
@steps turtle_drawing() do t

	# take 5 steps
	forward!(t, 5)

	# turn left, 90 degrees
	left!(t, 90)

	# take 10 steps
	forward!(t, 10)

end

# ╔═╡ 634309bc-64e7-47ef-888b-a083a485e105
md"""
## Using the `for` loop

Let's make a zig-zag line!
"""

# ╔═╡ 19abbdeb-efe3-4a26-85c9-011ae5939c8e
@steps turtle_drawing() do t

	forward!(t, 5)
	right!(t, 160) # turn right, 160 degrees (almost a 180 degree half turn)
	forward!(t, 5)
	left!(t, 160) # turn back
	

	### REPEAT
	forward!(t, 5)
	right!(t, 160)
	forward!(t, 5)
	left!(t, 160)
	
	### REPEAT
	forward!(t, 5)
	right!(t, 160)
	forward!(t, 5)
	left!(t, 160)
	
	### REPEAT
	forward!(t, 5)
	right!(t, 160)
	forward!(t, 5)
	left!(t, 160)
	
end

# ╔═╡ 2b245c13-82d7-40f6-b26b-d702962b37f3
md"""
You see that we make a zig-zag by doing one up-down motion, and repeating this. But if we want to make the drawing very long, **our code will become very long**.

This is why `for`-loops are useful: you can **repeat the same block of code multiple times**. Check it out:
"""

# ╔═╡ a84af845-7f7a-45eb-b1d4-dde8047cb8e8
@steps turtle_drawing() do t

	for i in 1:10
		forward!(t, 5)
		right!(t, 160)
		forward!(t, 5)
		left!(t, 160)
	end
	
end

# ╔═╡ 42f262dd-4208-4a84-bd2d-5f4be5c78964
md"""
**Try it yourself!** Write some code in the `for` loop, and it will repeat 10 times. Try whatever you want!
"""

# ╔═╡ 5f0a4d6a-2545-4610-b827-6adc50204136
@steps turtle_drawing() do t

	for i in 1:10
		# repeat something 10 times
		# write your code here! for example:
		forward!(t, 2)

	end
	
end

# ╔═╡ d742acd5-ad8d-4ee6-bab0-e54ab9313e0d
md"""
### The iterator `i`

Inside the `for` loop, you can use the variable `i`, which goes from `1` to `10`. In the playground above, write `forward!(t, i)` somewhere inside the `for` loop. This means: *"move the turtle `t` forward by `i` steps"*. 

Do you understand what happens?
"""

# ╔═╡ 71bb4346-7067-4db4-9a70-ab232e7c2ebc
md"""
## Adding color

You can use the `color!` function to set the color of the turtle. This will determine the color of all future lines that you draw!
"""

# ╔═╡ 448dc68d-cd0a-4491-82ad-0e7cc00782ad
@steps turtle_drawing() do t

	color!(t, "red")
	forward!(t, 5)

	right!(t, 90)

	color!(t, "pink")
	forward!(t, 10)

end

# ╔═╡ 14c803ff-268b-48bc-90c9-faa88010f5fe
md"""
### Which colors can I use?
Most English words for colors will work! Like **`"red"`**, **`"gray"`** and **`"darkviolet"`**. For a complete list, see [this table](https://developer.mozilla.org/en-US/docs/Web/CSS/named-color#value). You can also use [sytnax like **`"rgb(255 100 0)"`**](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#syntax).
"""

# ╔═╡ 45e31b3e-7f25-411a-b7c7-a1a8a7c77ddd
turtle_drawing() do t
	for color in ["red", "orange", "yellow", "green", "turquoise", "blue", "purple"]
		# draw the line
		color!(t, color)
		forward!(t, 10)
		backward!(t, 10)

		# take a step left
		penup!(t)
		left!(t, 90)
		forward!(t, 0.4)
		right!(t, 90)
		pendown!(t)
	end
end

# ╔═╡ 01b73386-ce68-4ad7-92af-17d91930f8f5
md"""
## Using global variables

In a code cell, you can also create a **variable**, and use the value multiple times. For example:
"""

# ╔═╡ aa3d15c6-f6c2-49cd-9a77-7d9951157897
example_step = 1.5

# ╔═╡ f3ced552-1b2e-47a1-be8a-6a0c20561ae1
md"""
You can use this variable in other cells:
"""

# ╔═╡ 93fc3d23-9d7d-42ac-83fe-1cd568624a87
example_step + example_step

# ╔═╡ 160a5b22-6f1e-446d-861a-747cfe25bfda
md"""
We can also use variables in our drawings! Do you see where `example_step` is used in the example below? 
"""

# ╔═╡ 31847740-bb0b-41cc-9d4f-a42ee33bbc62
turtle_drawing() do t

	for i in 1:10
		color!(t, "black")
		forward!(t, example_step)

		color!(t, "red")
		forward!(t, example_step)
	end
	
end

# ╔═╡ 468eb41d-fa5a-46cd-a5ef-2708c74e5ee0
md"""
Now, go to [the definition of `example_step`](#example_step) and change the value from `1.5` to another number. 

Do you see the drawing change?
"""

# ╔═╡ 5a32b0d4-6a72-4b11-96ab-b6c8374153ba
md"""
## Interactivity with PlutoUI

Let's do something fun! In the example above, you saw how you can change variables to control the image. In this section, we will use interactive elements from the package PlutoUI to **control Julia variables**. Let's try it!

**👇 Move the slider and color picker below:**
"""

# ╔═╡ 925a66b2-3564-480c-be12-0e626b01362f
@bind fun_angle Slider(0:180)

# ╔═╡ c347a8ad-c859-4eb2-8fdc-bb7f04c7f70e
@bind second_color ColorStringPicker()

# ╔═╡ fac4f50a-ce65-4f22-af23-0fc73af936f2
fun_angle, second_color

# ╔═╡ aa724bc5-563f-4421-a55c-84ebd766f364
turtle_drawing() do t

	for i in 1:10
		color!(t, "black")
		forward!(t, 3)

		right!(t, fun_angle)

		color!(t, second_color)
		forward!(t, 3)
	end
	
end

# ╔═╡ ea5f57d5-1396-4d66-885e-bc08864475c1
md"""
## Functions

You can extract some code into a function, and reuse it later! Here is some code that draws a house, and we can use it to make a street!
"""

# ╔═╡ 8f55e3f7-4082-4df9-b290-2b9183b067d8
function drawhouse(t)
	# floor
	forward!(t, 6)

	# wall
	left!(t, 90)
	forward!(t, 6)

	# roof
	left!(t, 45)
	forward!(t, sqrt(2) * 3)
	left!(t, 90)
	forward!(t, sqrt(2) * 3)
	left!(t, 45)

	# wall
	forward!(t, 6)
	left!(t, 90)
end

# ╔═╡ 1f3a56d1-0756-410d-be55-504398052149
@steps turtle_drawing() do t
	penup!(t)
	right!(t, 90)
	backward!(t, 14)
	pendown!(t)

	for i in 1:4
		drawhouse(t)
		
		penup!(t)
		forward!(t, 7)
		pendown!(t)
	end
end

# ╔═╡ adce0892-05bd-45da-9e1f-3877af5e8f7f
md"""
## Write your own notebook!

That's it for now! If you would like to play more with turtle code, just open a new Pluto notebook and use the [PlutoTurtles.jl](https://github.com/JuliaPluto/PlutoTurtles.jl) package:

```julia
using PlutoTurtles
```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTurtles = "67697473-756c-6b61-6172-6b407461726b"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTurtles = "~1.0.1"
PlutoUI = "~0.7.55"
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
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

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
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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
# ╟─105b069a-9052-49a5-8f0e-61986775ebb4
# ╠═30543e65-4cfb-41e0-80a8-fa3250ff0adb
# ╟─1da39e13-45e2-4d27-822a-0bacbd7b416a
# ╠═e18d7225-5a06-4fbc-b836-17798c0eb198
# ╟─1ac7cee2-4aa7-497e-befe-8135d1d27d8d
# ╟─46eebe4b-340b-468c-97c7-a4b5627b7163
# ╠═90b40abf-caa3-4274-b164-e8c6d2f5b920
# ╟─d78b93aa-ae37-4588-a975-575dbd9d1070
# ╟─04b3d54b-4e0b-46ad-bc92-f94ddfa890ef
# ╟─04ac9226-c32a-4efd-b0b5-b896d218e5a1
# ╠═3a485abf-8a9c-4ce6-a4a8-49a1be3f6b5f
# ╟─3733bed0-5490-4d08-bfa6-45f7cc18051b
# ╠═15738a72-008d-4fe0-9f31-d0c7a94b9b61
# ╟─634309bc-64e7-47ef-888b-a083a485e105
# ╠═19abbdeb-efe3-4a26-85c9-011ae5939c8e
# ╟─2b245c13-82d7-40f6-b26b-d702962b37f3
# ╠═a84af845-7f7a-45eb-b1d4-dde8047cb8e8
# ╟─42f262dd-4208-4a84-bd2d-5f4be5c78964
# ╠═5f0a4d6a-2545-4610-b827-6adc50204136
# ╟─d742acd5-ad8d-4ee6-bab0-e54ab9313e0d
# ╟─71bb4346-7067-4db4-9a70-ab232e7c2ebc
# ╠═448dc68d-cd0a-4491-82ad-0e7cc00782ad
# ╟─14c803ff-268b-48bc-90c9-faa88010f5fe
# ╠═45e31b3e-7f25-411a-b7c7-a1a8a7c77ddd
# ╟─01b73386-ce68-4ad7-92af-17d91930f8f5
# ╠═aa3d15c6-f6c2-49cd-9a77-7d9951157897
# ╟─f3ced552-1b2e-47a1-be8a-6a0c20561ae1
# ╠═93fc3d23-9d7d-42ac-83fe-1cd568624a87
# ╟─160a5b22-6f1e-446d-861a-747cfe25bfda
# ╠═31847740-bb0b-41cc-9d4f-a42ee33bbc62
# ╟─468eb41d-fa5a-46cd-a5ef-2708c74e5ee0
# ╟─5a32b0d4-6a72-4b11-96ab-b6c8374153ba
# ╠═e814a124-f038-11ea-3b22-f109c99dbe03
# ╠═925a66b2-3564-480c-be12-0e626b01362f
# ╠═c347a8ad-c859-4eb2-8fdc-bb7f04c7f70e
# ╠═fac4f50a-ce65-4f22-af23-0fc73af936f2
# ╠═aa724bc5-563f-4421-a55c-84ebd766f364
# ╟─ea5f57d5-1396-4d66-885e-bc08864475c1
# ╠═8f55e3f7-4082-4df9-b290-2b9183b067d8
# ╠═1f3a56d1-0756-410d-be55-504398052149
# ╟─adce0892-05bd-45da-9e1f-3877af5e8f7f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
