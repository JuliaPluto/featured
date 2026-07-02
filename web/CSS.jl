### A Pluto.jl notebook ###
# v0.20.27

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/main/LICENSES/Unlicense"
#> image = "https://github.com/JuliaPluto/featured/assets/43678097/ebcd0d6c-fa37-4d2b-8d82-6814854f726b"
#> order = "2"
#> title = "Styling with CSS"
#> tags = ["web", "css"]
#> license = "Unlicense"
#> description = "Learn how to use CSS to give a unique style to your notebooks!"
#> 
#>     [[frontmatter.author]]
#>     name = "Pluto.jl"
#>     url = "https://github.com/JuliaPluto"

using Markdown
using InteractiveUtils

# ╔═╡ 9e7188e0-9e7f-11ee-1fef-b56479103e4a
md"""
# Styling notebooks with CSS

Are you looking bring your notebook presentation to the next level? Do you want to change the way Pluto looks for you? Do you want special formatting for your cell output?

This is the notebook for you! We'll talk about how to style the notebook page using CSS. Let's get started!
"""

# ╔═╡ 01455807-c26e-478b-a871-f2b28526b5d9
md"""
## What is CSS?

CSS stands for _cascading style sheets_ and it's the language we use to describe what web content should look like.

A typical web page is written in HTML. HTML is essentially text with tags, which your browser is able to make sense of. For example:
"""

# ╔═╡ 0bbfdbd5-91cd-4faf-98ef-ed2401c7de15
html"""
<p>I like <i>apples</i>... </p>
<p>but I don't like <b>oranges</b>.</p>
"""

# ╔═╡ df764c10-adc0-4552-b1cf-a77afb9fbe27
md"""
In this case, `<p>`, `<i>`, and `<b>` are tags. When your browser displays this text, it understands that when you use the `<i>` tag, it should be displayed in a particular way - in this case, by writing the text in italics.
"""

# ╔═╡ 4812a04f-0e9f-484f-9253-cef3b3667a23
md"""
A CSS stylesheet is what we use to control exactly what each element should look like.

It lists _selectors_ for elements in the HTML content and then describes the desired look of those elements.

Here is an example. We have some text:
"""

# ╔═╡ d6c7985c-ff4b-4799-951f-093bfe920f98
html"""
I don't like <span id="orange">oranges</span>!
"""

# ╔═╡ 30e31be7-8aa1-4a00-913d-7af3388d71b2
md"""
And here is a stylesheet:
"""

# ╔═╡ e70d7a55-7eff-4c29-9af2-3288d99fb37c
html"""
<style>
	#orange {
		color: orange;
	}
</style>
"""

# ╔═╡ cdf0c733-bbf0-4e2f-832b-19e13e7fe561
md"""
What's happening here?

- Our first cell contains the tag `<span>`. A span is a _generic_ element that just tags a selection of text. It doesn't really do anything.
- The span tag includes another attribute: `id="orange"`. That's a way of giving a unique name to this element.
- We then write some style rules in a `<style>` tag. We added a rule with the _selector_ `#orange`. That means we want to select elements that have `orange` as their ID.
- The content of our rule, between the `{}`, describes what the selected element should look like. In this case, we say it should be written in orange.
"""

# ╔═╡ 0742d69f-246c-4c69-ae48-e80fc4ed3cf5
md"""
### Exercise: do it yourself

👉 **Your turn!** The cell below should be a demonstration of different things you can do with CSS, but the rules are all mixed up! Update the stylesheet so each rule is applied to the right selector.
"""

# ╔═╡ e6f1b9dc-8243-4d11-bd21-aa37396cb1e7
html"""
We can use also CSS to <span id="section-1">underline</span> text, or to make it very <span id="section-2">small</span> or <span id="section-3">big</span>. Or you can write text in <span id="section-4">all caps</span>. And you can change both the <span id="section-5">text colour</span> and <span id="section-6">background colour</span>.

<style>
	#section-1 {
		text-decoration: underline;
	}

	#section-2 {
		background-color: rgba(255, 0, 0, 0.3);
	}

	#section-3 {
		color: red;
	}

	#section-4 {
		font-size: x-large;
	}

	#section-5 {
		font-size: x-small;
	}

	#section-6 {
		text-transform: uppercase;
	}
</style>
"""

# ╔═╡ 6d224e02-a713-41df-a11c-80f39b7a90f8
md"""
## CSS selectors

So far we've used the `id` of elements to describe what they should look like. That's a fine way to do things if we want to style a specific element, like the output of a single cell.

But a lot of the time, we want to write more _general_ rules that describe the overall layout of the page, like "every code cell should have a blue background" or "images should have a margin of 100 pixels".

Luckily, CSS selectors can do a lot more than selecting elements by their ID. Let's go over the fundamentals.
"""

# ╔═╡ 4a0aaf47-3685-4b01-bd57-f1ea0a09d01a
html"""
We've already seen one type of selector: <span id="special-element">selecting the id of the element</span>.

<style>
	/* hashtag for ID selection */
	#special-element {
		text-decoration: underline wavy;
	}
</style>
"""

# ╔═╡ 8c0bd2dd-f819-4f77-ba27-23119a216636
html"""
You can also select the <special-element>name of the tag</special-element>. This is useful for very generic selectors, like "any paragraph".

<style>
	/* no special character for the tag name */
	special-element {
		text-decoration: underline wavy;
	}
</style>
"""

# ╔═╡ b6279fae-90fc-430f-bcb6-1d79f0e98fba
html"""
<p>
	Sometimes we want something a bit more fine-tuned than the element type: not all paragraphs, but some of them. We can't use IDs here: those are meant to be unique.
</p>

<p>
	In this case, we usually use the <code>class</code> attribute. That's a way of saying a bunch of elements belong to a particular category. Then you can <span class="special-element">select elements of a class</span>.
</p>

<style>
	/* use a dot for class names */
	.special-element {
		text-decoration: underline wavy;
	}
</style>
"""

# ╔═╡ 18613f4c-7beb-4051-ab75-1c3db8c4c97a
md"""
Alright, so we can select by the element type, the unique ID of the element, or the class name we assign to the element. We can also combine selectors!
"""

# ╔═╡ 8f553705-9f6f-4b0e-babc-1170cede56e6
html"""
<p class="example" id="example-1">
	This is the <span class="number">first</span> example.
</p>
<p class="example special" id="example-2">
	This is the <span class="number">second</span example.
</p>
<p class="example special" id="example-3">
	This is the <span class="number">third</span example.
</p>

<style>
	/* combine selectors to match all of them on the same element */

	p.example#example-1 {
		font-style: italic;
	}

	p.example.special {
		font-size: x-large;
	}

	/* chain selectors with a space to match "a within b" */
	/* in this case: an element with class "number" inside an element
	with ID "example-2" */

	#example-2 .number {
		font-weight: bold;
	}

	/* or wrap one rule in another */

	#example-3 {
		.number {
			text-decoration: underline;
		}
	}
</style>
"""

# ╔═╡ 89f79aa7-bcea-43a7-9596-ec347d67e03b
md"""
There is a lot more that you can do with CSS selectors, but this is already very powerful, and it should be enough to get you underway!
"""

# ╔═╡ 2c867409-ed53-42db-960d-27d3a25ab1b7
md"""
### Exercise: CSS selectors

👉 **Your turn!** Match up the colours with the story!
"""

# ╔═╡ 7af3994f-b0a1-40c1-9c64-f401a58bbfc7
html"""
<div id="exercise-text">
	<p id="1">
		I have a red <span class="vehicle">bike</span> but my <span class="apparel"> shoes</span> are green.
	</p>
	<p id="2">
		Yesterday a blue <span class="vehicle">car</span> drove by and splashed brown <span id="mud">mud</span> all over my <span class="apparel">shoes</span>.
	</p>
	<p class="conclusion">
		Luckily, my new purple <span class="apparel">coat</span> was still clean! I hopped on my <span class="vehicle">bike</span> and went to the shoe cleaner.
	</p>
</div>

<style>
	/* your code here... 


	For example, start out with a rule like:
	
	.vehicle {
		color: red;
	}

	*/
</style>
"""

# ╔═╡ fbf50d51-ba14-4f51-8820-aa1df38fb606
md"""
### Learn more about CSS

If this was all new to you so far, there is a lot more you can do with CSS - much more than we can cover in this notebook.

Luckily, CSS is widely used to there are plenty of tutorials available. I frequently use [MDN's CSS guide and reference](https://developer.mozilla.org/en-US/docs/Web/CSS)!
"""

# ╔═╡ c211b0c4-3801-4a49-ab78-692420240129
md"""
## Styling Pluto

Okay, we've gone over the basics of CSS and we've done some styling. How do we go about styling notebooks?

There are two things you may want to use CSS for: styling the output of specific cells, or styling the whole notebook page.
"""

# ╔═╡ dd8f6a67-3a00-4ca8-aaf4-c8d2a320dda0
md"""
### Selection scope

When you create a `<style>` declaration, it just applies to the entire page. For instance, try uncommenting the `color: red` rule here (remove the `/**/` marks). It will apply to all paragraphs in the notebook!
"""

# ╔═╡ ad900671-1662-415e-a1a2-48fcef3df6e2
html"""
<style>
	p {
		/*color: red;*/
	}
</style>
"""

# ╔═╡ db10ee0f-065e-4207-a20b-37ae17d8bbfe
md"""
With that in mind, let's look at our two uses for styling.
"""

# ╔═╡ 9483d382-1586-4668-8c1d-89d4afc46fa2
md"""
### Styling specific cells

If you want to add some styling to the output of specific styles, it's good to avoid statements that can accidentally affect the whole page.

A good way to do this is to wrap your cell in a tag with a `class` or `id`. Then when you write rules for that cell, write all your rules within that class or ID.
"""

# ╔═╡ 063a220c-58fb-4113-8f14-a2b4fe0c5791
html"""
<div class="special-cell-output">
	This cell has <span class="highlight">special formatting.</span>
</div>
"""

# ╔═╡ 0d4dac94-3b71-4cb0-be7d-52fe63878a2f
html"""
<div class="special-cell-output">
	So does <span class="highlight">this one!</span>
</div>
"""

# ╔═╡ 3f457aad-ffe9-4453-b11b-2e74e7bb45a1
html"""
But this is just a <span class="highlight">plain-looking cell!</span>
"""

# ╔═╡ 7d989347-3aa1-4bc7-8202-d2590bfd2a4e
html"""
<style>
	.special-cell-output {
		font-weight: bold;
		
		.highlight {
			background-color: rgba(255, 230, 0, 0.5);
			padding: 1px;
			border-radius: 2px;
			color: black;
		}
	}
</style>
"""

# ╔═╡ 0edc1d57-baff-4372-94bb-55cea542ebbc
md"""
!!! info "What's a div?"

	We used `<div>` as the top-level tag in these examples. `<div>` stands for division: it's a generic element meant to divide the content of a page into parts without really saying anything else about what those parts are for - it's a suitable generic wrapper for cell output.
"""

# ╔═╡ 00398409-91c3-4bec-8f80-d53d71c33bdd
md"""
If the style is supposed to apply to a single cell, it often makes sense to write it in there, like we've seen in this notebook a few times. But doing so won't restrict the styling to that cell: you should still use a selector.
"""

# ╔═╡ d1e9080c-e998-43a0-8f57-759c24b3207a
html"""
<div id="very-special-cell">
	<p>This cell has its own styling!</p>
</div>

<style>
	#very-special-cell {
		p {
			text-align: end;
		}
	}
</style>
"""

# ╔═╡ a08b40ea-9d80-4552-83bc-50d0c1bdaa13
md"""
## Styling Pluto

What if we _don't_ want to style specific cells?

Sometimes it's useful to style the entire page. For instance, you could change the layout of a notebook for a presentation to show bigger text or hide the live docs. Or maybe you just have a personal preference to show all text in purple!

We've already seen that `<style>` elements can modify anything on the page. If we want to style Pluto, though, we need to know how to select specific elements.

If you're not familiar with [browser developer tools](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Tools_and_setup/What_are_browser_developer_tools), those are going to be a huge help with this. You can use the developer tools to inspect elements and see the element and class names that Pluto uses.

For example, here we can set the header background colour of the "help" menu:
"""

# ╔═╡ 838600d7-1965-445d-ab79-cc81866eca24
html"""
<style>
	pluto-helpbox header {
		/* uncomment the line below to see the effect! */
		/* background-color: red; */
	}
</style>
"""

# ╔═╡ d9ac05cc-3c54-46fc-bf28-ad38418fe413
md"""
Keep in mind that Pluto doesn't guarantee a stable API for styling. That is to say, new versions of Pluto might change class names or element names, or just slightly restyle the page in a way that messes up your own styling rules.

That said, Pluto has been around for a while, so you can expect it to be reasonably stable.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.5"
manifest_format = "2.0"
project_hash = "71853c6197a6a7f222db0f1978c7cb232b87c5ee"

[deps]
"""

# ╔═╡ Cell order:
# ╟─9e7188e0-9e7f-11ee-1fef-b56479103e4a
# ╟─01455807-c26e-478b-a871-f2b28526b5d9
# ╠═0bbfdbd5-91cd-4faf-98ef-ed2401c7de15
# ╟─df764c10-adc0-4552-b1cf-a77afb9fbe27
# ╟─4812a04f-0e9f-484f-9253-cef3b3667a23
# ╠═d6c7985c-ff4b-4799-951f-093bfe920f98
# ╟─30e31be7-8aa1-4a00-913d-7af3388d71b2
# ╠═e70d7a55-7eff-4c29-9af2-3288d99fb37c
# ╟─cdf0c733-bbf0-4e2f-832b-19e13e7fe561
# ╟─0742d69f-246c-4c69-ae48-e80fc4ed3cf5
# ╠═e6f1b9dc-8243-4d11-bd21-aa37396cb1e7
# ╟─6d224e02-a713-41df-a11c-80f39b7a90f8
# ╠═4a0aaf47-3685-4b01-bd57-f1ea0a09d01a
# ╠═8c0bd2dd-f819-4f77-ba27-23119a216636
# ╠═b6279fae-90fc-430f-bcb6-1d79f0e98fba
# ╟─18613f4c-7beb-4051-ab75-1c3db8c4c97a
# ╠═8f553705-9f6f-4b0e-babc-1170cede56e6
# ╟─89f79aa7-bcea-43a7-9596-ec347d67e03b
# ╟─2c867409-ed53-42db-960d-27d3a25ab1b7
# ╠═7af3994f-b0a1-40c1-9c64-f401a58bbfc7
# ╟─fbf50d51-ba14-4f51-8820-aa1df38fb606
# ╟─c211b0c4-3801-4a49-ab78-692420240129
# ╟─dd8f6a67-3a00-4ca8-aaf4-c8d2a320dda0
# ╠═ad900671-1662-415e-a1a2-48fcef3df6e2
# ╟─db10ee0f-065e-4207-a20b-37ae17d8bbfe
# ╟─9483d382-1586-4668-8c1d-89d4afc46fa2
# ╠═063a220c-58fb-4113-8f14-a2b4fe0c5791
# ╠═0d4dac94-3b71-4cb0-be7d-52fe63878a2f
# ╠═3f457aad-ffe9-4453-b11b-2e74e7bb45a1
# ╠═7d989347-3aa1-4bc7-8202-d2590bfd2a4e
# ╟─0edc1d57-baff-4372-94bb-55cea542ebbc
# ╟─00398409-91c3-4bec-8f80-d53d71c33bdd
# ╠═d1e9080c-e998-43a0-8f57-759c24b3207a
# ╟─a08b40ea-9d80-4552-83bc-50d0c1bdaa13
# ╠═838600d7-1965-445d-ab79-cc81866eca24
# ╟─d9ac05cc-3c54-46fc-bf28-ad38418fe413
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
