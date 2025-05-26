### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://user-images.githubusercontent.com/6933510/174067982-904951c4-4bba-42c7-a340-102ceb7e8e10.png"
#> order = "1"
#> title = "Interactivity with HTML"
#> tags = ["interactivity", "classic", "web"]
#> license = "Unlicense"
#> description = "Write your own interactive controls with HTML!"
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

# ╔═╡ 73c8532e-09a6-429b-b8f6-530c00d92428
md"""
# Interactivity with HTML

Pluto notebooks can use the `@bind` macro for interactive inputs. Neat!

If you're completely new to coding anything interactive in a web browser, the easiest way to get started is with the `PlutoUI` package in Julia. (Check out the [PlutoUI featured notebook](https://featured.plutojl.org/basic/plutoui.jl) if you'd like to learn more about that!)

If you have some experience with HTML, or if you would like to learn how to make your own interactive elements, this notebook is for you! We'll cover the basics of using `@bind` with HTML elements. Let's get started!
"""

# ╔═╡ db24490e-7eac-11ea-094e-9d3fc8f22784
md"""
## Bound variables

A basic interactive cell looks like this: we use the `@bind` macro, define a Julia variable, and add a bit of HTML code that creates an `<input>` element. The HTML element will be rendered as the cell's output.
"""

# ╔═╡ bd24d02c-7eac-11ea-14ab-95021678e71e
@bind x html"<input type=range>"

# ╔═╡ cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
md"""
That's all you need! Pluto will synchronise the value of `x` with the latest value of the HTML input. Try moving the slider! 👆
"""

# ╔═╡ cb1fd532-7eac-11ea-307c-ab16b1977819
x

# ╔═╡ 0a7018ca-2afe-42b1-850f-a649e570709f
md"""
A neat aspect of this `@bind` macro is that on the Julia side, `x` is just a normal integer:
"""

# ╔═╡ cb65a4ee-02e5-4779-8728-b994d8af645d
typeof(x)

# ╔═╡ 816ea402-7eae-11ea-2134-fb595cca3068
md"""
Not an observable, callback, or something else that you need to wrap your head around. You can use `x` like you would any other number, and Pluto's reactivity means anything depending on `x` will be updated with it. 🚀
"""

# ╔═╡ 1ebba747-47f8-4ecd-809d-359e6d803ddc
y = x^2

# ╔═╡ 5301eb68-7f14-11ea-3ff6-1f075bf73955
md"""
## Input types

You can use binds with anything that fires an [`input` event](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/input_event). For example:
"""

# ╔═╡ 4a235d55-a80f-43c7-8f13-759976d88656
@bind a html"<input type=range >"

# ╔═╡ 33b5374c-91d1-4122-82c5-f793d063ffdc
@bind b html"<input type=text >"

# ╔═╡ d38d06f2-90ce-4e5a-9218-f5a52812e4a2
@bind c html"<input type=checkbox >"

# ╔═╡ 9985a640-c1d3-48dc-b00b-d7500085a37b
@bind d html"""
<select>
	<option value='one'>First</option>
	<option value='two'>Second</option>
</select>
"""

# ╔═╡ b6501bfb-5e1d-40b9-bd16-d38085d2611d
@bind e html"<input type=color >"

# ╔═╡ f595bdb6-bd15-4c62-9de6-49f14c7d365a
@bind f html"<input type=date>"

# ╔═╡ ede8009e-7f15-11ea-192a-a5c6135a9dcf
(a, b, c, d, e, f)

# ╔═╡ c1b9fbbb-3629-4abf-b11a-b7345b01d403
md"""
## Scripting inputs with Javascript

You can also use Javascript to write more complicated inputs. 

To get started with this, add a `<script>` tag to your cell. The easiest setup is to make the script a child of the cell's root element. Then you can use `currentScript.parentElement` to select the script's parent element.

For instance, here a HTML snippet with a script added to it.
"""

# ╔═╡ 2969d603-9b6c-403e-abdc-af078c2e53f1
html"""
<div>
	Let's make something interactive here!
	
	<script>
		const div = currentScript.parentElement;
	</script>
</div>
"""

# ╔═╡ de1b9643-66fa-4918-9a93-0f340c8548ba
md"""
Now we can use the script to handle whatever interaction we want. For a simple element, let's add a button and count the number of clicks.
"""

# ╔═╡ f1f53700-099b-4653-93f1-6b39acdc4c58
html"""
<div>
	<button>Click me!</button>
	
	<script>
		const div = currentScript.parentElement;
		const button = div.querySelector("button");
		var clicks = 0;

		button.addEventListener("click", e => {
			clicks += 1;
		});
	</script>
</div>
"""

# ╔═╡ cf9d49cc-fc70-480c-9f6b-850b0ba4c01f
md"""
The script is now keeping track of clicks, but it's not sending that value anywhere.

We need to:

- Update the parent's element `value` property (this is what Pluto will be reading).
- Dispatch an `"input"` event to trigger change detection.
"""

# ╔═╡ beb9a2bd-cbf5-4679-8403-fc249191f65e
html"""
<div>
	<button>Click me!</button>
	
	<script>
		const div = currentScript.parentElement;
		const button = div.querySelector("button");
		var clicks = 0;

		function update() {
			div.value = clicks;
			div.dispatchEvent(new CustomEvent("input"));
		}
		
		button.addEventListener("click", e => {
			clicks += 1;
			update();
		});

		// fire an event with the initial value immediately
		update();
	</script>
</div>
"""

# ╔═╡ 6b9a590b-ce24-4a9a-b5b4-5b353e6ccecf
md"""
Okay, now we can use this HTML snippet with a `@bind` macro and see the result!
"""

# ╔═╡ e3eb31ae-c512-426f-915c-01144edbc90d
@bind counter html"""
<div>
	<button>Click me!</button>
	
	<script>
		const div = currentScript.parentElement;
		const button = div.querySelector("button");
		var clicks = 0;

		function update() {
			div.value = clicks;
			div.dispatchEvent(new CustomEvent("input"));
		}
		
		button.addEventListener("click", e => {
			clicks += 1;
			update();
		});

		// fire an event with the initial value immediately
		update();
	</script>
</div>
"""

# ╔═╡ 5bd8b261-a89d-46a3-bb59-c95a1801c881
counter

# ╔═╡ 7b11caf2-1fc1-4e34-8b97-eab86e3557db
md"""
!!! tip

	In this example, we immediately call `update()` and trigger an input event with the initial value. If we didn't do that, the value of `counter` would be `nothing` until the first interaction. Whether that's appropriate, depends on the interaction you want. In this case, it made sense that the counter should start at 0!
"""

# ╔═╡ c50a5e52-7c95-445c-86ee-c60104a39dbd
md"""
## Using Julia values in HTML

We've seen how you can pass on values from an interactive HTML element on to Julia, but for proper interaction, we also want to do it the other way around!

The most basic way to do this is string interpolation. In this example, you can change the value of `limit` in the code to affect the maximum value of the slider. Try it out!
"""

# ╔═╡ 2714a923-2be5-4cf9-97dd-75347968dfee
limit = 5

# ╔═╡ 1a338f77-d8f3-4569-a2d5-c174368a4761
@bind limited HTML("""
	<input type="range" min="0" max="$(limit)">
""")

# ╔═╡ f39435d3-ed67-45f1-ae56-49cf5ec69d6e
limited

# ╔═╡ e2854aa0-e3c5-423d-80d9-fc875c5dd54d
md"""
Keep in mind that changing the value of `limit` will re-evaluate the slider cell, so it will reset the value.
"""

# ╔═╡ 2cefd0de-db13-49c1-abeb-097792ef46f6
md"""
For something even fancier, you can also interpolate value in Javascript. For example, here I have adapted my counter so it won't count past `limit`:
"""

# ╔═╡ f558f689-bd7a-4c65-8b3d-b3681a4ed013
@bind limited_counter HTML("""
<div>
	<button>Click me!</button>
	
	<script>
		const div = currentScript.parentElement;
		const button = div.querySelector("button");
		const max = $limit;
		var clicks = 0;


		function update() {
			div.value = clicks;
			div.dispatchEvent(new CustomEvent("input"));
		}
		
		button.addEventListener("click", e => {
			if (clicks < max) {
				clicks += 1;
				update();
			}
		});

		// fire an event with the initial value immediately
		update();
	</script>
</div>
""")

# ╔═╡ 901c2b84-14b8-4deb-89d6-705a4972582c
limited_counter

# ╔═╡ d5b3adc5-2c99-4901-adf5-8d8579a32b51
md"""
!!! tip

	Interpolating values in Javascript is neat, but remember that we are just taking the string representation of the variable and pasting it in the javascript code. For some complex data types like dates, you will need to do a bit of conversion to turn them into proper javascript expressions.
"""

# ╔═╡ 788c0b9b-238f-4402-b24f-52648103512e
md"""
If you're looking for something more sophisticated than simple string interpolation,  check out the [HyperTextLiteral package](https://juliapluto.github.io/HypertextLiteral.jl/stable/)!
"""

# ╔═╡ bb4b557b-e4fc-45f3-9d1f-060198167bfa
md"""
## Reusing elements

Once you've written some neat interactive element, you may want to use it a few times in notebook. The easiest way is to put the HTML literal in a variable.
"""

# ╔═╡ 2d8661f1-6f78-4161-a306-982e3ddf3646
myslider = html"""<input type="range" min=50 max=100 step=5 style="width: 100%">""";

# ╔═╡ c5a5e243-39d6-43d9-8de7-887661ba99cd
@bind x1 myslider

# ╔═╡ 3b6dc6d5-ce96-40f6-97f7-511ea6d49122
@bind x2 myslider

# ╔═╡ 3297233b-9567-4d5e-8138-93ebe20fed48
x1, x2

# ╔═╡ 82c7b1ea-08c0-495f-baba-37e5497abde2
md"""
It's as simple as that!
"""

# ╔═╡ 863c5996-9892-4bfc-96ba-225fa4a2266c
md"""
!!! tip

	To avoid confusing your readers, it's a good idea to put a `;` at the end of the cell where you define the interactive element, like we did here. This way, we only show sliders that are actually bound to something.
"""

# ╔═╡ ff3abf71-cff6-459d-a622-0ec0ca8f164b
md"""
This is is how the `PlutoUI` package works - it defines HTML literals - sometimes with their own scripts.

If you've written some cool HTML inputs and you want to share them with others, you can also make a UI package! Just publish those definitions as a Julia package and you're done! ✨
"""

# ╔═╡ 582769e6-7eb1-11ea-077d-d9b4a3226aac
md"""
## Behind the scenes

If you're curious to learn a bit more about how this all works, keep reading!

### The output value

As we've mentioned, bound values are just the latest value of the input element, rather than some kind of observable.

The update mechanism is _lossy_ and _lazy_, which means that it will skip values if your code is still running - and **only send the latest value when your code is ready again**. This is important when changing a slider from `0` to `100`, for example. If it would send all intermediate values, it might take a while for your code to process everything, causing a noticeable lag.
"""

# ╔═╡ 8f829274-7eb1-11ea-3888-13c00b3ba70f
md"""### What does the macro do?

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

_If you want to learn more about using Javascript in Pluto, check out the [JavaScript sample notebook](https://featured.plutojl.org/web/javascript)!_"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─73c8532e-09a6-429b-b8f6-530c00d92428
# ╟─db24490e-7eac-11ea-094e-9d3fc8f22784
# ╠═bd24d02c-7eac-11ea-14ab-95021678e71e
# ╟─cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
# ╠═cb1fd532-7eac-11ea-307c-ab16b1977819
# ╟─0a7018ca-2afe-42b1-850f-a649e570709f
# ╠═cb65a4ee-02e5-4779-8728-b994d8af645d
# ╟─816ea402-7eae-11ea-2134-fb595cca3068
# ╠═1ebba747-47f8-4ecd-809d-359e6d803ddc
# ╟─5301eb68-7f14-11ea-3ff6-1f075bf73955
# ╠═4a235d55-a80f-43c7-8f13-759976d88656
# ╠═33b5374c-91d1-4122-82c5-f793d063ffdc
# ╠═d38d06f2-90ce-4e5a-9218-f5a52812e4a2
# ╠═9985a640-c1d3-48dc-b00b-d7500085a37b
# ╠═b6501bfb-5e1d-40b9-bd16-d38085d2611d
# ╠═f595bdb6-bd15-4c62-9de6-49f14c7d365a
# ╠═ede8009e-7f15-11ea-192a-a5c6135a9dcf
# ╟─c1b9fbbb-3629-4abf-b11a-b7345b01d403
# ╠═2969d603-9b6c-403e-abdc-af078c2e53f1
# ╟─de1b9643-66fa-4918-9a93-0f340c8548ba
# ╠═f1f53700-099b-4653-93f1-6b39acdc4c58
# ╟─cf9d49cc-fc70-480c-9f6b-850b0ba4c01f
# ╠═beb9a2bd-cbf5-4679-8403-fc249191f65e
# ╟─6b9a590b-ce24-4a9a-b5b4-5b353e6ccecf
# ╠═e3eb31ae-c512-426f-915c-01144edbc90d
# ╠═5bd8b261-a89d-46a3-bb59-c95a1801c881
# ╟─7b11caf2-1fc1-4e34-8b97-eab86e3557db
# ╟─c50a5e52-7c95-445c-86ee-c60104a39dbd
# ╠═2714a923-2be5-4cf9-97dd-75347968dfee
# ╠═1a338f77-d8f3-4569-a2d5-c174368a4761
# ╠═f39435d3-ed67-45f1-ae56-49cf5ec69d6e
# ╟─e2854aa0-e3c5-423d-80d9-fc875c5dd54d
# ╟─2cefd0de-db13-49c1-abeb-097792ef46f6
# ╠═f558f689-bd7a-4c65-8b3d-b3681a4ed013
# ╠═901c2b84-14b8-4deb-89d6-705a4972582c
# ╟─d5b3adc5-2c99-4901-adf5-8d8579a32b51
# ╟─788c0b9b-238f-4402-b24f-52648103512e
# ╟─bb4b557b-e4fc-45f3-9d1f-060198167bfa
# ╠═2d8661f1-6f78-4161-a306-982e3ddf3646
# ╠═c5a5e243-39d6-43d9-8de7-887661ba99cd
# ╠═3b6dc6d5-ce96-40f6-97f7-511ea6d49122
# ╠═3297233b-9567-4d5e-8138-93ebe20fed48
# ╟─82c7b1ea-08c0-495f-baba-37e5497abde2
# ╟─863c5996-9892-4bfc-96ba-225fa4a2266c
# ╟─ff3abf71-cff6-459d-a622-0ec0ca8f164b
# ╟─582769e6-7eb1-11ea-077d-d9b4a3226aac
# ╟─8f829274-7eb1-11ea-3888-13c00b3ba70f
# ╟─ced18648-7eb2-11ea-2052-07795685f0da
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
