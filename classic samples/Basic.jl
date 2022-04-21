### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
md"""
# The Basel problem

_Leonard Euler_ proved in 1741 that the series

```math
\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots
```

converges to

```math
\frac{\pi^2}{6}.
```
"""

# ╔═╡ b2d79330-7f73-11ea-0d1c-a9aad1efaae1
n = 1:100000

# ╔═╡ b2d79376-7f73-11ea-2dce-cb9c449eece6
seq = n .^ -2

# ╔═╡ b2d792c2-7f73-11ea-0c65-a5042701e9f3
sqrt(sum(seq) * 6.0)

# ╔═╡ ec425e6e-6b9c-11eb-0c63-97fade58f6b5
frontmatter = (
    tags=["debug", "classic"],
    author=[(
        name="Pluto.jl",
        url="https://github.com/JuliaPluto",
    )],
);

# ╔═╡ Cell order:
# ╟─b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
# ╠═b2d792c2-7f73-11ea-0c65-a5042701e9f3
# ╠═b2d79330-7f73-11ea-0d1c-a9aad1efaae1
# ╠═b2d79376-7f73-11ea-2dce-cb9c449eece6
# ╟─ec425e6e-6b9c-11eb-0c63-97fade58f6b5
