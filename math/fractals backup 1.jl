### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/user-attachments/assets/3e16917b-625b-41af-a8c2-727078a2afef"
#> title = "Fractals and Fractal Art"
#> date = "2024-10-24"
#> tags = ["fractals", "math", "julia", "art"]
#> description = "Math + fractals, generate your own fractal art!"
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

# ╔═╡ 2e3a7a3a-2fa7-11ef-1b80-d793aa08ee42
using PlutoUI, PlutoTeachingTools, PlutoImageCoordinatePicker

# ╔═╡ 9f0f999c-4c4f-40a9-83b9-08b5b1cffa80
using ImageShow, ImageIO, Colors

# ╔═╡ 98bca732-c2c6-4a79-b57b-f3d10a7d5845
md" # Fractals: A Mathematical Concept 

Hey there 👋 Do you remember the first time you ever saw a snowflake? ❄️ 

Did you also know that if you zoom into a snowflake, you will see the same shape over and over again, no matter how deep you zoom in."

# ╔═╡ 60ee1932-63c1-45c4-a9a1-a9822a19f925
md"""
![](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExdW1vNndjMXdrZjR2cjc3bm9yMnYxOTN1MjliZThkYXlxaGNsbzJyaiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/EMJXuqkTkMmDp0c5Xc/giphy-downsized-large.gif)
"""

# ╔═╡ 859fe2ac-4e1b-4d83-9bad-22042ed46d29
md"

Turns out, many objects have this same property, where they can be split into parts and each tiny part is a copy of the whole. We call them **Fractals**.

Pretty cool, right? But what's even more cool is that fractals can be defined mathematically following a super simple formula! One famous such set of fractals is called the **Julia Set** "

# ╔═╡ 903617e4-e5c6-4a16-9f0f-586cdb803f3c
aside((md"""
!!! info "Lucky coincidence"
	Julia Set? How convenient is it that we're learning about the Julia language ?! 🤯"""), v_offset=-100)

# ╔═╡ 3ca5960c-2352-41f5-ac89-e58e3a5dd1c9
md"### A Fun Sequence to Work With

Before we get to the fractals, there are a few things we want to talk about. 

So, in math, instead of dealing with numbers in a list, we can define a formula that looks like this:

```math
z_{n+1} = z_n^2 + 1
```

This is called a **sequence**. Let's see how it works 😁"

# ╔═╡ 59620b66-798a-4723-b14b-596a355462bc
md"""

#### Calculating numbers
Step 1: choose an initial value $z_0$ :
"""

# ╔═╡ 1dfe4357-af4d-4db4-9a10-05219737041a
@bindname z0 PlutoUI.Slider(BigInt(-10):BigInt(10), default = 1, show_value = true) 

# ╔═╡ 9469dd0d-efb2-49a5-83f4-a6da7290af20
md"Now, we can calculate ``z_1``, and ``z_2``, and so on:"

# ╔═╡ 2e7f10f3-eb4d-40e0-ae48-c0b4563b99c4
z1 = z0^2 + 1

# ╔═╡ cf1f1d8a-c462-47b1-9e17-ea88357570aa
z2 = z1^2 + 1

# ╔═╡ b2a95d75-a254-4918-96d2-7ec5c2a60d8a
z3 = z2^2 + 1

# ╔═╡ d81173b4-8847-4c17-9a30-5e20c6f313dd
z4 = z3^2 + 1

# ╔═╡ 0c2b4fda-8c84-400c-abaf-5dcbc43169a3
md"And so on ..

Basically we calculate the next value by using the **same function** applied to the last value."

# ╔═╡ 6c49089e-9b7c-47ff-adcb-62ca2af3acdd
md"""

!!! danger "Fun Julia Alert!"
	Now check out this piece of cool Julia code. Can you guess what it does?

"""

# ╔═╡ 3f8e294c-ddeb-4509-b5d5-4e86284dfd34
@bindname n PlutoUI.Slider(1:10, default = 5, show_value = true) 

# ╔═╡ cab8c291-5c88-42ee-96aa-50d3b9df33ef
F(z) = z^2 + 1;

# ╔═╡ c3e25292-54aa-4b89-a2f2-0eb0d3880fae
Fⁿ(x, n) = ∘(fill(F, n)...)(x);

# ╔═╡ 4135244d-fb5a-4e8d-ad4b-c4046781b70c
zₙ = Fⁿ(z0, n)

# ╔═╡ 171a7aed-dd5f-46bf-ab5c-170a1c594370
checkbox = @bind show_answer CheckBox(default=false);

# ╔═╡ 57819281-a466-4f6c-af96-ffe512594270
begin 
	if show_answer 
	md"""
	!!! correct "Answer!"
	
		If you guessed that the code calculates the $n^{th}$ number in the sequence then you guessed correctly! 🎉"""
		
	else
		md"""
		!!! hint "Did you guess what the code does?" 
		
			**Tip:** Move both the $n$ **and** the $z_0$ sliders around if you need help!"""
	end
	end

# ╔═╡ dc9a7c58-0911-42ce-a985-c414ed5bba22
md" $checkbox Show answer"

# ╔═╡ 75a7a805-508b-4977-a667-0369421f7433
md" ### The Sequence

Now let's put it together! 

This code generate the whole sequence up to our chosen n and saves it in a list. If you're interested in how to use Julia methods to write compact code, check it out! 

But no worries if you don't understand it, it's not necessary for the rest."

# ╔═╡ bccffd3d-46b5-43e8-b515-626640b0bb32
function create_sequence(F, initial_value, max_n)
	# Define a function that computes the next element in the sequence 
	function z_i(last_z, i)
		F(last_z)
	end
	
	# We use Base.accumulate to get the series values
	series = accumulate(z_i, 2:max_n, init=initial_value)
	
	# Add initial element to the final series
	return [initial_value, series...]
end;

# ╔═╡ a3bce920-0be0-49cd-b639-4042a71b0001
md"Change the initial value and n and observe how the series changes!"

# ╔═╡ 066c0e7b-f127-40e9-af96-a0d03b559043
md"""
``z_0 = `` $(@bind initial_value Slider(BigInt(-10):BigInt(10); show_value=true))

``n = `` $(@bind max_n Slider(1:20; show_value=true))

"""

# ╔═╡ ee4df211-020e-43d4-a41d-513fbd6f31b7
sequence = create_sequence(F, initial_value, max_n)

# ╔═╡ d242a89b-8a02-42fd-bb14-92a31b50413e
md"""
*👆 Click on the sequence to see all entries.*

!!! info "Divergence!"

	What happens when we keep doing this for a long time?

	For most initial values, our numbers are always increasing and getting bigger and bigger, so they're going to infinity. We say the series **diverges**.

"""

# ╔═╡ 27591565-2676-4630-b6c1-ced4530086f8
aside(md"""
!!! warning "Negative Number?"
	If you noticed that some numbers become negative when we continue calculating the sequence, you unlocked a very common bug in computing. 

	Turns out computers cannot really count to infinity, they have a limit maximum (and minimum) number they count up (or down) to because they only have limited space on their memory to save each number. 

	So what happens, once they get to this limit they loop back forward and start counting from the beginning, so they start from the biggest negative number and add continue counting from there. This computational bug is called an *overflow* error. 
""", v_offset=-400)

# ╔═╡ bfdf2bf9-775f-4621-a57c-8ee2dfec0a39
md""" ### Fun Functions for a Fun Sequence

Now that you (hopefully) got the gist of that. Let's make it a bit more complicated. 

Remember how we chose the formula $z_{n+1} = z_n^2 + 1$ before? Well, we can do this in a more general way as $z_{n+1} = z_n^2 + C$. Before, we had **C = 1**."""

# ╔═╡ cfa4842a-0b3f-4ad3-8c0f-6364ca8313d8
C = -1

# ╔═╡ 9c4c6455-b21c-4e9c-aaf6-ce6486cf4be2
md"Let's define our function again in a more general setting"

# ╔═╡ 717b615d-91a8-4c59-a484-555406b6071e
Fc(z, c) = z^2 + c;

# ╔═╡ 7f0c6b02-ff50-4dca-8690-79b6d93e5e41
md"""Now let's use our code from above again with our new function this time. """

# ╔═╡ 8a4de5d7-1e7f-4d7c-a3a9-02fa954aa38d
function create_sequence_with_c(F, C, initial_value, max_n)
	# Define a function that computes the next element in the sequence 
	function z_i(last_z, i)
		F(last_z, C)
	end
	
	# We use Base.accumulate to get the series values
	series = accumulate(z_i, 2:max_n, init=initial_value)
	
	# Add initial element to the final series
	return [initial_value, series...]
end;

# ╔═╡ bc4a4421-f543-4bfc-8214-3d97468f89e7
@bindname initial_value_with_c PlutoUI.Slider(BigInt(-10):BigInt(10), default = 1, show_value = true) 

# ╔═╡ c12abce1-6109-4274-b260-835b5e1659df
md"""Try setting **C = -1**. What happens to our `C_sequence` (if you chance nothing else)?"""

# ╔═╡ ae6b02ce-180e-487b-9a25-2be9c6092293
C_sequence = create_sequence_with_c(Fc, C, initial_value_with_c, max_n)

# ╔═╡ b99f5d32-d017-4722-9226-13345cad6a2b
md"If you noticed that we get a completely new sequence, that's correct!

But, how about if we set **initial\_value\_with\_c = 1**. What happens? Do you notice anything special about this sequence?"

# ╔═╡ 221742a5-146e-4d7d-8d50-0f7bd5a30cb5
begin
if initial_value_with_c == 1
md"""
	!!! correct "Answer"

		In this case, the series **doesn't** go to infinity but moves back and forth between 0 and -1, and so it doesn't *diverge*. It oscillates. 

		PS: The same thing happens if initial\_value\_with\_c = 0"""
else
	md""
end
end

# ╔═╡ f47f2b4a-93e2-40ec-8123-73d004e9465d
md"Now, to make things more fun, let's try more values of C and see if the same thing happens again. 

To make it even more fun, let's make C a complex number!

If you don't know about complex numbers, that's okay. For now, we can think of C as a **2D point**."

# ╔═╡ c2b6b207-a485-48b8-8aff-c87cc6563555
aside(md"""
	!!! info "Complex Numbers"
		If you want to learn about complex number, check this awesome [Youtube video](https://www.youtube.com/watch?v=sZrOxm5Gszk&t=418s). I find it a good introduction to grasp the concept. 😉""", v_offset=-150)

# ╔═╡ c83c1af8-5f41-428d-b554-e3679fdbdf54
md"**👇 Click anywhere to chose a point!**"

# ╔═╡ db2a3f19-a755-4863-9b38-2f1d4e235dd2
md"Again, we get our code from above and set a fixed initial value. See how the sequence changes completely for even very similar c value? Pretty cool right!"

# ╔═╡ 87eb68ff-5af9-4748-bbc9-95d192b53e70
new_initial_value = 1.0

# ╔═╡ 1936a375-5b07-4c93-8e72-01c5370a021e
md"""

*👆 Click on the sequence to see all entries.*


#### Convergence?

Let's look at the last value of the sequence (``z_{20}``). Is it a small number (convergence), or something very large or `NaN` (divergence)?
"""

# ╔═╡ a979f1ad-8a2e-4687-ac64-3b7ac4eb1995
aside(md"""
!!! info "Explosion 🔥"
	For  some values of c, the values get so big that even Julia is overwhelmed and just returns `Inf` or `NaN` instead! Whoopsie.

	If you want to work with really big numbers, Julia offers the [`BigFloat` and `BigInt`](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/) types, which can be as big as you want! We secretly used `BigInt` in the previous examples.""", v_offset=-300)

# ╔═╡ 6827d3fd-91e2-49b2-b215-082fe0573723
md"### One last thing "

# ╔═╡ 119d2282-5d2e-494f-96cb-82e9c4f0bb92
md"""
Choose 2 of your favorite colors (ideally they should match each other 😉):
"""

# ╔═╡ bad211bc-220c-43dd-ade6-7b63f980f524
TwoColumn(
md""" First color: 

$(@bind color1 ColorPicker(default=colorant"#f5c894"))
""",  
md"""
Second color:

$(@bind color2 ColorPicker(default=colorant"#445233"))
""")

# ╔═╡ 98fbff5f-df70-4ee6-a2b3-7d56b6299140
md" ## Construct Fractals
Now we have everything we need to construct a fractal from the Julia set. 


"

# ╔═╡ 3dc2f13d-0238-444d-b440-5e7e2df0618f
# some markdown hackery because the $ interpolation did not work inside a blockquote.
Markdown.BlockQuote(
	md"""
	#### Recipe: Julia Set picture
	1. Choose a complex number ``c`` **(on the left)**.
	2. We define our favorite sequence $z_{n+1} = z_n^2 + c$
	3. Now, we're going over **all** the imaginary numbers in a square around ``0``, and for each:
	- Use the number as the initial value to compute a sequence.
	- If the sequence **converges**, we color the point in $(color1). 
	- If the sequence **diverges**, we color the point in $(color2).
	"""
) |> Markdown.MD

# ╔═╡ 9c83bdc9-8796-47cf-9a83-65dda43099bf
md"**👇 Click anywhere to choose the value of c!**"

# ╔═╡ e7f0f154-ddf6-432e-bc6f-5654fa4c5a14
md"If you're interested to dive deep into the code, take a look below, it's so simple and straighforward and yet we can create so many beautiful things with it!"

# ╔═╡ 712ce6d2-c5d4-4699-8b2c-f6db11ac17af
md"# Appendix"

# ╔═╡ 98d7894e-3a9f-4df4-b282-fe4566d3c0f7
function scale_tuple(tuple, new_min, new_max)
    return (Int(round((tuple[1] + 1.5) / 3 * (new_max - new_min) + new_min)),
            Int(round((tuple[2] + 1.5) / 3 * (new_max - new_min) + new_min)))
end

# ╔═╡ 81afcd2c-28e9-4b2a-8dc0-828d5feec4f7
begin
	f(z, c) = z*z + c
	img_size = 300

	# This checks for each point if it diverges
	function is_stable(iterations, z, c)
	    for _ in 1:iterations
	        # This can be set to a bigger value as check to stop divergence check
			if abs(z) > 5 
	            return 0
			end
	        z = f(z, c)
	    end
	    1
	end

	# This goes over all the points in the image, considers the point an initial, check the sequence, colors accordingly depending on whether they diverge or not
	function julia_fractal(depth, X, Y, c, f) 
		img_matrix = zeros(Float32, img_size+1, img_size+1) 
	    for x in X
	        for y in Y
	            z = f(x, y)
				x_scaled, y_scaled = scale_tuple((x, y), 0, img_size)
				img_matrix[y_scaled+1, x_scaled+1] = is_stable(depth, z, c)
	        end
	    end
		img_matrix
	end
	
end

# ╔═╡ 0cfe1f7a-bdae-443d-a1d2-4a503c05ea62
begin
	struct SVG
		content
	end

	function Base.show(io::IO, m::MIME"image/svg+xml", s::SVG)
		write(io, s.content)
	end

	SVG
end

# ╔═╡ ef869b3a-011f-4df5-90e8-f8f9a57e0375
const im_axes = """<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300" viewBox="0 0 300 300" style="max-width:100%;height:auto;color:black">

<defs>
    <marker id="triangle" viewBox="0 0 10 10" refX="1" refY="5" markerUnits="strokeWidth" markerWidth="10" markerHeight="10" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="currentColor"></path>
    </marker>
  </defs>

<rect width="300" height="300" fill="white" rx="1em"/>

<line x1="10" x2="290" y1="150" y2="150" stroke="currentColor" marker-start="url(#triangle)" marker-end="url(#triangle)"></line>

<line y1="10" y2="290" x1="150" x2="150" stroke="currentColor" marker-start="url(#triangle)" marker-end="url(#triangle)"></line>
<circle cx="150" cy="150" r="3" fill="currentColor"></circle>

<g style="    font-family: math;
    font-style: italic;
    font-size: 17px;">

<g transform="translate(260, 140)">
<text fill="currentColor">Real</text>
</g>

<g transform="translate(170, 50) rotate(-90)">
<text text-anchor="middle" fill="currentColor">Imaginary</text>
</g>


<g transform="translate(150, 150)">
<text text-anchor="end" fill="currentColor" dx="-10" dy="20">0</text>
</g>



<g transform="translate(270, 150)">
<line y1="-5" y2="5" stroke="currentColor"></line>
<text text-anchor="middle" fill="currentColor" dy="20">1</text>
</g>
<g transform="translate(30, 150)">
<line y1="-5" y2="5" stroke="currentColor"></line>
<text text-anchor="middle" fill="currentColor" dy="20">-1</text>
</g>





<g transform="translate(150, 30)">
<line x1="-5" x2="5" stroke="currentColor"></line>
<text text-anchor="end" fill="currentColor" dy=".5ch" dx="-10">i</text>
</g>
<g transform="translate(150, 270)">
<line x1="-5" x2="5" stroke="currentColor"></line>
<text text-anchor="end" fill="currentColor" dy=".5ch" dx="-10">-i</text>
</g>



</g>

</svg>""" |> SVG

# ╔═╡ 6233f626-19e9-4012-ba72-e9ca2386ab27
function ComplexNumberPicker(; default::Union{Real,Complex,Nothing}=nothing)
	t(x) = (x - 150.0) / 120.0
	tinv(x) = x * 120.0 + 150.0
	
	default_coord = default === nothing ? nothing : 
		PlutoImageCoordinatePicker.ClickCoordinate(300, 300, 
			tinv(real(default)), 
			tinv(-imag(default))
		)
	
	PlutoUI.Experimental.transformed_value(ImageCoordinatePicker(im_axes; default=default_coord)) do point
		if point === nothing
			nothing
		else
			t(point.x) - im * t(point.y)
		end
	end
end

# ╔═╡ 7d05121b-1932-4018-ba1a-fdfecaefa54a
@bind c ComplexNumberPicker(default=.9+.4im)

# ╔═╡ 9155d298-7758-4715-913f-9624c22450bb
c

# ╔═╡ 78da1442-19df-464f-8099-407b50d99303
new_sequence = create_sequence_with_c(Fc, c, new_initial_value, 15)

# ╔═╡ 4693d328-0907-4d62-b8e4-dcccff803b59
last(new_sequence)

# ╔═╡ 454f51c5-c11d-405b-b3e2-7ef289aec7db
c_fractal_picker = @bind c_for_fractal ComplexNumberPicker(default=-.04+.72im);

# ╔═╡ 7789450c-31d6-4286-9fd9-3e88b075b538
PlutoTeachingTools.Columns(
	# Left
	c_fractal_picker,

	# Right
	let	
		fractal = julia_fractal(
			80, 
			LinRange(-1.5,1.5,img_size + 1),
			LinRange(-1.5,1.5,img_size + 1), 
			c_for_fractal, Complex);
		
		colored_fractal = [
			fractal[i, j] == 1 ? color1 : color2 
			for i in 1:img_size, j in 1:img_size
		]
		
		RGB.(colored_fractal)
	end
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
PlutoImageCoordinatePicker = "79686372-6169-7274-6170-6568746b6366"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Colors = "~0.12.11"
ImageIO = "~0.6.8"
ImageShow = "~0.3.8"
PlutoImageCoordinatePicker = "~1.4.1"
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "8508a01b24a1bcf53c7b4c30872126ceb034fdc5"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

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

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "62ca0547a14c57e98154423419d8a342dca75ca9"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.4"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

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

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "b2a7eaa169c13f5bcae8131a83bc30eff8f71be0"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.2"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

    [deps.IntervalSets.weakdeps]
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "25ee0be4d43d0269027024d75a24c24d6c6e590c"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.4+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "260dc274c1bc2cb839e758588c63d9c8b5e639d1"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.5"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

    [deps.OffsetArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoImageCoordinatePicker]]
deps = ["AbstractPlutoDingetjes", "Base64", "HypertextLiteral", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "0befd0746e8c8387afa36097731aae3cebc76116"
uuid = "79686372-6169-7274-6170-6568746b6366"
version = "1.4.1"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoLinks", "PlutoUI"]
git-tree-sha1 = "8252b5de1f81dc103eb0293523ddf917695adea1"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.3.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "7f4228017b83c66bd6aa4fddeb170ce487e53bc7"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.6.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "98ca7c29edd6fc79cd74c61accb7010a4e7aee33"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.6.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

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
version = "1.11.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "38f139cc4abf345dd4f22286ec000728d5e8e097"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.2"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "b70c870239dc3d7bc094eb2d6be9b73d27bef280"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.44+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "7dfa0fd9c783d3d0cc43ea1af53d69ba45c447df"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═2e3a7a3a-2fa7-11ef-1b80-d793aa08ee42
# ╠═9f0f999c-4c4f-40a9-83b9-08b5b1cffa80
# ╟─98bca732-c2c6-4a79-b57b-f3d10a7d5845
# ╟─60ee1932-63c1-45c4-a9a1-a9822a19f925
# ╟─859fe2ac-4e1b-4d83-9bad-22042ed46d29
# ╟─903617e4-e5c6-4a16-9f0f-586cdb803f3c
# ╟─3ca5960c-2352-41f5-ac89-e58e3a5dd1c9
# ╟─59620b66-798a-4723-b14b-596a355462bc
# ╟─1dfe4357-af4d-4db4-9a10-05219737041a
# ╟─9469dd0d-efb2-49a5-83f4-a6da7290af20
# ╠═2e7f10f3-eb4d-40e0-ae48-c0b4563b99c4
# ╠═cf1f1d8a-c462-47b1-9e17-ea88357570aa
# ╠═b2a95d75-a254-4918-96d2-7ec5c2a60d8a
# ╠═d81173b4-8847-4c17-9a30-5e20c6f313dd
# ╟─0c2b4fda-8c84-400c-abaf-5dcbc43169a3
# ╟─6c49089e-9b7c-47ff-adcb-62ca2af3acdd
# ╟─3f8e294c-ddeb-4509-b5d5-4e86284dfd34
# ╠═cab8c291-5c88-42ee-96aa-50d3b9df33ef
# ╠═c3e25292-54aa-4b89-a2f2-0eb0d3880fae
# ╠═4135244d-fb5a-4e8d-ad4b-c4046781b70c
# ╟─57819281-a466-4f6c-af96-ffe512594270
# ╟─dc9a7c58-0911-42ce-a985-c414ed5bba22
# ╟─171a7aed-dd5f-46bf-ab5c-170a1c594370
# ╟─75a7a805-508b-4977-a667-0369421f7433
# ╠═bccffd3d-46b5-43e8-b515-626640b0bb32
# ╟─a3bce920-0be0-49cd-b639-4042a71b0001
# ╟─066c0e7b-f127-40e9-af96-a0d03b559043
# ╠═ee4df211-020e-43d4-a41d-513fbd6f31b7
# ╟─d242a89b-8a02-42fd-bb14-92a31b50413e
# ╟─27591565-2676-4630-b6c1-ced4530086f8
# ╟─bfdf2bf9-775f-4621-a57c-8ee2dfec0a39
# ╠═cfa4842a-0b3f-4ad3-8c0f-6364ca8313d8
# ╟─9c4c6455-b21c-4e9c-aaf6-ce6486cf4be2
# ╠═717b615d-91a8-4c59-a484-555406b6071e
# ╟─7f0c6b02-ff50-4dca-8690-79b6d93e5e41
# ╠═8a4de5d7-1e7f-4d7c-a3a9-02fa954aa38d
# ╟─bc4a4421-f543-4bfc-8214-3d97468f89e7
# ╟─c12abce1-6109-4274-b260-835b5e1659df
# ╠═ae6b02ce-180e-487b-9a25-2be9c6092293
# ╟─b99f5d32-d017-4722-9226-13345cad6a2b
# ╟─221742a5-146e-4d7d-8d50-0f7bd5a30cb5
# ╟─f47f2b4a-93e2-40ec-8123-73d004e9465d
# ╟─c2b6b207-a485-48b8-8aff-c87cc6563555
# ╟─c83c1af8-5f41-428d-b554-e3679fdbdf54
# ╟─7d05121b-1932-4018-ba1a-fdfecaefa54a
# ╠═9155d298-7758-4715-913f-9624c22450bb
# ╟─db2a3f19-a755-4863-9b38-2f1d4e235dd2
# ╠═87eb68ff-5af9-4748-bbc9-95d192b53e70
# ╠═78da1442-19df-464f-8099-407b50d99303
# ╟─1936a375-5b07-4c93-8e72-01c5370a021e
# ╠═4693d328-0907-4d62-b8e4-dcccff803b59
# ╟─a979f1ad-8a2e-4687-ac64-3b7ac4eb1995
# ╟─6827d3fd-91e2-49b2-b215-082fe0573723
# ╟─119d2282-5d2e-494f-96cb-82e9c4f0bb92
# ╟─bad211bc-220c-43dd-ade6-7b63f980f524
# ╟─98fbff5f-df70-4ee6-a2b3-7d56b6299140
# ╟─3dc2f13d-0238-444d-b440-5e7e2df0618f
# ╟─9c83bdc9-8796-47cf-9a83-65dda43099bf
# ╟─7789450c-31d6-4286-9fd9-3e88b075b538
# ╟─e7f0f154-ddf6-432e-bc6f-5654fa4c5a14
# ╟─81afcd2c-28e9-4b2a-8dc0-828d5feec4f7
# ╟─454f51c5-c11d-405b-b3e2-7ef289aec7db
# ╟─712ce6d2-c5d4-4699-8b2c-f6db11ac17af
# ╟─98d7894e-3a9f-4df4-b282-fe4566d3c0f7
# ╟─6233f626-19e9-4012-ba72-e9ca2386ab27
# ╟─0cfe1f7a-bdae-443d-a1d2-4a503c05ea62
# ╟─ef869b3a-011f-4df5-90e8-f8f9a57e0375
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
