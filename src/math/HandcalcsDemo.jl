### A Pluto.jl notebook ###
# v0.20.3

#> [frontmatter]
#> license_url = "https://opensource.org/license/unlicense"
#> image = "https://github.com/user-attachments/assets/4fbb12d8-5f13-4f30-82a9-0bed7351dd02"
#> title = "Handcalcs.jl"
#> date = "2025-01-23"
#> tags = ["math"]
#> description = "Calculations you can read and reuse"
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Cole Miller"
#>     image = "https://avatars.githubusercontent.com/u/143426779?s=400&u=fa08421f50ab5dad60ec5a9cf534ec1549ded72d&v=4"
#>     url = "https://github.com/co1emi11er2/Handcalcs.jl"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 12d41162-b9aa-11ef-33d9-a32698d6f054
using Handcalcs, StructuralUnits, PlutoUI, LaTeXStrings, PlutoPlotly, Markdown, TestHandcalcFunctions

# ╔═╡ 5ac917a4-79bf-419e-9eff-6501c2d15d28
PlutoUI.TableOfContents()

# ╔═╡ bd811c3e-6802-4c5a-9904-9e6044c976be
md"# Handcalcs.jl"

# ╔═╡ a8bb7d69-55a4-4381-aa98-b2169d3064d7
md"[Handcalcs.jl](https://co1emi11er2.github.io/Handcalcs.jl/dev/) is a package that was designed to be used in Pluto! This package supplies macros to generate $LaTeX$ formatted strings from mathmatical formulas. Handcalcs.jl takes inspiration from [handcalcs.py](https://github.com/connorferster/handcalcs), a python package that works best in jupyter notebooks. "

# ╔═╡ 897f866e-40ef-4c47-993e-40f58f8c340b
md"# Brief Tutorial of Handcalcs"

# ╔═╡ 98ec50cc-dddf-48ac-9806-990a9e2e334a
md"""
Handcalcs exports two macros where all of the functionality stems from:
- `@handcalc`
- `@handcalcs`

Think of `@handcalc` as doing a single inline \$ *latex expression* \$, and `@handcalcs` as a multiline display equation \$\$ *latex expression* \$\$.

I primarily use `@handcalcs`. It can even be inlined into markdown as well. It also handles multiple expressions, and generally does a better job at cleaning up the equations for redundant information.
"""

# ╔═╡ 18eded2b-f973-4a61-9754-56331fd01336
md"""
Change this setting in the notebook to change the alignment of the expressions to the left.

Left Align Equations: $(@bind left_aligned PlutoUI.CheckBox())
"""

# ╔═╡ ba51899c-61d6-440d-8263-d479f6a871f6
if left_aligned
	Handcalcs.left_align_in_pluto()
end

# ╔═╡ a2758980-252e-4e6b-baf3-a5a6e85df34d
md"## Single Expression Example"

# ╔═╡ 27b55f64-358e-4bc2-a5f4-315ea361b646
md"Lets try to calculate the area of a circle"

# ╔═╡ 0eac9a5a-c6a8-43e9-99c9-16f7c3d77204
d = 5;

# ╔═╡ 00e75249-8d2c-4407-9564-68c8d79fc29f
@handcalcs begin
	area = π*d^2/4
end

# ╔═╡ 2a7e9993-74f9-48f8-964b-e858e3b96672
md"Handcalcs was able to show the equation defining `area` as a $LaTeX$ expression showing both the symbolic and numeric parts. The variable `area` was also evaluated!"

# ╔═╡ 3589a61a-84a2-4413-9fb9-3454105f6df2
area

# ╔═╡ f3a4d941-fcd4-421b-94e4-2d486e71da12
md"The number of decimals in the above expression may be too much. Let change that."

# ╔═╡ 69f31cc2-af12-4a8c-bbf1-9959f9d78b4f
md"""
!!! note
	The number of decimals you see in the area calc above may just be 2. The cell below may have changed the output due to how pluto works. Just know that without the cell below, the number of decimals would be too much.
"""

# ╔═╡ 79f4fb1c-e512-4af6-835c-ea0865d80c5e
set_handcalcs(precision=2)

# ╔═╡ cd4ab653-0627-44e4-8b58-c475e0a0a251
md"You can use `set_handcalcs` using the `precision` keyword to change the default precision shown. Alternatively, Handcalcs uses [Latexify.jl](https://github.com/korsbo/Latexify.jl) under the hood, so you can use the `set_default` function from Latexify to change the default settings of the output, or you can add it to the end of the handcalcs expression similar to the `@latexdefine` macro in Latexify.

See [here](https://korsbo.github.io/Latexify.jl/stable/#Setting-your-own-defaults) for more details in the Latexify docs."

# ╔═╡ 99730005-9dca-48aa-a409-5b0438660220
let # adding let here to avoid pluto variable clash
@handcalcs begin
	area = π*d^2/4
end
end

# ╔═╡ 6633dd4a-2b68-4127-90ed-9e4caab68f56
md"## Multiple Expression Example"

# ╔═╡ c0a250de-36dd-4647-9281-c237e9efd359
md"Now lets see how Handcalcs handles multiple expressions!"

# ╔═╡ b5c7a277-da51-487b-869e-1936816017ac
a = 2;

# ╔═╡ 54ea2e03-ab01-4371-a13d-c3de13876c10
b = -5;

# ╔═╡ ef8baa5a-90ef-4a67-94bc-40d6c50abe74
c = 2;

# ╔═╡ ec3681b3-7c95-4c4e-8320-89f535440d92
md"This time lets show the variables we defined above in $LaTeX$ as well"

# ╔═╡ 1c5ec9af-8f8b-416d-ad76-aec0af292895
@handcalcs begin
	a
	b
	c
end color=:blue cols=3

# ╔═╡ 20503429-f22b-49b0-9f06-3ffcfc811a93
md"Here we changed the color of the output as well as the number of columns by adding a few extra parameters to the macro"

# ╔═╡ fd00ab45-3967-4159-88a3-e6a924be40bc
@handcalcs begin
	x_1 = (-b + sqrt(b^2 - 4*a*c))/ (2*a)
	x_2 = (-b - sqrt(b^2 - 4*a*c))/ (2*a)
end

# ╔═╡ 350d438e-1cfa-4c4c-85ff-afdfecfc171e
md"You can see `@handcalcs` handles multiple expressions with ease, and yes `x_1` and `x_2` are evaluated as expected"

# ╔═╡ 43633b23-b5cd-45ad-893f-ecd766726610
x_1, x_2

# ╔═╡ 778b64c5-6a06-4e74-8da6-67a83f08eac5
md"When an equation is too long, you can also add the setting below. 

You can also add a comment using the syntax shown below."

# ╔═╡ 4b8d463f-b186-4d1f-9b80-62ff7a5a886d
let # adding let here to avoid pluto variable clash
	@handcalcs begin
		x_1 = (-b + sqrt(b^2 - 4*a*c))/ (2*a); "this is a comment";
	end len = :long
end

# ╔═╡ 24c12e97-4090-48a4-8c66-bb5d2068e1e4
md"## Changing Default Settings of Handcalcs"

# ╔═╡ 3867ea24-0e62-46bf-84e3-b86bc3e74ae7
md"Similarly with Latexify, Handcalcs has a way to change some default settings using the `set_handcalcs` function. Some of the settings you have seen so far are:
- `color`: change the color of the output (`:blue`, `:red`, etc)
- `cols`: change the number of columns the expression returns (default = 1).
- `len`: can set to `:long` and it will split equation to multiple lines
but there are more! See [here](https://co1emi11er2.github.io/Handcalcs.jl/stable/tutorial/#Changing-Default-Settings:) for more details."

# ╔═╡ ad2ea96b-4b87-49ed-bd5e-37aca4f8973d
md"## Using Unitful with UnitfulLatexify"

# ╔═╡ bec7dfa6-8787-45b7-b2cb-230666712a3f
md"This package integrates with [Unitful.jl](https://painterqubits.github.io/Unitful.jl/stable/) and [UnitfulLatexify](https://gustaphe.github.io/UnitfulLatexify.jl/stable/)"

# ╔═╡ 5dd3bce5-9f12-480d-9000-ec84766c18be
let
	a = 2u"inch"
	b = -5u"inch"
	@handcalcs c = sqrt(a^2 + b^2)
end

# ╔═╡ 07ff6778-df02-4dc1-81ba-661afaec6320
md"If you want to set the units of the output, you can write it the same way you would using Unitful. The @handcalcs macro will parse the |> operator out of the output while still evaluating the result with the conversion."

# ╔═╡ b2237f22-b523-4f71-b196-85e1fdddb393
let
	b = 40u"ft"
	t = 8.5u"inch"
	@handcalcs begin
    	b
    	t
    	a = b * t       |> u"inch"^2
    	Ix = b*t^3/12   |> u"inch"^4
	end
end

# ╔═╡ 740bda9e-8191-447b-ba1d-e5a8784fca84
md"## The BEST Part - Function Examples"

# ╔═╡ 42e089cd-1ec2-4924-ac4a-d42d18c9c68a
md"""
The @handcalcs macro will automatically try to "unroll" the expressions within a function when the expression has the following pattern: `variable = function_name(args...; kwargs...)`. Note that this is recursive, so if you have a function that calls other functions where the expressions that call the function are of the format mentioned, it will continue to step into each function to "unroll" all expressions.

One issue that can arise are for the functions that you do not want to unroll. Consider the expression: `y = sin(x)` or `y = x + 5`. Both of these expressions match the format: `variable = function_name(args...; kwargs...)` and would be unrolled. This would result in an error since these functions don't have generic math expressions that can be latexified. You will need to use the `not_funcs` keyword to manually tell the @handcalcs macro to pass over these functions. Some of the common math functions that you will not want to unroll are automatically passed over. See examples below.
"""

# ╔═╡ 3f2d9d3e-82f9-4cc7-bf06-18bd33dde4c0
md"### Function Unrolling Example: `calc_Ix`"

# ╔═╡ 081762c8-3109-438a-abd4-17f20c7db455
md"There is a function that is defined in the TestHandcalcsFunctions.jl package called `calc_Ix`. The definition looks like the following:
```
function calc_Ix(b, h)
    Ix = b*h^3/12
    return Ix
end
```

Lets try to call that function within our `@handcalcs` macro."

# ╔═╡ 4b9ff29b-d777-4694-926a-5c95851e81e7
let
	b = 5 # width
	h = 15 # height
	@handcalcs Ix = calc_Ix(b, h)
end

# ╔═╡ 7c09b665-e48b-4825-bd75-4540ba12afeb
md"The Ix variable is evaluated. Ix being the variable assigned in the @handcalcs part (variables within function are not defined in the global name space). If you assign it to a different variable then that will be the variable defined (although you will still see it as Ix in the latex portion). Also note that return statements are filtered out of the function body, so keep relevant parts separate from return statements."

# ╔═╡ c3addf2d-bdaf-4d09-88c4-0aca5cac368a
md"""
!!! note "Note to reader"
	Unfortunately functions need to be defined in another package and they can't be defined in the pluto notebook for function unrolling to work. See current limitations of handcalcs below.
"""

# ╔═╡ 9d6f3c2a-fe77-4712-94b5-1dd9c61edc22
md"### Recursive Function Unrolling Example: `calc_Is`"

# ╔═╡ e266ab7d-21a6-4f91-a229-102e27a4e68d
md"This macro is recursive! If the function that you call contains another function call that matches the form `variable = function_name(args...; kwargs...)`, then @handcalcs will try to unroll that one as well! Lets see an example with the `calc_Is` function defined in the TestHandcalcsFunction.jl package. The function definition is shown below:
```
function calc_Is(b, h) # function defined in TestHandcalcFunctions
    Ix = calc_Ix(b, h)
    Iy = calc_Iy(h, b)
    return Ix, Iy
end;
```"

# ╔═╡ bdb88b43-7c4f-48a8-b6b5-0130cf5f402a
let
	x = 0
	@handcalcs begin
		y = sin(x)
		z = cos(x)
		I_x, I_y = TestHandcalcFunctions.calc_Is(5, 15)
	end not_funcs = [:sin :cos]
end

# ╔═╡ 8a0028f1-1d1d-4448-a20a-9bc25b17e02c
md"""
In the above example `sin` and `cos` were passed over and `calc_Is` was not. As you can see, the `calc_Is` function was a function that called other functions, and the `@handcalcs` macro continued to step into each function to unroll all expressions. Please see below for a list of the current functions that are passed over automatically. Please submit a pull request if you would like to add more generic math functions that I have left out.

```
const math_syms = [
    :*, :/, :^, :+, :-, :%,
    :.*, :./, :.^, :.+, :.-, :.%,
    :<, :>, Symbol(==), :<=, :>=,
    :.<, :.>, :.==, :.<=, :.>=,
    :sqrt, :sin, :cos, :tan, :sum, 
    :cumsum, :max, :min, :exp, :log,
    :log10, :√]
```

If you want to add functions to your specific project, you can do the following:
```
set_handcalcs(not_funcs = [:foo :bar :baz])
```

!!! warning "Current Limitations for `@handcalcs`"
	- The function needs to be defined in another package. The `@code_expr` macro from `CodeTracking.jl` does not see functions in Main for some reason (unless in the REPL). This means functions defined in a jupyter notebook or a pluto notebook will not work for function unrolling. They must be defined in an actual package (there is a workaround using `includet` through `Revise.jl` but I have not got that working with Pluto).
"""

# ╔═╡ 39977ff0-c012-499d-9985-690d5455cf2d
md"""
## Options for if statements
If statements have two different formats in how they can be displayed. The default format is different than how Latexify would display the if statement. The reasoning was to show an if statement more like the way you would if you were performing a calculation by hand and to also integrate function unrolling. The default format (parse_ifs=true), only shows the branches of the if statement that pass the logic statements within the if statement. This is nice, because you only see the equations that are relevant to that specific problem. See the example below:
"""

# ╔═╡ a185cb84-0b40-4f57-8c6b-6de9a750fc9b
md"Select x: $(@bind if_ex1_slider PlutoUI.Slider(1:10, show_value=true))"

# ╔═╡ 57c31b0f-2ff6-4038-bddd-b8339e7017c5
let
	x = if_ex1_slider
	@handcalcs begin
		x
		if x > 5
		    x = calc_Ix(5, 15)
		else
		    x = calc_Ix(x, 15)
		end
	end
end

# ╔═╡ 47e751ee-4cd5-4c80-904e-2439e7674b6a
md"Nested if statements work as well. See below:"

# ╔═╡ adaaad57-7ace-4df4-95e6-221e8800e6a5
md"""
Select x: $(@bind if_ex2_slider_x PlutoUI.Slider(1:10, show_value=true))

Select y: $(@bind if_ex2_slider_y PlutoUI.Slider(1:10, show_value=true))
"""

# ╔═╡ 7cba83f6-caef-4490-9329-fb9d33e15041
let
	x = if_ex2_slider_x
	y =if_ex2_slider_y
	@handcalcs begin
		x
		y
		if x > 5
		    if y < 3
		        x = 5
		    else
		        x = 3
		    end
		else
		    x = 10
		end
	end
end

# ╔═╡ c369e6bc-74bf-4f1a-9c2d-0254d121119f
md"The other format (parse_ifs=false) looks more like the Latexify format. However, nested ifs don't always work and function unrolling (see the Function Examples section) does not work."

# ╔═╡ 35fc8539-d9b7-4917-81e5-51e5c1623efd
let
	@handcalcs begin
		x = 10
		y = 5
		if x > 5
		    x = 5
		else
		    x = 10
		end
	end parse_ifs=false
end

# ╔═╡ 64b18b41-1d01-4b63-91d1-ba470ab2626c
md"You can also write the if statement like so:"

# ╔═╡ 4fc079d2-e40c-4324-9797-973253955815
let
	@handcalcs begin
		x = 10
		y = 5
		x = if x > 5
		    5
		else
		    10
		end
	end parse_ifs=false
end

# ╔═╡ c2252cdb-4151-4a2a-b421-2e808bb26883
md"## Writing Packages"

# ╔═╡ 5ba38942-a676-40a7-9d9c-821f76d642d6
md"""
So you might be thinking, 

\"Does that mean I can write packages filled with julia functions and this just works?\" 
- Yes, that is exactly what you can do and what the package is being developed for. 

\"What julia language features work (if statements, for loops, vectors, etc)\"
- General mathmatical expressions work
- If statements work as shown above. There may be some tweaking to the way the default is displayed, but the functionality is there.
- For loops is not something Latexify can do. The idea of this tool is to show the work of what is being done. Since for loops repeat the work being done, I recommend showing an example of the work inside the loop and then running the loop separate.
- Vectors do work. However, they need to be relatively small or the expression just gets too big. 

\"This looks pretty cool, but is this slow?\"
- Compared to the pure julia expressions, yes.
- The non-function unrolling expressions are controlled by the speed of Latexify, so if Latexify gets faster, this will. I haven't found the need for it yet though.
- The function-unrolling parts are even slower. It is currently using `@eval`, but I am not sure how to get rid of it. I want to improve this as well if possible, but I currently don't have the need for it yet either.
"""

# ╔═╡ 0db4dbe2-4405-463c-a676-b26e652c4d03
md"""
## Debugging Handcalcs
This is an area that needs improvement. The error messages need improvement mainly in the area of function unrolling. I have found that you really need to `dev` the package and add print statements to get good information. That also requires knowing the package on a deeper level. This is not ideal from a user's perspective.

Improving debugging will be the top priority for the next release. 
"""

# ╔═╡ a7064738-e518-42c6-9aa8-f8bc2e013f2d
md"# Actual Project Demo: AISCSteel"

# ╔═╡ fdee2c0c-add7-4e08-a307-9259711a61b1
md"Here is a short demo of the idea of the use case of the Handcalcs.jl package. The idea that you can write a Julia package and use Handcalcs to create documentation/report of the package"

# ╔═╡ cae8c270-c620-4bb4-9175-a8702e7ed7ab
begin
	import AISCSteel
	import AISCSteel.Shapes.IShapes.RolledIShapes: WShape
	import AISCSteel.Shapes.IShapes.RolledIShapes.Flexure as Flexure
	import AISCSteel.ChapterFFlexure as Chf
end

# ╔═╡ 419375f5-1f14-465e-8d3f-3c7fd5664166
md"""
## Example Problem

!!! note "Note to reader"
	The AISCSteel.jl package isn't important here, but I will use it to demonstrate a use case for Handcalcs. The package is based on [AISC360](https://www.aisc.org/globalassets/aisc/publications/standards/a360-16w-rev-june-2019.pdf) and the demo will go through Chapter F, and will design an I-Shaped beam for flexure. You can follow along in Chapter F or just read along. I will hide the handcalc cells so be sure to run the notebook if you want to see the code (I am calling functions within the AISCSteel package).

Determine the LRFD flexural design strength for a W10x12 beam with an unbraced length of 10 ft.

Other beams to try:
- W30x235
- W12x26
"""

# ╔═╡ 4b33c7b8-460e-4248-bbb6-58ebe434fa0c
begin
w_list = ["W10X12", "W30X235", "W12X26"]
w_fy_list = [50ksi, 200ksi, 500ksi]
end;

# ╔═╡ 73050a9f-3938-4d90-b7d6-e145ae7c6a9d
md"""
Select W-Shape: $(@bind w_name PlutoUI.Select(w_list))

Select Steel Strength: $(@bind w_fy PlutoUI.Select(w_fy_list)) (change to unrealistic **200ksi** or **500ksi** for `F4` or `F5` equations on first beam)
"""

# ╔═╡ 1a2b22b3-b730-4475-85cb-ec284ae1612c
w = WShape(w_name, F_y=w_fy)

# ╔═╡ f827503c-ef71-48e1-9e54-c46afd810bed
md"Lateral braced length: $(@bind L_b PlutoUI.Select([2ft, 5ft, 10ft, 25ft, 50ft]))"

# ╔═╡ 1cc8d792-6850-490c-bc1a-12c1059acf1b
L_b

# ╔═╡ 089d48f6-76fa-4610-a007-c18246ef25cb
ϕ_b = 0.9;

# ╔═╡ 209b7fc9-a06a-43de-9400-fa6537d4350c
begin
	if w.shape == "W10X12"
		max_x = 20ft*1
	elseif w.shape == "W12X26"
		max_x = 20ft*2
	else
		max_x = 20ft*5
	end
	
	max_x = max(max_x, L_b+10ft)
end;

# ╔═╡ 1ee5a282-0919-4e2a-982a-845a89de384d
begin
(;h,
t_f,
b_f,
t_w,
E,
F_y,
S_x,
) = w
end;

# ╔═╡ 083d1e86-90da-4e54-adbb-06939a665c3f
md"### Section Properties of $(w.shape)"

# ╔═╡ 3610dacf-fa4d-446a-8e3b-ef0dc645e074
md"""
![wshape_image](https://github.com/user-attachments/assets/efd343c5-a55d-47c5-af87-a7176ff01945)
"""

# ╔═╡ bf97f95b-860b-4367-b5bd-6081c384dd40
@handcalcs begin
	h
	t_f
	b_f
	t_w
	E 
	F_y
	S_x
end color = :blue cols=4

# ╔═╡ 5cec6944-201d-498e-b2e1-6844c8c56d2b
let
	xs = collect(0ft:0.1ft:max_x) 
	M_ns = [Flexure.calc_Mnx(w, x)*ϕ_b for x in xs] .|> kip*ft

	M_n = Flexure.calc_Mnx(w, L_b)*ϕ_b
	M_n = round(kip*ft, M_n, digits=2)
	
	l = Layout(
		;title=attr(
			text = "$(w.shape) Moment Capacity ($(Flexure.classify_section(w)))",
			x = 0.5
		),
		xaxis_title="Lateral Braced Length (ft)",
		yaxis_title="Moment (kip-ft)",
		xaxis_gridcolor = "lightgrey",
		yaxis_gridcolor = "lightgrey",
		xaxis_showgrid=true, 
		yaxis_showgrid=true,
		plot_bgcolor="white"
                   )
	trace1 = scatter(
			x=xs, 
			y=M_ns,
			mode="lines",
			name="Moment Capacity",
		)
	trace2 = scatter(
		x=[L_b], 
		y=[Flexure.calc_Mnx(w, L_b)*ϕ_b],
		mode="markers+text",
		text=["$M_n"],
		textposition="right",
		name="ϕM_n",
		)
	plot([trace1, trace2], l)
	# p = plot(xs, M_ns, title="Moment Capacity")
 #    plot(scatter([L_b], [Flexure.calc_Mnx(w, L_b)*ϕ_b], 
	# 	# xlabel="Lateral Braced Length", 
	# 	# ylabel="Moment", 
	# 	# label="ϕM_n",
	# 	# title="$(w.shape) Moment Capacity ($(Flexure.classify_section(w)))",
	# 	# series_annotations = [Plots.text("   $M_n", 6, :left)]
	# ))
end

# ╔═╡ 2d322e46-9b1b-44d2-9a93-9dea65945768
md" ## Determine if Section is Compact"

# ╔═╡ 08701b61-f7a5-4e0e-9844-254c331f2276
md"""
## Determine the limiting ratios (AISC Table B4.1b)
### Check Flange
"""

# ╔═╡ 536885c8-73d7-47ab-9b79-6071391d5710
@handcalcs begin
λ_f, λ_pf, λ_rf, λ_fclass = Flexure.classify_flange_major_axis(w)
end

# ╔═╡ 01cd1817-7493-4c4e-908d-0fba32860bb4
L"\text{\color{blue}Flange is %$λ_fclass}"

# ╔═╡ 29bbc01a-c3e4-44b1-94ee-a7ec102308c0
md"### Check Web"

# ╔═╡ 5eb052e9-5f8c-4502-8ac3-7ab87bab1361
@handcalcs begin
λ_w, λ_pw, λ_rw, λ_wclass = Flexure.classify_web(w)
end

# ╔═╡ f12e06f8-1dfc-4e04-bd9a-1da1d733fe56
L"\text{\color{blue}Web is %$λ_wclass}"

# ╔═╡ ad759d44-ab32-4ca8-b7e7-664720df987d
begin
	section_class = Flexure.classify_section(w)
	L"\text{\color{blue} W-Shape is classified as %$section_class}"
end

# ╔═╡ 9c734a4d-afc0-42ba-91e7-4044b40d8032
if λ_fclass == :compact
	md"## Determine Flexural Capacity based on Chapter F, Section 2"
else
	md"## Determine Flexural Capacity based on Chapter F, Section 3"
end

# ╔═╡ 208b1627-8bc3-48ae-b150-6d4ad63a475b
md"### Calculate Miscellaneous Variables"

# ╔═╡ 35e59de0-fb24-43e6-8e71-c62b01c66dbc
if section_class == :F2
	p1 = md"### 1. Yielding"
	p2 = md"### 2. Lateral Torsional Buckling"
	p3 = md""
	p4 = md""
	@handcalcs begin 
		(;M_p, L_p, L_r, F_cr) = Flexure.F2.calc_variables(w, L_b)
	end
elseif section_class == :F3
	p1 = md"### 1. Lateral Torsional Buckling"
	p2 = md"### 2. Compression Flange Local Buckling"
	p3 = md""
	p4 = md""
	@handcalcs begin 
		(;M_p, L_p, L_r, F_cr, k_c) = Flexure.F3.calc_variables(w, L_b)
	end len= :long
elseif section_class == :F4
	p1 = md"### 1. Compression Flange Yielding"
	p2 = md"### 2. Lateral Torsional Buckling"
	p3 = md"### 3. Compression Flange Local Buckling"
	p4 = md"### 4. Tension Flange Yielding"
	@handcalcs begin 
		(;M_p, M_yc, M_yt, k_c, F_cr, F_L, L_p, L_r, R_pc, R_pt) = Flexure.F4.calc_variables(w, L_b, λ_w, λ_pw, λ_rw)
	end not_funcs = [:zero]
else
	p1 = md"### 1. Compression Flange Yielding"
	p2 = md"### 2. Lateral Torsional Buckling"
	p3 = md"### 3. Compression Flange Local Buckling"
	p4 = md"### 4. Tension Flange Yielding"
	@handcalcs begin
	(;M_p, R_pg, F_crLTB, F_crCFLB) = Flexure.F5.calc_variables(w, L_b, λ_f, λ_pf, λ_rf, λ_fclass)
	end
end

# ╔═╡ 51f64402-6f11-473d-b8cc-5413755afd49
p1

# ╔═╡ 13c498b5-b029-45e3-b4c5-41a623b4e653
if section_class == :F2
	@handcalcs begin 
		M_n1 = Chf.F2.calc_MnFY(M_p)
	end
elseif section_class == :F3
	@handcalcs begin 
		M_n1 = Chf.F3.calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r)
	end len=:long
elseif section_class == :F4
	@handcalcs begin 
		M_n1 = Chf.F4.calc_MnCFY(R_pc, M_yc)
	end len=:long
else
	@handcalcs begin 
		M_n1 = Chf.F5.calc_MnCFY(M_p)
	end
end

# ╔═╡ 943ab848-5503-40a1-93dc-7f5554d00eed
p2

# ╔═╡ 38e78ac9-b1dd-4dd4-a302-357c637715f1
if section_class == :F2
	@handcalcs begin 
		M_n2 = Chf.F2.calc_MnLTB(M_p, F_y, S_x, F_cr, L_b, L_p, L_r)
	end len=:long
elseif section_class == :F3
	@handcalcs begin 
		M_n2 = Chf.F3.calc_MnCFLB(M_p, E, F_y, S_x, k_c, λ_f, λ_pf, λ_rf, λ_fclass)
	end
elseif section_class == :F4
	@handcalcs begin 
		M_n2 = Chf.F4.calc_MnLTB(M_p, R_pc, M_yc, F_L, S_x, F_cr, L_b, L_p, L_r)
	end
else
	@handcalcs begin 
		M_n2 = Chf.F5.calc_MnLTB(R_pg, F_crLTB, S_x)
	end
end

# ╔═╡ dd663dc2-ac32-46dd-8aa4-36f9144eef76
p3

# ╔═╡ 309b20c2-8fe1-4f5c-a2e6-d4d27776903a
if section_class == :F2
	M_n3 = M_p
	nothing
elseif section_class == :F3
	M_n3 = M_p
	nothing
elseif section_class == :F4
	@handcalcs begin 
		M_n3 = Chf.F4.calc_MnCFLB(M_p, R_pc, M_yc, F_L, S_x, E, k_c, λ_f, λ_pf, λ_rf, λ_fclass)
	end
else
	@handcalcs begin 
		M_n3 = Chf.F5.calc_MnCFLB(R_pg, F_crCFLB, S_x)
	end
end

# ╔═╡ 5fc2d565-0edd-4e55-86ea-a342bf2b6aed
p4

# ╔═╡ 08fc9b39-5910-4760-9cb0-14505f88ab15
if section_class == :F2
	M_n4 = M_p
	nothing
elseif section_class == :F3
	M_n4 = M_p
	nothing
elseif section_class == :F4
	@handcalcs begin 
		M_n4 = Chf.F4.calc_MnTFY(M_p, R_pt, M_yt, S_x, S_x)
	end
else
	@handcalcs begin 
		M_n4 = Chf.F5.calc_MnTFY(F_y, S_x)
	end
end

# ╔═╡ 20fa8d0b-3223-48ff-9dc2-1fe4dbadedbe
md"### Flexure Capacity"

# ╔═╡ a0b5b142-6f8a-4662-b8b9-dbbf90ab5f73
if section_class == :F2
	@handcalcs begin ϕM_n = ϕ_b*min(M_n1, M_n2) end
elseif section_class == :F3
	@handcalcs begin ϕM_n = ϕ_b*min(M_n1, M_n2) end
elseif section_class == :F4
	@handcalcs begin ϕM_n = ϕ_b*min(M_n1, M_n2, M_n3, M_n4) end
else
	@handcalcs begin ϕM_n = ϕ_b*min(M_n1, M_n2, M_n3, M_n4) end
end

# ╔═╡ d28355b3-6028-45f9-b411-570c207a31b0
begin
	w_load = ϕM_n*8/L_b^2
	w_load_strip = ustrip(Float64, kip/ft ,w_load)
	w_load_total = round(kip, w_load*L_b, digits=2)
	md"""
	**This means a $(w.shape) with a steel strength of $(w.F_y), when oriented properly and spanned a distance of $(L_b), can hold about $(round(w_load_strip, digits=2)) kips per foot (1 kip = 1000 lbs) without any lateral bracing.**
	
	**That is a total of $(w_load_total)s!**
	"""
end

# ╔═╡ 103caf9f-123d-470d-8141-3739f60cd6df
md"""
## Reporting

You can create reports with this tool as well. See [here](https://github.com/co1emi11er2/Handcalcs.jl/blob/master/examples/aisc_example.pdf) for an example that was made using quarto.

There currently isn't a great way to integrate Quarto and Pluto. It is best to use Jupyter or a qmd file at the moment. Hopefully Pluto will get better integration in the future.
"""

# ╔═╡ 8b234519-539d-4774-b18f-2f65377606c6
md"""
# Thank you

Thank you for taking your time to read about Handcalcs.jl. I hope you find the package useful. Feel free to contact me through Github at the [Handcalcs Github Page](https://github.com/co1emi11er2/Handcalcs.jl) if you have any questions or find any bugs!
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AISCSteel = "599de4a1-440e-403d-8b33-ce14758023a2"
Handcalcs = "e8a07092-c156-4455-ab8e-ed8bc81edefb"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StructuralUnits = "ec81c399-378c-4a82-baa1-80fb2fc85b6c"
TestHandcalcFunctions = "6ba57fb7-81df-4b24-8e8e-a3885b6fcae7"

[compat]
AISCSteel = "~0.2.0"
Handcalcs = "~0.5.0"
LaTeXStrings = "~1.4.0"
PlutoPlotly = "~0.6.2"
PlutoUI = "~0.7.61"
StructuralUnits = "~0.2.0"
TestHandcalcFunctions = "~0.2.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.8"
manifest_format = "2.0"
project_hash = "5fa37c06d73c6e8872c517e468f2b9a10f49414e"

[[deps.AISCSteel]]
deps = ["CSV", "DataFramesMeta", "EnumX", "StructuralUnits"]
git-tree-sha1 = "24ce089a7a31dcd73a89e4442e2f053a542fd797"
uuid = "599de4a1-440e-403d-8b33-ce14758023a2"
version = "0.2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "deddd8725e5e1cc49ee205a1964256043720a6c3"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.15"

[[deps.Chain]]
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

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

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "fb61b4812c49343d7ef0b533ba982c46021938a6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport", "TableMetadataTools"]
git-tree-sha1 = "21a4335f249f8b5f311d00d5e62938b50ccace4e"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.15.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Handcalcs]]
deps = ["AbstractTrees", "CodeTracking", "InteractiveUtils", "LaTeXStrings", "Latexify", "MacroTools", "PrecompileTools", "Revise", "TestHandcalcFunctions"]
git-tree-sha1 = "1bb18c94645287fa0c499da38a6f04f74ef8f66d"
uuid = "e8a07092-c156-4455-ab8e-ed8bc81edefb"
version = "0.5.0"

[[deps.HashArrayMappedTries]]
git-tree-sha1 = "2eaa69a7cab70a52b9687c8bf950a5a93ec895ae"
uuid = "076d061b-32b6-4027-95e0-9a2c6f6d7e74"
version = "0.2.0"

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

[[deps.InlineStrings]]
git-tree-sha1 = "6a9fde685a7ac1eb3495f8e812c5a7c3711c2d5e"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.3"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a434e811d10e7cbf4f0674285542e697dca605d0"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.42"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd714447457c660382fe634710fb56eb255ee42e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.6"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "688d6d9e098109051ae33d126fcfc88c4ce4a021"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "1833212fd6f580c20d4291da9c1b4e8a655b128e"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.0.0"

[[deps.MacroTools]]
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Colors", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "90af5c9238c1b3b25421f1fdfffd1e8fca7a7133"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.20"

    [deps.PlotlyBase.extensions]
    DataFramesExt = "DataFrames"
    DistributionsExt = "Distributions"
    IJuliaExt = "IJulia"
    JSON3Ext = "JSON3"

    [deps.PlotlyBase.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Artifacts", "ColorSchemes", "Colors", "Dates", "Downloads", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "Pkg", "PlotlyBase", "PrecompileTools", "Reexport", "ScopedValues", "Scratch", "TOML"]
git-tree-sha1 = "9ebe25fc4703d4112cc418834d5e4c9a4b29087d"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.6.2"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"
    UnitfulExt = "Unitful"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "7e71a55b87222942f0f9337be62e26b1f103d3e4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.61"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Revise]]
deps = ["CodeTracking", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "9bb80533cb9769933954ea4ffbecb3025a783198"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.7.2"

    [deps.Revise.extensions]
    DistributedExt = "Distributed"

    [deps.Revise.weakdeps]
    Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.ScopedValues]]
deps = ["HashArrayMappedTries", "Logging"]
git-tree-sha1 = "1147f140b4c8ddab224c94efa9569fc23d63ab44"
uuid = "7e506255-f358-4e82-b7e4-beb19740aa63"
version = "1.3.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "712fb0231ee6f9120e005ccd56297abbc053e7e0"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.8"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "725421ae8e530ec29bcbdddbe91ff8053421d023"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.1"

[[deps.StructuralUnits]]
deps = ["Reexport", "Unitful", "UnitfulLatexify"]
git-tree-sha1 = "0e2a61508c26a096c3c032a55f9f997b13011b59"
uuid = "ec81c399-378c-4a82-baa1-80fb2fc85b6c"
version = "0.2.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableMetadataTools]]
deps = ["DataAPI", "Dates", "TOML", "Tables", "Unitful"]
git-tree-sha1 = "c0405d3f8189bb9a9755e429c6ea2138fca7e31f"
uuid = "9ce81f87-eacc-4366-bf80-b621a3098ee2"
version = "0.1.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

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

[[deps.TestHandcalcFunctions]]
git-tree-sha1 = "54dac4d0a0cd2fc20ceb72e0635ee3c74b24b840"
uuid = "6ba57fb7-81df-4b24-8e8e-a3885b6fcae7"
version = "0.2.4"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═12d41162-b9aa-11ef-33d9-a32698d6f054
# ╟─5ac917a4-79bf-419e-9eff-6501c2d15d28
# ╟─bd811c3e-6802-4c5a-9904-9e6044c976be
# ╟─a8bb7d69-55a4-4381-aa98-b2169d3064d7
# ╟─897f866e-40ef-4c47-993e-40f58f8c340b
# ╟─98ec50cc-dddf-48ac-9806-990a9e2e334a
# ╟─18eded2b-f973-4a61-9754-56331fd01336
# ╠═ba51899c-61d6-440d-8263-d479f6a871f6
# ╟─a2758980-252e-4e6b-baf3-a5a6e85df34d
# ╟─27b55f64-358e-4bc2-a5f4-315ea361b646
# ╠═0eac9a5a-c6a8-43e9-99c9-16f7c3d77204
# ╠═00e75249-8d2c-4407-9564-68c8d79fc29f
# ╟─2a7e9993-74f9-48f8-964b-e858e3b96672
# ╠═3589a61a-84a2-4413-9fb9-3454105f6df2
# ╟─f3a4d941-fcd4-421b-94e4-2d486e71da12
# ╟─69f31cc2-af12-4a8c-bbf1-9959f9d78b4f
# ╠═79f4fb1c-e512-4af6-835c-ea0865d80c5e
# ╟─cd4ab653-0627-44e4-8b58-c475e0a0a251
# ╟─99730005-9dca-48aa-a409-5b0438660220
# ╟─6633dd4a-2b68-4127-90ed-9e4caab68f56
# ╟─c0a250de-36dd-4647-9281-c237e9efd359
# ╠═b5c7a277-da51-487b-869e-1936816017ac
# ╠═54ea2e03-ab01-4371-a13d-c3de13876c10
# ╠═ef8baa5a-90ef-4a67-94bc-40d6c50abe74
# ╟─ec3681b3-7c95-4c4e-8320-89f535440d92
# ╠═1c5ec9af-8f8b-416d-ad76-aec0af292895
# ╟─20503429-f22b-49b0-9f06-3ffcfc811a93
# ╠═fd00ab45-3967-4159-88a3-e6a924be40bc
# ╟─350d438e-1cfa-4c4c-85ff-afdfecfc171e
# ╠═43633b23-b5cd-45ad-893f-ecd766726610
# ╟─778b64c5-6a06-4e74-8da6-67a83f08eac5
# ╠═4b8d463f-b186-4d1f-9b80-62ff7a5a886d
# ╟─24c12e97-4090-48a4-8c66-bb5d2068e1e4
# ╟─3867ea24-0e62-46bf-84e3-b86bc3e74ae7
# ╟─ad2ea96b-4b87-49ed-bd5e-37aca4f8973d
# ╟─bec7dfa6-8787-45b7-b2cb-230666712a3f
# ╠═5dd3bce5-9f12-480d-9000-ec84766c18be
# ╟─07ff6778-df02-4dc1-81ba-661afaec6320
# ╠═b2237f22-b523-4f71-b196-85e1fdddb393
# ╟─740bda9e-8191-447b-ba1d-e5a8784fca84
# ╟─42e089cd-1ec2-4924-ac4a-d42d18c9c68a
# ╟─3f2d9d3e-82f9-4cc7-bf06-18bd33dde4c0
# ╟─081762c8-3109-438a-abd4-17f20c7db455
# ╠═4b9ff29b-d777-4694-926a-5c95851e81e7
# ╟─7c09b665-e48b-4825-bd75-4540ba12afeb
# ╟─c3addf2d-bdaf-4d09-88c4-0aca5cac368a
# ╟─9d6f3c2a-fe77-4712-94b5-1dd9c61edc22
# ╟─e266ab7d-21a6-4f91-a229-102e27a4e68d
# ╠═bdb88b43-7c4f-48a8-b6b5-0130cf5f402a
# ╟─8a0028f1-1d1d-4448-a20a-9bc25b17e02c
# ╟─39977ff0-c012-499d-9985-690d5455cf2d
# ╟─a185cb84-0b40-4f57-8c6b-6de9a750fc9b
# ╠═57c31b0f-2ff6-4038-bddd-b8339e7017c5
# ╟─47e751ee-4cd5-4c80-904e-2439e7674b6a
# ╟─adaaad57-7ace-4df4-95e6-221e8800e6a5
# ╠═7cba83f6-caef-4490-9329-fb9d33e15041
# ╟─c369e6bc-74bf-4f1a-9c2d-0254d121119f
# ╠═35fc8539-d9b7-4917-81e5-51e5c1623efd
# ╟─64b18b41-1d01-4b63-91d1-ba470ab2626c
# ╠═4fc079d2-e40c-4324-9797-973253955815
# ╟─c2252cdb-4151-4a2a-b421-2e808bb26883
# ╟─5ba38942-a676-40a7-9d9c-821f76d642d6
# ╟─0db4dbe2-4405-463c-a676-b26e652c4d03
# ╟─a7064738-e518-42c6-9aa8-f8bc2e013f2d
# ╟─fdee2c0c-add7-4e08-a307-9259711a61b1
# ╠═cae8c270-c620-4bb4-9175-a8702e7ed7ab
# ╟─419375f5-1f14-465e-8d3f-3c7fd5664166
# ╟─4b33c7b8-460e-4248-bbb6-58ebe434fa0c
# ╟─73050a9f-3938-4d90-b7d6-e145ae7c6a9d
# ╠═1a2b22b3-b730-4475-85cb-ec284ae1612c
# ╟─f827503c-ef71-48e1-9e54-c46afd810bed
# ╠═1cc8d792-6850-490c-bc1a-12c1059acf1b
# ╠═089d48f6-76fa-4610-a007-c18246ef25cb
# ╟─209b7fc9-a06a-43de-9400-fa6537d4350c
# ╟─1ee5a282-0919-4e2a-982a-845a89de384d
# ╟─083d1e86-90da-4e54-adbb-06939a665c3f
# ╟─3610dacf-fa4d-446a-8e3b-ef0dc645e074
# ╟─bf97f95b-860b-4367-b5bd-6081c384dd40
# ╟─5cec6944-201d-498e-b2e1-6844c8c56d2b
# ╟─2d322e46-9b1b-44d2-9a93-9dea65945768
# ╟─08701b61-f7a5-4e0e-9844-254c331f2276
# ╠═536885c8-73d7-47ab-9b79-6071391d5710
# ╟─01cd1817-7493-4c4e-908d-0fba32860bb4
# ╟─29bbc01a-c3e4-44b1-94ee-a7ec102308c0
# ╠═5eb052e9-5f8c-4502-8ac3-7ab87bab1361
# ╟─f12e06f8-1dfc-4e04-bd9a-1da1d733fe56
# ╟─ad759d44-ab32-4ca8-b7e7-664720df987d
# ╟─9c734a4d-afc0-42ba-91e7-4044b40d8032
# ╟─208b1627-8bc3-48ae-b150-6d4ad63a475b
# ╟─35e59de0-fb24-43e6-8e71-c62b01c66dbc
# ╟─51f64402-6f11-473d-b8cc-5413755afd49
# ╟─13c498b5-b029-45e3-b4c5-41a623b4e653
# ╟─943ab848-5503-40a1-93dc-7f5554d00eed
# ╟─38e78ac9-b1dd-4dd4-a302-357c637715f1
# ╟─dd663dc2-ac32-46dd-8aa4-36f9144eef76
# ╟─309b20c2-8fe1-4f5c-a2e6-d4d27776903a
# ╟─5fc2d565-0edd-4e55-86ea-a342bf2b6aed
# ╟─08fc9b39-5910-4760-9cb0-14505f88ab15
# ╟─20fa8d0b-3223-48ff-9dc2-1fe4dbadedbe
# ╟─a0b5b142-6f8a-4662-b8b9-dbbf90ab5f73
# ╟─d28355b3-6028-45f9-b411-570c207a31b0
# ╟─103caf9f-123d-470d-8141-3739f60cd6df
# ╟─8b234519-539d-4774-b18f-2f65377606c6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
