### A Pluto.jl notebook ###
# v0.19.32

#> [frontmatter]
#> image = "https://jupyter.org/assets/homepage/main-logo.svg"
#> title = "Pluto for Jupyter users"
#> tags = ["basic"]
#> description = "Coming to Pluto from Jupyter? Here's what you need to know!"

using Markdown
using InteractiveUtils

# ╔═╡ db1ef6d1-7921-4035-8705-a0820048b785
using PlutoUI

# ╔═╡ cdbcc440-858c-11ee-25d2-dd9d69531eef
md"""
# Pluto for Jupyter users

[Jupyter](https://jupyter.org/) is another open source notebook environment, that works with Julia, Python, and R. If you're already familiar with Jupyter and are now trying out Pluto, this notebook is for you!
"""

# ╔═╡ b5eefb2d-95f0-474e-9651-dfe91f627ec3
md"""
## Reactivity

The key difference between Pluto and Jupyter is *reactivity*.

Here we have two cells: one defines `x`, and one defines `y`, which depends on `x`. Try changing the value of `x` here, and see what happens!
"""

# ╔═╡ b25c812b-7ec2-4e17-aa1b-e1a1407d29fb
x = 1

# ╔═╡ 8e1faf5f-7b60-4b57-9902-e9d2531f0961
y = x + 1

# ╔═╡ fcc01f50-521d-44e3-b162-b689379db2af
md"""
When you change `x`, `y` is immediately updated with it!

This can save you some tedious work where you have to rerun several cells after making an update. But it's more than a time-saver!
"""

# ╔═╡ d65cefad-e53f-4dc9-86cf-a6c010d36a23
md"""
In a Jupyter notebook, your session has an internal *state*, that contains all the variables you have defined. When you run a cell defining `x = 1`, the value of `x` is stored - and it will stay there when you remove the cell. So now your session remembers that `x = 1`, even though you don't have any code saying that!

This can cause all sorts of headaches. You might recognise some of these situations:
- You work on a notebook and it all runs great. The next day, you open it again, and suddenly it doesn't work anymore.
- You ask someone for help with a notebook, but they can't see the issue. Finally, you realise the problem was a line of code that you had written *and* deleted an hour ago!
- 
"""

# ╔═╡ 798659b9-583c-41d2-8cf7-cc1ac18d0992
md"""
## Multiple expressions per cell

It may surprise you that you can't put multiple expressions in the same cell:
"""

# ╔═╡ 89670543-7e56-4c7d-8d33-25430e99f8e6
cat = "🐈"
dog = "🐕"

# ╔═╡ 4e964657-88ba-4ad2-8c25-ff2e3053fb69
md"""
There are a few ways to make this code work again. As the error message suggests, you can just split up your code in multiple cells. It is also possible to wrap the code in a `begin`/`end` block, like this:
"""

# ╔═╡ 34ae0410-a129-4720-ac40-23b36c48f470
begin
	cat = "🐈"
	dog = "🐕"
end

# ╔═╡ 42bf60f4-72b5-45f0-8924-65715675bf20
md"""
In other cases, it may be more appropriate to use a `let`/`end` block, where you use a few lines of code but only define one variable.
"""

# ╔═╡ 46d8bf1a-0565-4c4f-b6ef-2e75a1f96ea2
mice = let
	mouse1 = "🐁"
	mouse2 = "🐭"
	mouse1 * mouse2
end

# ╔═╡ 1d93dabf-8583-4f7f-a48e-e339c7d73bba
md"""
Coming from Jupyter, this can all feel very frustrating. Jupyter programmers tend to use cells as little "sections" of code, and are often used to having a few lines of code per cell.

This makes sense for Jupyter! We've already talked about reactivity. In Jupyter, you want to avoid having to rerun many cells when you change a variable. So it's more efficient to group related statements that you can run together.

In Pluto, you don't have to worry about any of that! Instead, Pluto's analysis of the dependencies in your code works best when you use one variable per cell.

A lot of Jupyter start out by wrapping every cell in a `begin`/`end` block. Of course, you are the best person to decide what style of code works for you, but I encourage you to give this one-expression-per-cell style a chance!
"""

# ╔═╡ 9bf88092-2c64-43e9-8d84-619cbcf64b09
md"""
## Package management

Here is a neat thing about Pluto: by default, it will manage your packages for you!

Packages are automatically installed when you use `import` or `using`. To use a package, you simply have to create cell like this:
"""

# ╔═╡ 74ff3d85-a6f4-4ae4-8502-18cf7a180ac5
md"""
As you're probably aware, the good folks maintaining packages will release new versions over time. That's great, but it can cause issues with compatibility.

Because of this, it can be useful if you've written down somewhere which versions of each package you were using - and if you're running someone else's code, you can avoid errors by using the same versions they used.

In Pluto all of that happens automatically: your package environment is stored inside the notebook file. When someone else opens your notebook with Pluto, the exact same package environment will be used, and packages will work on their computer.
"""

# ╔═╡ 491e1d24-c08b-438f-9947-9e9f2639e97f
md"""
!!! tip

	If you're starting to protest because you're used to managing your own package environment, don't worry. Calling `Pkg.activate` will disable Pluto's package manager.
"""

# ╔═╡ 58761686-b3c8-47f3-b05c-616f34ac71d9
md"""
For more information on this, [read about package management on the Pluto.jl wiki](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management).
"""

# ╔═╡ 8bbe13ff-f643-4ed0-aacf-9bafaa7c59c0
md"""
## Markdown cells

Unlike Jupyter, Pluto doesn't have text cells or markdown cells. Ever cell is just Julia code. However, you can write markdown expressions in Julia, and those will be nicely displayed by Pluto. Like this:
"""

# ╔═╡ 016f9e48-1672-481e-b642-d0c6bf67a5bc
md"""
This cell contains some **text** in *Markdown*!
"""

# ╔═╡ 669323ca-aac3-415c-bbfc-14525447ccd8
md"""
!!! tip

	Use `ctrl + M` / `cmd + M` in a cell to wrap it in `md""\"` markers!
"""

# ╔═╡ 9c9e807d-7b6b-47ff-b98f-351f0e0ee90c
md"""
## Version control

Many programmers work with git to keep track of the different versions of their code that develop over time. Git is a useful tool to keep track of your changes, even between different collaborators and different "branches" of the project. When developing large coding projects with a group of people, version control is indispensible.

The files for Jupyter notebooks are not very suitable for keeping track of changes over time, though. Opening a notebook, running the code and changing a single line can cause a lot of changes in the file.

This is because Jupyter notebooks contain not just the code, but also information about the output of the cells and the order in which they were run. That information is useful in some cases, but for version control, it creates a lot of clutter.

If you do the kind of programming where version control is important, you'll find that Pluto notebooks work really well with that!
"""

# ╔═╡ e1c813e5-a393-4364-8494-687b98811a0b
md"""
## Other programming languages

Jupyter was created to work with Julia, Python, and R (hence the name), and can even be made compatible with other languages!

Pluto, however, is only ever going to be Julia environment. The core of Pluto is built in Julia, and Pluto's reactivity works by analysing your code. Jupyter is built to be largely language-agnostic, but Pluto decidedly isn't.

This comes with pros and cons: Pluto can do some cool stuff because it knows the language you're working in, but it doesn't have the flexibility that Jupyter does.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.53"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "db8ec28846dbf846228a32de5a6912c63e2052e3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.53"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─cdbcc440-858c-11ee-25d2-dd9d69531eef
# ╟─b5eefb2d-95f0-474e-9651-dfe91f627ec3
# ╠═b25c812b-7ec2-4e17-aa1b-e1a1407d29fb
# ╠═8e1faf5f-7b60-4b57-9902-e9d2531f0961
# ╟─fcc01f50-521d-44e3-b162-b689379db2af
# ╟─d65cefad-e53f-4dc9-86cf-a6c010d36a23
# ╟─798659b9-583c-41d2-8cf7-cc1ac18d0992
# ╠═89670543-7e56-4c7d-8d33-25430e99f8e6
# ╟─4e964657-88ba-4ad2-8c25-ff2e3053fb69
# ╠═34ae0410-a129-4720-ac40-23b36c48f470
# ╟─42bf60f4-72b5-45f0-8924-65715675bf20
# ╠═46d8bf1a-0565-4c4f-b6ef-2e75a1f96ea2
# ╟─1d93dabf-8583-4f7f-a48e-e339c7d73bba
# ╟─9bf88092-2c64-43e9-8d84-619cbcf64b09
# ╠═db1ef6d1-7921-4035-8705-a0820048b785
# ╟─74ff3d85-a6f4-4ae4-8502-18cf7a180ac5
# ╟─491e1d24-c08b-438f-9947-9e9f2639e97f
# ╟─58761686-b3c8-47f3-b05c-616f34ac71d9
# ╟─8bbe13ff-f643-4ed0-aacf-9bafaa7c59c0
# ╠═016f9e48-1672-481e-b642-d0c6bf67a5bc
# ╟─669323ca-aac3-415c-bbfc-14525447ccd8
# ╟─9c9e807d-7b6b-47ff-b98f-351f0e0ee90c
# ╟─e1c813e5-a393-4364-8494-687b98811a0b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
