### A Pluto.jl notebook ###
# v0.20.23

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

# ╔═╡ de8a4ea0-1612-11f1-2797-4d9056ff202f
using ForwardDiff

# ╔═╡ b3c85af5-ebf5-47f5-9904-e1a2730ed369
using PlutoUI

# ╔═╡ 7645bc1a-57c7-4f95-a025-70bad52a896e
using PlutoPlotly

# ╔═╡ c80bc51c-0261-4c96-8544-59f7767f1a4b
begin
	
	# Setup some default settings for the layout:
	layout = PlutoPlotly.Layout(
	    xaxis=attr(range=[-3, 3]),          # xlim
	    yaxis=attr(range=[-1.5, 1.5]),      # ylim
	    width=600,                           # figure width
	    height=300,                          # figure height
	    font=attr(family="Arial", size=12), # optional for readability
	    showlegend=true
)
end

# ╔═╡ 1641945a-b35c-4c24-b1fa-48dbffe1affb
md"Your currently chosen point:"

# ╔═╡ 834a78e6-244e-41da-96f9-0ce2b7125a37
@bindname x₀ Slider(-3:.01:3; default=.8, show_value=true)

# ╔═╡ a6176fcc-5efd-4c36-8279-550894b959b4
md"""
We can use `f` to calculate the value, and `ForwardDiff` for the derivative at `x_0`:
"""

# ╔═╡ 3b539fcd-22ff-4183-871a-94e56e4a0d42
md"""
Let's show this in a graph by drawing a **tangent** line with these values:
"""

# ╔═╡ 7dd56bcf-0cb6-4380-9340-710a58909897
md"We can also do the same thing for 3D data:"

# ╔═╡ 77660563-a3c3-4419-8af2-c0420d4c6c9e
md"Define your 3D domain size here:"

# ╔═╡ 330b4687-b097-4f63-854a-5b2655a35ec8
S = 20

# ╔═╡ 149b2e74-9429-4ce0-8bca-ec251a589899
md"Now chose a point on the grid:"

# ╔═╡ f998d9b3-4262-4530-ba1e-5381ae24a748
 @bindname z₀x PlutoUI.Slider(-1:0.1:1; default=0.1, show_value=true)

# ╔═╡ 261093b6-ccce-4060-930e-64ec5dc02d4c
 @bindname z₀y PlutoUI.Slider(-1:0.1:1; default=0.1, show_value=true)

# ╔═╡ 33d7038a-990c-4592-80a8-52fa6a5390c3
z₀ = [z₀x, z₀y]

# ╔═╡ c98c2c1f-bd35-496a-a4e5-83cb1cb8bc4a
md"""
Again, we can use $f_{3d}$ to calculate the value, and `ForwardDiff` for the gradient at $z_0$:
"""

# ╔═╡ 01ac7b12-c5a7-443f-b807-1d596cfe1ef9
# This helps control the size of the tangent plane for better visibility
@bindname r Slider(0.1:0.05:2.0, default=0.5)

# ╔═╡ 44345c3c-24e8-4216-8771-334e74de86af
md"## Bonus Tips

You can also use `ForwardDiff` to calculate a lot of other helpful functions:"

# ╔═╡ 085dff59-20b0-460b-a242-e5fd60f69986
g(y::Real) = [sin(y), 1/y]; # g: scalar → vector

# ╔═╡ 64e27aa8-e248-42b1-ac85-4e4743853c07
deriv_vec = ForwardDiff.derivative(g, pi/4)

# ╔═╡ 12439c8f-4864-4548-9001-cbe6ab81d0f0
h(x::Vector) = [cos(x[1]) + x[2]^2, 1/x[1]*x[2]]; # h: vector → vector

# ╔═╡ 04077410-4c77-4884-b807-1fbed2bc037b
jacobian = ForwardDiff.jacobian(h, z₀) 

# ╔═╡ ff11846e-c435-4ca3-8a15-3bbd4ff9208c
md"# Appendix"

# ╔═╡ 7797dbd1-5ba8-4b83-b259-7348323939f1
x = range(-1, 1, length=S);

# ╔═╡ 9d9853de-bf17-4a99-99ea-9e230703e80f
y = range(-1, 1, length=S);

# ╔═╡ 97584846-51b3-4ed2-93ed-c2bdca377468
f2(z) = 1/z

# ╔═╡ 24c89d68-a741-4221-9328-9cf1d62ce0dc
f1(z) = sin(z)

# ╔═╡ 0755da84-e9b3-464d-be7b-f8c8363b45a3
f3(z) = z^4 - 1

# ╔═╡ e4bd3b93-cf5d-4825-8290-642fb9d49575
σ(z) = 1/(1 + exp(-z))

# ╔═╡ d523567f-1408-4803-b1d5-fda3797f1485
function_chooser = @bind f Select([f1 => md"Fun sin f1", f2 => "Boring Inverse f2", f3 => "Simple Polynomial f3", σ => "Famous sigma σ"]);

# ╔═╡ 9e7a7ee1-fe83-4c7b-ac49-c7d6acf0f066
function_chooser

# ╔═╡ 4e1cc405-c5d2-4c78-aa57-b1518b9f5694
val = f(x₀)

# ╔═╡ 40570c4c-4b89-4384-a5ec-88aa34f1c790
deriv = ForwardDiff.derivative(f, x₀)

# ╔═╡ 298e4328-32b3-43cf-9712-ac3ced3f207a
let
	# Define the domain
	i = 3;
	x_2d = range(-i, i, length=i*10);
	
	# Plot f and x₀:
	trace_f = PlutoPlotly.scatter(
	    x=x_2d,           # vector of x-values
	    y=f.(x_2d),       # evaluate f at each x
	    mode="lines",  # line plot
	    name="f(x)"    # label in legend
	)

	trace_point = PlutoPlotly.scatter(
	    x=[x₀],
	    y=[val],
	    mode="markers",
	    marker=attr(size=8, color="rgba(255,100,100,0.95)"),
	    name="x₀"
	)

	# The tangent line function:
	tangent(x) = (x - x₀)*deriv + val
	trace_tangent = PlutoPlotly.scatter(
	    x=x_2d,           
	    y=tangent.(x_2d),       
	    mode="lines",
		marker=attr(size=8, color="rgba(255,100,100,0.5)"),
	    name="tangent"    
	)

	PlutoPlotly.plot([trace_f, trace_point, trace_tangent], layout)
end

# ╔═╡ c1a9d891-c4eb-4239-9450-ed2f4e255d91
function_names = Dict(
    f1 => md"$f_1(x) = sin(x)$",
    f2 => md"$f_2(x) = 1/x$",
	f3 => md"$f_3(x) = x^4 - 1$",
	σ => md"$\sigma(x)=\frac{1}{1+e^{-x}}$",
);

# ╔═╡ d0b08993-233e-4f39-b287-b1e10b602b8d
md"Your currently chosen function is: $(function_names[f])"

# ╔═╡ 93dab591-cb97-4a98-8a0f-8ce5444cad1d
function ackley(z::Vector)
	x, y = z
	term1 = -0.2 * sqrt(0.5 * (x^2 + y^2))
	term2 = 0.5 * (cos(2π * x) + cos(2π * y))
    result = -20 * exp(term1) - exp(term2) + 20 + exp(1)
    return 2*(result / 15) - 1
end

# ╔═╡ 05d5c55c-3995-41c0-81f1-188a09e59671
function goldstein_price(z::Vector)
	x, y = z
	term1 = (1 + (x + y + 1)^2 * (19 - 14*x + 3*x^2 - 14*y + 6*x*y + 3*y^2))
	term2 = (30 + (2*x - 3*y)^2 * (18 - 32*x + 12*x^2 + 48*y - 36*x*y + 27*y^2))
	return 2* ((term1 * term2) / 10000000 / 30) - 1 

end

# ╔═╡ 046cac65-5416-460c-a8a3-cee540bb1582
# function scaled_sphere(x::Float64, y::Float64) 
	function scaled_sphere(z::Vector)
		x, y = z
	return 2*(x^2 + y^2) / 50 - 1
end

# ╔═╡ 30132636-507c-4620-81e7-803a702107f0
function_chooser3d = @bind f_3d Select([
	ackley => "Ackley",
	scaled_sphere => "Sphere",	
	((z) -> sin(sqrt(z[1]^2 + z[2]^2))) => "Sinus",
	goldstein_price => "Goldstein Price",
]);

# ╔═╡ 6af2bbb9-29cd-44ed-96ce-4b64721dad03
function_chooser3d

# ╔═╡ 964e620c-a6a1-4eb1-93a3-6ea32fc52083
f₀ = f_3d(z₀)

# ╔═╡ 77d43859-7e89-438a-a91e-a1d4f5f827a1
∇f = ForwardDiff.gradient(f_3d, z₀)

# ╔═╡ 79e5ef6e-3c16-49ce-a267-5e8ecbbf3beb
hessian = ForwardDiff.hessian(f_3d, z₀)

# ╔═╡ 89a4af4b-f445-432a-8693-0067d30fca19
z = [f_3d([x[i], y[j]]) for i in 1:S, j in 1:S];

# ╔═╡ ac13394e-ec31-46a6-a46d-ad3f646f7fde
let
	# draw the function surface
	trace1 = PlutoPlotly.surface(x=x, y=y, z=z, colorscale="Viridis", name="f(z)")

	# define the tangent function and the plane in a local area near the point
	tangent(x, y) = f₀ + ∇f[1]*(x - z₀x) + ∇f[2]*(y - z₀y)
	plane = [
		abs(x[i] - z₀x) <= r && abs(y[j] - z₀y) <= r ?
        tangent(x[i], y[j]) :
        NaN
    for i in eachindex(x), j in eachindex(y)]

	# draw the point and the tangent plane
	trace_point = PlutoPlotly.scatter3d(x=[z₀x], y=[z₀y], z=[f₀], mode="markers", marker=attr(size=3, color="red"), name="z₀")
	trace2 = PlutoPlotly.surface(x=x, y=y, z=plane, colorscale=[[0, "red"], [1, "red"]], opacity=0.6, showscale=false, name="tangent")

	# put it all together
    PlutoPlotly.plot([trace1, trace_point, trace2], Layout(uirevision = 1, scene = 		attr(aspectmode = "cube", showlegend=true, )))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ForwardDiff = "~1.3.2"
PlutoPlotly = "~0.6.5"
PlutoUI = "~0.7.79"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.5"
manifest_format = "2.0"
project_hash = "2654e168b21ac80140c2f158a6d4a8a92c2b222a"

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

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

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
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "eef4c86803f47dcb61e9b8790ecaa96956fdd8ae"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "1.3.2"

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

    [deps.ForwardDiff.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "b3ad4a0255688dcb895a52fafbaae3023b588a90"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.4.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.11.4"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Colors", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "6256ab3ee24ef079b3afa310593817e069925eeb"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.23"

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
git-tree-sha1 = "8acd04abc9a636ef57004f4c2e6f3f6ed4611099"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.6.5"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"
    UnitfulExt = "Unitful"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "3ac7038a98ef6977d44adeadc73cc6f596c08109"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.79"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

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

[[deps.ScopedValues]]
deps = ["HashArrayMappedTries", "Logging"]
git-tree-sha1 = "c3b2323466378a2ba15bea4b2f73b081e022f473"
uuid = "7e506255-f358-4e82-b7e4-beb19740aa63"
version = "1.5.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5acc6a41b3082920f79ca3c759acbcecf18a8d78"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.7.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6ab403037779dae8c514bad259f32a447262455a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "28145feabf717c5d65c1d5e09747ee7b1ff3ed13"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.6.3"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

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
# ╠═de8a4ea0-1612-11f1-2797-4d9056ff202f
# ╠═b3c85af5-ebf5-47f5-9904-e1a2730ed369
# ╠═7645bc1a-57c7-4f95-a025-70bad52a896e
# ╠═c80bc51c-0261-4c96-8544-59f7767f1a4b
# ╠═9e7a7ee1-fe83-4c7b-ac49-c7d6acf0f066
# ╟─d0b08993-233e-4f39-b287-b1e10b602b8d
# ╟─1641945a-b35c-4c24-b1fa-48dbffe1affb
# ╠═834a78e6-244e-41da-96f9-0ce2b7125a37
# ╟─a6176fcc-5efd-4c36-8279-550894b959b4
# ╠═4e1cc405-c5d2-4c78-aa57-b1518b9f5694
# ╠═40570c4c-4b89-4384-a5ec-88aa34f1c790
# ╟─3b539fcd-22ff-4183-871a-94e56e4a0d42
# ╠═298e4328-32b3-43cf-9712-ac3ced3f207a
# ╟─7dd56bcf-0cb6-4380-9340-710a58909897
# ╠═6af2bbb9-29cd-44ed-96ce-4b64721dad03
# ╟─77660563-a3c3-4419-8af2-c0420d4c6c9e
# ╠═330b4687-b097-4f63-854a-5b2655a35ec8
# ╟─149b2e74-9429-4ce0-8bca-ec251a589899
# ╠═33d7038a-990c-4592-80a8-52fa6a5390c3
# ╠═f998d9b3-4262-4530-ba1e-5381ae24a748
# ╠═261093b6-ccce-4060-930e-64ec5dc02d4c
# ╟─c98c2c1f-bd35-496a-a4e5-83cb1cb8bc4a
# ╠═964e620c-a6a1-4eb1-93a3-6ea32fc52083
# ╠═77d43859-7e89-438a-a91e-a1d4f5f827a1
# ╠═01ac7b12-c5a7-443f-b807-1d596cfe1ef9
# ╠═ac13394e-ec31-46a6-a46d-ad3f646f7fde
# ╟─44345c3c-24e8-4216-8771-334e74de86af
# ╠═79e5ef6e-3c16-49ce-a267-5e8ecbbf3beb
# ╠═64e27aa8-e248-42b1-ac85-4e4743853c07
# ╠═04077410-4c77-4884-b807-1fbed2bc037b
# ╠═085dff59-20b0-460b-a242-e5fd60f69986
# ╠═12439c8f-4864-4548-9001-cbe6ab81d0f0
# ╟─ff11846e-c435-4ca3-8a15-3bbd4ff9208c
# ╠═7797dbd1-5ba8-4b83-b259-7348323939f1
# ╠═9d9853de-bf17-4a99-99ea-9e230703e80f
# ╠═89a4af4b-f445-432a-8693-0067d30fca19
# ╠═d523567f-1408-4803-b1d5-fda3797f1485
# ╠═c1a9d891-c4eb-4239-9450-ed2f4e255d91
# ╠═97584846-51b3-4ed2-93ed-c2bdca377468
# ╠═24c89d68-a741-4221-9328-9cf1d62ce0dc
# ╠═0755da84-e9b3-464d-be7b-f8c8363b45a3
# ╠═e4bd3b93-cf5d-4825-8290-642fb9d49575
# ╠═30132636-507c-4620-81e7-803a702107f0
# ╠═93dab591-cb97-4a98-8a0f-8ce5444cad1d
# ╠═05d5c55c-3995-41c0-81f1-188a09e59671
# ╠═046cac65-5416-460c-a8a3-cee540bb1582
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
