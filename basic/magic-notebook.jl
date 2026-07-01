### A Pluto.jl notebook ###
# v0.20.21

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://upload.wikimedia.org/wikipedia/commons/9/99/Colordblind-friendly-map.png"
#> language = "en-US"
#> title = "Magic Notebook 🔮"
#> tags = ["reactivity", " basics", "math", "art", "adaptibility"]
#> date = "2025-12-18"
#> description = "This is a notebook that adapts to you! "
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Boshra Ariguib"
#>     url = "https://github.com/ariguiba"

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

# ╔═╡ be844db0-bf12-11f0-3f35-a981c30c2bf5
using PlutoUI, PlutoTeachingTools, PlutoImageCoordinatePicker, Colors,ImageIO, ImageShow

# ╔═╡ d4a44096-79af-479f-994c-8de983feb76c
md"""
# Magic Notebooks 

Welcome to the magic notebook 🔮 This notebook can adapt to **you**, the reader! All you need to do is choose the right setting down here 👇 """

# ╔═╡ 26bd9a9d-b1f6-44a5-a716-34518b4c5ae4
aside(md"""
!!! tip "Check it out!! 😮"
	  👈 Look what happens here when you switch on beginner mode!""", v_offset=240)

# ╔═╡ 52cc92b0-ead0-4619-a623-a099170334a8
md"## Domain Coloring"

# ╔═╡ 1cedc786-1811-414f-9f02-63b478e70dab
md"""
Hey there 👋 Now if you're like me (or like most people), you probably didn't think of the word 'Art' first, because often we don't associate art🎨 with mathematics📏. And yet today we're going to see how we can create some beautiful (slightly trippy🌀) art by using **only** math. 

Are you ready? 💃
"""

# ╔═╡ 707e5bd4-9715-47e5-ab5f-9c99dac04962
md"👇 Start by chosing a function $f$ below:"

# ╔═╡ 1e37e7fb-b440-489f-a5bb-dce3fe8c1670
aside(md"""
!!! info "Check it out!! 😮"
	  👈 Now try switching on math mode and see what appears!""", v_offset=40)

# ╔═╡ 4b6a2002-f70a-4d39-ae44-a467650dc610
aside(md"""
!!! tip "Check it out!! 😮"
	  👈 What about here!!""", v_offset=90)

# ╔═╡ c923e948-10cb-44b7-967d-0c2f7fe32457
md"Great! Now let's choose our point $x$. To make thing more fun, we'll use complex numbers. If you don't know what that is, that's okay, for now you can think of it as a **2D point**"

# ╔═╡ 23ce42b5-0cc2-4448-b8fb-9123fe85f307
md"That's pretty boring and unintuitive to understand right? Isn't there a better way?

Well there is: let's use colors! 🎨

Now each point in our initial space has a *unique* position **and** a *unique* color. So we follow these steps: 

👉 We choose our point (or color) $x$ 🔴

👉 Calculate our function value $f(x)$ 

👉 Find the corresponding **color** for that value in the initial space 🔵

✨ Try it out!"

# ╔═╡ d30bc58b-0dbd-4b6e-95ed-24f9d6a1d13f
md"## Math Art 📏🎨"

# ╔═╡ 0b437583-f142-4844-9150-4db126105c0b
md" 👇Let's choose again a function "

# ╔═╡ 4c1ea556-72fb-4f5a-a1a0-b2af8e9fd22d
md"And tadaaa 🎉"

# ╔═╡ cea778b1-8cf9-4abb-8114-35fe36906351
md"# Appendix"

# ╔═╡ 8d330a5c-9db4-4016-90ab-2c82d4be09cb
md"### Functions and Code"

# ╔═╡ 82f80e24-5997-46d9-9c8b-e7e60780f4b0
function g(r)
	return (1.0 - 1.0 / (1 + r^2))^(0.2)
end


# ╔═╡ 80e596a3-d342-4ce4-8491-6314b56665cf
heatmap(cs) = cs

# ╔═╡ 99f769f3-5048-411e-93f4-1acc8694f306
md"### Tranformation functions"

# ╔═╡ 65443471-c43a-4c00-9733-99820b45e23e
f0(z) = z

# ╔═╡ 4f3c7400-c094-42a6-91f8-ae9868ff3893
f1(z) = (z^3 - 1) / z

# ╔═╡ 61f52c43-6ebf-47fb-91c1-d63ebef01bbf
f2(z) = (z - 0.5 - 0.5*1im) / z^2

# ╔═╡ b53f42b4-994f-4d88-a130-822ac4ff9dd0
f3(z) = 1/z

# ╔═╡ f5745a58-12a3-459a-b375-7ffacfb75ba0
f4(z) = sin(z)

# ╔═╡ fb79c857-0899-4658-afc3-8fcf2da2cf7b
f5(z) = z^9 - 1/ z^3 + 1

# ╔═╡ 5972906a-ab4c-42b7-8d6f-554361293f4d
function_chooser = @bind f Select([f1 => md"Cool f1", f2 => "Super cool f2", f3 => "Boring Inverse f3", f4 => "Fun sin f4", f5 => "Wild function"]);

# ╔═╡ 1d0ad3fe-8e13-4c68-b616-29883e28f2ee
function_chooser

# ╔═╡ d60c997e-f16f-4949-9a35-ef6245395152
function_chooser

# ╔═╡ b0c7f22b-d350-4ae1-b38f-e3e1a3392e26
# TODO: Probably a better more automated way to do this
function_names = Dict(
    f1 => md"$f_1(x) = (x^3 - 1) / x$",
    f2 => md"$f_2(x) = \frac{x - \frac{1}{2} (1 + i)}{x^2}$",
    f3 => md"$f_3(x) = 1/x$",
	f4 => md"$f_4(x) = sin(x)$",
	f5 => md"$f_5(x) = x^9 - 1/ x^3 + 1$",
)

# ╔═╡ f3463cbf-1841-4079-afbf-0f78a6007fba
md"### Functions for initial domain "

# ╔═╡ 2b49529e-b51d-4fd5-b078-63492e6ae82f
function g1(r)
	return (1.0 - 1.0 / (1 + r^2))^(0.2)
end

# ╔═╡ 7abe3aad-39b7-4d40-93c8-2f64c02a07ac
function g2(r)
    logm = log(r) / log(2) 
    logm = logm |> (r -> isnan(r) ? 0.0 : r) 
   
    return (logm - floor(logm))^0.3
end

# ╔═╡ 4fb45141-001f-4ce6-93ea-650c91862a3d
function g3(r)
	return 0.5 + 0.5*(r - floor(r))
end

# ╔═╡ 25e95390-0b20-457a-8fdf-18d87515f4b2
md"### Toggles"

# ╔═╡ 1c5e90d0-8c18-461d-9f3b-4531319607fb
math_mode = @bind math Switch()

# ╔═╡ 0baf3cbd-3f16-4b91-befd-960abff1ed70
if math
	md"Your currently chosen function is: $(function_names[f])"
end

# ╔═╡ f3a37fc0-cd93-41e3-b3b6-dcf33b578c5f
if math
md"Your currently chosen function is: $(function_names[f])"
end

# ╔═╡ 150de310-3969-46cc-8ace-1b3d9aafbb6f
beginner_mode = @bind beginner Switch()

# ╔═╡ 6daac7c1-efd8-4200-aa3a-d564bcf687c3
md""" 
Switch me on $beginner_mode  if you are a beginner 

Switch me on $math_mode if you want to see the math 
"""

# ╔═╡ 6eb87aab-3f89-4824-b953-e140199bc33a
if beginner

md"""
### 2D Functions
	
You (hopefully) know from school, that we can define a function for a number, such as $f(x) = 2x$ which just basically means for any number $x$ ❗ we want our function $f$ to double ‼️ that value. So functions are nothing more than just a **transformation** of the numbers! There are countless functions in math, in fact they kind of define the very basics of mathematics 😉"""

end

# ╔═╡ 788a6961-f926-4cf8-bccd-a6f3e80f1e70
if beginner md"👇 Click anywhere to chose a point!" end

# ╔═╡ f0fbdc00-54a6-4ab0-a52c-134a240939f7
if beginner 
md"""To finally create our art pieces, all we have to do is repeat the same thing we did so far for **all** the points in our 2D space. So instead of checking the values for each point one by one, we will do the following: 

👉 Go over each point in the initial drawing one by one 🔵

👉 Apply the transformation from above 📏

👉 Put in the transformed color 🔴 in the place of the original one in the new drawing
"""
end

# ╔═╡ 5d3a2612-18b2-4a51-87ba-6bfc7a6130d3
colorblind_mode = @bind colorblind Switch()

# ╔═╡ f6067289-8664-4600-ad33-35dd9cc7b154
aside(md"""
!!! tip "Color-blind friendly 🎨"
	Toggle me $colorblind_mode to increase contrast between neighboring regions. This also uses color-blind friendly colors :) 
	  
	  ⚠ The mapping is not unique now! If a point is colored in green, we don't know if it's the upper right or middle left green value meant. """, v_offset=30 )

# ╔═╡ 7c7b6eb0-0e83-4333-968f-3fb9223e4d13
md"### Number Picker from `PlutoImageCoordinatePicker`"

# ╔═╡ f51b5948-7338-4808-9d6c-e5d2b10251fa
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

# ╔═╡ c83cd5db-598b-491b-a723-7df10fb11d53
begin
	struct SVG
		content
	end

	function Base.show(io::IO, m::MIME"image/svg+xml", s::SVG)
		write(io, s.content)
	end

	SVG
end

# ╔═╡ 962a0b57-ecdd-4abd-92a7-a9f75bbe64cd
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

# ╔═╡ f10023d7-d957-424d-9582-7e68a9a3c5e0
c_fractal_picker = @bind x ComplexNumberPicker(im_axes, default=-.04+.72im);

# ╔═╡ 5dfe9168-f4a1-48c7-aaff-01cd878c0c17
c_fractal_picker

# ╔═╡ 3c1a7943-d218-46cf-89d2-7d273e3eb730
md"### Coloring and Formating"

# ╔═╡ 66a10c3b-c1e8-4641-958a-e5a9908711ff
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

# ╔═╡ 674c2efc-4642-4c46-ba6a-45dbddd6b0f4
begin
x_trim = trim_c(x)
fx = trim_c(f(x))
end;

# ╔═╡ cd1d54a2-b64a-4ef4-9998-a337ee5e37d3
if beginner
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
end

# ╔═╡ bf3c888d-fa1e-4d2d-a2e9-bcb47b7920a9
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

# ╔═╡ 887f4c87-47ce-479e-b20f-3171f64b1cfa
# Calculates the colors for the whole domain
function color_domain(f::Function, g::Function; v::Real=1.0) 
	# Create complex grid z = x + 1im*y (NICE JULIA WAY TO DO THIS)
	depth = 300
	x = range(-1.25,1.25,length=depth)
	y = range(-1.25,1.25,length=depth)
	grid = x' .- 1im .* y
	Z = f.(grid)
	
	# Colorblind-friendly palette
	colorblind_hues = [210, 30, 270, 60, 180, 330]

	# Function to map angle to colorblind-friendly hue
	function map_to_colorblind_hue(angle)
		# Ensure angle is in [0, 360]
		angle = mod(angle, 360)
		# Normalize angle to [0, 1]
		normalized = angle / 360
		# Map to palette index
		segment = normalized * length(colorblind_hues)
		idx = mod(floor(Int, segment), length(colorblind_hues)) + 1
		next_idx = mod(idx, length(colorblind_hues)) + 1
		
		# Interpolate between adjacent colors
		t = segment - floor(segment)
		return colorblind_hues[idx] * (1 - t) + colorblind_hues[next_idx] * t
	end
		
	# Compute H (hue), S (saturation), V (value)
	angles = rad2deg.(angle.(Z)) # Convert to degrees
	if colorblind
		H = map_to_colorblind_hue.(angles) # Map to colorblind-friendly hues
	else
		H = rad2deg.(angle.(Z)) # Convert to degrees angle 
	end
	S = v * ones(size(H)) # Constant saturation
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

# ╔═╡ d246dbb7-9fbc-49d8-9b86-e78a33e8a288
standard_domain = heatmap(color_domain(f0, f0));

# ╔═╡ 5cfb95df-6418-4747-8350-3ea5bb27df2c
c_picker_colored = @bind x_colored ComplexNumberPicker(standard_domain, default=-.04+.72im);

# ╔═╡ d66ef0b3-7c1a-4524-b188-cfe61fe1ff83
begin
	x_col_trimed = trim_c(x_colored); x_color = color_value(x_colored, g)
	fx_colored = trim_c(f(x_colored)); fx_color = color_value(fx_colored, g)
end;

# ╔═╡ 9d307da9-f5ac-478f-a3a5-1d623dc56a80
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

# ╔═╡ 665ddd8e-dc5b-4925-a283-aebe7d16592c
begin
	v = 0.9
	domain = heatmap(color_domain(f0, g; v)) # f0 is the identity functionn
	rgb_image = heatmap(color_domain(f, g; v))
	PlutoTeachingTools.Columns(domain, rgb_image)
end

# ╔═╡ 104139ad-6423-44b5-99b6-022ac5003154
md"### RGB to HSV"

# ╔═╡ bd210be7-6f2b-4313-9f54-3b6129a2508f
intensity_picker_circle = @bind v_circle PlutoUI.Slider(0:0.05:1, default=0.9, show_value=true)

# ╔═╡ f6d74dca-e4a2-4f3d-95c3-6defd219f359
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

# ╔═╡ 1da45205-794c-4982-b809-4dadfe90a2a0
let
n = 500  # Size of image
img = Array{RGB{Float64}, 2}(undef, n, n) # Initialize array

# Define the center of the circle
center = (n / 2, n / 2)
radius = n / 2

# Colorblind-friendly palette (these hues work well for most types of color blindness)
# Using colors that are distinguishable: blue, orange, purple, yellow-green
colorblind_hues = [
    210,  # Blue
    30,   # Orange
    270,  # Purple
    60,   # Yellow-green
    180,  # Cyan
    330,  # Magenta
]

# Function to map angle to colorblind-friendly hue
function map_to_colorblind_hue(angle)
    # Normalize angle to [0, 1]
    normalized = angle / 360
    # Map to palette index
    segment = normalized * length(colorblind_hues)
    idx = floor(Int, segment) % length(colorblind_hues) + 1
    next_idx = (idx % length(colorblind_hues)) + 1
    
    # Interpolate between adjacent colors
    t = segment - floor(segment)
    return colorblind_hues[idx] * (1 - t) + colorblind_hues[next_idx] * t
end

# Fill the image
for x in 1:n
    for y in 1:n
        # Coordinates
        tcx = (x - center[1]) / radius
        tcy = (y - center[2]) / radius
        distance = sqrt(tcx^2 + tcy^2)
        
        # Check if the point is within the circle
        if distance <= 1.0
            # Get the angle (in degrees)
            angle = atan(tcy, tcx) * 180 / π 
            angle = angle < 0 ? angle + 360 : angle  # Ensure angle is in [0, 360]
            
            # Map to colorblind-friendly hue
            hue = map_to_colorblind_hue(angle)
            
            # Calculate saturation based on the distance from the center
            saturation = distance
            
            # Get value using the slider
            value = v_circle
            
            # Convert HSV to RGB
            color = HSV(hue, saturation, value)
            # Set the pixel color
            img[x, y] = RGB(color)
        else
            # Outside the circle, set the pixel to white
            img[x, y] = RGB(1, 1, 1)
        end
    end
end

# Show wheel
img
end

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
Colors = "~0.13.1"
ImageIO = "~0.6.9"
ImageShow = "~0.3.8"
PlutoImageCoordinatePicker = "~1.4.2"
PlutoTeachingTools = "~0.4.6"
PlutoUI = "~0.7.76"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.2"
manifest_format = "2.0"
project_hash = "77750a01c86041d0e62e249efd8313aeea2ef5fb"

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
git-tree-sha1 = "4126b08903b777c88edf1754288144a0492c05ad"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.8"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "8b3b6f87ce8f65a2b4f857528fd8d70086cd72b1"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.11.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.DataStructures]]
deps = ["OrderedCollections"]
git-tree-sha1 = "e357641bb3e0638d353c4b29ea0e40ea644066a6"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.3"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "d60eb76f37d7e5a40cc2e7c36974d864b82dc802"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.17.1"

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

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

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
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

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
git-tree-sha1 = "d966f85b3b7a8e49d034d27a189e9a4874b4391a"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.13"

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
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "9496de8fb52c224a2e3f9ff403947674517317d9"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.6"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6893345fd6658c8e475d40155789f4860ac3b21"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.4+0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

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
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

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
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

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
git-tree-sha1 = "0ee4497a4e80dbd29c058fcee6493f5219556f40"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.3"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

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
version = "2025.5.20"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

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
version = "0.3.29+0"

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

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

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

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.0"
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
git-tree-sha1 = "07038a9658bfc6607ab27d26663c3b7a181f4025"
uuid = "79686372-6169-7274-6170-6568746b6366"
version = "1.4.2"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoUI"]
git-tree-sha1 = "dacc8be63916b078b592806acd13bb5e5137d7e9"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.4.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "0d751d4ceb9dbd402646886332c2f99169dc1cfd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.76"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "522f093a29b31a93e34eaea17ba055d850edea28"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "fbb92c6c56b34e1a2c4c36058f68f332bec840e7"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.11.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "472daaa816895cb7aee81658d4e7aec901fa1106"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
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
git-tree-sha1 = "e24dc23107d426a096d3eae6c165b921e74c18e4"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.2"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "be8eeac05ec97d379347584fa9fe2f5f76795bcb"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.5"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "0494aed9501e7fb65daba895fb7fd57cc38bc743"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.5"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be1cf4eb0ac528d96f5115b4ed80c26a8d8ae621"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.2"

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
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "PrecompileTools", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "98b9352a24cb6a2066f9ababcc6802de9aed8ad8"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.6"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

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
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "de8ab4f01cb2d8b41702bab9eaad9e8b7d352f73"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.53+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[deps.libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "4e4282c4d846e11dce56d74fa8040130b7a95cb3"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.6.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.7.0+0"
"""

# ╔═╡ Cell order:
# ╟─d4a44096-79af-479f-994c-8de983feb76c
# ╟─6daac7c1-efd8-4200-aa3a-d564bcf687c3
# ╟─26bd9a9d-b1f6-44a5-a716-34518b4c5ae4
# ╟─52cc92b0-ead0-4619-a623-a099170334a8
# ╟─1cedc786-1811-414f-9f02-63b478e70dab
# ╟─6eb87aab-3f89-4824-b953-e140199bc33a
# ╟─707e5bd4-9715-47e5-ab5f-9c99dac04962
# ╟─1d0ad3fe-8e13-4c68-b616-29883e28f2ee
# ╟─1e37e7fb-b440-489f-a5bb-dce3fe8c1670
# ╟─0baf3cbd-3f16-4b91-befd-960abff1ed70
# ╟─4b6a2002-f70a-4d39-ae44-a467650dc610
# ╟─c923e948-10cb-44b7-967d-0c2f7fe32457
# ╟─788a6961-f926-4cf8-bccd-a6f3e80f1e70
# ╟─f10023d7-d957-424d-9582-7e68a9a3c5e0
# ╟─cd1d54a2-b64a-4ef4-9998-a337ee5e37d3
# ╟─674c2efc-4642-4c46-ba6a-45dbddd6b0f4
# ╟─23ce42b5-0cc2-4448-b8fb-9123fe85f307
# ╟─9d307da9-f5ac-478f-a3a5-1d623dc56a80
# ╟─d66ef0b3-7c1a-4524-b188-cfe61fe1ff83
# ╟─d246dbb7-9fbc-49d8-9b86-e78a33e8a288
# ╟─5cfb95df-6418-4747-8350-3ea5bb27df2c
# ╟─d30bc58b-0dbd-4b6e-95ed-24f9d6a1d13f
# ╟─f0fbdc00-54a6-4ab0-a52c-134a240939f7
# ╟─0b437583-f142-4844-9150-4db126105c0b
# ╟─d60c997e-f16f-4949-9a35-ef6245395152
# ╟─f3a37fc0-cd93-41e3-b3b6-dcf33b578c5f
# ╟─f6067289-8664-4600-ad33-35dd9cc7b154
# ╟─4c1ea556-72fb-4f5a-a1a0-b2af8e9fd22d
# ╟─665ddd8e-dc5b-4925-a283-aebe7d16592c
# ╟─cea778b1-8cf9-4abb-8114-35fe36906351
# ╠═be844db0-bf12-11f0-3f35-a981c30c2bf5
# ╟─8d330a5c-9db4-4016-90ab-2c82d4be09cb
# ╟─82f80e24-5997-46d9-9c8b-e7e60780f4b0
# ╟─5972906a-ab4c-42b7-8d6f-554361293f4d
# ╟─b0c7f22b-d350-4ae1-b38f-e3e1a3392e26
# ╟─80e596a3-d342-4ce4-8491-6314b56665cf
# ╟─99f769f3-5048-411e-93f4-1acc8694f306
# ╟─65443471-c43a-4c00-9733-99820b45e23e
# ╟─4f3c7400-c094-42a6-91f8-ae9868ff3893
# ╟─61f52c43-6ebf-47fb-91c1-d63ebef01bbf
# ╟─b53f42b4-994f-4d88-a130-822ac4ff9dd0
# ╟─f5745a58-12a3-459a-b375-7ffacfb75ba0
# ╟─fb79c857-0899-4658-afc3-8fcf2da2cf7b
# ╟─f3463cbf-1841-4079-afbf-0f78a6007fba
# ╟─2b49529e-b51d-4fd5-b078-63492e6ae82f
# ╟─7abe3aad-39b7-4d40-93c8-2f64c02a07ac
# ╟─4fb45141-001f-4ce6-93ea-650c91862a3d
# ╟─25e95390-0b20-457a-8fdf-18d87515f4b2
# ╟─1c5e90d0-8c18-461d-9f3b-4531319607fb
# ╟─150de310-3969-46cc-8ace-1b3d9aafbb6f
# ╟─5d3a2612-18b2-4a51-87ba-6bfc7a6130d3
# ╟─7c7b6eb0-0e83-4333-968f-3fb9223e4d13
# ╟─5dfe9168-f4a1-48c7-aaff-01cd878c0c17
# ╟─f51b5948-7338-4808-9d6c-e5d2b10251fa
# ╟─c83cd5db-598b-491b-a723-7df10fb11d53
# ╟─962a0b57-ecdd-4abd-92a7-a9f75bbe64cd
# ╟─3c1a7943-d218-46cf-89d2-7d273e3eb730
# ╟─66a10c3b-c1e8-4641-958a-e5a9908711ff
# ╟─bf3c888d-fa1e-4d2d-a2e9-bcb47b7920a9
# ╟─887f4c87-47ce-479e-b20f-3171f64b1cfa
# ╟─104139ad-6423-44b5-99b6-022ac5003154
# ╟─bd210be7-6f2b-4313-9f54-3b6129a2508f
# ╟─f6d74dca-e4a2-4f3d-95c3-6defd219f359
# ╟─1da45205-794c-4982-b809-4dadfe90a2a0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
