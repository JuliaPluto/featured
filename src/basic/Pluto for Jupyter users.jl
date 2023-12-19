### A Pluto.jl notebook ###
# v0.19.33

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/main/LICENSES/Unlicense"
#> image = "https://github.com/JuliaPluto/featured/assets/6933510/19a10d1d-2a3b-42d0-9804-c1fd41c83bcd"
#> title = "Pluto for Jupyter users"
#> tags = ["basic"]
#> license = "Unlicense"
#> description = "Coming to Pluto from Jupyter? Here's what you need to know!"
#> 
#>     [[frontmatter.author]]
#>     name = "Pluto.jl"
#>     url = "https://github.com/JuliaPluto"

using Markdown
using InteractiveUtils

# ╔═╡ db1ef6d1-7921-4035-8705-a0820048b785
using PlutoUI

# ╔═╡ cdbcc440-858c-11ee-25d2-dd9d69531eef
md"""
# Pluto for Jupyter users

[Jupyter](https://jupyter.org/) is another open source notebook environment, that works with Julia, Python, and R. If you're already familiar with Jupyter and are now trying out Pluto, this notebook is for you!

We'll go over some key differences between Pluto and Jupyter. Let's get started!
"""

# ╔═╡ a423fc4f-6000-4451-bc03-4035c9847753
md"""
## Reactivity

The most notable difference between Pluto and Jupyter is *reactivity*.

Here we have two cells: one defines `x`, and one defines `y`, which depends on `x`. Try changing the value of `x` here, and see what happens!
"""

# ╔═╡ b25c812b-7ec2-4e17-aa1b-e1a1407d29fb
x = 1

# ╔═╡ 8e1faf5f-7b60-4b57-9902-e9d2531f0961
y = x + 1

# ╔═╡ 03d3ade3-056a-4f16-9b31-d259879082c9
md"""
When you change `x`, `y` is immediately updated with it! ⚡
"""

# ╔═╡ 3ed1ed94-8741-48a0-9d23-bb78499eec91
md"""
That's what we mean by reactivity in Pluto. Pluto analyses the _dependencies_ between your code, and reruns cells when needed to keep everything up to date. This is very different from Jupyter, where you were in charge of deciding when to rerun cells!
"""

# ╔═╡ 773ac617-4e5d-46b9-92ff-b0d9a23e42f1
md"""
### Why?
Reactivity can save you some tedious work of having to rerun several cells when you change a variable, but it's more than a time-saver!

Because the output of your cells is always kept up-to-date, you won't have weird errors that depend on some code that you ran in your session but deleted over an hour ago. Likewise, when you shut down Pluto and open it the next day, all your notebooks will work exactly like yesterday.

### Try it!

"""

# ╔═╡ 6ba28587-3612-45bb-a5fa-5e1ce8fa3aa6


# ╔═╡ f4d990a8-274a-4098-b4f9-ce1d39ec41a6


# ╔═╡ 74a6102a-e09d-4ebb-9ef8-2511b0f46f58
md"""
## Cell order

Like Jupyter, Pluto doesn't mind if your cells don't match execution order. Here the `mice` cell depends on `mouse`, but `mouse` comes second:
"""

# ╔═╡ 3bca136c-115f-4dd1-ac4d-d14c23c538ce
mouse = "🐭"

# ╔═╡ 807b1586-8b3e-4cb1-9a9d-8ca66a28ec3e
mice = repeat(mouse, 3)

# ╔═╡ 2b91d104-921a-4d66-ac1f-a940cdb2d14c
md"""
This is also fine in Jupyter, but it's discouraged. Running cells yourself is easier when you can run things top-to-bottom, and the "run all cells" command also requires your cells work like that.

Because Pluto analyses the dependencies in your code, playing with the order of cells is no problem at all! You can place cells in the order that you want to *present* them in – you might want to show results first, and put your functions and calculations at the bottom of the notebook.
"""

# ╔═╡ 447f49ce-1738-4987-a976-094174971ccb
md"""
## Re-assigning variables

Here' s something that you can't do in Pluto:
"""

# ╔═╡ c4ece2cd-31f4-4c91-a59b-e520de13dedd
md"""
We tried to create multiple cells that set the value of `greatness`, but that's not possible!

This is because Pluto's reactivity. This cell depends on `greatness`, but which value should it use?
"""

# ╔═╡ 162513a8-4ca9-4cae-9e43-1ae09827f7a4
badness = -greatness

# ╔═╡ 5c958b92-c511-48b0-aeb2-a8b5fe4514cb
md"""
Pluto also can't decide the proper dependency order between the three cells. Should `greatness` be `(0 + 1) * 2)` or `(0 * 2) + 1` ?
"""

# ╔═╡ ee7adb33-b394-484d-8071-122642ea867b
md"""
We can't give an answer that everyone will agree on in every situation - so for clarity, Pluto just prohibits this kind of ambiguity.
"""

# ╔═╡ 4fe5a14c-a482-4d77-9472-d9c0a793e91e
md"""
If you run into this error, you can do two things:

- Wrap all definitions together into a single cell
- Rename variables so they all have different names, e.g. `greatness_1`, `greatness_2`.
"""

# ╔═╡ 5200e802-8080-4394-aa85-e2604c7279c8
md"""
## Multiple expressions per cell

When you start programming your first Pluto notebook, you'll probably run in to this error:
"""

# ╔═╡ 94991d24-6aad-4361-a8e5-5e2c1f15c53c
cat = "🐈"
dog = "🐕"

# ╔═╡ 244ca1ba-c2dc-4713-9dd0-57ed0d19ba70
md"""
Ah, Pluto cells must be a single expression. Not to worry - as you can see, the error message lets you pick a solution (you can click on the two options). Either split up the cell in two:

```julia
cat = "🐈"
```

```julia
dog = "🐕"
```

... or write a cell with a `begin` ... `end` block:

```julia
begin
	cat = "🐈"
	dog = "🐕"
end
```
"""

# ╔═╡ 4df1d31c-db13-49a1-963b-337550cd2bda
md"""
### Why?
Coming from Jupyter, this can feel a bit frustrating. Jupyter programmers often divide up their notebook in "sections" or code, with each cell containing 3-10 expressions, rather than 1.

Grouping expressions like this makes sense in Jupyter because you're in charge of rerunning cells. It's just more efficient and less error-prone to group related statements in a single cell.

In Pluto, you don't have to worry about that! Instead, Pluto's analysis of dependencies in your code works best when each cell defines only a single variable. We find that it is **almost always a good idea to split your code into more cells**. The more cells, the more intermediate results that you can see.
"""

# ╔═╡ a7ea9146-86f6-4d2a-85a3-950f2e7bc102
md"""
## Package management

Here is a neat thing in Pluto: it will manage your packages for you!

To use a package to your notebook, just write a cell importing it, and Pluto will automatically make sure that the right packages are installed. If you import a new package, it will be installed behind the scenes. If you remove the import, then Pluto will uninstall it.

In the cell below, click the ✔ button next to `using PlutoUI` to learn more about its status.
"""

# ╔═╡ d8b4d774-258d-4ef8-9bd9-586d19c785d2
md"""
Try importing another package (like `Measurements`):
"""

# ╔═╡ 4e75b797-dbba-4d2e-843e-4abb0f8de22c


# ╔═╡ 4720cedc-502b-4c66-9c4a-98622c87cb04
md"""
### But that's slow!

In Julia, packages are always installed globally, while _environments_ (including notebooks) only store **version information**, not the package code itself. This means that multiple notebooks that use the same version of `Plots` will not lead to more disk usage or precompile time. 

This is different from `venv` in Python/pip, or `node_modules` in NodeJS/npm, where every environment contains copies of package code by default. Julia's package manager is designed to work well with many package environments on the same computer.
"""

# ╔═╡ 74ff3d85-a6f4-4ae4-8502-18cf7a180ac5
md"""
### Reproducibility
The package manager does some other neat stuff too. As you're probably aware, the good folks maintaining packages will release new versions over time. That's great, but it can cause issues with compatibility.

Because of this, it can be useful if you've written down somewhere which versions of each package you were using - and if you're running someone else's code, you can avoid errors by using the same versions they used.

In Pluto all of that happens automatically: your package environment is stored inside the notebook file. When someone else opens your notebook with Pluto, the exact same package environment will be used, and packages will work on their computer.
"""

# ╔═╡ d3cf365d-ef7e-4a48-a32d-b050e69e5075
md"""
!!! tip
	
	If you're used to doing your own package management and you don't want Pluto to take over, don't worry! When you use `Pkg.activate(...)` inside a notebook, [the package manager will be disabled](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management#advanced-set-up-an-environment-with-pkgactivate).
"""

# ╔═╡ 58761686-b3c8-47f3-b05c-616f34ac71d9
md"""
For more information on this, [read about package management on the Pluto.jl wiki](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management).
"""

# ╔═╡ 8bbe13ff-f643-4ed0-aacf-9bafaa7c59c0
md"""
## Markdown cells

Unlike Jupyter, Pluto doesn't have text cells or markdown cells. Every cell is just Julia code. However, you can write markdown expressions in Julia, and those will be nicely displayed by Pluto. Like this:
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

# ╔═╡ e99b9c02-a31a-46d9-a5f1-9849c9d3cbe0
md"""
## Notebook files

### Pluto notebooks are scripts

A neat thing: Pluto notebooks are saved as `.jl` files: they're just Julia scripts! You can send them to Julia programmers that don't use Pluto, and they can run the script just like that. Or you can write your code in a notebook, and then run it on a larger dataset from the command line.

And just in case you're wondering: Pluto notebook files will save your cells in the order they should be _run_, not the order in which they're displayed. So you can play with the order and still run the code as a script!

This is quite different from `.ipynb` files, which can only be run with Jupyter.

There are a few more notable differences in the files:

### Pluto notebooks include packages

As we mentioned, Pluto comes with a built-in package manager, so the notebook file also includes info about package versions.

### Pluto notebooks don't include output

You may already have noticed that the experience of opening a Pluto notebook is a bit different, because it doesn't come with pre-loaded output for each cell.

This comes with pros and cons: it allows Pluto notebooks to maintain a simpler file, but makes it a bit harder to "preview" a notebook.

If you want to send someone your notebook _with output_, a good way to do it is as an HTML export (on the top menu) - that file will show all the output you created, and also allow viewers to download the original notebook file.

### Version management

If you work with Git, good news! Pluto notebook files are designed to work well with version management.

Jupyter notebooks are notorious for creating huge *git diffs* (a git diff is an overview of changes in the file). Jupyter notebooks are easy to read, but their raw files are not.

By contrast, the changes to a Pluto notebook are much easier to make sense of. Small changes to a notebook will result in small changes to the file. Nice!
"""

# ╔═╡ e1c813e5-a393-4364-8494-687b98811a0b
md"""
## Other programming languages

Jupyter was created to work with Julia, Python, and R (hence the name: JuPyteR), and can even be made compatible with other languages!

Pluto, however, is only ever going to be Julia environment. The core of Pluto is built in Julia, and Pluto's reactivity works by analysing your code. Jupyter is built to be largely language-agnostic, but Pluto decidedly isn't.

This comes with pros and cons: Pluto can do some cool stuff because it knows the language you're working in, but it doesn't have the flexibility that Jupyter does.
"""

# ╔═╡ 40ff93d6-1755-4258-9c15-3ae7be681d93
md"""
## Wrapping up

That's it!

I encourage you to make your own notebooks and play around with Pluto yourself. You can also take a look at Pluto's featured notebooks (on the home page) which show you a bit more of what you can do with Pluto!
"""

# ╔═╡ aff0754c-8e3a-4cbc-9697-0797e5d32fc2
greatness = 0

# ╔═╡ 5dd0949a-82d1-4b27-8318-9b42065d0957
greatness = greatness * 2

# ╔═╡ c12c3f7d-f91b-4395-9323-52a582a79bc6
greatness = greatness + 1

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

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "2221109544af0af0a1dbe6ee2a9707ab16223647"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

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
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

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
version = "0.7.0"

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
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

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
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─cdbcc440-858c-11ee-25d2-dd9d69531eef
# ╟─a423fc4f-6000-4451-bc03-4035c9847753
# ╠═b25c812b-7ec2-4e17-aa1b-e1a1407d29fb
# ╠═8e1faf5f-7b60-4b57-9902-e9d2531f0961
# ╟─03d3ade3-056a-4f16-9b31-d259879082c9
# ╟─3ed1ed94-8741-48a0-9d23-bb78499eec91
# ╠═773ac617-4e5d-46b9-92ff-b0d9a23e42f1
# ╠═6ba28587-3612-45bb-a5fa-5e1ce8fa3aa6
# ╠═f4d990a8-274a-4098-b4f9-ce1d39ec41a6
# ╟─74a6102a-e09d-4ebb-9ef8-2511b0f46f58
# ╠═807b1586-8b3e-4cb1-9a9d-8ca66a28ec3e
# ╠═3bca136c-115f-4dd1-ac4d-d14c23c538ce
# ╟─2b91d104-921a-4d66-ac1f-a940cdb2d14c
# ╟─447f49ce-1738-4987-a976-094174971ccb
# ╠═aff0754c-8e3a-4cbc-9697-0797e5d32fc2
# ╠═c12c3f7d-f91b-4395-9323-52a582a79bc6
# ╠═5dd0949a-82d1-4b27-8318-9b42065d0957
# ╟─c4ece2cd-31f4-4c91-a59b-e520de13dedd
# ╠═162513a8-4ca9-4cae-9e43-1ae09827f7a4
# ╟─5c958b92-c511-48b0-aeb2-a8b5fe4514cb
# ╟─ee7adb33-b394-484d-8071-122642ea867b
# ╟─4fe5a14c-a482-4d77-9472-d9c0a793e91e
# ╟─5200e802-8080-4394-aa85-e2604c7279c8
# ╠═94991d24-6aad-4361-a8e5-5e2c1f15c53c
# ╟─244ca1ba-c2dc-4713-9dd0-57ed0d19ba70
# ╟─4df1d31c-db13-49a1-963b-337550cd2bda
# ╟─a7ea9146-86f6-4d2a-85a3-950f2e7bc102
# ╠═db1ef6d1-7921-4035-8705-a0820048b785
# ╟─d8b4d774-258d-4ef8-9bd9-586d19c785d2
# ╠═4e75b797-dbba-4d2e-843e-4abb0f8de22c
# ╟─4720cedc-502b-4c66-9c4a-98622c87cb04
# ╟─74ff3d85-a6f4-4ae4-8502-18cf7a180ac5
# ╟─d3cf365d-ef7e-4a48-a32d-b050e69e5075
# ╟─58761686-b3c8-47f3-b05c-616f34ac71d9
# ╟─8bbe13ff-f643-4ed0-aacf-9bafaa7c59c0
# ╠═016f9e48-1672-481e-b642-d0c6bf67a5bc
# ╟─669323ca-aac3-415c-bbfc-14525447ccd8
# ╟─e99b9c02-a31a-46d9-a5f1-9849c9d3cbe0
# ╟─e1c813e5-a393-4364-8494-687b98811a0b
# ╟─40ff93d6-1755-4258-9c15-3ae7be681d93
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
