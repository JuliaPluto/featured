### A Pluto.jl notebook ###
# v0.19.43

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

# ╔═╡ 84c2083b-7bc1-4ba2-8da3-4f2da8fe8449
using PlutoUI

# ╔═╡ cd922998-3fee-4586-8458-7c2fa4a4bce1
md"""
# TODO

- which Julia drawing library could be added? *=> the Turtle notebook creates its own SVG drawing code. Check on Zulip whether this should be turned into a module or whether it should be copy & pasted*
- add `random word` button
- game needs to refresh every time the password field changes
- Should we start with an empty password field or a random word?
- Keep the requirement of every word being its own line or shall we also allow other seperators?
- is there something like an immutable textfield that I could use to display the revelation?
- handle special characters:
  + in password
  + in guesses
- maybe regexs could be used to handle the str replaces, but god knows how or why [this](https://discourse.julialang.org/t/use-regex-replacement-strings/76729) works
- how to make guesses permanent (i.e., prohibit deleting entered guesses?)
- use turtle drawing to create the hangman
- use a button to "commit" to a guess
- add internal links
- fix the game description to actually include line breaks
"""

# ╔═╡ 1690c572-4112-11ef-0781-f979a8a12dca
md"""
# Simple Hangman

Using `PlutoUI`, it's really easy to code up a simple game of Hangman.
For your entertainment, I've already provided the game logic.
But the hangman picture could really use your Julia drawing skills.

But don't get hung up too much ;-)
"""

# ╔═╡ 033e6593-b0d2-475b-91bc-c1118db7725c
md"""
First, we need a secret word. If there's two people playing, just enter the textfield and type (it will be all stars like so ******). Otherwise, click `random word`.
"""

# ╔═╡ 4b39a5ab-b612-4986-86c5-d3dd5ab5dc5a
@bind guesses TextField(22, default="")

# ╔═╡ 8f4c5838-e895-49b4-89ae-60536f29f791
md"""
**todo** *delete after debugging*

$guesses
"""

# ╔═╡ 163b6b19-dbe9-4a46-bef8-0af32dbba4b5
num_guesses = length(unique(guesses))

# ╔═╡ b7c82f65-bdad-495a-bfbe-43cda1bad3b8
description_entries = [
	"A hill ...",
	"... with an upright beam on top ...",
	"... and a beam across ...",
	"... and an diagonal beam for support ...",
	"... a rope hanging in the air; ...",
	"... a face already in the noose, ...",
	"... the body attached, ...",
	"... one arm, ...",
	"... no, two arms visible; ...",
	"... with one leg visible the air is getting thin; ...",
	"... and the final leg is gone. GAME OVER :-("
]

# ╔═╡ 28e9f3e1-2634-405f-954e-8041b4350754
md"""
## Better graphics

Hoosah, the game wo\rks. But the graphics suck. Let's change that!
"""

# ╔═╡ 1a7cd867-c199-4f95-ba63-fc2b36a89401
md"""
# Hangman

The simple game logic above, it's easy to cheat for both players.
Both the secret as well as the guesses can be modified at any time.
So let's modify the game to make each player commit to their choices during a round.
"""

# ╔═╡ c1591133-f1ce-4f12-b68a-7edd126f2d58
md"""
## Best graphics

Let's make the ultimate graphical user interface for the ultimate hangman game.
(This might be disappointing-I'm not any good with graphic design. But, hey: maybe you are?)
"""

# ╔═╡ a47488dd-c702-4ab9-81b2-bae55f4fc762
md"""
# Behind the scenes

Okay, maybe the few lines of code are not fully sufficient to get all the bells and whistles.
For this reason, I've hidden a couple of code tidbits that I've needed to set the stage but which do not really add to the understanding of how to program hangman.
But we don't have any secrets here!
Leave no stone unturned and browse all my secrets to your heart's delight.
"""

# ╔═╡ d3c1f0c1-eab7-4bbd-94ad-d42e16a6dc3c
md"""
## Random word list

Below you'll find the pool of random words. Feel free to add or remove words, if the list is not to your liking. Each word must be on it's own line.
"""

# ╔═╡ 8bd64560-5e4e-4b4e-a95f-d16b4c20495f
@bind random_word_box TextField((20, 10), default=
"Julia
Notebook
Pluto
Hangman
Programmer
Feature
Bug
Gamer
Developer")

# ╔═╡ f9a6d19e-7fcd-4b18-a551-9c8edabe8ed7
random_word = rand(collect(eachsplit(random_word_box)))

# ╔═╡ 61ff91c4-4257-470a-99d9-7080f52c11ba
@bind secret PasswordField(default=random_word)

# ╔═╡ 0644c3b7-2a90-4c86-b8c7-377ddca6d4d1
md"""
**todo** *delete after debugging*

$secret
"""

# ╔═╡ ae098903-9c20-400b-9228-64479d349095
revelation = map(c -> contains(lowercase(guesses), lowercase(c)) ? c : '*', secret)

# ╔═╡ adee442c-bba4-4664-b082-50bb13962925
hits = filter(c -> contains(lowercase(secret), lowercase(c)), guesses)

# ╔═╡ 732db7c4-2408-45b2-ab8e-12630f7bb465
num_misses = num_guesses - length(hits)

# ╔═╡ ba1886df-509a-4016-8a28-d43b4403c999
description = join(description_entries[1:num_misses], "\\\n")

# ╔═╡ 26707dfc-d247-41ea-bea3-6c64fc248bbf
Markdown.parse("Can you picture the scene?\\\n\\\n" * description)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

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

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

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

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═cd922998-3fee-4586-8458-7c2fa4a4bce1
# ╠═1690c572-4112-11ef-0781-f979a8a12dca
# ╠═84c2083b-7bc1-4ba2-8da3-4f2da8fe8449
# ╟─033e6593-b0d2-475b-91bc-c1118db7725c
# ╠═61ff91c4-4257-470a-99d9-7080f52c11ba
# ╠═0644c3b7-2a90-4c86-b8c7-377ddca6d4d1
# ╠═4b39a5ab-b612-4986-86c5-d3dd5ab5dc5a
# ╠═8f4c5838-e895-49b4-89ae-60536f29f791
# ╟─ae098903-9c20-400b-9228-64479d349095
# ╟─163b6b19-dbe9-4a46-bef8-0af32dbba4b5
# ╟─adee442c-bba4-4664-b082-50bb13962925
# ╟─732db7c4-2408-45b2-ab8e-12630f7bb465
# ╟─b7c82f65-bdad-495a-bfbe-43cda1bad3b8
# ╠═ba1886df-509a-4016-8a28-d43b4403c999
# ╠═26707dfc-d247-41ea-bea3-6c64fc248bbf
# ╠═28e9f3e1-2634-405f-954e-8041b4350754
# ╠═1a7cd867-c199-4f95-ba63-fc2b36a89401
# ╠═c1591133-f1ce-4f12-b68a-7edd126f2d58
# ╠═a47488dd-c702-4ab9-81b2-bae55f4fc762
# ╠═d3c1f0c1-eab7-4bbd-94ad-d42e16a6dc3c
# ╠═8bd64560-5e4e-4b4e-a95f-d16b4c20495f
# ╠═f9a6d19e-7fcd-4b18-a551-9c8edabe8ed7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
