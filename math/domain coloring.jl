### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/user-attachments/assets/0273c73f-f92f-4ceb-a03a-d8839983f591"
#> title = "Domain Coloring"
#> date = "2025-01-17"
#> tags = ["math", "julia", "art", "complex numbers", "transformations"]
#> description = "Let's use math as a paintbrush with complex numbers!"
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

# ╔═╡ cfa96c23-a980-416c-a11d-d03b0d476984
using PlutoUI, PlutoTeachingTools, Colors, ImageShow, ImageIO, PlutoImageCoordinatePicker

# ╔═╡ 48380e35-1985-47a1-aa4d-1da27837839c
md"# 🎨 Domain Coloring"

# ╔═╡ cc3d1dfe-e167-4c8c-a276-9ccc079cae45
md"Hey there! Let's play a round of **Word Link**, I will say a word and you have to write down the first word that comes to mind in response: 

What's the first you can think of when I say **'Math'**? 

👇 Type your answer below:"

# ╔═╡ 0fe41744-2ea3-4d95-a094-adffb6a9db17
@bind answer TextField()

# ╔═╡ 198332aa-1070-4cbc-88a3-af0d26ff7f2e
begin 
	if answer == ""
	md"""
	!!! correct "Try!"
		
		Type anything, try it out!"""
	
	elseif answer == "Art" || answer == "art"
	md"""
	!!! correct "Impressive!"
	
		Now that's unexpected, great job! 🎉 I really want to know what kind of math you were taught at school, sounds more fun than the one I had!"""
		
	else
		md"""
		!!! correct "Nice!" 
		
			There's really no correct answer here, but it's nice to see how your brain works ☺️ 
		
			Fun fact: the most common words are: *Numbers*, *Equations*, *Algebra* """
	end
	end

# ╔═╡ 997932b8-2a6e-4ef7-8c91-2b1fc2d92289
md"Now if you're like me (or like most people), you probably didn't think of the word 'Art' first, because often we don't associate art🎨 with mathematics📏. And yet today we're going to see how we can create some beautiful (slightly trippy🌀) art by using **only** math. 

Are you ready? 💃"

# ╔═╡ b07e51fd-b4e1-4baf-bf08-5e475f7ef744
md"## 2D Functions"

# ╔═╡ b27a9694-bf59-4f61-b527-2d54e0a28129
md"You (hopefully) know from school, that we can define a function for a number, such as $f(x) = 2x$ which just basically means for any number $x$ ❗ we want our function $f$ to double ‼️ that value. So functions are nothing more than just a **transformation** of the numbers! There are countless functions in math, in fact they kind of define the very basics of mathematics 😉

👇 Start by chosing a function $f$ below:"

# ╔═╡ 7c477f2a-691b-431d-9930-f5eb925ad356
md"Great! Now let's choose our point $x$. To make thing more fun, we'll use complex numbers. If you don't know what that is, that's okay, for now you can think of it as a **2D point**

👇 Click anywhere to chose a point!"

# ╔═╡ caee3573-b2cf-4ff4-b8f5-a1ddff1c4718
md"That's pretty boring and unintuitive to understand right? Isn't there a better way?

Well there is: let's use colors! 🎨

Now each point in our initial space has a *unique* position **and** a *unique* color. So we follow these steps: 

👉 We choose our point (or color) $x$ 🔴

👉 Calculate our function value $f(x)$ 

👉 Find the corresponding **color** for that value in the initial space 🔵

✨ Try it out!"

# ╔═╡ ba68a796-f347-4c80-a9f7-5a5e6d2ddc49
md"Much better, right?! Now, we're ready for some art! 🎉"

# ╔═╡ 374d32d1-2d91-44a7-8624-7ca9f6af32f8
aside(md"""
!!! info "Functions vs Brushes 🖌️🧑‍🎨"
	What we're doing here isn't very different than what an artist does: we're taking the initial canvas of colors and changing them by adding ➕ intensity, 🔄 rotating the colors, $\rightarrow$ moving some to the side. All of these are **transformations** that can be expressed using **only** numbers instead of brushes. 

	So, when learning math, we're not *always* restricted to using only numbers but rather we can map these numbers to colors 🎨 and play around with those instead, how awesome is that ! 🤯
	""", v_offset=100)

# ╔═╡ 261f1a0d-a261-42fb-9c57-ea0ba1846282
md"## Math Art 📏🎨"

# ╔═╡ bd52785f-c057-4bc3-94ae-86e1dd773ba7
md"""To finally create our art pieces, all we have to do is repeat the same thing we did so far for **all** the points in our 2D space. So instead of checking the values for each point one by one, we will do the following: 

👉 Go over each point in the initial drawing one by one 🔵

👉 Apply the transformation from above 📏

👉 Put in the transformed color 🔴 in the place of the original one in the new drawing
"""

# ╔═╡ 91758932-ef9e-4265-b32b-1edb4c0a61d6
md"Let's start by choosing our initial drawing, or what we call **domain**. We're not limited to any specific respresentation. We can give each number any color we want as long as each one gets its **unique** color. 

👇 Try it out! Choose a different domain color"

# ╔═╡ 28c92348-5d69-47cb-ace3-f5ca04447237
md" 👇And now let's choose again a function "

# ╔═╡ cb82c7ac-1a9e-4d5b-ab4d-fb384f66b2ec
md"And tadaaa 🎉"

# ╔═╡ b8fee414-320c-4268-95b4-90e53700e0b8
begin
	intensity_picker = @bind v PlutoUI.Slider(0:0.05:1, default=0.9, show_value=true)
	
	aside(
		md"""
		👉 You can also change the intensity of the colors here: 
		
		intensity = $intensity_picker
		""", v_offset= -380)
end

# ╔═╡ 02a36bc7-a969-4d18-b742-2daa8076fff4
md"## Your turn 🫵

Now it's your turn: Let your creativity run free!! Here you can choose your own domain coloring 🎨 and own transformation 📏 and create all the awesome art you want! 🤪

Have fun 🥳"

# ╔═╡ d8177c39-6490-441a-aa3d-f9bb1cee5ee0
aside(md"""
!!! info "Functions 🤓" 
	Example functions to use:

	📈 Polynomials and fractions: $x^2$ or $\frac{1}{x}$

	📈 Trigonometric functions: $\sin$, $\cos$, $\tan$

	📈 Exponentials and logarithms: $2^x$, $e^2$, $\log(x)$""", v_offset=-160)

# ╔═╡ 8a77f33c-34ee-45e4-8693-468cb5c8a345
custom_f(x) = x^2 #Replace this

# ╔═╡ 5abc3c95-4cad-4671-8b29-1faa8bc81919
aside(md"👈 Set your transformation function here", v_offset=-455)

# ╔═╡ b0fa6891-4626-4269-81c6-b118c8d41c48
aside(md"""
!!! tip "💡 Tip"
	You can mix around and combine different types of functions: add, substract, multiply them together. Go wild!
""", v_offset=-400)

# ╔═╡ 80d4795c-c278-4844-a2cd-d375bc9330d1
md"""## Pro Tip: The base function

⚠️ Notice that if we were to really plot the identify function, we would get a big black square because the density of the points in polar coordinates is not uniform. 

👇 Try it out: Replace `custom_g` with the identity function"""

# ╔═╡ 32701e29-5a09-4ef5-b2f3-9be3e16fe411
md"""
🌞 For this reason, if we want to ensure that our colors are uniformely distributed in the base domain, we need to rescale the magnitudes logarithmically. One such way to do this is using our $g_1$ function. 

👇 But you can also set your own function! Try it out, change this to a different expression and see how both the base and color domains change:
"""

# ╔═╡ de52fc27-a144-4ad2-8c47-4444b5abbe0a
custom_g(x) = x # g1(x) # Replace this

# ╔═╡ 90cd3a2f-1b66-410d-a4ef-4f0b3fac5047
md"## Advanced: Functions and Code"

# ╔═╡ 888c35f5-a18b-454e-b7c6-0f51e5610aa0
heatmap(cs) = cs

# ╔═╡ 4a583be7-7ad9-4bc9-9788-ff5573eaac69
md"### Tranformation functions"

# ╔═╡ a4f5dd94-acd3-4099-ab05-2e7f1e435ba3
f0(z) = z

# ╔═╡ 48386799-c121-4358-b7fa-3988ddd3c0ef
f1(z) = (z^3 - 1) / z

# ╔═╡ 416011b9-b4db-4c9e-9bfb-4dd105596733
f2(z) = (z - 0.5 - 0.5*1im) / z^2

# ╔═╡ 993ec4e0-df4d-4720-b256-40b6f3e91f55
f3(z) = 1/z

# ╔═╡ f9efc61e-3fc9-48a0-85c8-58f24550e308
f4(z) = sin(z)

# ╔═╡ 7780f241-b477-45ab-8287-1cd6b5409e13
f5(z) = z^9 - 1/ z^3 + 1

# ╔═╡ e5c408b1-8285-4898-988c-731ad1a59ecc
function_chooser = @bind f Select([f1 => md"Cool f1", f2 => "Super cool f2", f3 => "Boring Inverse f3", f4 => "Fun sin f4", f5 => "Wild function"]);

# ╔═╡ 805529fa-a017-435d-949f-c718ed74b56f
function_chooser

# ╔═╡ 9fb31e84-d4e1-4b37-ab4a-17f2dab7a5fe
function_chooser

# ╔═╡ ad915710-ef64-4aed-8514-f3214491b9ab
# TODO: Probably a better more automated way to do this
function_names = Dict(
    f1 => md"$f_1(x) = (x^3 - 1) / x$",
    f2 => md"$f_2(x) = \frac{x - \frac{1}{2} (1 + i)}{x^2}$",
    f3 => md"$f_3(x) = 1/x$",
	f4 => md"$f_4(x) = sin(x)$",
	f5 => md"$f_5(x) = x^9 - 1/ x^3 + 1$",
)

# ╔═╡ b9616798-709e-417a-b850-a1d0fc4cf61a
md"Your currently chosen function is: $(function_names[f])"

# ╔═╡ a8f1c7a9-3a9a-4ff5-9203-b2b7bac74dd2
md"Your currently chosen function is: $(function_names[f])"

# ╔═╡ 1ce4351a-e9fa-4e49-924b-b9d5146c20af
md"### Functions for initial domain "

# ╔═╡ 9ae3fe47-4c53-48c1-a126-bad1d1615f01
function g1(r)
	return (1.0 - 1.0 / (1 + r^2))^(0.2)
end


# ╔═╡ 762ae276-0afa-4a37-877a-b3274df149d3
function g2(r)
    logm = log(r) / log(2) 
    logm = logm |> (r -> isnan(r) ? 0.0 : r) 
   
    return (logm - floor(logm))^0.3
end

# ╔═╡ 79d23ca2-0034-4b04-997a-14a29e4c2df6
@bind g Select([g1 => "Standard", g2 => "Fancy"])

# ╔═╡ 8e1c0295-d7e1-4bb0-8e50-62a6e6992011
function g3(r)
	return 0.5 + 0.5*(r - floor(r))
end

# ╔═╡ a278c9af-3409-4bd2-b977-d21ef52aacc5
md"### Coloring and Formating"

# ╔═╡ 44473d2a-a38b-449c-a739-6ac7025c6c27
# Trims the c value in the picker to 3 digits after the ,
function trim_c(c)
	# Extract real and imaginary parts
	real_part = real(c)
	imag_part = imag(c)
	
	# Trim the real and imaginary parts
	real_part_trimmed = round(real_part, digits=3)  # Round to 3 decimal places
	imag_part_trimmed = round(imag_part, digits=3)
	
	# Combine trimmed parts back into a complex number
	trimmed_num = real_part_trimmed + imag_part_trimmed * im
	return trimmed_num
end

# ╔═╡ 1948ca3e-619b-4a4f-938d-97d3d9b5de65
# Returns the color corresponding to one point
function color_value(x, g; v::Real=1.0) 
	Z = x
	# Compute H (hue), S (saturation), V (value)
	H = rad2deg.(angle.(Z)) # Convert to degrees angle
	S = v # Constant value
	V = g.(abs.(Z)) 
	
	# Combine H, S, V into an HSV image
	hsv_array = reshape(hcat(H, S, V), 1, 1, 3)
	
	# Convert HSV image to RGB image
	height, width = size(hsv_array)
	rgb_image = Array{RGB, 2}(undef, height, width)
	color = HSV(H, S, V)	
	rgb = RGB(color)
	return rgb
	
end

# ╔═╡ 8803ea22-6cdc-4e5b-85b3-f89a70f2e627
# Calculates the colors for the whole domain
function color_domain(f::Function, g::Function; v::Real=1.0) 
	# Create complex grid z = x + 1im*y (NICE JULIA WAY TO DO THIS)
	depth = 300
	x = range(-1.25,1.25,length=depth)
	y = range(-1.25,1.25,length=depth)
	grid = x' .- 1im .* y
	Z = f.(grid)
		
	# Compute H (hue), S (saturation), V (value)
	H = rad2deg.(angle.(Z)) # Convert to degrees angle
	S = v * ones(size(H)) # Constant value
	V = g.(abs.(Z)) 
	
	# Combine H, S, V into an HSV image
	hsv_array = reshape(hcat(H, S, V), depth, depth, 3)
	
	# Convert HSV image to RGB image
	height, width = size(hsv_array)
	rgb_image = Array{RGB, 2}(undef, height, width)
	
	for i in 1:height
	    for j in 1:width
	        hue = hsv_array[i, j, 1]
	        saturation = hsv_array[i, j, 2]
	        value = hsv_array[i, j, 3]
			
	        color = HSV(hue, saturation, value)	
			rgb_image[i, j] = RGB(color)
	    end
	end
	return rgb_image
end

# ╔═╡ 4a59a504-b55a-45cb-a101-a518f6ace1f5
standard_domain = heatmap(color_domain(f0, g1));

# ╔═╡ 008fd9ac-c5b5-4f0c-bf44-3c0368e0d21d
begin
	domain = heatmap(color_domain(f0, g; v)) # f0 is the identity functionn
	rgb_image = heatmap(color_domain(f, g; v))
	PlutoTeachingTools.Columns(domain, rgb_image)
end

# ╔═╡ a254f5c8-110a-4d11-9737-9e350a5e6a81
let
	domain = heatmap(color_domain(f0, custom_g))
	rgb_image = heatmap(color_domain(custom_f, custom_g))
	PlutoTeachingTools.Columns(domain, rgb_image)
end

# ╔═╡ 64a04229-067d-448d-866e-15fae2938420
md"### RGB to HSV"

# ╔═╡ 525a91e4-9830-47ca-86dc-4bf0786b5df1
intensity_picker_circle = @bind v_circle PlutoUI.Slider(0:0.05:1, default=0.9, show_value=true)

# ╔═╡ 80ade766-5d49-11ef-200e-c99f313ca7bc
let
n = 500  # Size of image
img = Array{RGB{Float64}, 2}(undef, n, n) # Initialize array

# Define the center of the circle
center = (n / 2, n / 2)
radius = n / 2

# Fill the image
for x in 1:n
    for y in 1:n
    	# Coordinates
        tcx = (x - center[1]) / radius
        tcy = (y - center[2]) / radius
        distance = sqrt(tcx^2 + tcy^2)
        
        # Check if the point is within the circle
        if distance <= 1.0
            # Get the hue angle (in degrees)
            hue = atan(tcy, tcx) * 180 / π 
            hue = hue < 0 ? hue + 360 : hue  # Ensure hue is in [0, 360]

            # Calculate saturation based on the distance from the center
            saturation = distance
            
            # Get value using the slider
            value = v_circle

            # Convert HSV to RGB
            color = HSV(hue, saturation, value)

            # Set the pixel color
            img[x, y] = RGB(color)
        else
            #Outside the circle, set the pixel to white
            img[x, y] = RGB(1, 1, 1)
        end
    end
end

# Show wheel
img
end

# ╔═╡ 7e231820-c804-4581-8dcf-b5f9824931b3
md"### Number Picker from `PlutoImageCoordinatePicker`"

# ╔═╡ ca565680-2c1b-4a68-8877-0df94c7fe0a6
function ComplexNumberPicker(axes; default::Union{Real,Complex,Nothing}=nothing)
	t(x) = (x - 150.0) / 120.0
	tinv(x) = x * 120.0 + 150.0
	
	default_coord = default === nothing ? nothing : 
		PlutoImageCoordinatePicker.ClickCoordinate(300, 300, 
			tinv(real(default)), 
			tinv(-imag(default))
		)
	PlutoUI.Experimental.transformed_value(ImageCoordinatePicker(axes; default=default_coord)) do point
		if point === nothing
			nothing
		else
			t(point.x) - im * t(point.y)
		end
	end
end

# ╔═╡ d07c146a-e106-42fb-9647-6e4132e51740
c_picker_colored = @bind x_colored ComplexNumberPicker(standard_domain, default=-.04+.72im);

# ╔═╡ 3efa98cd-1b19-464e-8923-191e01b8d659
begin
	x_col_trimed = trim_c(x_colored); x_color = color_value(x_colored, g)
	fx_colored = trim_c(f(x_colored)); fx_color = color_value(fx_colored, g)
end;

# ╔═╡ e59508e9-9254-48eb-8c5f-5de361c903df
PlutoTeachingTools.Columns(
	# Left
	c_picker_colored,

	# Right
	let	
		md"""
		**Your chosen point:** 
		
		$x_color x = $x_col_trimed

		**Your function value:**
		
		$fx_color f(x) = $fx_colored"""
	end
)

# ╔═╡ 9b72deef-6212-4b67-a314-8be3a983a73a
begin
	struct SVG
		content
	end

	function Base.show(io::IO, m::MIME"image/svg+xml", s::SVG)
		write(io, s.content)
	end

	SVG
end

# ╔═╡ ba4f4620-f98f-41e3-bfb5-9e704a93d98e
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

# ╔═╡ 5f7297f5-2412-4576-ae35-4bda3004d1d9
c_fractal_picker = @bind x ComplexNumberPicker(im_axes, default=-.04+.72im);

# ╔═╡ 98e9021c-fdf0-48d0-a44a-583f57256382
begin
x_trim = trim_c(x)
fx = trim_c(f(x))
end;

# ╔═╡ 612e7826-aae1-41eb-a507-4d7cd2c9f586
PlutoTeachingTools.Columns(
	# Left
	c_fractal_picker,

	# Right
	let
		md"""
		**Your chosen point:** x = $x_trim

		**Your function value:** f(x) = $fx"""
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
Colors = "~0.13.0"
ImageIO = "~0.6.9"
ImageShow = "~0.3.8"
PlutoImageCoordinatePicker = "~1.4.1"
PlutoTeachingTools = "~0.4.1"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "a7e1120370af25ced256f004bf63ce9f28e1addf"

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

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

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
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

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
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "b66970a70db13f45b7e57fbda1736e1cf72174ea"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.17.0"

    [deps.FileIO.extensions]
    HTTPExt = "HTTP"

    [deps.FileIO.weakdeps]
    HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"

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

[[deps.Giflib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6570366d757b50fabae9f4315ad74d2e40c0560a"
uuid = "59f7168a-df46-5410-90c8-f2779963d0ec"
version = "5.2.3+0"

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
git-tree-sha1 = "e12629406c6c4442539436581041d372d69c55ba"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.12"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs", "WebP"]
git-tree-sha1 = "696144904b76e1ca433b886b4e7edd067d76cbf7"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.9"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "2a81c3897be6fbcde0802a0ebe6796d0562f63ec"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.10"

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
git-tree-sha1 = "5fbb102dcb8b1a858111ae81d56682376130517d"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.11"

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
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "9496de8fb52c224a2e3f9ff403947674517317d9"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.6"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd10d2cc78d34c0e2a3a36420ab607b611debfbb"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.7"

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

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

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
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"

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
git-tree-sha1 = "97db9e07fe2091882c765380ef58ec553074e9c7"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.3"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "cf181f0b1e6a18dfeb0ee8acc4a9d1672499626c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.4"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

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

[[deps.PlutoImageCoordinatePicker]]
deps = ["AbstractPlutoDingetjes", "Base64", "HypertextLiteral", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "0befd0746e8c8387afa36097731aae3cebc76116"
uuid = "79686372-6169-7274-6170-6568746b6366"
version = "1.4.1"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoUI"]
git-tree-sha1 = "537c439831c0f8d37265efe850ee5c0d9c7efbe4"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.4.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

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
git-tree-sha1 = "13c5103482a8ed1536a54c08d0e742ae3dca2d42"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.4"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "8b3fc30bc0390abdce15f8822c889f669baed73d"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.1"

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
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "fea870727142270bdf7624ad675901a1ee3b4c87"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.1"

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
git-tree-sha1 = "f21231b166166bebc73b99cea236071eb047525b"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WebP]]
deps = ["CEnum", "ColorTypes", "FileIO", "FixedPointNumbers", "ImageCore", "libwebp_jll"]
git-tree-sha1 = "aa1ca3c47f119fbdae8770c29820e5e6119b83f2"
uuid = "e3aaa7dc-3e4b-44e0-be63-ffb868ccd7c1"
version = "0.1.3"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "002748401f7b520273e2b506f61cab95d4701ccf"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.48+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[deps.libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "d2408cac540942921e7bd77272c32e58c33d8a77"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.5.0+0"

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
# ╠═cfa96c23-a980-416c-a11d-d03b0d476984
# ╟─48380e35-1985-47a1-aa4d-1da27837839c
# ╟─cc3d1dfe-e167-4c8c-a276-9ccc079cae45
# ╟─0fe41744-2ea3-4d95-a094-adffb6a9db17
# ╟─198332aa-1070-4cbc-88a3-af0d26ff7f2e
# ╟─997932b8-2a6e-4ef7-8c91-2b1fc2d92289
# ╟─b07e51fd-b4e1-4baf-bf08-5e475f7ef744
# ╟─b27a9694-bf59-4f61-b527-2d54e0a28129
# ╟─805529fa-a017-435d-949f-c718ed74b56f
# ╟─b9616798-709e-417a-b850-a1d0fc4cf61a
# ╟─7c477f2a-691b-431d-9930-f5eb925ad356
# ╟─5f7297f5-2412-4576-ae35-4bda3004d1d9
# ╟─612e7826-aae1-41eb-a507-4d7cd2c9f586
# ╟─98e9021c-fdf0-48d0-a44a-583f57256382
# ╟─caee3573-b2cf-4ff4-b8f5-a1ddff1c4718
# ╟─d07c146a-e106-42fb-9647-6e4132e51740
# ╟─e59508e9-9254-48eb-8c5f-5de361c903df
# ╟─ba68a796-f347-4c80-a9f7-5a5e6d2ddc49
# ╟─3efa98cd-1b19-464e-8923-191e01b8d659
# ╟─4a59a504-b55a-45cb-a101-a518f6ace1f5
# ╟─374d32d1-2d91-44a7-8624-7ca9f6af32f8
# ╟─261f1a0d-a261-42fb-9c57-ea0ba1846282
# ╟─bd52785f-c057-4bc3-94ae-86e1dd773ba7
# ╟─91758932-ef9e-4265-b32b-1edb4c0a61d6
# ╟─79d23ca2-0034-4b04-997a-14a29e4c2df6
# ╟─28c92348-5d69-47cb-ace3-f5ca04447237
# ╟─9fb31e84-d4e1-4b37-ab4a-17f2dab7a5fe
# ╟─a8f1c7a9-3a9a-4ff5-9203-b2b7bac74dd2
# ╟─cb82c7ac-1a9e-4d5b-ab4d-fb384f66b2ec
# ╟─008fd9ac-c5b5-4f0c-bf44-3c0368e0d21d
# ╟─b8fee414-320c-4268-95b4-90e53700e0b8
# ╟─02a36bc7-a969-4d18-b742-2daa8076fff4
# ╟─d8177c39-6490-441a-aa3d-f9bb1cee5ee0
# ╠═8a77f33c-34ee-45e4-8693-468cb5c8a345
# ╠═a254f5c8-110a-4d11-9737-9e350a5e6a81
# ╟─5abc3c95-4cad-4671-8b29-1faa8bc81919
# ╟─b0fa6891-4626-4269-81c6-b118c8d41c48
# ╟─80d4795c-c278-4844-a2cd-d375bc9330d1
# ╟─32701e29-5a09-4ef5-b2f3-9be3e16fe411
# ╠═de52fc27-a144-4ad2-8c47-4444b5abbe0a
# ╟─90cd3a2f-1b66-410d-a4ef-4f0b3fac5047
# ╠═e5c408b1-8285-4898-988c-731ad1a59ecc
# ╠═ad915710-ef64-4aed-8514-f3214491b9ab
# ╠═888c35f5-a18b-454e-b7c6-0f51e5610aa0
# ╟─4a583be7-7ad9-4bc9-9788-ff5573eaac69
# ╠═a4f5dd94-acd3-4099-ab05-2e7f1e435ba3
# ╠═48386799-c121-4358-b7fa-3988ddd3c0ef
# ╠═416011b9-b4db-4c9e-9bfb-4dd105596733
# ╠═993ec4e0-df4d-4720-b256-40b6f3e91f55
# ╠═f9efc61e-3fc9-48a0-85c8-58f24550e308
# ╠═7780f241-b477-45ab-8287-1cd6b5409e13
# ╟─1ce4351a-e9fa-4e49-924b-b9d5146c20af
# ╠═9ae3fe47-4c53-48c1-a126-bad1d1615f01
# ╠═762ae276-0afa-4a37-877a-b3274df149d3
# ╠═8e1c0295-d7e1-4bb0-8e50-62a6e6992011
# ╟─a278c9af-3409-4bd2-b977-d21ef52aacc5
# ╠═44473d2a-a38b-449c-a739-6ac7025c6c27
# ╠═1948ca3e-619b-4a4f-938d-97d3d9b5de65
# ╠═8803ea22-6cdc-4e5b-85b3-f89a70f2e627
# ╟─64a04229-067d-448d-866e-15fae2938420
# ╟─525a91e4-9830-47ca-86dc-4bf0786b5df1
# ╠═80ade766-5d49-11ef-200e-c99f313ca7bc
# ╟─7e231820-c804-4581-8dcf-b5f9824931b3
# ╟─ca565680-2c1b-4a68-8877-0df94c7fe0a6
# ╟─9b72deef-6212-4b67-a314-8be3a983a73a
# ╟─ba4f4620-f98f-41e3-bfb5-9e704a93d98e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
