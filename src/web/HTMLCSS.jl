### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> author_url = "https://github.com/JuliaPluto"
#> image = "https://upload.wikimedia.org/wikipedia/commons/9/99/Unofficial_JavaScript_logo_2.svg"
#> tags = ["javascript", "web", "classic"]
#> author_name = "Pluto.jl"
#> description = "Use HTML, CSS and JavaScript to make your own interactive visualizations!"
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

# ╔═╡ 571613a1-6b4b-496d-9a68-aac3f6a83a4b
using PlutoUI, HypertextLiteral

# ╔═╡ dbb6824b-86b6-489c-b8c8-89100482e742
using Unitful

# ╔═╡ 97914842-76d2-11eb-0c48-a7eedca870fb
md"""
# Using _HTML_ inside Pluto

You have already seen that Pluto is designed to be _interactive_. You can make fantastic explorable documents using just the basic inputs provided by PlutoUI, together with the wide range of visualization libraries that Julia offers.

_However_, if you want to take your interactive document one step further, then Pluto offers a great framework for **combining Julia with HTML, CSS and JavaScript**.
"""

# ╔═╡ f93c7f38-10e9-46de-af22-39e752d098f1


# ╔═╡ cb2faea5-a171-4c5b-b760-5218a088422c
md"""
> Before we start
> 
> ## 🙈🙉 Learning a new language is scary!
> 
> Maybe you just learned Julia and Markdown and you think: *whyyy* would I learn another language?
> 
> It's not as bad as it sounds! Julia has lots of syntax features, like `import`, `function`, `;`, `do`, HTML and CSS are super basic: they have **very simple** structure, and you will learn it in less than an hour!
"""

# ╔═╡ aebe6a1e-afa1-4bb0-b6a1-4fdcb0b1a910


# ╔═╡ 8d8daf00-6c3f-4903-a3d8-97604f7e5ece
md"""
## HTML

HTML is a language to define the *structure* of web documents: headings, paragraphs, images, info blocks and more! It can do the same as Markdown, but also much more!
"""

# ╔═╡ 85a9dc12-bd5c-49e4-8ea3-89a32d2fd40b


# ╔═╡ d279ace8-e561-4a0a-a2dd-d587bd35af0d
@htl("""
<h4>This is written in HTML!</h4>

<p>HTML defines <em>structure</em>.</p>

<blockquote>
	<p>HTML structure can be <strong>nested</strong>: elements are placed inside each other.</p>
</blockquote>

<p>Here is an image!</p>

<img src="https://upload.wikimedia.org/wikipedia/commons/6/61/HTML5_logo_and_wordmark.svg" width="100">
""")

# ╔═╡ 8574aa05-62fb-4c87-9b3f-5735beeecbf0
md"""
!!! info "Boring!"
	Right now, it does not look super useful compared to Markdown! 😅 But wait! The real power of HTML is the **combination with CSS**!
"""

# ╔═╡ 9a415a57-3d39-403f-96f7-878a0b14957f
md"""
### Elements

Here, I used the elements:
- `<h4>` (heading level 4)
- `<p>` (paragraph)
- `<em>` (emphasized text)
- `<blockquote>` (a box dispaying a quote)
- `<img>` (image). Here, we also used **attributes**: `src` and `width`.
"""

# ╔═╡ 5728748c-249b-49ad-ab5c-bf6ed75ed131
md"""
There are hundreds of these built-in elements that have a special *default* function. You can find all of them [here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element). Try them out in a notebook!
"""

# ╔═╡ 991c5bfb-a430-473c-8da2-3a453fff8f53


# ╔═╡ 94e5ce3e-859a-42a7-b932-71efcdf44d16


# ╔═╡ 9efbabab-88e0-4fbe-8ed6-b30edae6c277


# ╔═╡ a2c6cd2b-7251-4e5b-a36d-a8e4a7e605fe
md"""
### Attributes

An HTML element can also have **atributes**, which give additional information about an element. 
"""

# ╔═╡ c1d5fec8-1dae-4fd6-808b-41a3623bfb28
@htl("""
<article class="recipe vegetarian">

	<h2>Apple sauce</h2>
	<p>A classic for all ages!</p>

	<section class="ingredients">
		<h3>Ingredients</h3>
		<ul>
			<li>1kg apples</li>
			<li>1tbsp lemon juice</li>
			<li>100mL water</li>
			<li>1tbsp sugar</li>
			<li>1tsp cinnamon</li>
		</ul>
	</section>

	<section class="preparation">
		<h3>Preparation</h3>
		<ol>
			<li>Peel apples and cut into chunks.</li>
			<li>Add all ingredients to a large pot and bring to a boil.</li>
			<li>Simmer on low heat for 15 minutes, stirring occasionally.</li>
			<li>Turn off the heat and cool down.</li>
		</ol>
	</section>

</article>
""")

# ╔═╡ b3a2498f-25bb-4472-bae0-e354dbb3c6b8


# ╔═╡ ed07848c-411e-4899-941e-ecf87cded5ab


# ╔═╡ 20aaa738-f431-43f5-bc48-46aa39419bb5


# ╔═╡ 91325d20-6e77-464c-94a9-37648a733700


# ╔═╡ 52ed865b-8180-4edc-b4e2-1db15d82cfed
md"""
## CSS

CSS is a language to define the **visual style and layout** of HTML content. This is SUPER useful!

You write CSS **inside the HTML `<style>` element**. 
"""

# ╔═╡ f618f971-5d3d-47d4-8ab3-5239553b2aa4
@htl """
<style>
.recipe {
	background: #ffb;
	color: #111;
}
</style>
"""

# ╔═╡ 168e13f7-2ff2-4207-be56-e57755041d36
md"""
## Prerequisites

This document assumes that you have used HTML, CSS and JavaScript before in another context. If you know Julia, and you want to add these web languages to your skill set, we encourage you to do so! It will be useful knowledge, also outside of Pluto.

"""

# ╔═╡ 28ae1424-67dc-4b76-a172-1185cc76cb59
@htl("""

<article class="learning">
	<h4>
		Learning HTML and CSS
	</h4>
	<p>
		It is easy to learn HTML and CSS because they are not 'programming languages' like Julia and JavaScript, they are <em>markup languages</em>: there are no loops, functions or arrays, you only <em>declare</em> how your document is structured (HTML) and what that structure looks like on a 2D color display (CSS).
	</p>
	<p>
		As an example, this is what this cell looks like, written in HTML and CSS:
	</p>
</article>


<style>

	article.learning {
		background: #f996a84f;
		padding: 1em;
		border-radius: 5px;
	}

	article.learning h4::before {
		content: "☝️";
	}

	article.learning p::first-letter {
		font-size: 1.5em;
		font-family: cursive;
	}

</style>
""")

# ╔═╡ ea39c63f-7466-4015-a66c-08bd9c716343
md"""
> My personal favourite resource for learning HTML and CSS is the [Mozilla Developer Network (MDN)](https://developer.mozilla.org/en-US/docs/Web/CSS). 
> 
> _-fons_
"""

# ╔═╡ d70a3a02-ef3a-450f-bf5a-4a0d7f6262e2
TableOfContents()

# ╔═╡ 10cf6ed1-8276-4a4a-ad06-097d10335512
md"""
# Essentials

## Using HTML, CSS and JavaScript

To use web languages inside Pluto, we recommend the small package [`HypertextLiteral.jl`](https://github.com/MechanicalRabbit/HypertextLiteral.jl), which provides an `@htl` macro.

You wrap `@htl` around a string expression to mark it as an *HTML literal*, as we did in the example cell from earlier. When a cell outputs an HTML-showable object, it is rendered directly in your browser.
"""

# ╔═╡ d967cdf9-3df9-40bb-9b08-09cae95a5ca7
@htl(" <b> Hello! </b> ")

# ╔═╡ 858745a9-cd59-43a6-a296-803515518e57
md"""
### CSS and JavaScript

You can use CSS and JavaScript by including it inside HTML, just like you do when writing a web page.

For example, here we use `<script>` to include some JavaScript, and `<style>` to include CSS.
"""

# ╔═╡ 21a9e3e6-92f4-475d-9c8e-21e15c09336b
@htl("""

<div class='blue-background'>
Hello!
</div>

<script>
// more about selecting elements later!
currentScript.previousElementSibling.innerText = "Hello from JavaScript!"

</script>

<style>
.blue-background {
	padding: .5em;
	background: lightblue;
	color: black;
}
</style>

""")

# ╔═╡ 4a3398be-ee86-45f3-ac8b-f627a38c00b8
md"""
## Interpolation

Julia has a nice feature: _string interpolation_:
"""

# ╔═╡ 2d5fd611-284b-4428-b6a5-8909203990b9
who = "🌍"

# ╔═╡ 82de4674-9ecc-46c4-8a57-0b4453c579c3
"Hello $(who)!"

# ╔═╡ 70a415be-881a-4c01-9f8c-635b8b89e1ad
md"""
With some (frustrating) exceptions, you can also interpolate into Markdown literals:
"""

# ╔═╡ 730a692f-2bf2-4d5b-86da-6ab861e8b8ac
md"""
Hello $(who)!
"""

# ╔═╡ a45fdec4-2d4b-429b-b809-4c256b57fffe
md"""
**However**, you cannot interpolate into an `html"` string:
"""

# ╔═╡ c68ebd7b-5fb6-4527-ac34-33f9730e4587
html"""
<p>Hello $(who)!</p>
"""

# ╔═╡ 8c03139f-a94b-40cc-859f-0d86f1c72143
md"""

😢 Luckily we can perform these kinds of interpolations (and much more) with the `@htl` macro, as we will see next.


### Interpolating into HTML -- HypertextLiteral.jl
"""

# ╔═╡ d8dcb044-0ac8-46d1-a043-1073bb6d1ff1
@htl("""
	<p> Hello $(who)!</p>
	""")

# ╔═╡ e7d3db79-8253-4cbd-9832-5afb7dff0abf
cool_features = [
	md"Interpolate any **HTML-showable object**, such as plots and images, or another `@htl` literal."
	md"Interpolated lists are expanded _(like in this cell!)_."
	"Easy syntax for CSS"
	]

# ╔═╡ bf592202-a9a4-4e9b-8433-fed55e3aa3bc
@htl("""
	<p>It has a bunch of very cool features! Including:</p>
	<ul>$([
		@htl(
			"<li>$(item)</li>"
		)
		for item in cool_features
	])</ul>
	""")

# ╔═╡ 5ac5b984-8c02-4b8d-a342-d0f05f7909ec
md"""
#### Why not just `HTML(...)`?

You might be thinking, why don't we just use the `HTML` function, together with string interpolation? The main problem is correctly handling HTML _escaping rules_. For example:
"""

# ╔═╡ ef28eb8d-ec98-43e5-9012-3338c3b84f1b
cool_elements = "<div> and <marquee>"

# ╔═╡ 1ba370cc-3631-47ea-9db5-75587e8e4ff3
HTML("""
<h6> My favourite HTML elements are $(cool_elements)!</h6>
""")

# ╔═╡ 7fcf2f3f-d902-4338-adf0-8ef181e79420
@htl("""
<h6> My favourite HTML elements are $(cool_elements)!</h6>
""")

# ╔═╡ 965f3660-6ec4-4a86-a2a2-c167dbe9315f
md"""
**Let's look at a more exciting example:**
"""

# ╔═╡ 00d97588-d591-4dad-9f7d-223c237deefd
@bind fantastic_x Slider(0:400)

# ╔═╡ 01ce31a9-6856-4ee7-8bce-7ce635167457
my_data = [
	(name="Cool", coordinate=[100, 100]),
	(name="Awesome", coordinate=[200, 100]),
	(name="Fantastic!", coordinate=[fantastic_x, 150]),
]

# ╔═╡ 21f57310-9ceb-423c-a9ce-5beb1060a5a3
@htl("""
	<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

	<script>

	// interpolate the data 🐸
	const data = $(my_data)

	const svg = DOM.svg(600,200)
	const s = d3.select(svg)

	s.selectAll("text")
		.data(data)
		.join("text")
		.attr("x", d => d.coordinate[0])
		.attr("y", d => d.coordinate[1])
		.style("fill", "red")
		.text(d => d.name)

	return svg
	</script>
""")

# ╔═╡ 88120468-a43d-4d58-ac04-9cc7c86ca179
md"""
## Debugging

The HTML, CSS and JavaScript that you write run in the browser, so you should use the [browser's built-in developer tools](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/What_are_browser_developer_tools) to debug your code. 
"""

# ╔═╡ ea4b2da1-4c83-4a1f-8fc3-c71a120e58e1
@htl("""

<script>

console.info("Can you find this message in the console?")

</script>

""")

# ╔═╡ 08bdeaff-5bfb-49ab-b4cc-3a3446c63edc
@htl("""
	<style>
	.cool-class {
		font-size: 1.3rem;
		color: purple;
		background: lightBlue;
		padding: 1rem;
		border-radius: 1rem;
	}
	
	
	</style>
	
	<div class="cool-class">Can you find out which CSS class this is?</div>
	""")

# ╔═╡ da7091f5-8ba2-498b-aa8d-bbf3b4505b81
md"""
# Appendix
"""

# ╔═╡ 64cbf19c-a4e3-4cdb-b4ec-1fbe24be55ad
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ 93abe0dc-f041-475f-9ef7-d8ee4408414b
details(md"""
	```htmlmixed
	
	<article class="learning">
		<h4>
			Learning HTML and CSS
		</h4>
		<p>
			It is easy to learn HTML and CSS because they are not 'programming languages' like Julia and JavaScript, they are <em>markup languages</em>: there are no loops, functions or arrays, you only <em>declare</em> how your document is structured (HTML) and what that structure looks like on a 2D color display (CSS).
		</p>
		<p>
			As an example, this is what this cell looks like, written in HTML and CSS:
		</p>
	</article>


	<style>

		article.learning {
			background: #fde6ea4c;
			padding: 1em;
			border-radius: 5px;
		}

		article.learning h4::before {
			content: "☝️";
		}

		article.learning p::first-letter {
			font-size: 1.5em;
			font-family: cursive;
		}

	</style>
	```
	""", "Show with syntax highlighting")

# ╔═╡ 94561cb1-2325-49b6-8b22-943923fdd91b
details(md"""
	```htmlmixed
	<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

	<script>

	// interpolate the data 🐸
	const data = $(my_data)

	const svg = DOM.svg(600,200)
	const s = d3.select(svg)

	s.selectAll("text")
		.data(data)
		.join("text")
		.attr("x", d => d.coordinate[0])
		.attr("y", d => d.coordinate[1])
		.style("fill", "red")
		.text(d => d.name)

	return svg
	</script>
	```
	""", "Show with syntax highlighting")

# ╔═╡ cc318a19-316f-4fd9-8436-fb1d42f888a3
demo_img = let
	url = "https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg"
	data = read(download(url))
	PlutoUI.Show(MIME"image/jpg"(), data)
end

# ╔═╡ 7aacdd8c-1571-4461-ba6e-0fd65dd8d788
demo_html = @htl("<b style='font-family: cursive;'>Hello!</b>")

# ╔═╡ 71a300bd-9ff3-41f6-9156-53670e8db67f
u"tbsp"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
HypertextLiteral = "~0.9.3"
PlutoUI = "~0.7.34"
Unitful = "~1.14.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─97914842-76d2-11eb-0c48-a7eedca870fb
# ╠═571613a1-6b4b-496d-9a68-aac3f6a83a4b
# ╟─f93c7f38-10e9-46de-af22-39e752d098f1
# ╟─cb2faea5-a171-4c5b-b760-5218a088422c
# ╟─aebe6a1e-afa1-4bb0-b6a1-4fdcb0b1a910
# ╟─8d8daf00-6c3f-4903-a3d8-97604f7e5ece
# ╟─85a9dc12-bd5c-49e4-8ea3-89a32d2fd40b
# ╟─d279ace8-e561-4a0a-a2dd-d587bd35af0d
# ╟─8574aa05-62fb-4c87-9b3f-5735beeecbf0
# ╠═9a415a57-3d39-403f-96f7-878a0b14957f
# ╟─5728748c-249b-49ad-ab5c-bf6ed75ed131
# ╟─991c5bfb-a430-473c-8da2-3a453fff8f53
# ╠═94e5ce3e-859a-42a7-b932-71efcdf44d16
# ╟─9efbabab-88e0-4fbe-8ed6-b30edae6c277
# ╠═a2c6cd2b-7251-4e5b-a36d-a8e4a7e605fe
# ╠═c1d5fec8-1dae-4fd6-808b-41a3623bfb28
# ╟─b3a2498f-25bb-4472-bae0-e354dbb3c6b8
# ╟─ed07848c-411e-4899-941e-ecf87cded5ab
# ╟─20aaa738-f431-43f5-bc48-46aa39419bb5
# ╟─91325d20-6e77-464c-94a9-37648a733700
# ╟─52ed865b-8180-4edc-b4e2-1db15d82cfed
# ╠═f618f971-5d3d-47d4-8ab3-5239553b2aa4
# ╟─168e13f7-2ff2-4207-be56-e57755041d36
# ╠═28ae1424-67dc-4b76-a172-1185cc76cb59
# ╟─93abe0dc-f041-475f-9ef7-d8ee4408414b
# ╟─ea39c63f-7466-4015-a66c-08bd9c716343
# ╟─d70a3a02-ef3a-450f-bf5a-4a0d7f6262e2
# ╟─10cf6ed1-8276-4a4a-ad06-097d10335512
# ╠═d967cdf9-3df9-40bb-9b08-09cae95a5ca7
# ╟─858745a9-cd59-43a6-a296-803515518e57
# ╠═21a9e3e6-92f4-475d-9c8e-21e15c09336b
# ╟─4a3398be-ee86-45f3-ac8b-f627a38c00b8
# ╠═2d5fd611-284b-4428-b6a5-8909203990b9
# ╠═82de4674-9ecc-46c4-8a57-0b4453c579c3
# ╟─70a415be-881a-4c01-9f8c-635b8b89e1ad
# ╠═730a692f-2bf2-4d5b-86da-6ab861e8b8ac
# ╟─a45fdec4-2d4b-429b-b809-4c256b57fffe
# ╠═c68ebd7b-5fb6-4527-ac34-33f9730e4587
# ╟─8c03139f-a94b-40cc-859f-0d86f1c72143
# ╠═d8dcb044-0ac8-46d1-a043-1073bb6d1ff1
# ╠═bf592202-a9a4-4e9b-8433-fed55e3aa3bc
# ╟─e7d3db79-8253-4cbd-9832-5afb7dff0abf
# ╟─5ac5b984-8c02-4b8d-a342-d0f05f7909ec
# ╠═ef28eb8d-ec98-43e5-9012-3338c3b84f1b
# ╠═1ba370cc-3631-47ea-9db5-75587e8e4ff3
# ╠═7fcf2f3f-d902-4338-adf0-8ef181e79420
# ╟─965f3660-6ec4-4a86-a2a2-c167dbe9315f
# ╠═01ce31a9-6856-4ee7-8bce-7ce635167457
# ╠═00d97588-d591-4dad-9f7d-223c237deefd
# ╠═21f57310-9ceb-423c-a9ce-5beb1060a5a3
# ╟─94561cb1-2325-49b6-8b22-943923fdd91b
# ╟─88120468-a43d-4d58-ac04-9cc7c86ca179
# ╠═ea4b2da1-4c83-4a1f-8fc3-c71a120e58e1
# ╟─08bdeaff-5bfb-49ab-b4cc-3a3446c63edc
# ╟─da7091f5-8ba2-498b-aa8d-bbf3b4505b81
# ╠═64cbf19c-a4e3-4cdb-b4ec-1fbe24be55ad
# ╟─cc318a19-316f-4fd9-8436-fb1d42f888a3
# ╟─7aacdd8c-1571-4461-ba6e-0fd65dd8d788
# ╠═dbb6824b-86b6-489c-b8c8-89100482e742
# ╠═71a300bd-9ff3-41f6-9156-53670e8db67f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
