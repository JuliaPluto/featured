### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> licence_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Collatz_Conjecture_Vizualization.png/600px-Collatz_Conjecture_Vizualization.png?20231214223051"
#> title = "Visualizing the Collatz Conjecture "
#> tags = ["math", "interactive visualization", "collatz conjecture", "edmond harris"]
#> date = "2023-12-14"
#> description = "Explore this cool math problem and create your own visualization!"
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Chris Damour"
#>     url = "https://github.com/damourChris"

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
Colors = "~0.12.11"
FixedPointNumbers = "~0.8.5"
Graphs = "~1.12.1"
HypertextLiteral = "~0.9.5"
ImageIO = "~0.6.9"
ImageShow = "~0.3.8"
Karnak = "~1.1.0"
Luxor = "~4.2.0"
NetworkLayout = "~0.4.10"
Parameters = "~0.12.3"
Plots = "~1.40.13"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "71aa551c5c33f1a4415867fe06b7844faadb0ae9"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.1"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2ac646d71d0d24b44f3f8c84da8c9f4d70fb67df"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.4+0"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[Collatz]]
git-tree-sha1 = "f2ebb33a345e086823cc57ed206e956eb8f1d4d8"
uuid = "93a6299e-2ed6-4a7f-9f14-000d52f8d402"
version = "1.0.0"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[Extents]]
git-tree-sha1 = "b309b36a9e02fe7be71270dd8c0fd873625332b4"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.6"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "b66970a70db13f45b7e57fbda1736e1cf72174ea"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.17.0"
weakdeps = ["HTTP"]

    [FileIO.extensions]
    HTTPExt = "HTTP"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "301b5d5d731a0654825f1f2e906990f7141a106b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.16.0+0"

[[Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "7ffa4049937aeba2e5e1242274dc052b0362157a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.14"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "98fc192b4e4b938775ecd276ce88f539bcec358e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.14+0"

[[GeoFormatTypes]]
git-tree-sha1 = "8e233d5167e63d708d41f87597433f59a0f213fe"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.4"

[[GeoInterface]]
deps = ["DataAPI", "Extents", "GeoFormatTypes"]
git-tree-sha1 = "294e99f19869d0b0cb71aef92f19d03649d028d5"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.4.1"

[[GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "2670cf32dcf0229c9893b895a9afe725edb23545"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.9"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Giflib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6570366d757b50fabae9f4315ad74d2e40c0560a"
uuid = "59f7168a-df46-5410-90c8-f2779963d0ec"
version = "5.2.3+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "a641238db938fff9b2f60d08ed9030387daf428c"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.3"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "3169fd3440a02f35e549728b0890904cfd4ae58a"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.1"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "e12629406c6c4442539436581041d372d69c55ba"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.12"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs", "WebP"]
git-tree-sha1 = "696144904b76e1ca433b886b4e7edd067d76cbf7"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.9"

[[ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "2a81c3897be6fbcde0802a0ebe6796d0562f63ec"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.10"

[[ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[IntervalSets]]
git-tree-sha1 = "5fbb102dcb8b1a858111ae81d56682376130517d"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.11"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "9496de8fb52c224a2e3f9ff403947674517317d9"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.6"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[Karnak]]
deps = ["Colors", "Graphs", "InteractiveUtils", "Luxor", "NetworkLayout", "Reexport", "SimpleWeightedGraphs"]
git-tree-sha1 = "5e81bf85c0b34c3f6d947ac975992eb11edd6fa6"
uuid = "cd156443-31ad-4f6f-850f-a93ee5f75905"
version = "1.1.0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd10d2cc78d34c0e2a3a36420ab607b611debfbb"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.7"

    [Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a31572773ac1b745e0343fe5e2c8ddda7a37e997"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.0+0"

[[Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "321ccef73a96ba828cd51f2ab5b9f917fa73945a"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "PolygonAlgorithms", "PrecompileTools", "Random", "Rsvg"]
git-tree-sha1 = "9234dbf7598ba767b9c380c86104faa37187ab95"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "4.2.0"

    [Luxor.extensions]
    LuxorExtLatex = ["LaTeXStrings", "MathTeXEngine"]

    [Luxor.weakdeps]
    LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
    MathTeXEngine = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"

[[MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "StaticArrays"]
git-tree-sha1 = "f7466c23a7c5029dc99e8358e7ce5d81a117c364"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.10"
weakdeps = ["Graphs"]

    [NetworkLayout.extensions]
    NetworkLayoutGraphsExt = "Graphs"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"

    [OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

    [OffsetArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "97db9e07fe2091882c765380ef58ec553074e9c7"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.3"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "cf181f0b1e6a18dfeb0ee8acc4a9d1672499626c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.4"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [Pkg.extensions]
    REPLExt = "REPL"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "809ba625a00c605f8d00cd2a9ae19ce34fc24d68"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.13"

    [Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[PolygonAlgorithms]]
git-tree-sha1 = "384967bb9b0dda05f9621e57c780dae5ca0c8574"
uuid = "32a0d02f-32d9-4438-b5ed-3a2932b48f96"
version = "0.3.2"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "13c5103482a8ed1536a54c08d0e742ae3dca2d42"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.4"

[[PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "8b3fc30bc0390abdce15f8822c889f669baed73d"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.1"

[[Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

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
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "fea870727142270bdf7624ad675901a1ee3b4c87"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.1"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "3e5f165e58b18204aed03158664c4982d691f454"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.5.0"

[[Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "95af145932c2ed859b63329952ce8d633719f091"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.3"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"

    [StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "b81c5035922cc89c2d9523afc6c54be512411466"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.5"

[[StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "f21231b166166bebc73b99cea236071eb047525b"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.3"

[[TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d62610ec45e4efeabf7032d67de2ffdea8344bed"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.1"

    [Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[WebP]]
deps = ["CEnum", "ColorTypes", "FileIO", "FixedPointNumbers", "ImageCore", "libwebp_jll"]
git-tree-sha1 = "aa1ca3c47f119fbdae8770c29820e5e6119b83f2"
uuid = "e3aaa7dc-3e4b-44e0-be63-ffb868ccd7c1"
version = "0.1.3"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "9caba99d38404b285db8801d5c45ef4f4f425a6d"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.1+0"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a5bc75478d323358a90dc36766f3c99ba7feb024"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.6+0"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "aff463c82a773cb86061bce8d53a0d976854923e"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.5+0"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "e3150c7400c41e207012b41659591f083f3ef795"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.3+0"

[[Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "cc803af2e0d7647ae880e7eaf4be491094def6c7"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.12+0"

[[gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3cad2cf2c8d80f1d17320652b3ea7778b30f473f"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.3.0+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "002748401f7b520273e2b506f61cab95d4701ccf"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.48+0"

[[libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "d2408cac540942921e7bd77272c32e58c33d8a77"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.5.0+0"

[[mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "c950ae0a3577aec97bfccf3381f66666bc416729"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.8.1+0"
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
# ╠═13f52ec2-16b9-41a5-9560-177ca827a72e
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
