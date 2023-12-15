### A Pluto.jl notebook ###
# v0.19.36

#> [frontmatter]
#> title = "Visualizing the Collatz Conjecture "
#> description = "Explore this cool math problem and create your own visualization!"
#> tags = ["math", "interactive visualization", "collatz conjecture", "edmond harris"]
#> image = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Collatz_Conjecture_Vizualization.png/600px-Collatz_Conjecture_Vizualization.png?20231214223051"
#> date = "2023-12-14"
#> license = "Unlicense"
#> licence_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Chris Damour"
#>     url = "https://github.com/damourChris"

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

# ╔═╡ c5673bfa-d2b0-4893-ad88-42a5b81f27b4
begin
	using Collatz
	using Graphs
	using FixedPointNumbers 
	md"""
	!!! info "Numerical Packages"
		[Collatz](https://juliapackages.com/p/collatz): This package provide the methods to generate the hailstone sequence, the tree graph and stopping time for the collatz conjecture. 
	
		[Graphs](https://www.juliapackages.com/p/graphs): Used to deal with creating and modifying graphs. 
	
		[FixedPointNumbers](https://www.juliapackages.com/p/fixedpointnumbers): Package to deal with fixed point number, only used to handle colors.
	"""
end

# ╔═╡ e4a76493-9aea-4379-9a56-6a9b9e8d6b54
begin
	# Notebook related packages
	using PlutoUI
	import PlutoUI: combine
	using HypertextLiteral:@htl
	using Parameters
	md"""
	!!! info "Notebook Packages"
		[PlutoUI](https://www.juliapackages.com/p/PlutoUI): Extension for Pluto to handle interactivity, provides the Sliders, Checkboxes and Color Picker. 
	
		[HypertextLiteral](https://www.juliapackages.com/p/HypertextLiteral): Drawing library, specifically for graphs.
	
	"""
end

# ╔═╡ 13f52ec2-16b9-41a5-9560-177ca827a72e
begin
	using Plots
	using Colors
	using Luxor
	using Karnak, NetworkLayout
	using ImageIO ,ImageShow
	gr()
	md"""
	!!! info "Ploting Packages"
		[Plots](https://www.juliapackages.com/p/plots): Plotting library for the several plots in the notebook.
		
		[Luxor](https://www.juliapackages.com/p/luxor): Drawing library used for the visualiation.
	
		[Karnak](https://www.juliapackages.com/p/karnak): Drawing library, specifically for graphs.
	
		[NetworkLayout](https://www.juliapackages.com/p/networklayout): Used to compute the layout of the graphs.
		
		[ImageIO](https://www.juliapackages.com/p/ImageIO): Used to faciliate the handling of images.
		
		[ImageShow](https://www.juliapackages.com/p/ImageShow): Enhances the displaying of the images in the interactive visualization and the gallery.
	"""
end

# ╔═╡ e60fcc3e-312c-4546-9b04-e6b558ba752a
TableOfContents()

# ╔═╡ 5328c6f3-2ae7-4449-a2a2-b6803cec0dcc
md"""
$(Resource("https://static.wixstatic.com/media/a27d24_08a39705c99d40c6b764c9b8d699b71a~mv2.jpg/v1/fit/w_900%2Ch_1000%2Cal_c%2Cq_80/file.jpg", :height => 500))
Visualization of the Collatz Conjecture by [Edmund Harris](https://maxwelldemon.com/)
# The Collatz Conjecture
> "Mathematics may not be ready for such problems." - Paul Erdos
"""

# ╔═╡ 822a3646-be9d-4b1c-a189-550bd8b56ab7
md"# Introduction"

# ╔═╡ 0bc0ea95-585d-43be-b7ac-c33a2a7417b4
md"""

The [Collatz Conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture), also known as the 3x+1 problem, is a fascinating mathematical puzzle that has been named after the German mathematician [Lothar Collatz](https://en.wikipedia.org/wiki/Lothar_Collatz). This conjecture arises from an iterative process where you start with any positive integer and alternate between two simple rules: 
- if the number is *even*, you divide it by 2,
- and if it's *odd*, you multiply it by 3 and add 1. 

For example, take the number 3. It's odd, so we multiply by 3 and add 1. We get 10. Now that's even, so we can divide it by 2, to get 5. Back to odd, so let's multiply that by 3 and add 1. We are now at 16, which is *very* even. So much so that we can keep on dividing by 2 until we reach 1. 

``3 \rightarrow 10 \rightarrow 5 \rightarrow 16 \rightarrow 8 \rightarrow 4 \rightarrow 2 \rightarrow 1``

What happens when we reach 1? Well, it's odd so we multiply by 3 and add 1. And we are back at 4, which leads back to one. We have reached a cycle. 

`` 4 \rightarrow 2 \rightarrow 1 \rightarrow  4 \rightarrow 2 \rightarrow 1  \ldots``


##### The question is, can you predict what the number will be after a certain number of iterations?
#####

The conjecture is that no matter what starting number you choose, **regardless** of its size, you will **always** reach the number 1. 

However, despite being relatively simple to understand and easy to test for small numbers, it has so far proven difficult to prove definitively for all cases. This conjecture is an unsolved problem in mathematics that continues to intrigue both mathematicians and enthusiasts alike.

"""

# ╔═╡ bdd54208-1f66-45da-9e67-9479cc460863
md"---"

# ╔═╡ 81db5594-75c0-4bfb-8908-ef8084559123
md"## The Hailstone Sequence"

# ╔═╡ b3c9453e-3198-4697-966f-ade21f2255ce
md"""
The sequence of values that you go through when iterating a number is often called the hailstone sequence, as the numbers go up and down through the sequence. 
"""

# ╔═╡ 10ab31ff-2d28-4ac3-a118-654f8366768e
@htl(""" <div style="display: flex;padding: .5rem; gap: 10px"> <div>Animate?</div><div> $(@bind animate_hailstone PlutoUI.CheckBox(default=true))</div> </div>""")

# ╔═╡ 75b9294e-43a4-48c4-b493-5d40027f3cd6
md"## The Collatz Graph"

# ╔═╡ 12d218ee-9a43-4647-a96b-c9252c665fa0
md"""

We can visualize the path that each number takes with a graph. 


"""

# ╔═╡ 6f68b20d-67e5-4872-a23b-1840bbbb06ec
md"## The stopping time of a number"

# ╔═╡ 6a45247d-25db-445f-a687-191c0952c6c4
md"""At first it might seem that the fact that it *always* reaches 1 could appear strange, as some numbers get caught in a repeating pattern of multiplying by 3 and adding one, when dividing by 2, give a another odd number. Since:

``
\begin{aligned} x < \frac{3x + 1}{2} \end{aligned}
``

Thus, it's possible (and quite frequent) that we end going up in numbers, and looks like we are getting further away from the pit of doom that is the number 1. 

However, this is unfortunately not the case, but we quantify this by calculating how long it takes for a number to reach a another number that is lower than the starting point: the stopping time. 

Here is a plot to show the total stopping times of the numbers for up to 1000. 
"""



# ╔═╡ d0672735-8007-4a69-9fa5-0f40ac0685ea
md"# Interactive Visualization"

# ╔═╡ aef6cb43-61c7-4436-ad66-7e7f0459610d
@htl("""
<div class="slider_group_inner">
Filename: 
				$(@bind filename PlutoUI.TextField(default="MyCoolVisualization"))
				
			</div>
""")

# ╔═╡ b56a1328-194c-4e1c-a033-9ca6e0ab3eeb
md"---"

# ╔═╡ 6e359db6-581f-4a5a-a0a7-6924faf19653
md"> Of course, we are not limited to the 3x + 1 problem, what happens if we change up those values?"

# ╔═╡ dc1dba7c-8c0d-4609-882a-e5703c467fef
md"# Generalizing the Collatz function"

# ╔═╡ b9277abb-7a14-4479-8bcb-6a50df27182b
md"""
A generalization of the collatz function is the following:

``
	g(n) = n/P \ \ \ \ \ \ \ \text{when}\ \ \ n \ \text{mod}\ P = 0
``

``
	g(n) = an+b \ \ \ \text{otherwise}
``

This formulation makes sure that we always deal with integers.

"""

# ╔═╡ 0e85d872-ef01-463e-b395-b0797c96317e
@htl("""
<div style="padding: .5rem">
	<div>
	<h4>
	Want to generalize the parameters? $(@bind do_generalize_collatz PlutoUI.CheckBox())
	</h4>
	
	</div>
	<div>
	<b>Note</b>: This will update all the plots and visualizations in the notebook. 
</div>
</div>

""")

# ╔═╡ 1c3f1bea-f1ba-4d64-90ad-584391c01da5
begin
	generalize_checkbox = @bind generalize_collatz MultiCheckBox(["Hailstone Sequence", "Graph", "Stopping Time", "Interactive"], default=["Interactive"])
	if(do_generalize_collatz)
		generalize_checkbox
	end
end

# ╔═╡ 5f074850-b967-4de5-8ca3-b85a74052499
begin
	generalize_collatz
	stopping_times = Dict();
end;

# ╔═╡ af0c36ee-0534-4143-b59b-4ee041ef0f04
do_generalize_collatz ? md"""
!!! warning "Divergence"
	Some parameters will not behave as the traditional problem and will lead to some numbers diverging up to infinity. In that case, the calculations will stop at a stopping time of 1000. However, this still can still result in high latency so beware! .
""" : md""

# ╔═╡ 16d57341-6c55-4440-bdeb-492b4d0c4427
md"# Gallery"

# ╔═╡ 5655a706-2c53-4763-b8c5-e21aa3e72371
md"While playing around with the viusalization, I stumbled into some nice patterns that I wanted to share with you! I added the parameters in case you want to recreate them. Enjoy :)

*(Note that the parameters are highly dependent on the size of the canvas so it might not be trivial to reproduced)*"

# ╔═╡ b7b80bd8-7a16-4483-9b8f-b6a8da531b0a


# ╔═╡ 3e9a6e74-a0ab-4c47-b493-4670fa828c45
md"---"

# ╔═╡ 546a2cf6-f54a-4482-9da5-af9d966b22eb
md"---"

# ╔═╡ cdfb638b-a04c-482c-9206-47f7dfd63766
md"# Appendix"

# ╔═╡ 3e6323cb-4b09-4fe9-a223-8c66cb0d3efc
md"""
Here a list of extra ressources in case you want to learn more. They inspired me a lot through this notebook so hope you find them usefull!


- [Wikipedia page](https://en.wikipedia.org/wiki/Collatz_conjecture)
- [The Numberphile video](https://www.youtube.com/watch?v=5mFpVDpKX70) ( [and the extras](https://www.youtube.com/watch?v=O2_h3z1YgEU) )
- [The Coding Train](https://www.youtube.com/watch?v=EYLWxwo1Ed8)
- [This amazing post from Luc Blassel] (https://lucblassel.com/posts/visualizing-the-collatz-conjecture/)
- [Edmund Harris's website](https://maxwelldemon.com/) 
"""

# ╔═╡ 0fdafbdc-a6aa-42a6-a899-41b351b5e7e8
md"## Packages"


# ╔═╡ 091d8f63-d02a-48fa-be0c-e9e027409279
md"## Custom Types"

# ╔═╡ 8c854d1c-2f89-43f0-a810-ce174cf94af8
"""
A struct to store parameters related to the visualization

```julia
num_traject::Int64 = 100.0
line_length::Float64 = 20.0
turn_scale::Float64  = 10.0
init_angle::Float64 = 90.0
x_start::Float64 = 250.0
y_start::Float64 = 500.0
window_width::Float64 = 500.0
window_height::Float64 = 500.0
stroke_width::Float64 = 2.0
stroke_color::Colors.RGBA = RGBA(1.0,1.0,1.0,1.0)
background_color::Colors.RGBA = RGBA(0.0,0.0,0.0,1.0)
vary_shade::Bool = false
random_shade::Bool = false
edmund_style::Bool = false
```
"""
@with_kw struct VisualizationParameters
	num_traject::Int64 = 100.0
	line_length::Float64 = 20.0
	turn_scale::Float64  = 10.0
	init_angle::Float64 = 90.0
	x_start::Float64 = 250.0
	y_start::Float64 = 500.0
	window_width::Float64 = 500.0
	window_height::Float64 = 500.0
	stroke_width::Float64 = 2.0
	stroke_color::Colors.RGBA = RGBA(0.0,0.0,0.0,1.0)
	background_color::Colors.RGBA = RGBA(1.0,1.0,1.0,1.0)
	vary_shade::Bool = false
	random_shade::Bool = false
	edmund_style::Bool = false
	chris_style::Bool = false
end

# ╔═╡ 9803f163-0027-4577-af8f-c66de195d182
md"## Functions"

# ╔═╡ 1e85c1af-3318-4f20-a358-25aa0999dc8a
"""
	hailstone_sequences(range::UnitRange{Int64}; P::Int=2, a::Int=3, b::Int=1 )

Extension for the `hailstone_sequence()` method from Collatz.jl to calculate list of hailstone sequence given a UnitRange. 

## Args

- `range::UnitRange{Int64}`: Unit Range in which to calculate the hailstone sequences.


## Kwargs

- `P::Integer = 2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer = 3`: Factor by which to multiply n.
- `b::Integer = 1`: Value to add to the scaled value of n.

## Examples
```jldoctest
julia> hailstone_sequences(2:5) 
[[2, 1], [3, 10, 5, 16, 8, 4, 2, 1], [4, 2, 1], [5, 16, 8, 4, 2, 1]]
```
```jldoctest
julia> hailstone_sequences(1:5; P=4, a=1, b=3)
[[1], [2, 5, 8, 2], [3, 6, 9, 12, 3], [4, 1], [5, 8, 2, 5]]
```

## See also
[`hailstone_sequence`](@ref), [`reverse_hailstone_sequences`](@ref)
"""
function hailstone_sequences(range::UnitRange{Int64}; P::Int=2, a::Int=3, b::Int=1 )
	return [ 
				hailstone_sequence(starting_number; P, a, b, verbose =false)  
			
			for starting_number in range
		]
end

# ╔═╡ 40dd9659-abb9-4484-b5f1-f332e2abe90e
"""
	reverse_hailstone_sequences(range::UnitRange{Int64}; P::Int=2, a::Int=3, b::Int=1)
This function wraps the `hailstone_sequence()` method from Collatz.jl to calculate list of hailstone sequence given a UnitRange. 

It return the reversed sequence where the endpoint is the first element of the result.

## Args

- `range::UnitRange{Int64}`: Unit Range in which to calculate the hailstone sequences.


## Kwargs

- `P::Integer = 2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer = 3`: Factor by which to multiply n.
- `b::Integer = 1`: Value to add to the scaled value of n.

## Examples
```jldoctest
julia> hailstone_sequences(2:5) 
[[1, 2], [1, 2, 4, 8, 16, 5, 10, 3], [1, 2, 4], [1, 2, 4, 8, 16, 5]]
```
```jldoctest
julia> hailstone_sequences(1:5; P=4, a=1, b=3)
[[1], [2, 8, 5, 2], [3, 12, 9, 6, 3], [1, 4], [5, 2, 8, 5]]
```

## See also
[`hailstone_sequence`](@ref), [`hailstone_sequences`](@ref)
"""
function reverse_hailstone_sequences(range::UnitRange{Int64}; P::Int=2, a::Int=3, b::Int=1 )
	return [ 
				reverse(hailstone_sequence(starting_number; P, a, b, verbose =false))
			for starting_number in range
		]
end

# ╔═╡ f02affaa-534b-4c72-81ae-c42ca3b455fd
md"### Collatz"

# ╔═╡ 4c991173-d9ff-4ba9-b217-8f9aafbbd631
shortcut_collatz_cache = Dict{Int, Vector{Int}}()

# ╔═╡ 240b4cc1-1bae-429b-863b-792897cd555b
ultra_shortcut_collatz_cache = Dict{Int, Vector{Int}}()

# ╔═╡ 23be8efa-b907-453f-9245-8bc46a37ad26
"""
	shortcut_collatz(n::Int)

Calculate the collatz sequence of a number using the shortcut formulation:
g(n) = (3n + 1) / 2 if odd and g(n) = n / 2 if even

"""
function shortcut_collatz(n::Int)
   if n == 1
	   return [1]
   elseif haskey(shortcut_collatz_cache, n)
	   return shortcut_collatz_cache[n]
   elseif n % 2 == 0
	   sequence = [n, shortcut_collatz(n ÷ 2)...]
	   shortcut_collatz_cache[n] = sequence
	   return sequence
   else
	   sequence = [n, shortcut_collatz(Int((3n + 1)/2))...]
	   shortcut_collatz_cache[n] = sequence
	   return sequence
   end
end


# ╔═╡ a1a6130d-771a-43d7-ae94-049e3c9b81b3
"""
	ultra_shortcut_collatz(n::Int)

Calculate the collatz sequence of a number using the absolute shortcut formulation:
g(n) = (3n + 1) / 2^k  if odd where k is the highest power that divides 3n+1 and g(n) = n / 2 if even

"""
function ultra_shortcut_collatz(n::Int)
   if n == 1
	   return [1]
   elseif haskey(ultra_shortcut_collatz_cache, n)
	   return ultra_shortcut_collatz_cache[n]
   elseif n % 2 == 0
	   
	   while n % 2 == 0
		   n = n ÷ 2
	   end
	   
	   if n == 1 return [1] end
	   sequence = [n, ultra_shortcut_collatz(3n + 1)...]
	   ultra_shortcut_collatz_cache[n] = sequence
	   return sequence
   else
	   sequence = [n, ultra_shortcut_collatz(Int((3n + 1)/2))...]
	   ultra_shortcut_collatz_cache[n] = sequence
	   return sequence
   end
end


# ╔═╡ 3153ba89-f2d4-4e31-9e79-00ec5ecbb91c
"""
	descend_tree!(g::SimpleGraph{Int64}, record::Array{Tuple{Number,Number}},  tree::Dict, previous::Number=collect(keys(tree))[1], depth::Int=0)
	
This function is used to explore the tree return by `tree_graph` from Collatz.jl and modify the graph g given as input. 

## Args 
- `g::SimpleGraph`: The graph to modify 
- `record::Array{Tuple{Number,Number}}`: An array that keeps track of each of the encountered values. Each value is stored as (depth, value) in order to keep track of what depth the value was encountered
- `tree::Dict`: The tree graph returned by `tree_graph` 
- `previous::Number`: The number passed by the previous call to the function 
- `depth::Int`: The current depth of the search  
"""
function descend_tree!(g::SimpleGraph{Int64}, record::Array{Tuple{Number,Number}},  tree::Dict, previous::Number=collect(keys(tree))[1], depth::Int=0)
	
	# loop over each branch
	for key in  keys(tree)
		
		add_vertex!(g)
		
		# check if previous number exist in record
		previous_index = findfirst(x -> x == previous, map(x -> x[2], record))
		
		# if exist, create a edge in the graph 
		isnothing(previous_index) ? "" : add_edge!(g, previous_index, length(record)+1)

		# this check is there cos when reaching a cycle the tree has a non number key
		if(isa(key, Number))
			push!(record, (depth, key))
		end

		# call recursively to continue descending the tree 
		descend_tree!(g, record,tree[key], key, depth +1)
	end
	# end
end


# ╔═╡ b79405c3-42d1-4289-bbc3-67b6eae2b135
"""
	descend_tree!(g::SimpleGraph{Int64}, record::Array{Tuple{Number,Number}},  key::Int64, previous::Collatz._CC.CC, depth::Int=0)

To handle the case where the search hits a cycle and previous is of type Collatz._CC.CC

## Args 

- `g::SimpleGraph`: The graph to modify 
- `record::Array{Tuple{Number,Number}}`: An array that keeps track of each of the encountered values
- `tree::Dict`: The tree graph returned by `tree_graph` 
- `previous::Collatz._CC.CC`: The cycle value.
- `depth::Int`: The current depth of the search  

"""
function descend_tree!(g::SimpleGraph{Int64}, record::Array{Tuple{Number,Number}},  key::Int64, previous::Collatz._CC.CC, depth::Int=0)
	
	# check if previous number exist in record
	previous_index = findfirst(x -> x == previous, map(x -> x[2], record))

	# if exist, create a edge in the graph 
	isnothing(previous_index) ? "" : add_edge!(g, previous,  length(record)+1)

	# push key in record 
	push!(record, (depth, key))
	return
end

# ╔═╡ 319d784b-c62d-4f28-a5b3-ebf89c892afc
"""
	make_collatz_graph(initial_value::Int, max_orbit_distance::Int; P=2, a=3, b=1)

This function returns a graph that represent the different branches that each number takes.

## Args

- `initial_value::Integer`: The starting value of the directed tree graph.

- `max_orbit_distance::Integer`: Degree of seperation between the initial value and each value encountered. 

## Kwargs

- ```P::Integer=2```: Modulus used to devide n, iff n is equivalent to (0 mod P).

- ```a::Integer=3```: Factor by which to multiply n.

- ```b::Integer=1```: Value to add to the scaled value of n.


## See also
[`tree_graph`](@ref)
"""
function make_collatz_graph(initial_value::Int, max_orbit_distance::Int; P=2, a=3, b=1)
	g = SimpleGraph()
	record::Array{Tuple{Number,Number}} = []
	tree = tree_graph(initial_value,max_orbit_distance; P, a,b )
	descend_tree!(g, record, tree)
	return g, record
end

# ╔═╡ cf545d05-7846-4881-a532-33cb2c1972a4
md"### Drawing"

# ╔═╡ 5683080b-7d4b-4e34-aa75-b3c68dc60314
"""
	draw_hailstone_sequence(hailstone_seq::Vector{Int64}; params::VisualizationParameters)

This function is used to draw the trajectory of the hailstone sequence of a number. Using a Turtle, the function loops over each number in the sequence. For the sequence, a curve is drawn where for each step in the sequence, it will curves one way if the number is odd, and the other way if the number is even. 

## See also
[`VisualizationParameters`](@ref)

"""
function draw_hailstone_sequence(hailstone_seq::Vector{Int64}; params::VisualizationParameters=VisualizationParameters())

	@unpack line_length, turn_scale, 
	stroke_width, stroke_color, random_shade, vary_shade, edmund_style, chris_style = params
	# Initiliaze turle
	🐢 = Turtle()
	
	# set stroke width
	Penwidth(🐢, stroke_width)

	# Handle Color
	if(random_shade)
		Pencolor(🐢,RGB(rand(), rand(), rand()))
		
	elseif vary_shade
		
		color_offset = randn()/2
		Pencolor(🐢,RGB(stroke_color.r + color_offset, stroke_color.g + color_offset, stroke_color.b + color_offset))
	else
		Pencolor(🐢,stroke_color)
	end

	# Move the turtle 
	 for (index,number) in enumerate(hailstone_seq)

		# decrease opacity as the sequence gets longer
		setopacity(rescale(index, 1, length(hailstone_seq)*8
			, 0.1,1))

		if(chris_style)
			if number % 3 == 1
				Turn(🐢, turn_scale)
			else
				Turn(🐢, -turn_scale)	
			end
			Forward(🐢, line_length)
			continue
		end
			
		 
		if number % 2 == 0
			Turn(🐢, turn_scale)
		else
			if(edmund_style) 
				Turn(🐢, -1/2*turn_scale)
			else
				Turn(🐢, -turn_scale)
			end
			
		end
			
		
		# if number < 0
		# 	Turn(🐢, -90)
		# end
		 
		Forward(🐢, line_length)
	end
	
end


# ╔═╡ 278572e6-5a74-4dad-b39b-68cc85e4339c
"""
	draw_hailstone_sequences(hailstone_seqs::Vector{Vector{Int64}}; params::VisualizationParameters)

This function is used to draw each trajectory given an array of hailstone sequences.

## See also

[`VisualizationParameters`](@ref)

"""
function draw_hailstone_sequences(hailstone_seqs::Vector{Vector{Int64}}; params::VisualizationParameters)
	
	@unpack init_angle, x_start, y_start, window_width, window_height = params
	
	for hailstone_seq in hailstone_seqs
		# reset to origin and setup windows accord to user parameter
		origin()
		Luxor.translate(
			x_start - window_width  /2,
			y_start - window_height /2
		)
		Luxor.rotate(deg2rad(init_angle)+π)

		# draw sequence
		draw_hailstone_sequence(hailstone_seq; params)
	end
end

# ╔═╡ d6cc6642-018d-4a7f-b82a-dd50bff8e2fc
"""
A struct to bundle the parameters and the generated image together. 

`viz_parameters::VisualizationParameters`
`collatz_parameters::NamedTuple{(:P, :a, :b)}` = (P = 2, a = 3, b = 1)
`imgdata::Matrix{RGBA{N0f8}}` = []
`shortcut::Bool` = false
`notes::String` = ""



"""
@with_kw struct CollatzVisualization
	viz_parameters::VisualizationParameters
	collatz_parameters::NamedTuple{(:P, :a, :b)} = (P=2,a=3,b=1)
	imgdata::Matrix{RGBA{N0f8}} = []
	shortcut::Bool = false
	ultra_shortcut::Bool = false
	notes::String = ""
	
	function CollatzVisualization(viz_parameters, collatz_parameters,imgdata, shortcut,ultra_shortcut, notes)
		if((shortcut || ultra_shortcut)  &&  (collatz_parameters.P != 2 || collatz_parameters.a != 3 || collatz_parameters.b == 1)) 
			@info "Custom style is applied, running with default collatz parameters.." 
			collatz_parameters = (P = 2, a=3, b=1)
		end
		# convert to struct not supplied 
		if(!isa(viz_parameters, VisualizationParameters))
			viz_parameters = VisualizationParameters(edmund_style=shortcut,chris_style=ultra_shortcut;viz_parameters...)
		end

		
	
		# Caluclate reversed hailstone_sequences
		if(ultra_shortcut)
			hailstone_sequences = [ 
				reverse(ultra_shortcut_collatz(starting_number))
				for starting_number in 1:viz_parameters.num_traject
			]
		elseif(shortcut)
			hailstone_sequences = [ 
				reverse(shortcut_collatz(starting_number))
				for starting_number in 1:viz_parameters.num_traject
			]
		else
			hailstone_sequences = reverse_hailstone_sequences(1:viz_parameters.num_traject;
						collatz_parameters...)
		end
		# Draw the sequence and store in an image matrix
		imgdata = @imagematrix begin
			background(viz_parameters.background_color)
			draw_hailstone_sequences(
				hailstone_sequences; params = viz_parameters
			)
		end viz_parameters.window_width viz_parameters.window_height

		# Convert matrix to img 
		imgdata = convert.(Colors.RGBA, imgdata)
	
		return new(viz_parameters, collatz_parameters ,imgdata, shortcut,ultra_shortcut, notes)
	end
end

# ╔═╡ b7161895-ba79-4b99-b2f1-eda7484708da
begin

	viz_thumbnail = CollatzVisualization(
		viz_parameters = (
				num_traject = 10000,
				line_length = 15,
				turn_scale = 9.3,
				window_width = 500.0,
				window_height = 500.0, 
				x_start = 100.0, 
				y_start = 0.0,
				init_angle = 270, 
				stroke_width = 2.0, 
				stroke_color = RGB(38/255,148/255,30/255), 
				background_color = RGB(188/255, 251/255, 199/255), 
				vary_shade=true,
				random_shade=false
			),
		ultra_shortcut = true,
		
	)

	viz_5_5_5 = CollatzVisualization(
		viz_parameters = (
				num_traject = 1000,
				line_length = 15,
				turn_scale = 21.3,
				window_width = 500.0,
				window_height = 500.0, 
				x_start = 500.0, 
				y_start = 250.0,
				init_angle = 30.5, 
				stroke_width = 2.0, 
				stroke_color = RGB(0,102/255,0), 
				background_color = RGB(128/255, 234/255, 193/255), 
				vary_shade=true,
				random_shade=false
			),
		collatz_parameters = (
			P = 5,
			a = 5,
			b = 5
		)
	)

	viz_3_7_2 = CollatzVisualization(
		viz_parameters = (
				num_traject = 1000,
				line_length = 24, 
				turn_scale = 10.3,
				window_width = 500.0,
				window_height = 500.0, 
				x_start = 500.0, 
				y_start = 250.0,
				init_angle = 306.0, 
				stroke_width = 2.0, 
				stroke_color = RGB(67/255,65/255,210/255), 
				background_color = RGB(0/255,4/255,36/255), 
				vary_shade=true,
				random_shade=false
		),
		collatz_parameters = (
			P = 2,
			a = 3,
			b = 7
		)
	)
	
	viz_1_1_3 = CollatzVisualization(
		viz_parameters = (
			num_traject = 1000,
			line_length = 25, 
			turn_scale = 15.0,
			window_width = 500.0,
			window_height = 500.0, 
			x_start = 500.0, 
			y_start = 250.0,
			init_angle = 24.0, 
			stroke_width = 2.0, 
			stroke_color = RGB(191/255,237/255,253/255), 
			background_color = RGB(1/255,152/255,150/255), 
			vary_shade=true,
			random_shade=false
		),
		collatz_parameters = (
			P = 3,
			a = 1,
			b = 1
		)
	)
	viz_3_1_7 = CollatzVisualization(
		collatz_parameters = (
			P = 7,
			a = 1,
			b = 3
		),
		viz_parameters = (
			num_traject = 1000,
			line_length = 22, 
			turn_scale = 11.0,
			window_width = 500.0,
			window_height = 500.0, 
			x_start = 500.0, 
			y_start = 250.0,
			init_angle = 5.0, 
			stroke_width = 2.0, 
			stroke_color = RGB(236/255,196/255,50/255), 
			background_color = RGB(255/255,243/255,163/255), 
			vary_shade=true,
			random_shade=false
		)
	)

	hex_grid = CollatzVisualization(
		viz_parameters = (
				num_traject = 1000,
				line_length = 12,
				turn_scale = 60.0,
				window_width = 500.0,
				window_height = 500.0, 
				x_start = 300.0, 
				y_start = 350.7,
				init_angle = 112.8, 
				stroke_width = 3.0, 
				stroke_color = RGB(196/255,132/255,231/255), 
				background_color = RGB(28/255,0,87/255), 
				vary_shade=true,
				random_shade=false
			),
		collatz_parameters = (
			P = 2,
			a = 3,
			b = 1
		)
	)

	
	lil_guy = CollatzVisualization(
		viz_parameters = (
				num_traject = 600,
				line_length = 42,
				turn_scale = 29.4,
				window_width = 500.0,
				window_height = 500.0, 
				x_start = 300.0, 
				y_start = 150.0,
				init_angle = 74.3, 
				stroke_width = 3.0, 
				stroke_color = RGB(230/255,130/255,130/255), 
				background_color = RGB(0/255,0,0/255), 
				vary_shade=true,
				random_shade=false
			),
		collatz_parameters = (
			P = 3,
			a = 8,
			b = 1
		)
	)
	
	gallery_vizs = [viz_thumbnail, viz_5_5_5, viz_3_1_7,viz_1_1_3,viz_3_7_2, hex_grid, lil_guy,]
	
end;

# ╔═╡ f718bbfd-2e86-45c5-96b3-ef3d810966a9
"""
	buffer_img_data(vis::CollatzVisualization)

Helper function to transform the RGBA img of CollatzVisualization into a UInt8 buffer for loading onto a html canvas.
"""
function buffer_img_data(vis::CollatzVisualization)
	buffer::Vector{UInt8} = [] 
		
	for pix in vis.imgdata
		push!(buffer, reinterpret.(UInt8, [pix.r, pix.g, pix.b, pix.alpha])...)
	end
	return buffer
end

# ╔═╡ 7335059c-d9b8-40a5-b2c0-6bcca4bdfe28
function Base.getproperty(obj::CollatzVisualization, sym::Symbol) 
	if(sym == :P) return obj.collatz_parameters.P end
	if(sym == :a) return obj.collatz_parameters.a end
	if(sym == :b) return obj.collatz_parameters.b end
	return getfield(obj, sym)
end

# ╔═╡ b4a31304-34a3-4ecc-8c6e-e67714bc5d52
function Base.show(io::IO, m::MIME"image/png",obj::CollatzVisualization)
	show(io, m, obj.imgdata)
end

# ╔═╡ ae8c02c0-2944-42dc-8a19-a45fbdc16134
md"### HTML Functions"

# ╔═╡ f47eb656-67ec-4760-8906-713fa480cb47
md"### Interactivity extensions"

# ╔═╡ 43479204-cd12-40b4-a65f-16bf54aaddfe
@with_kw struct SliderParameter{T} 
	lb::T = 0.0
	ub::T = 100.0
	step::T = 1.0
	default::T = lb
	label::String 
	alias::Symbol = Symbol(label)
	function SliderParameter{T}(lb::T,ub::T,step::T,default::T, label::String, alias::Symbol) where T
		 if ub < lb error("Invalid Bounds") end 
		 return new{typeof(default)}(lb,ub,step,default,label,alias)
	end
end

# ╔═╡ 31a7994d-13e0-440a-8279-5f19d7d0933f
@with_kw struct NumberFieldParameter{T}
	lb::T = 0
	ub::T = 100
	step::T = 1
	default::T = lb
	label::String
	alias::Symbol = Symbol(label)
	function NumberFieldParameter(lb,ub,step,default, label, alias) 
		 if ub < lb error("Invalid Bounds") end 
		 return new{typeof(default)}(lb,ub,step,default,label,alias)
	end
end

# ╔═╡ 25d2291f-f422-41e4-aa61-9000e13d34ad
@with_kw struct CheckBoxParameter
	label::String 
	default::Bool = false
	alias::Symbol = Symbol(label)
end

# ╔═╡ 1255f4cc-7448-40f6-83ba-0cca1637d1cf
@with_kw struct ColorParameter
	label::String 
	default::RGB = RGB(0,0,0)
	alias::Symbol = Symbol(label)
end

# ╔═╡ 7dac4da8-0877-4d07-b4d2-2164faeccfde
function format_sliderParameter( params::Vector{SliderParameter{T}};title::String,) where T
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.Slider(param.lb:param.step:param.ub, default = param.default, show_value = true))) 
			</div>
			
			""")
			
			for param in params
		]
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ 4dd44fbd-f26a-4b72-a580-842209b44f27
function format_sliderParameter( params::Vector{SliderParameter};title::String,)
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.Slider(param.lb:param.step:param.ub, default = param.default, show_value = true))) 
			</div>
			
			""")
			for param in params
		]
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ e57da7e5-32bb-48a2-af27-5ac671cabdae
@bind hailstone_params format_sliderParameter(title="Hailstone Sequence Parameters:",[
	SliderParameter(lb=1,ub=1000,default=15,step=1,alias=:start_value,label="Starting Value")]
	)

# ╔═╡ 43c4fd8d-bb44-43cd-91dd-d221629d1fd9
begin
graph_sliders = @bind graph_parameters format_sliderParameter(title="Collatz Graph Parameters:",[
	SliderParameter(lb=1,ub=1000,default=1,step=1,alias=:start_value,label="Starting Value"),
	SliderParameter(lb=1,ub=25,default=9,step=1,alias=:orbit,label="Maximum Orbit")
	
])
	

	@htl("""
	<div class="slider_group">
	<div>
		$graph_sliders
	</div>
	
	</div>
	""")
end

# ╔═╡ 0fd7242c-46a1-4929-9c53-3c45768893b4
@bind stopping_parameters format_sliderParameter(title="Stopping Time Plot Parameters",
	[SliderParameter(lb=100, ub=30000, step=100, default=1000,alias=:ub, label="Upper Bound")]

)

# ╔═╡ 5ba5f885-1de1-4058-91bf-35e1b05d1941
viz_sliders = @bind viz_parameters format_sliderParameter(
			title = "Visualization Options:", 
			[
				SliderParameter(
					lb = 100.0,
					ub = 10000.0, 
					default = 1000.0, 
			 		step = 100.0, 
					alias = :num_traject, 
					label = "Numbers of trajectories"
				),
				SliderParameter(
					lb = 1,
					ub = 150, 
					default = 20,
					step = 1,
					alias=:line_length, 
					label="Step"),
				SliderParameter(
					lb = 0.0,
					ub = 180.0, 
					default = 10.0,
					step = 0.1, 
					alias = :turn_scale, 
					label = "Rotation Angle (in degrees)"
				),
			]
		);

# ╔═╡ f21f1e3e-a3ab-458e-a101-ce824731f0b6
begin
collatz_sliders = @bind collatz_parameters format_sliderParameter(title="Collatz Parameters:",[
	SliderParameter(lb=1,ub=10,step=1,default=2,label="P"),
	SliderParameter(lb=1,ub=10,step=1,default=3,label="a"),
	SliderParameter(lb=1,ub=10,step=1,label="b"),
])
	if(do_generalize_collatz)
		collatz_sliders
	else
	end
end

# ╔═╡ 66fe673a-7679-4c55-bf59-146a8dd1241c
begin
	hailstone_seq = "Hailstone Sequence" ∈ generalize_collatz ? hailstone_sequence(hailstone_params.start_value; collatz_parameters... ,verbose=false) : hailstone_sequence(hailstone_params.start_value; verbose=false)
	
	pl = plot(leg = false)
	xlabel!("Iterations")
	ylabel!("Value")
	title!("Hailstone sequence of: $(hailstone_params.start_value)")
	
	if(animate_hailstone)
		# using with_terminal to remove the @info msg 
		with_terminal(show_value=false) do
			global gl = @gif for i in range(0,length(hailstone_seq),step=1) 
				plot!(pl, hailstone_seq[1:i], linecolor=:lightblue)
				scatter!(pl, hailstone_seq[1:i], marker = :star7, markersize=7, markercolor=:lightblue)
			end fps = 4
		end
	else
		plot!(pl, hailstone_seq, linecolor=:lightblue)
		scatter!(pl, hailstone_seq, marker = :star7, markersize=7, markercolor=:lightblue)
		global gl = pl
	end
	gl
	
end

# ╔═╡ 6693800b-e2bc-46e4-b5f8-004184ef472b
begin
	g, record = "Graph" ∈ generalize_collatz ?  make_collatz_graph(
		graph_parameters.start_value,
		graph_parameters.orbit;
		collatz_parameters...
	) :  make_collatz_graph(
		graph_parameters.start_value,
		graph_parameters.orbit;
	)
	
	graph_colors = [RGB(rescale(record[i][1],1,graph_parameters.orbit, 1,0.3),.1,.3) 
		               for i in 1:nv(g)]
end;

# ╔═╡ 3550fe19-261e-4069-9bf6-6417dcaac102
begin
	collatz_graph = @drawsvg begin
	    background("white")
	    sethue("grey40")
	    fontsize(25)
	    drawgraph(g, 
			layout=Stress(initialpos=[(0.0,0.0)]),
			margin = 60,                         
	        vertexlabels = map(x -> x[2], record),
			vertexshapesizes = 40,
	        vertexfillcolors = graph_colors
	    )	
	end 1600 1200
			
	collatz_graph
end

# ╔═╡ 45ca6e2a-6a58-475e-9c02-4925e71625bd
begin
	# find values that that have not been previously been calculated
	newValues = filter(x -> !(x ∈ keys(stopping_times)),collect(range(1,stopping_parameters.ub,step=1)) )
	
	# calculate the values and add them to the dictionary 
	for newValue in newValues
		push!(stopping_times, 
			( newValue => "Stopping Time" ∈ generalize_collatz ? stopping_time(newValue, ;collatz_parameters..., total_stopping_time=true) : stopping_time(newValue, total_stopping_time=true))
		)
	end

	scatter(
		collect(values(sort(
				filter(
					key -> (key[1] ∈ range(1,stopping_parameters.ub,step=1))
					, stopping_times)
			)
		)
	), markersize = 1, leg = false)
	
	title!("Total stopping time of numbers up to $(stopping_parameters.ub)")
	ylabel!("Stopping time")
	xlabel!("Starting point")
end

# ╔═╡ 5977a13d-93b8-4e51-8484-5b1882100c49
function format_numberFieldParameter( params::Vector{NumberFieldParameter{T}};title::String,) where T
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.NumberField(param.lb:param.step:param.ub, default = param.default)) ) 
			</div>
			
			""")
			for param in params
		]
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ 0865f8a3-a959-481b-a9ae-adbca78a2749
begin
	window_size_sliders = @bind window_size_parameters format_numberFieldParameter(
		title="Window Size",
	[
		NumberFieldParameter(
			lb=100.0,
			ub=10000.0,
			default=700.0,
			alias = :window_height, 
			label = "Height", 
		),
		NumberFieldParameter(
			lb=100.0,
			ub=10000.0,
			default=500.0,
			alias=:window_width, 
			label="Width")
	]
	)
end


# ╔═╡ 8a64e9e3-477e-4a7e-97f7-61cf5e428731
@unpack window_height,window_width = window_size_parameters;

# ╔═╡ 7dbfb4dc-c9d0-464d-83b2-18db90d76878
viz_specs_sliders = @bind viz_specs_parameters format_sliderParameter(
			title = "Image Options:", 
			[
				SliderParameter(
					lb = 0.0,
					ub = 360.0,
					default = 20.0,
					step = 0.1,
					alias = :init_angle, 
					label = "Image Rotation (in degrees)"
				),
				SliderParameter(
					lb = 0.0,
					ub = window_width, 
					default = window_width/2, 
					step = 0.1, 
					alias = :x_start, 
					label = "Starting point (X)"
				),
				SliderParameter(
					lb = 0.0, 
					ub = window_height,
					default = window_height, 
					step = 0.1, 
					alias = :y_start, 
					label = "Starting point (Y)"
				),
				SliderParameter(
					lb = 1.0, 
					ub = 50.0,
					default = 5.0, 
					step = 0.1, 
					alias = :stroke_width, 
					label = "Stroke Width"
				),
			]
		);

# ╔═╡ a7885279-3f73-4c5d-aeef-061dea1ce930
function format_checkBoxParameter( params::Vector{CheckBoxParameter};title::String)
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.CheckBox(default=param.default)) ) 
			</div>
			
			""")
			
			for param in params
		]
		
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ f680e7ea-8e3a-41ac-ab92-a27c05103864
viz_extra_sliders = @bind viz_extra_options format_checkBoxParameter(
			title="Extra Options",
			[
				CheckBoxParameter(
					alias=:random_shade, 
					label="Random Color"
				),
				CheckBoxParameter(
					alias=:vary_shade, 
					label="Vary Shade"
				),
				CheckBoxParameter(
					alias=:edmund_style, 
					label="In Edmund Harris's style"
				),
				CheckBoxParameter(
					alias=:chris_style, 
					label="In Chris's style"
				),
			], 
		);

# ╔═╡ 2d98aed3-9a51-4225-b914-a20b19f43908
function format_colorPicker( params::Vector{ColorParameter};title::String)
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.ColorPicker(default=param.default))) 
			</div>
			
			""")
			
			for param in params
		]
		
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ 01cc5e4f-d94b-4211-b268-9ce0640cd23f
colors_sliders = @bind viz_colors_options format_colorPicker(
		title="Color Options",
	[
		ColorParameter(
		alias = :stroke_color, 
		label = "Stroke Color", 
		default = RGB{N0f8}(
			reinterpret(N0f8, UInt8(230)),
			reinterpret(N0f8, UInt8(130)),
			reinterpret(N0f8, UInt8(130)))
		),
		ColorParameter(
			alias=:background_color, 
			label="Background")
	]
	
);

# ╔═╡ 50a423ad-ca90-4015-9ef6-577f60e4efe7
begin
	@htl("""
	<div class="slider_group sidebar-left">
		<div class="on_big_show">
			<div class="slider_group_inner">
				$viz_sliders
			</div>

		</div>	
	</div>
	
	<div class="slider_group sidebar-right">
		<div class="on_small_show">
			<div class="slider_group_inner ">
				$viz_sliders
			</div>
		</div>
	
		<div class="slider_group_inner">
			$viz_specs_sliders
		</div>
	
		<div class="slider_group_inner">
			$colors_sliders
		</div>
	
		<div class="slider_group_inner">
			$viz_extra_sliders
		</div>
	</div>
	<div class="sidebar-bottom">
		<div class="on_tiny_show">
			<div class="slider_group">
				<div class="slider_group_inner">
					$viz_sliders
				</div>
			
				<div class="slider_group_inner ">
					$viz_sliders
				</div>
			</div>
		
			<div class="slider_group">
				<div class="slider_group_inner">
					$viz_specs_sliders
				</div>
			
				<div class="slider_group_inner">
					$colors_sliders
				</div>
				<div class="slider_group_inner">
					$viz_extra_sliders
				</div>
			</div>
		</div>
		<div>
				
		</div>
	</div>
	""")
end

# ╔═╡ 6d225dce-3362-4f5d-bba9-0b5312f6be5a
begin
	@unpack ( num_traject, turn_scale, line_length ) = viz_parameters
	@unpack ( init_angle, x_start, y_start, stroke_width) = viz_specs_parameters
	@unpack ( stroke_color, background_color ) = viz_colors_options
	@unpack ( random_shade, vary_shade, edmund_style, chris_style ) = viz_extra_options


	interactive_viz =  CollatzVisualization(
		viz_parameters = (
				num_traject = num_traject,
				line_length = line_length,
				turn_scale = turn_scale,
				window_width = window_width,
				window_height = window_height, 
				x_start = x_start, 
				y_start = y_start,
				init_angle = init_angle, 
				stroke_width = stroke_width, 
				stroke_color = stroke_color, 
				background_color = background_color, 
				random_shade = random_shade,
				vary_shade = vary_shade
			),
		collatz_parameters = (P=collatz_parameters.P,a = collatz_parameters.a, b= collatz_parameters.b),
		shortcut = edmund_style,
		ultra_shortcut = chris_style
	)
	
	# trajectories = reverse_hailstone_sequences(range(5,num_traject); collatz_parameters...)
	
	# viz = @draw begin
	# 	background(background_color)
	# 	draw_hailstone_sequences(
	# 		trajectories; line_length, turn_scale,
	# 		window_width, window_height, init_angle, x_start, y_start,
	# 		stroke_width, stroke_color, random_shade, vary_shade
	# 	)
	# end window_width window_height
end

# ╔═╡ 1b48b435-e959-477f-a8d2-3507da73fc28
@htl("""
$(filename == "" ? PlutoUI.DownloadButton(interactive_viz,"MyCoolVisualization.png") : PlutoUI.DownloadButton(interactive_viz,"$filename.png"))
"""
)

# ╔═╡ d9aaaadc-7d94-4e85-a1cb-c137e869ad2f
md"### Extras"

# ╔═╡ fb2dd0e1-5198-4c0a-b62b-50649ac21f32
begin
	# getters
	get_num_trajects(viz::CollatzVisualization) = viz.viz_parameters.num_traject
	get_line_length(viz::CollatzVisualization) = viz.viz_parameters.line_length
	get_turn_scale(viz::CollatzVisualization) = viz.viz_parameters.turn_scale
	get_window_width(viz::CollatzVisualization) = viz.viz_parameters.window_width
	get_window_height(viz::CollatzVisualization) = viz.viz_parameters.window_height
	get_x_start(viz::CollatzVisualization) = viz.viz_parameters.x_start
	get_y_start(viz::CollatzVisualization) = viz.viz_parameters.y_start
	get_init_angle(viz::CollatzVisualization) = viz.viz_parameters.init_angle
	get_stroke_width(viz::CollatzVisualization) = viz.viz_parameters.stroke_width
	get_stroke_color(viz::CollatzVisualization, as_hex=true) = as_hex ? hex(RGB(viz.viz_parameters.stroke_color)) : viz.viz_parameters.stroke_color
	get_background_color(viz::CollatzVisualization, as_hex=true) = as_hex ? hex(RGB(viz.viz_parameters.background_color)) : viz.viz_parameters.background_color
	get_vary_shade(viz::CollatzVisualization) = viz.viz_parameters.vary_shade 
	get_random_shade(viz::CollatzVisualization) = viz.viz_parameters.random_shade
	get_notes(viz::CollatzVisualization) = viz.notes
end

# ╔═╡ 03eb05fa-57bc-45d0-9943-79034ed10211
"""
	makeCollatzGallery(visualizations::Vector{CollatzVisualization}; width::Int=500, height::Int=500)

Helper function to format an array of visualizations into a scrollable gallery, with an panel below the image showing the parameters used to generate the visualization.

## Kwargs
-`width::Int`=500: Width of each image in pixels

-`height::Int`=500: Height of each image in pixels

"""
function makeCollatzGallery(visualizations::Vector{CollatzVisualization}; width::Int=500, height::Int=500)
	res = []
	for (i,viz) in enumerate(visualizations)
		push!(res, @htl("""
		<div>
			<div class="canvas-container">
				<canvas id="canvas$(i-1)" width="$width" height="$height">
				</canvas>
			</div>
			<div class="notes-container ">
				<div class="notes-container-inner">
					Parameters:
					<br>
					P: $(viz.P)
					<br>
					a: $(viz.a)
					<br>
					b: $(viz.b)
					<br>
				</div>
				<div class="notes-container-inner">
					Number of trajectories: $(get_num_trajects(viz))
					<br>
					Step length: $(get_line_length(viz))
					<br>
					Rotation Angle: $(get_turn_scale(viz))
				</div>
				<div class="notes-container-inner">
					Window Width: $(get_window_width(viz))
					<br>		
					Window Height: $(get_window_height(viz))
					<br>
					Starting point (X): $(get_x_start(viz))
					<br>
					Starting point (Y): $(get_y_start(viz))
					<br>
					Rotation Angle: $(get_init_angle(viz))
				</div>
				<div class="notes-container-inner">
					Stroke Width: $(get_stroke_width(viz))
					<br>
					Stroke Color: #$(get_stroke_color(viz))
					<br>
					Background Color: #$(get_background_color(viz))
				</div>
				<div class="notes-container-inner">
					Shade Variation: $(get_vary_shade(viz))
					<br>
					Random Shade: $(get_random_shade(viz))
				</div>

				$(get_notes(viz))
				
			</div> 
		</div>"""))
	end
	return res
end

# ╔═╡ 53520512-fc88-4dd2-ae6d-a8ed0d599e42
begin
	@htl("""
	<script>
	
	
	const buffers = $([buffer_img_data(viz) for viz in gallery_vizs])
	buffers.forEach((buffer, index) => {
		
		const canvas = document.getElementById("canvas"+index);
		const ctx = canvas.getContext("2d");
		const arr = new Uint8ClampedArray(buffer);
		let imageData = new ImageData(arr, 500, 500);
		ctx.putImageData(imageData, 0, 0);
		
		
	})
	</script>
	<div class="gallery">
		$(makeCollatzGallery(gallery_vizs))
	</div>
	""")
end

# ╔═╡ 90dc6dd4-c4f3-4e4d-8e91-0fecafd258e1
md"## CSS Styles"

# ╔═╡ 7baab6e9-31bb-4da5-8ab9-938546cc863e
@htl("""

<style>

input[type="button" i] {
	padding: 0.5rem;
}

@media screen and (min-width: 1000px) {
	
	.on_tiny_show {
		display: flex;
	}
	.on_small_show {
		display: none;
	}
	.on_big_show {
		display: none;
	}
}
@media screen and (min-width: 1000px) {
	.on_tiny_show {
		display: none;
	}
	.on_small_show {
		display: flex;
	}
	.on_big_show {
		display: none;
	}
}
@media screen and (min-width: 1500px) {
	.on_tiny_show {
		display: none;
	}
	.on_small_show {
		display: none;
	}
	.on_big_show {
		display: flex;
	}
}

.sidebar-left {
	position: absolute;
    top: 100%;
	right: 110%;
	width: 17rem;
	z-index: 99;
}
.sidebar-right {
    top: 100%;
	position: absolute;
	left: 100%;
	width: 17rem;
}
.sidebar-bottom {
    display: flex;
}

.slider_group{
	display:flex; 
	flex-direction: column;
	padding: .5rem; 
	gap: 2rem
}
.slider_group_inner{
	display:flex; 
	align-items:center; 
	padding: .5rem; 
	gap: 2rem
}

.gallery{
	display: flex;
	width: fit-content;
	background-color: white
}

.canvas-container{
	display: flex;
	margin: .75rem;
	box-shadow: 6px 5px 11px 0px gray;
	border: solid black 1px;
}
.notes-container{
	display: flex;
	flex-wrap: wrap;
	margin: .75rem;
	box-shadow: 6px 5px 11px 0px gray;
	padding: .5rem;
	border: solid black 1px;
	color: black
}
.notes-container-inner{
	margin-right: 4px
}

</style>

""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Collatz = "93a6299e-2ed6-4a7f-9f14-000d52f8d402"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FixedPointNumbers = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
Karnak = "cd156443-31ad-4f6f-850f-a93ee5f75905"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
NetworkLayout = "46757867-2c16-5918-afeb-47bfcb05e46a"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Collatz = "~1.0.0"
Colors = "~0.12.10"
FixedPointNumbers = "~0.8.4"
Graphs = "~1.9.0"
HypertextLiteral = "~0.9.5"
ImageIO = "~0.6.7"
ImageShow = "~0.3.8"
Karnak = "~1.0.0"
Luxor = "~3.8.0"
NetworkLayout = "~0.4.6"
Parameters = "~0.12.3"
Plots = "~1.39.0"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"

[[ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[Collatz]]
git-tree-sha1 = "f2ebb33a345e086823cc57ed206e956eb8f1d4d8"
uuid = "93a6299e-2ed6-4a7f-9f14-000d52f8d402"
version = "1.0.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

[[Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[Extents]]
git-tree-sha1 = "2140cd04483da90b2da7f99b2add0750504fc39c"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.2"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "d53480c0793b13341c40199190f92c611aa2e93c"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.2"

[[GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "424a5a6ce7c5d97cca7bcc4eac551b97294c54af"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.9"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "fc5d1d3443a124fde6e92d0260cd9e064eba69f8"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.1"

[[ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60b1194df0a3298f460063de985eae7b01bc011a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.1+0"

[[Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[Karnak]]
deps = ["CSV", "Colors", "DataFrames", "DelimitedFiles", "Graphs", "InteractiveUtils", "Luxor", "NetworkLayout", "Reexport", "SimpleWeightedGraphs", "TOML"]
git-tree-sha1 = "f578c724468443b0945669a9cb02cef58de6d1a8"
uuid = "cd156443-31ad-4f6f-850f-a93ee5f75905"
version = "1.0.0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

[[LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

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

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "PrecompileTools", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "aa3eb624552373a6204c19b00e95ce62ea932d32"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.8.0"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "StaticArrays"]
git-tree-sha1 = "91bb2fedff8e43793650e7a677ccda6e6e6e166b"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.6"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4745216e94f71cb768d58330b059c9b76f32cb66"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.14+0"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "2aded4182a14b19e9b62b063c0ab561809b5af2c"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.8.0"

[[StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[StructArrays]]
deps = ["Adapt", "ConstructionBase", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "0a3db38e4cce3c54fe7a71f831cd7b6194a54213"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.16"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"

[[Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

[[UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

[[libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─e60fcc3e-312c-4546-9b04-e6b558ba752a
# ╟─5328c6f3-2ae7-4449-a2a2-b6803cec0dcc
# ╟─822a3646-be9d-4b1c-a189-550bd8b56ab7
# ╟─0bc0ea95-585d-43be-b7ac-c33a2a7417b4
# ╟─bdd54208-1f66-45da-9e67-9479cc460863
# ╟─81db5594-75c0-4bfb-8908-ef8084559123
# ╟─b3c9453e-3198-4697-966f-ade21f2255ce
# ╟─e57da7e5-32bb-48a2-af27-5ac671cabdae
# ╟─66fe673a-7679-4c55-bf59-146a8dd1241c
# ╟─10ab31ff-2d28-4ac3-a118-654f8366768e
# ╟─75b9294e-43a4-48c4-b493-5d40027f3cd6
# ╟─12d218ee-9a43-4647-a96b-c9252c665fa0
# ╟─3550fe19-261e-4069-9bf6-6417dcaac102
# ╟─43c4fd8d-bb44-43cd-91dd-d221629d1fd9
# ╟─6693800b-e2bc-46e4-b5f8-004184ef472b
# ╟─6f68b20d-67e5-4872-a23b-1840bbbb06ec
# ╟─6a45247d-25db-445f-a687-191c0952c6c4
# ╟─0fd7242c-46a1-4929-9c53-3c45768893b4
# ╟─45ca6e2a-6a58-475e-9c02-4925e71625bd
# ╟─5f074850-b967-4de5-8ca3-b85a74052499
# ╟─d0672735-8007-4a69-9fa5-0f40ac0685ea
# ╟─50a423ad-ca90-4015-9ef6-577f60e4efe7
# ╟─6d225dce-3362-4f5d-bba9-0b5312f6be5a
# ╟─aef6cb43-61c7-4436-ad66-7e7f0459610d
# ╟─1b48b435-e959-477f-a8d2-3507da73fc28
# ╟─0865f8a3-a959-481b-a9ae-adbca78a2749
# ╟─8a64e9e3-477e-4a7e-97f7-61cf5e428731
# ╟─01cc5e4f-d94b-4211-b268-9ce0640cd23f
# ╟─5ba5f885-1de1-4058-91bf-35e1b05d1941
# ╟─7dbfb4dc-c9d0-464d-83b2-18db90d76878
# ╟─f680e7ea-8e3a-41ac-ab92-a27c05103864
# ╟─b56a1328-194c-4e1c-a033-9ca6e0ab3eeb
# ╟─6e359db6-581f-4a5a-a0a7-6924faf19653
# ╟─dc1dba7c-8c0d-4609-882a-e5703c467fef
# ╟─b9277abb-7a14-4479-8bcb-6a50df27182b
# ╟─0e85d872-ef01-463e-b395-b0797c96317e
# ╟─1c3f1bea-f1ba-4d64-90ad-584391c01da5
# ╟─f21f1e3e-a3ab-458e-a101-ce824731f0b6
# ╟─af0c36ee-0534-4143-b59b-4ee041ef0f04
# ╟─16d57341-6c55-4440-bdeb-492b4d0c4427
# ╟─5655a706-2c53-4763-b8c5-e21aa3e72371
# ╟─53520512-fc88-4dd2-ae6d-a8ed0d599e42
# ╟─b7161895-ba79-4b99-b2f1-eda7484708da
# ╟─b7b80bd8-7a16-4483-9b8f-b6a8da531b0a
# ╟─3e9a6e74-a0ab-4c47-b493-4670fa828c45
# ╟─546a2cf6-f54a-4482-9da5-af9d966b22eb
# ╟─cdfb638b-a04c-482c-9206-47f7dfd63766
# ╟─3e6323cb-4b09-4fe9-a223-8c66cb0d3efc
# ╟─0fdafbdc-a6aa-42a6-a899-41b351b5e7e8
# ╟─c5673bfa-d2b0-4893-ad88-42a5b81f27b4
# ╟─e4a76493-9aea-4379-9a56-6a9b9e8d6b54
# ╟─13f52ec2-16b9-41a5-9560-177ca827a72e
# ╟─091d8f63-d02a-48fa-be0c-e9e027409279
# ╟─d6cc6642-018d-4a7f-b82a-dd50bff8e2fc
# ╟─8c854d1c-2f89-43f0-a810-ce174cf94af8
# ╟─9803f163-0027-4577-af8f-c66de195d182
# ╟─1e85c1af-3318-4f20-a358-25aa0999dc8a
# ╟─40dd9659-abb9-4484-b5f1-f332e2abe90e
# ╟─f718bbfd-2e86-45c5-96b3-ef3d810966a9
# ╟─7335059c-d9b8-40a5-b2c0-6bcca4bdfe28
# ╟─b4a31304-34a3-4ecc-8c6e-e67714bc5d52
# ╟─f02affaa-534b-4c72-81ae-c42ca3b455fd
# ╟─4c991173-d9ff-4ba9-b217-8f9aafbbd631
# ╟─240b4cc1-1bae-429b-863b-792897cd555b
# ╟─23be8efa-b907-453f-9245-8bc46a37ad26
# ╟─a1a6130d-771a-43d7-ae94-049e3c9b81b3
# ╟─319d784b-c62d-4f28-a5b3-ebf89c892afc
# ╟─3153ba89-f2d4-4e31-9e79-00ec5ecbb91c
# ╟─b79405c3-42d1-4289-bbc3-67b6eae2b135
# ╟─cf545d05-7846-4881-a532-33cb2c1972a4
# ╟─278572e6-5a74-4dad-b39b-68cc85e4339c
# ╟─5683080b-7d4b-4e34-aa75-b3c68dc60314
# ╟─ae8c02c0-2944-42dc-8a19-a45fbdc16134
# ╟─03eb05fa-57bc-45d0-9943-79034ed10211
# ╟─f47eb656-67ec-4760-8906-713fa480cb47
# ╟─43479204-cd12-40b4-a65f-16bf54aaddfe
# ╟─31a7994d-13e0-440a-8279-5f19d7d0933f
# ╟─25d2291f-f422-41e4-aa61-9000e13d34ad
# ╟─1255f4cc-7448-40f6-83ba-0cca1637d1cf
# ╟─7dac4da8-0877-4d07-b4d2-2164faeccfde
# ╟─4dd44fbd-f26a-4b72-a580-842209b44f27
# ╟─5977a13d-93b8-4e51-8484-5b1882100c49
# ╟─a7885279-3f73-4c5d-aeef-061dea1ce930
# ╟─2d98aed3-9a51-4225-b914-a20b19f43908
# ╟─d9aaaadc-7d94-4e85-a1cb-c137e869ad2f
# ╟─fb2dd0e1-5198-4c0a-b62b-50649ac21f32
# ╟─90dc6dd4-c4f3-4e4d-8e91-0fecafd258e1
# ╟─7baab6e9-31bb-4da5-8ab9-938546cc863e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
