### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "Formatting text cells"
#> description = "Learn to format text cells with markdown"

using Markdown
using InteractiveUtils

# ╔═╡ 293f0720-72a9-11ee-243a-0dc1916d72fa
md"""
# Formatting text cells

This notebook is not about creating awesome julia code, but about creating nice-looking text blocks in-between.

*This is an explanation for beginners. If you are familiar with markdown, great! You probably won't learn anything new here.*
"""

# ╔═╡ 40d0c7e8-79d8-4911-b095-de0d545a47d0
md"""
## The basics: markdown formatting

The typical way to include text blocks in notebooks is using _markdown_. This is a simple way of describing how your text should be formatted.

For example, if you write a markdown text, you can type `a *big* tree` and that means `big` should be in italics: a *big* tree.

The easiest way to write a text cell with markdown is to press `ctrl/cmd + M` in a code cell. Then type whatever text you want to show.

Try it! Press `ctrl/cmd + M` in this cell and type a message. Then run the cell.
"""

# ╔═╡ 79248697-1769-4e6e-9217-14466e8a78b4


# ╔═╡ 9a7e812e-f6bd-47b8-ac36-124a2a233354
md"""
If you are just writing some descriptions between your code, you usually don't want to display the code beneath it. You can *hide the code* of the cell. (Button to the left of the cell.)

That's how all the text cells in this notebook are made! You can show the code on any of them to see how they are written.
"""

# ╔═╡ af97612d-832e-431a-b096-be8d7c94228f
md"""
## Markdown syntax

We've seen one bit of markdown syntax already: a single `*` for italics. There are more! Here is a quick reference to get you started:
"""

# ╔═╡ 99f3bca7-5314-4e86-8f28-bb5a6358bdbd
md"""
Text in *italics* or **bold**
"""

# ╔═╡ cd5b10ac-0618-4220-b7e3-b1beeea43eff
md"""
Headers:

# Biggest header
## Big header
### Medium header
#### Small header
##### Smaller header
"""

# ╔═╡ 8b622d0d-def6-4a2c-af3b-fdf91240fb90
md"""
Bullet points:

- something
- something else
"""

# ╔═╡ 5a399dae-5756-4614-a64f-214e812ee069
md"""
Numbered lists:

1. First item
2. Second item
"""

# ╔═╡ cca6c895-7974-4c3e-9170-ed85ae127478
md"""
If you're familiar with writing LaTeX formulas, you can do that too: ``i = \sqrt{-1}``.
"""

# ╔═╡ 65b31de3-fe0b-4e2a-97ad-39e4cd17962f
md"""
Text blocks are often describing code, so it's important that we can write code neatly!

You can use `ticks` when you want to talk about variables or expressions.
"""

# ╔═╡ 3b8ae605-025f-485e-a5a2-1f823319a67a
md"""
For longer pieces of code, you can use three ticks:

```
x = 1
```

If you're writing code in a specific language, you can also specify it to get nice formatting:

```julia
function square(x)
	x^2
end
```

Neat!
"""

# ╔═╡ 6e315f3b-1a46-483e-86bc-931023a8ac54
md"""
You can add links like so: [read about Julia on Wikipedia](https://en.wikipedia.org/wiki/Julia_(programming_language)) 
"""

# ╔═╡ cb3b24f4-10d1-4de9-bd82-813af622f79b
md"""
If you want to include an image from the web, it looks a lot like adding a a link. Adding a `!` at the start means that we want to *show* the image instead of linking to it.

![julia logo](https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Julia_Programming_Language_Logo.svg/1920px-Julia_Programming_Language_Logo.svg.png)

For images, the text between the `[]` is used as *alt text*: a text description that can be used when the image can't be shown. This is useful for people with impaired vision, but it's also useful if the link doesn't work.

![julia logo](https://broken.link)
"""

# ╔═╡ dd004d6c-54f6-4dd7-9aea-910adf0b22a5
md"""
What if you want to add an image that isn't on the internet? You can also link to your own filesystem:

![cute picture of my dog](C:/Users/Luka/Pictures/Hannes_playing_in_the_snow.jpg)

Oops, you probably can't see that one! That's the trouble with linking to files: it doesn't always work. There are ways around that, but if you're new to all this, linking to online images is the way to go.
"""

# ╔═╡ 5b08043c-302b-4b9b-982d-4ba1da41ff9f
md"""
Those are the basics! There is more you can do in markdown, like adding tables or footnotes: see the links at the bottom if you want to learn more.
"""

# ╔═╡ 4428fe55-7d65-487b-864b-b566e7ecee9e
md"""
## Dynamic content

Writing some text is nice, what's really neat is if the text can respond to the code. A simple way to do this is with an `if`/`else` block. Here we make a statement based on the value of `x`:
"""

# ╔═╡ 7e5644fd-75ff-4f70-9981-ddb7d9ad470c
x = 1

# ╔═╡ 445eddb1-ccee-45d9-be5b-3f5fec9e2c7a
if x > 0
	md"`x` is positive"
elseif x < 0
	md"`x` is negative"
else
	md"`x` is zero"
end

# ╔═╡ 51e38551-742c-48dd-aaea-ffe479b9621b
md"""
You can also use $ to include expressions in your text. For example, show the value of a variable:
"""

# ╔═╡ 1a2f37ec-9be2-4fd5-8f0b-b6579a241b55
md"""
The value of `x` is $(x).
"""

# ╔═╡ d2451923-6487-497c-a169-9815702c42fc
md"""
## Useful links

- [Markdown Guide](https://www.markdownguide.org/)
- [Documentation of Julia's Markdown library](https://docs.julialang.org/en/v1/stdlib/Markdown/) 

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─293f0720-72a9-11ee-243a-0dc1916d72fa
# ╟─40d0c7e8-79d8-4911-b095-de0d545a47d0
# ╠═79248697-1769-4e6e-9217-14466e8a78b4
# ╟─9a7e812e-f6bd-47b8-ac36-124a2a233354
# ╟─af97612d-832e-431a-b096-be8d7c94228f
# ╠═99f3bca7-5314-4e86-8f28-bb5a6358bdbd
# ╠═cd5b10ac-0618-4220-b7e3-b1beeea43eff
# ╠═8b622d0d-def6-4a2c-af3b-fdf91240fb90
# ╠═5a399dae-5756-4614-a64f-214e812ee069
# ╠═cca6c895-7974-4c3e-9170-ed85ae127478
# ╠═65b31de3-fe0b-4e2a-97ad-39e4cd17962f
# ╠═3b8ae605-025f-485e-a5a2-1f823319a67a
# ╠═6e315f3b-1a46-483e-86bc-931023a8ac54
# ╠═cb3b24f4-10d1-4de9-bd82-813af622f79b
# ╠═dd004d6c-54f6-4dd7-9aea-910adf0b22a5
# ╟─5b08043c-302b-4b9b-982d-4ba1da41ff9f
# ╟─4428fe55-7d65-487b-864b-b566e7ecee9e
# ╠═7e5644fd-75ff-4f70-9981-ddb7d9ad470c
# ╠═445eddb1-ccee-45d9-be5b-3f5fec9e2c7a
# ╟─51e38551-742c-48dd-aaea-ffe479b9621b
# ╠═1a2f37ec-9be2-4fd5-8f0b-b6579a241b55
# ╟─d2451923-6487-497c-a169-9815702c42fc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
