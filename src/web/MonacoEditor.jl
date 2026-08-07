### A Pluto.jl notebook ###
# v0.19.46

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

# ╔═╡ ee548ea6-a23d-11ef-1960-593b3c152611
using PlutoUI, HypertextLiteral

# ╔═╡ 70f3067f-07a1-40f6-aecf-6f2d9b6baf6e
using Deno_jll

# ╔═╡ 4b6c7580-90af-49e8-950e-5b116fbc7c49
md"""
# Using Monaco Editor inside Pluto

[Pluto.jl](https://plutojl.org/) is a reactive notebook, which means that when users update a function or variable, Pluto automatically updates all affected cells. The [PlutoUI.jl](https://github.com/JuliaPluto/PlutoUI.jl) package provides a interactive elements to be used in Pluto.jl. As an application, we can use this functionality to implement a simple live code editor for TypeScript using [Monaco Editor](https://microsoft.github.io/monaco-editor/) that powers VS Code.
"""

# ╔═╡ 36cfce04-af57-426d-8001-a9c784d8e14e
md"""
## A Simple Text Editor using `TextField`

Before creating a rich text. Let's create a simple one. According to the [PlutoUI.jl documentation](https://featured.plutojl.org/basic/plutoui.jl), there is a type named [TextField](https://featured.plutojl.org/basic/plutoui.jl) to display a text box.
"""

# ╔═╡ 42fde362-6065-43d8-89a1-fb7d2c20dc4d
begin
	default_typescript_code = raw"""
function greet(name: string): string {
  return `Hello, ${name}!`;
}

console.log(greet("world"));
"""
	simpleeditor = @bind txtfield PlutoUI.TextField(
		(60, 6), placeholder="Input TypeScript code here", default=default_typescript_code
	)
end;

# ╔═╡ 1dffaa89-a9cb-4de4-a39d-35676ceab270
md"""
The code cell above displays a text box below that contains TypeScript code by default.
"""

# ╔═╡ e608a1d9-b5f3-48de-aeca-d7283470b550
simpleeditor

# ╔═╡ 4ffe75d3-1e7f-4826-8fee-c59e49368ee8
md"""
The `@bind` macro creates a live bond between a Julia's variable (`textfield`) and a HTML object (`Pluto.TextFiled`). If you edit the text box above, the following result corresponds to `println(txtfield)` should be updated.
"""

# ╔═╡ 7cc67d1e-3e8b-4745-8aaa-d3558960c8f5
println(txtfield)

# ╔═╡ d06df8d6-719f-4004-985f-03b584cf1f2e
md"""
One may think that it would be nice to have live code editor on Pluto.jl for those who are using Julia mainly and need to learn or run another language for some reasons.
"""

# ╔═╡ 4bd3d424-8d40-43c7-a0a4-649edc11d2d0
md"""
To make this notebook be self-contained, we use the [JLL package](https://docs.binarybuilder.org/dev/jll/#JLL-packages) named [Deno_jll.jl](https://github.com/JuliaBinaryWrappers/Deno_jll.jl).
"""

# ╔═╡ f7a5eb3d-482c-4d58-8b68-ce2bea00bb40
md"""
The following code cell saves the content of `txtfield` as a TypeScript file named `main.ts` and execute it. By using Deno_jll package, we can use the `deno` command out of the box.
"""

# ╔═╡ 4ca7e0c2-c28d-4f02-bfea-4d281e7d9e9f
mktempdir() do d
	sourcepath = joinpath(d, "main.ts")
	tsruntime = `$(Deno_jll.deno()) run`
	write(sourcepath, txtfield)
	executablepath = joinpath(d, "main")
	run(`$(tsruntime) $(sourcepath)`)
end

# ╔═╡ afa34ab5-9110-4e07-ad73-f9c923f48916
md"""
We expect that we've managed to run the TypeScript code above.
"""

# ╔═╡ 2a47e0ee-fb27-47d9-9540-2f96f2c73d63
md"""
We were able to interpret the strings entered into PlutoUI.TextField as source code and run as TypeScript code. However, there is a shorthand regarding this implementation. The text box created by `TextField` won't highlight your code. [We are greedy](https://julialang.org/blog/2012/02/why-we-created-julia/) and want to use a rich text editor on top of Pluto.jl, something rich like VS Code, for example. Is it possible?
"""

# ╔═╡ a3be7f55-6fc3-4a40-84ba-01e3bf1be790
md"""
## A TypeScript code editor using Monaco Editor

The [Monaco Editor](https://microsoft.github.io/monaco-editor/) is the code editor that powers [VS Code](https://code.visualstudio.com/). Wouldn't it be great if this worked on Pluto Notebook? Let's find out.

Since Monaco Editor is a JavaScript library one may want to read the [Pluto.jl documentation JavasScript API](https://plutojl.org/en/docs/javascript-api/). This will help you to understand about relations between Pluto.jl and JavaScript.
"""

# ╔═╡ 430cbf8e-5ecf-4536-b6fd-db7d85baa8df
md"""
We need to write JavaScript to set up the editor. The init_editor.js is required to store JavaScript code that HypertextLiteral.jl does not recognize.
"""

# ╔═╡ b617f632-fe6a-43b3-a7e3-486361956515
begin
	initJS = raw"""
	// Initialize Monaco Editor
	var monEditor
	require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.51.0/min/vs/' } });
	require(['vs/editor/editor.main'], function () {
	    monEditor = monaco.editor.create(document.getElementById('mymonacoeditor'), {
	        value: [
	            'function greet(name: string): string{',
	            '\treturn \`Hello, ${name}!\`;',
				'}',
				'console.log(greet("Update me"));'
	        ].join('\n'),
	        language: 'typescript'
	    });
	});
	"""
	rm("./init_MonacoEditor.js", force=true)
	write("./init_MonacoEditor.js", initJS)
end

# ╔═╡ 70dbf80a-4d55-43b4-b4bb-2fbec97f9341
md"""
Let's bond a Julia variable (`tsmonacofield`) and HTML object (Monaco Editor instance) here.
"""

# ╔═╡ ed3d15f4-2fe2-4ece-8bcb-bd1b3be3d1db
@bind tsmonacofield @htl """
<div>
    <style>
        #mymonacoeditor {
            width: 700px;
            height: 200px;
            border: 1px solid #ddd;
        }
    </style>

    <div id="mymonacoeditor"></div>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.7/require.js"></script>
    <!-- Load Monaco Editor from CDN -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.51.0/min/vs/loader.min.js"></script>
	<!-- This LocalResource hack is required to avoid getting errors due to content parsing in init_editor.js. -->
	$(PlutoUI.LocalResource("./init_MonacoEditor.js"))
<script>
	const pE = currentScript.parentElement;
	var editorValue = "function main(){}";
	function myUpdate() {
		pE.dispatchEvent(new CustomEvent("update"));
		pE.value = editorValue;
	}
	
	const myEditor = pE.querySelector("#mymonacoeditor");
	myEditor.addEventListener("input", e=>{
		editorValue = monEditor.getValue();
		console.log(editorValue);
		myUpdate();
	})
	
	myUpdate();
</script>
</div>
"""

# ╔═╡ 6bf85144-a9b5-4d26-951c-8bfd4c1ffaf8
md"""
We've seen the `string` in the TypeScript is highlighted. Select `string` literal and typing `Ctrl+D` (on macOS, type `Cmd+D`) works multiple cursor features!!! Of course when you update the editor, the following cell should update.
"""

# ╔═╡ d072be97-ac26-441b-8367-409f7f2b5e79
println(tsmonacofield)

# ╔═╡ 8b302258-7bfb-45a8-baae-df08a25920cf
md"""
Let's run the TypeScript code showing in the Monaco Editor. The JavaScript code dispatchEvent(new CustomEvent("update")); detects users input and run the value of tsmonacofield as TypeScript source code.
"""

# ╔═╡ b5b8a79a-46e4-491b-bbbe-203e031d79ed
mktempdir() do d
	sourcepath = joinpath(d, "main.ts")
	tsruntime = `$(Deno_jll.deno()) run`
	write(sourcepath, tsmonacofield)
	executablepath = joinpath(d, "main")
	run(`$(tsruntime) $(sourcepath)`)
end

# ╔═╡ 3fe637e1-ed16-4aef-90e3-578e5b577e0f


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Deno_jll = "~2.0.0"
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.1"
manifest_format = "2.0"
project_hash = "94c513de5fb63b21a61842aa34f6e60f7e8d6ab4"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Deno_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7e2908b0979fcf7375db8b7613cb348b31be8ad8"
uuid = "04572ae6-984a-583e-9378-9577a1c2574d"
version = "2.0.0+0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

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

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

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
# ╟─4b6c7580-90af-49e8-950e-5b116fbc7c49
# ╠═ee548ea6-a23d-11ef-1960-593b3c152611
# ╟─36cfce04-af57-426d-8001-a9c784d8e14e
# ╠═42fde362-6065-43d8-89a1-fb7d2c20dc4d
# ╟─1dffaa89-a9cb-4de4-a39d-35676ceab270
# ╟─e608a1d9-b5f3-48de-aeca-d7283470b550
# ╟─4ffe75d3-1e7f-4826-8fee-c59e49368ee8
# ╠═7cc67d1e-3e8b-4745-8aaa-d3558960c8f5
# ╟─d06df8d6-719f-4004-985f-03b584cf1f2e
# ╠═4bd3d424-8d40-43c7-a0a4-649edc11d2d0
# ╠═70f3067f-07a1-40f6-aecf-6f2d9b6baf6e
# ╟─f7a5eb3d-482c-4d58-8b68-ce2bea00bb40
# ╠═4ca7e0c2-c28d-4f02-bfea-4d281e7d9e9f
# ╟─afa34ab5-9110-4e07-ad73-f9c923f48916
# ╟─2a47e0ee-fb27-47d9-9540-2f96f2c73d63
# ╟─a3be7f55-6fc3-4a40-84ba-01e3bf1be790
# ╟─430cbf8e-5ecf-4536-b6fd-db7d85baa8df
# ╠═b617f632-fe6a-43b3-a7e3-486361956515
# ╟─70dbf80a-4d55-43b4-b4bb-2fbec97f9341
# ╠═ed3d15f4-2fe2-4ece-8bcb-bd1b3be3d1db
# ╟─6bf85144-a9b5-4d26-951c-8bfd4c1ffaf8
# ╠═d072be97-ac26-441b-8367-409f7f2b5e79
# ╟─8b302258-7bfb-45a8-baae-df08a25920cf
# ╠═b5b8a79a-46e4-491b-bbbe-203e031d79ed
# ╠═3fe637e1-ed16-4aef-90e3-578e5b577e0f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
