### A Pluto.jl notebook ###
# v0.19.32

#> [frontmatter]
#> title = "Dark or light mode?"
#> license = "Unlicense"
#> description = "Check whether a notebook is displayed in dark mode!"
#> 
#>     [[frontmatter.author]]
#>     name = "Pluto.jl"
#>     url = "https://github.com/JuliaPluto"

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

# ╔═╡ 15547e00-9164-11ee-2efe-852f113ce155
md"""
# Dark or light mode?

Did you know Pluto has a **dark and a light mode**? 🌑🌕 Which one you see is selected automatically by your system / browser settings.

The nice thing about this is that you can send your notebooks to anyone, and they'll be seeing the colour scheme that they prefer (or at least the one that their browser thinks they prefer). Neat!

On the other hand, when we're making visuals, it can be an issue if we don't know whether our audience is going to be viewing it in dark mode or light mode. If you've ever wanted to **make your visuals adapt to light/dark mode**, this notebook is about that!
""" 

# ╔═╡ 97aae464-8e19-4264-b3e7-f302269e7bf9
md"""
!!! info "Where's the magic function?"

	This notebook tries to explain things instead of just showing you some "magic function" that detects whether you're in dark mode. If you're curious about CSS and Javascript, I hope you learn something new!

	However, if you just want a magic function that detects whether you're in dark mode, scroll down to the `dark_mode_detector()`! 😉
"""

# ╔═╡ cbaab8be-88bc-4b40-b1dc-24429c698fe1
md"""
## CSS

Let's start with CSS, since that's the easiest. Making dark and light styles is a common need on the web!

In CSS, you can use **media queries** to check some things about the device the page is displayed on, such as the screen size. One of the things you can check is [`prefers-color-scheme`](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme), which checks whether we'd want to use dark mode.

That's how Pluto detects whether to show you the dark or light version of the page, but you can use it yourself as well! Here is an example:
"""

# ╔═╡ 46e197f7-7cdf-41a6-9b28-847dce80e435
html"""
<div>
	<div id="box">I'm blue in dark mode and yellow in light mode!</div>
	
	<style>
		#box {
			margin: 1rem;
			padding: 1rem;
			border-radius: 1rem;

			@media (prefers-color-scheme: light) {
				background: #EAD270;
				color: black;
			}

			@media (prefers-color-scheme: dark) {
				background: #1739C4;
				color: white;
			}
		}
		

	</style>
</div>
"""

# ╔═╡ be72c582-4286-4d1b-9de4-ae9bff780f97
md"""
This is very useful if you're adding your own styles to your notebooks!
"""

# ╔═╡ fd068840-a21e-497f-a436-a7ccde22617c
md"""
## Javascript

While it's generally the most useful to query colour scheme preference in CSS, you can also make those queries in javascript. (This will turn out to  be useful later...)

We can use [`matchMedia()`](https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList) to make queries. Here is the simplest example:
"""

# ╔═╡ cbc8531a-60f8-42ee-bb5c-279b230fab85
html"""
<div>
	<p></p>

	<script>
		const p = currentScript.parentElement.querySelector("p");
		const query = window.matchMedia("(prefers-color-scheme: dark)");

		if (query.matches) {
			p.innerText = "This page is in dark mode!";
		} else {
			p.innerText = "This page is in light mode!";
		}
	</script>
</div>
"""

# ╔═╡ e5a66db1-97ff-45ed-8c3b-d8354346182c
md"""
!!! tip "Media queries"

	[Media queries](https://developer.mozilla.org/en-US/docs/Web/CSS/@media) can be use for other things, too! For example, if you want to distinguish between the web view and the PDF export, you can use a `screen` or `print` query!
"""

# ╔═╡ 282364ce-7512-489c-a397-9a3446edb7eb
md"""
### For the perfectionists: event listeners

If you've been switching between light and dark mode in this page, you may have noticed that the text in the example above doesn't change when you switch. We're only checking the result of the media query when the cell is run.

That's usually fine for a notebook, but if you want, you can add an event listener so it will update when you adjust your settings.
"""

# ╔═╡ 2cf359c6-503c-41fa-99c2-0945df3012ea
html"""
<div>
	<p></p>

	<script>
		const p = currentScript.parentElement.querySelector("p");
		const query = window.matchMedia("(prefers-color-scheme: dark)");

		function setText(e) {
			if (e.matches) {
				p.innerText = "This page is in dark mode!";
			} else {
				p.innerText = "This page is in light mode!";
			}
		}

		setText(query)
		query.addEventListener("change", setText);
	</script>
</div>
"""

# ╔═╡ 107ff353-7fcb-4ecf-b0ca-d4b8c3e74e8f
md"""
## Julia

Okay, now the big question: can we detect dark/light mode in our Julia script?

Not directly: most of the time, our Julia process doesn't really know or care how it's being displayed, so it doesn't have the same utility functions. The workaround is that we use the Javascript method we saw before, and use Pluto's `@bind` macro to pass on that result to Julia!

To do this, we need an HTML element that will detect colour preference, and send it as an `input` event.
"""

# ╔═╡ 0bcdad45-93cf-4817-b1cb-dfdeb1fbc996
dark_mode_detector() = html"""
<div>
	<script>
		const parent = currentScript.parentElement;
		const query = window.matchMedia("(prefers-color-scheme: dark)");

		function dispatch(e) {
			parent.value = e.matches;
			parent.dispatchEvent(new CustomEvent("input"));
		}

		dispatch(query)
		query.addEventListener("change", dispatch);
	</script>
</div>
"""

# ╔═╡ e338ded1-80f1-4c0f-bd72-95f8472470d8
md"""
Now we can use `@bind` to bind the event to a julia variable!
"""

# ╔═╡ 40f68e1f-928b-4aee-bab2-8bcf92a332a3
@bind dark_mode dark_mode_detector()

# ╔═╡ e2618b54-f13f-49a5-8bf1-f3cca86525d6
dark_mode

# ╔═╡ d5b03b17-8499-437f-bee9-c918bd0192b8
md"""
And there we have it!

Feel free to copy this function and use it in your own notebooks! (This notebook is shared under an Unlicense.) This function makes a lot of sense in combination with the `PlotThemes` package, for example. ✨
"""

# ╔═╡ Cell order:
# ╟─15547e00-9164-11ee-2efe-852f113ce155
# ╟─97aae464-8e19-4264-b3e7-f302269e7bf9
# ╟─cbaab8be-88bc-4b40-b1dc-24429c698fe1
# ╠═46e197f7-7cdf-41a6-9b28-847dce80e435
# ╟─be72c582-4286-4d1b-9de4-ae9bff780f97
# ╟─fd068840-a21e-497f-a436-a7ccde22617c
# ╠═cbc8531a-60f8-42ee-bb5c-279b230fab85
# ╟─e5a66db1-97ff-45ed-8c3b-d8354346182c
# ╟─282364ce-7512-489c-a397-9a3446edb7eb
# ╠═2cf359c6-503c-41fa-99c2-0945df3012ea
# ╟─107ff353-7fcb-4ecf-b0ca-d4b8c3e74e8f
# ╠═0bcdad45-93cf-4817-b1cb-dfdeb1fbc996
# ╟─e338ded1-80f1-4c0f-bd72-95f8472470d8
# ╠═40f68e1f-928b-4aee-bab2-8bcf92a332a3
# ╠═e2618b54-f13f-49a5-8bf1-f3cca86525d6
# ╟─d5b03b17-8499-437f-bee9-c918bd0192b8
