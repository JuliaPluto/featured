### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> author_url = "https://github.com/JuliaPluto"
#> image = "https://user-images.githubusercontent.com/6933510/174067982-904951c4-4bba-42c7-a340-102ceb7e8e10.png"
#> title = "Interactivity — advanced"
#> tags = ["interactivity", "classic", "advanced"]
#> author_name = "Pluto.jl"
#> description = "How @bind works, and writing your own inputs."
#> license = "Unlicense"

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

# ╔═╡ a9fe430b-08b4-42e2-94d4-dbdffcdcb9dd
using PlutoUI

# ╔═╡ dc5d75cd-2eaa-49b3-9c73-c343dfd04fa5
using AbstractPlutoDingetjes

# ╔═╡ eb47db64-d202-497f-9e54-7cc5479ae07b
md"""
# Advanced `@bind`

behind the scenes, and custom inputs
"""

# ╔═╡ f94d3fc1-f611-4b03-8bd9-772f15737e6b


# ╔═╡ f8b6b839-ed59-40d8-9d48-006f3ca583bb
@bind ff Slider([sin , cos, tan])

# ╔═╡ 57a7aaa2-27c8-4a10-8e50-e50497dfdab2


# ╔═╡ 805d12d8-080c-41d0-9c33-22b351858c59
AbstractPlutoDingetjes.Bonds.transform_value(Select([sin , cos, tan]), 2)

# ╔═╡ 7f156d6a-a76a-40e0-952a-5d90cd6c6b77
ff

# ╔═╡ e9a663c9-cc25-48fd-b152-81489e3ad96d
md"""
# How does `@bind` work?

"""

# ╔═╡ 7d25aa74-c105-47b8-9925-be939b1ec19d
md"""
uitleggen:
- macro expansion
- html renderen
- return value of bind to repeat/move bond
- sync
  - get & set
- lossy lazy
- customevent
- abstractplutodingetjes
- 
"""

# ╔═╡ c04b6856-a761-4168-bef9-8cc6767145a0


# ╔═╡ 9c8774c0-d118-4cd3-b5ea-5d5b9dd16a4c


# ╔═╡ db24490e-7eac-11ea-094e-9d3fc8f22784
md"# Introducing _bound_ variables

With the `@bind` macro, Pluto.jl can synchronize a Julia variable with an HTML object!"

# ╔═╡ bd24d02c-7eac-11ea-14ab-95021678e71e
xbond = @bind x html"<input type=range>"

# ╔═╡ 74881530-cbea-4bb2-a627-2e68b585879d
xbond

# ╔═╡ 73aaf6fa-2f25-44ed-b6bb-0d1673f8d4c1


# ╔═╡ cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
md"This syntax displays the HTML object as the cell's output, and uses its latest value as the definition of `x`. Of course, the variable `x` is _reactive_, and all references to `x` come to life ✨

_Try moving the slider!_ 👆" 

# ╔═╡ cb1fd532-7eac-11ea-307c-ab16b1977819
x

# ╔═╡ 816ea402-7eae-11ea-2134-fb595cca3068
md""

# ╔═╡ ce7bec8c-7eae-11ea-0edb-ad27d2df059d
md"### Combining bonds

The `@bind` macro returns a `Bond` object, which can be used inside Markdown and HTML literals:"

# ╔═╡ fc99521c-7eae-11ea-269b-0d124b8cbe48
begin
	dog_slider = @bind 🐶 html"<input type=range>"
	cat_slider = @bind 🐱 html"<input type=range>"
	
	md"""
	**How many pets do you have?**
	
	Dogs: $(dog_slider)
	
	Cats: $(cat_slider)
	"""
end

# ╔═╡ 1cf27d7c-7eaf-11ea-3ee3-456ed1e930ea
md"""
You have $(🐶) dogs and $(🐱) cats!
"""

# ╔═╡ e3204b38-7eae-11ea-32be-39db6cc9faba
md""

# ╔═╡ 5301eb68-7f14-11ea-3ff6-1f075bf73955
md"### Input types

You can use _any_ DOM element that fires an `input` event. For example:"

# ╔═╡ c7203996-7f14-11ea-00a3-8192ccc54bd6
md"""
`a = ` $(@bind a html"<input type=range >")

`b = ` $(@bind b html"<input type=text >")

`c = ` $(@bind c html"<input type=button value='Click'>")

`d = ` $(@bind d html"<input type=checkbox >")

`e = ` $(@bind e html"<select><option value='one'>First</option><option value='two'>Second</option></select>")

`f = ` $(@bind f html"<input type=color >")

"""

# ╔═╡ ede8009e-7f15-11ea-192a-a5c6135a9dcf
(a, b, c, d, e, f)

# ╔═╡ e2168b4c-7f32-11ea-355c-cf5932419a70
md"""**You can also use JavaScript to write more complicated input objects.** The `input` event can be triggered on any object using

```js
obj.dispatchEvent(new CustomEvent("input"))
```

Try drawing a rectangle in the canvas below 👇 and notice that the `area` variable updates."""

# ╔═╡ 7f4b0e1e-7f16-11ea-02d3-7955921a70bd
@bind dims html"""
<span>
<canvas width="200" height="200" style="position: relative"></canvas>

<script>
// 🐸 `currentScript` is the current script tag - we use it to select elements 🐸 //
const span = currentScript.parentElement
const canvas = span.querySelector("canvas")
const ctx = canvas.getContext("2d")

var startX = 80
var startY = 40

function onmove(e){
	// 🐸 We send the value back to Julia 🐸 //
	span.value = [e.layerX - startX, e.layerY - startY]
	span.dispatchEvent(new CustomEvent("input"))

	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)
	ctx.fillStyle = '#3f3d6d'
	ctx.fillRect(startX, startY, ...span.value)
}

canvas.onpointerdown = e => {
	startX = e.layerX
	startY = e.layerY
	canvas.onpointermove = onmove
}

canvas.onpointerup = e => {
	canvas.onpointermove = null
}

// Fire a fake pointermoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
</span>
"""

# ╔═╡ 5876b98e-7f32-11ea-1748-0bb47823cde1
area = abs(dims[1] * dims[2])

# ╔═╡ 72c7f60c-7f48-11ea-33d9-c5ea55a0ad1f
dims

# ╔═╡ d774fafa-7f34-11ea-290d-37805806e14b
md""

# ╔═╡ 8db857f8-7eae-11ea-3e53-058a953f2232
md"""## Can I use it?

The `@bind` macro is **built into Pluto.jl** — it works without having to install a package. 

You can use the (tiny) package [PlutoUI.jl](https://github.com/JuliaPluto/PlutoUI.jl) for some predefined input elements. For example, you use `PlutoUI` to write

```julia
@bind x Slider(5:15)
```

instead of 

```julia
@bind x html"<input type=range min=5 max=15>"
```

Have a look at the [sample notebook about PlutoUI](./sample/PlutoUI.jl.jl)!

_The `@bind` syntax in not limited to `html"..."` objects, but **can be used for any HTML-showable object!**_
"""

# ╔═╡ d5b3be4a-7f52-11ea-2fc7-a5835808207d
md"""
#### More packages

In fact, **_any package_ can add bindable values to their objects**. For example, a geoplotting package could add a JS `input` event to their plot that contains the cursor coordinates when it is clicked. You can then use those coordinates inside Julia. Take a look at the [JavaScript sample notebook](./sample/JavaScript.jl) to learn more about these techniques!
"""

# ╔═╡ aa8f6a0e-303a-11eb-02b7-5597c167596d


# ╔═╡ 5c1ececa-303a-11eb-1faf-0f3a6f94ac48
md"""## Separate definition and reference
Interactivity works through reactivity. If you put a bond and a reference to the same variable together, then setting the bond will trigger the _entire cell_ to re-evaluate, including the bond itself.

So **do not** write
```julia
md""\"$(@bind r html"<input type=range>")  $(r^2)""\"
```
Instead, create two cells:
```julia
md""\"$(@bind r html"<input type=range>")""\"
```
```julia
r^2
```
"""

# ╔═╡ 55783466-7eb1-11ea-32d8-a97311229e93


# ╔═╡ 582769e6-7eb1-11ea-077d-d9b4a3226aac
md"## Behind the scenes

#### What is x?

It's an **`Int64`**! Not an Observable, not a callback function, but simply _the latest value of the input element_.

The update mechanism is _lossy_ and _lazy_, which means that it will skip values if your code is still running - and **only send the latest value when your code is ready again**. This is important when changing a slider from `0` to `100`, for example. If it would send all intermediate values, it might take a while for your code to process everything, causing a noticeable lag."

# ╔═╡ 8f829274-7eb1-11ea-3888-13c00b3ba70f
md"""#### What does the macro do?

The `@bind` macro does not actually contain the interactivity mechanism, this is built into Pluto itself. Still, it does two things: it assigns a _default value_ to the variable (`missing` in most cases), and it wraps the second argument in a `PlutoRunner.Bond` object.

For example, _expanding_ the `@bind` macro turns this expression:

```julia
@bind x Slider(5:15)
```

into (simplified):
```julia
begin
    local el = Slider(5:15)
    global x = AbstractPlutoDingetjes.intial_value(el)
    PlutoRunner.create_bond(el, :x)
end
```

We see that the macro creates a variable `x`, which is given the value `AbstractPlutoDingetjes.intial_value(el)`. This function returns `missing` by default, unless a method was implemented for your widget type. For example, `PlutoUI` has a `Slider` type, and it defines a method for `intial_value(slider::Slider)` that returns the default number.

Declaring a default value using `AbstractPlutoDingetjes` is **not necessary**, as shown by the earlier examples in this notebook, but the default value will be used for `x` if the `notebook.jl` file is _run as a plain julia file_, without Pluto's interactivity.

You don't need to worry about this if you are just getting started with Pluto and interactive elements, but more advanced users should take a look at [`AbstractPlutoDingetjes.jl`](https://github.com/JuliaPluto/AbstractPlutoDingetjes.jl).

"""

# ╔═╡ ced18648-7eb2-11ea-2052-07795685f0da
md"#### JavaScript?

Yes! We are using `Generator.input` from [`observablehq/stdlib`](https://github.com/observablehq/stdlib#Generators_input) to create a JS _Generator_ (kind of like an Observable) that listens to `onchange`, `onclick` or `oninput` events, [depending on the element type](https://github.com/observablehq/stdlib#Generators_input).

This makes it super easy to create nice HTML/JS-based interaction elements - a package creator simply has to write a `show` method for MIME type `text/html` that creates a DOM object that triggers the `input` event. In other words, _Pluto's `@bind` will behave exactly like [`viewof` in observablehq](https://observablehq.com/@observablehq/introduction-to-views)_.

_If you want to make a cool new UI for Pluto, go to the [JavaScript sample notebook](./sample/JavaScript.jl) to learn how!_"

# ╔═╡ dddb9f34-7f37-11ea-0abb-272ef1123d6f
md""

# ╔═╡ 23db0e90-7f35-11ea-1c05-115773b44afa
md""

# ╔═╡ f7555734-7f34-11ea-069a-6bb67e201bdc
md"That's it for now! Let us know what you think using the feedback box below! 👇"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

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

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

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

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
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

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a5aef8d4a6e8d81f171b2bd4be5265b01384c74c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.10"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─eb47db64-d202-497f-9e54-7cc5479ae07b
# ╠═f94d3fc1-f611-4b03-8bd9-772f15737e6b
# ╠═f8b6b839-ed59-40d8-9d48-006f3ca583bb
# ╠═57a7aaa2-27c8-4a10-8e50-e50497dfdab2
# ╠═805d12d8-080c-41d0-9c33-22b351858c59
# ╠═7f156d6a-a76a-40e0-952a-5d90cd6c6b77
# ╠═a9fe430b-08b4-42e2-94d4-dbdffcdcb9dd
# ╠═dc5d75cd-2eaa-49b3-9c73-c343dfd04fa5
# ╟─e9a663c9-cc25-48fd-b152-81489e3ad96d
# ╠═7d25aa74-c105-47b8-9925-be939b1ec19d
# ╠═c04b6856-a761-4168-bef9-8cc6767145a0
# ╠═9c8774c0-d118-4cd3-b5ea-5d5b9dd16a4c
# ╟─db24490e-7eac-11ea-094e-9d3fc8f22784
# ╠═bd24d02c-7eac-11ea-14ab-95021678e71e
# ╠═74881530-cbea-4bb2-a627-2e68b585879d
# ╠═73aaf6fa-2f25-44ed-b6bb-0d1673f8d4c1
# ╟─cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
# ╠═cb1fd532-7eac-11ea-307c-ab16b1977819
# ╟─816ea402-7eae-11ea-2134-fb595cca3068
# ╟─ce7bec8c-7eae-11ea-0edb-ad27d2df059d
# ╠═fc99521c-7eae-11ea-269b-0d124b8cbe48
# ╠═1cf27d7c-7eaf-11ea-3ee3-456ed1e930ea
# ╟─e3204b38-7eae-11ea-32be-39db6cc9faba
# ╟─5301eb68-7f14-11ea-3ff6-1f075bf73955
# ╟─c7203996-7f14-11ea-00a3-8192ccc54bd6
# ╠═ede8009e-7f15-11ea-192a-a5c6135a9dcf
# ╟─e2168b4c-7f32-11ea-355c-cf5932419a70
# ╟─7f4b0e1e-7f16-11ea-02d3-7955921a70bd
# ╠═5876b98e-7f32-11ea-1748-0bb47823cde1
# ╠═72c7f60c-7f48-11ea-33d9-c5ea55a0ad1f
# ╟─d774fafa-7f34-11ea-290d-37805806e14b
# ╟─8db857f8-7eae-11ea-3e53-058a953f2232
# ╟─d5b3be4a-7f52-11ea-2fc7-a5835808207d
# ╟─aa8f6a0e-303a-11eb-02b7-5597c167596d
# ╟─5c1ececa-303a-11eb-1faf-0f3a6f94ac48
# ╟─55783466-7eb1-11ea-32d8-a97311229e93
# ╟─582769e6-7eb1-11ea-077d-d9b4a3226aac
# ╟─8f829274-7eb1-11ea-3888-13c00b3ba70f
# ╟─ced18648-7eb2-11ea-2052-07795685f0da
# ╟─dddb9f34-7f37-11ea-0abb-272ef1123d6f
# ╟─23db0e90-7f35-11ea-1c05-115773b44afa
# ╟─f7555734-7f34-11ea-069a-6bb67e201bdc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
