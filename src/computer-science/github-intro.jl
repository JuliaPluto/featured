### A Pluto.jl notebook ###
# v0.19.45

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> title = "Contributing to Open Source Software"
#> date = "2024-05-07"
#> tags = ["basic"]
#> description = "Learn how to contribute to Open Source via Github"
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Michael Tiemann"
#>     url = "https://github.com/mitiemann"

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

# ╔═╡ b50f67e5-5baf-4072-8048-f96ef8b2996c
using PlutoUI

# ╔═╡ 70cf43f4-d593-4920-a19e-93db8345cbb4
using GitHub

# ╔═╡ 96fbe505-ef5c-48d6-8204-e114e8bb33fb
md"""
# TODOs

- add links to relevant Wikipedia pages:
  + https://en.wikipedia.org/wiki/Open-source_software#
  + https://en.wikipedia.org/wiki/History_of_free_and_open-source_software
  + https://en.wikipedia.org/wiki/Version_control
  + https://en.wikipedia.org/wiki/Distributed_version_control
  + https://nl.wikipedia.org/wiki/Git_(software)

- add link to Pluto's Github (and Pluto itself?)

- where to put `using` statements sensibly?

- fix broken images

- add logos:
![Github logo](https://commons.wikimedia.org/wiki/File:GitHub_Invertocat_Logo.svg#/media/File:GitHub_Invertocat_Logo.svg)
![Git logo](https://commons.wikimedia.org/wiki/File:Git-logo.svg#/media/Bestand:Git-logo.svg)
"""

# ╔═╡ 1fe6fe32-9518-4606-94f1-fc7f24a21c72
Resource("https://commons.wikimedia.org/wiki/File:GitHub_Invertocat_Logo.svg#/media/File:GitHub_Invertocat_Logo.svg", :width => 100)

# ╔═╡ cd4958d6-0ca8-11ef-1688-f9e6399bc56d
md"""
# Github and Contributing to Open Source Software

Open Source Software is a social exercise.
In the olden days before the internet, sharing code mostly meant to publish it in books, journals and magazines.
These days, programmers use web platforms and open source software to aid in organizing the community.
The most prominent of these platforms is [Github](https://www.github.com/) and the version control software `git`.
"""

# ╔═╡ 77cefff2-1502-4d85-b20b-caf77df08c47
md"""
# What is `git`?

What is something an open source programmer might need help with? Please write it down in this textfield. (I'm promising there's a reason for this ;-))
"""

# ╔═╡ 79a64297-b44f-4bf1-b441-444eb6e9571e
@bind oss_reqs TextField()

# ╔═╡ b23c067d-74f6-4352-8a9e-d92765611bc0
md"""
**TODO** turn this into a `htl` and make the text fields a `<li>`

You're initial list of requirements:

$oss_reqs \

Yepp, that's pretty important. Can you think of something else? (Hint: if you're too tired to think about something else, you'll need the same [energy drink](https://en.wikipedia.org/wiki/Coffee) the programmer needs)
"""

# ╔═╡ f11b2d0f-209d-4798-ad3e-ecd35dfe120d
@bind oss_more_reqs TextField()

# ╔═╡ 2d63de8b-fece-49c8-9513-165d1ce1d3aa
md"""
Your extended list now looks like this:

$(oss_reqs * " " * oss_more_reqs) \

And, you've guessed it, I need one more final thing. Can you think of one more? If not, did you know that programmers require a [rubber duck](https://en.wikipedia.org/wiki/Rubber_duck_debugging) on their desk at all times?
"""

# ╔═╡ 74c5b78c-d4dc-48ab-b795-6c036d4ed0eb
@bind oss_most_reqs TextField()

# ╔═╡ d93e059c-088d-4698-ad77-865e9249b301
md"""
You're final list:

$(oss_reqs * " " * oss_more_reqs * " " * oss_most_reqs)
"""

# ╔═╡ 2dcca891-f0c9-46d4-86de-dd96482145a8
md"""
Okay, enough with the textfields already! What was the point?

Well, pretend that it wasn't just you who has filled out these boxes. The `Pluto` developers have been asked to do the same and now we've got this mess:
"""

# ╔═╡ 477bfd3b-b930-44f8-b3d5-faf757cb53c6
reqs = [oss_reqs, oss_more_reqs, oss_most_reqs]

# ╔═╡ a9401ae3-52d0-43f2-aa8a-10c79d97355e
md"""
There are many good ideas. But, wow, it's a mess! What we need is a way to pick and mix. That way, we can collect all ideas while eliminating duplicates.

And this is exactly what `git` tries do help with for software developers :-)
"""

# ╔═╡ d085db19-5446-485c-96c1-4616d961aebe
md"""
**TODO** need another couple of cells to play with the different strings. Can I get drag-and-drop functionality?
"""

# ╔═╡ 50a5dd66-e44c-4b6e-90d1-ff415181149c
md"""
# What is Github?

Github is a website that offers services for 
"""

# ╔═╡ 4186fd62-75dc-49c9-8a75-e0788606c230
pluto_featured = repo("JuliaPluto/featured")

# ╔═╡ ddcc6daf-7077-4645-80ce-f622f16717df
md"""
# Appendix: housekeeping

Below you'll find all the code that is necessary to make this notebook run, but would disrupt the flow of presentation. Enjoy!
"""

# ╔═╡ 52053b66-3a18-4d29-b3a0-c65e725cadc1
pluto_dev_reqs = ["a website" "coffee" "a keyboard and a mouse";
"foo" "bar" "baz"]

# ╔═╡ 9d98a5b8-7e00-4672-967c-7a77dd1bfbea
md"""
**TODO** need a representative graph of all things that might be required

$reqs \
$pluto_dev_reqs
"""

# ╔═╡ ccba7bc5-07ea-402c-8596-083c9917bd55
typeof(pluto_dev_reqs)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GitHub = "bc5e4493-9b4d-5f90-b8aa-2b2bcaad7a26"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
GitHub = "~5.9.0"
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

[[BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[GitHub]]
deps = ["Base64", "Dates", "HTTP", "JSON", "MbedTLS", "Sockets", "SodiumSeal", "URIs"]
git-tree-sha1 = "7ee730a8484d673a8ce21d8536acfe6494475994"
uuid = "bc5e4493-9b4d-5f90-b8aa-2b2bcaad7a26"
version = "5.9.0"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

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

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

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

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SodiumSeal]]
deps = ["Base64", "Libdl", "libsodium_jll"]
git-tree-sha1 = "80cef67d2953e33935b41c6ab0a178b9987b1c99"
uuid = "2133526b-2bfb-4018-ac12-889fb3908a75"
version = "0.1.1"

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

[[TranscodingStreams]]
git-tree-sha1 = "96612ac5365777520c3c5396314c8cf7408f436a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.1"
weakdeps = ["Random", "Test"]

    [TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

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

[[libsodium_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "848ab3d00fe39d6fbc2a8641048f8f272af1c51e"
uuid = "a9144af2-ca23-56d9-984f-0d03f7b5ccf8"
version = "1.0.20+0"

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
# ╠═b50f67e5-5baf-4072-8048-f96ef8b2996c
# ╠═96fbe505-ef5c-48d6-8204-e114e8bb33fb
# ╠═1fe6fe32-9518-4606-94f1-fc7f24a21c72
# ╟─cd4958d6-0ca8-11ef-1688-f9e6399bc56d
# ╟─77cefff2-1502-4d85-b20b-caf77df08c47
# ╠═79a64297-b44f-4bf1-b441-444eb6e9571e
# ╟─b23c067d-74f6-4352-8a9e-d92765611bc0
# ╠═f11b2d0f-209d-4798-ad3e-ecd35dfe120d
# ╟─2d63de8b-fece-49c8-9513-165d1ce1d3aa
# ╠═74c5b78c-d4dc-48ab-b795-6c036d4ed0eb
# ╟─d93e059c-088d-4698-ad77-865e9249b301
# ╟─2dcca891-f0c9-46d4-86de-dd96482145a8
# ╠═477bfd3b-b930-44f8-b3d5-faf757cb53c6
# ╠═9d98a5b8-7e00-4672-967c-7a77dd1bfbea
# ╠═a9401ae3-52d0-43f2-aa8a-10c79d97355e
# ╠═d085db19-5446-485c-96c1-4616d961aebe
# ╠═50a5dd66-e44c-4b6e-90d1-ff415181149c
# ╠═70cf43f4-d593-4920-a19e-93db8345cbb4
# ╠═4186fd62-75dc-49c9-8a75-e0788606c230
# ╠═ddcc6daf-7077-4645-80ce-f622f16717df
# ╠═52053b66-3a18-4d29-b3a0-c65e725cadc1
# ╠═ccba7bc5-07ea-402c-8596-083c9917bd55
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
