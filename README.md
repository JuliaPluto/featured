# `featured`

This repository contains Pluto's *featured* notebooks! Learn more about our featured notebook system [here](https://github.com/fonsp/Pluto.jl/pull/2048).

## New submissions

Right now, while we are still building up the system, the Pluto featured notebooks are *invite-only*: you should only submit a PR with a new notebook if you received an email from us. In a couple of months, we will change the system to also allow applications from the public. So if you are interested in contributing, hold on!

## Contributing to existing notebooks

If you find a typo, bug, or another issue with an existing notebook, feel free to open a PR!

# What is a featured notebook?

Pluto's *featured* notebooks is a collection of notebooks from the Julia community and the Pluto developers to **showcase what you can do with Julia and Pluto**, and to help you get started. Featured notebooks are intended to **get people excited**, and to **teach new skills**. We want to reach a diverse audience, with different backgrounds and skill levels, but we have a special interest in notebooks that might improve the accessibility of scientific computing. This might include notebooks that are accessible to Julia beginners, to high school students, or notebooks that are just really flashy and beautiful.

# Where can people read my notebook?

Featured notebooks have a large audience! People can find them in three different places:

## 1. In Pluto

When people start Pluto on their computer, featured notebooks will be listed directly on the main menu. It is the first thing new users will see!

You can read and interact with featured notebooks in Pluto without having to run the notebooks on your own computer. But if you want, you can! The "Edit or run" button will open the notebook locally, and you can start making edits.

<img src="https://github.com/JuliaPluto/featured/assets/6933510/f2e06d64-5363-4291-8a49-f4ace85c9aa4" alt="Screenshot of the Pluto.jl IDE main menu, where featured notebooks are listed." width=400>

## 2. On the plutojl.org website
When you visit Pluto's website: [plutojl.org](plutojl.org), you can click **Featured notebooks** on the top. This sends you to [featured.plutojl.org](featured.plutojl.org), the online website with all of our featured notebooks. You can read notebooks on this website without having to install Julia or Pluto, and it also works on your phone.

We use [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl) for this website, which means that people can interact with `@bind` interactions instantly on our website, without having to run the notebook!

<img src="https://github.com/JuliaPluto/featured/assets/6933510/dcd1968f-a3f2-479b-9436-48480dd68e7e" alt="Screenshot of featured.plutojl.org." width=400>


## 3. On julialang.org/learning
On Julia's [official *learning* page](https://julialang.org/learning/), we included a section about Pluto.jl. This includes a couple screenshots of featured notebooks, which will send people to our website with all featured notebooks.

<img src="https://github.com/JuliaPluto/featured/assets/6933510/a4e29293-65a3-42e0-a44f-f59be89b937f" alt="Screenshot of the learning page on the julialang website" width=400>


# How to add/change a notebook

To add a notebook, simply add the file to this repository! It will be picked up automatically.

**Important:** fill out *frontmatter*, using Pluto's [Frontmatter GUI](https://github.com/fonsp/Pluto.jl/pull/2104). To open it, click the share button ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/share-outline.svg" width=20> ), and then the frontmatter button in the top right. ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/newspaper-outline.svg" width=20> ). You need to fill in the following fields:

- `description`
- `license`
- `image`: should be a URL
- `author_name`: use `Pluto.jl` if authored by Pluto devs, your name otherwise
- `author_url`: your github user page URL
- `tags`: fill in as many tags as you wish! (lowercase, spaces allowed)

All notebook files in this repository will be rendered by PlutoSliderServer, but they will only show up in Pluto's main menu if they belong to a collection. 

### License

Notebooks are licensed individually. Each notebook specifies a license in the frontmatter. Here is an example of what that looks like:

```julia
### A Pluto.jl notebook ###
# v0.19.27

#> [frontmatter]
#> author_url = "https://github.com/JuliaPluto"
#> author_name = "Pluto.jl"
#> license = "Unlicense"
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
```

In this case, the notebook is authored by Pluto.jl, it is shared under the _Unlicense_, and the full text is available at the linked url. This link leads to the [LICENSES/Unlicense](/LICENSES/Unlicense) file in this repository.

If you're adding a notebook of your own, see [CONTRIBUTING](/CONTRIBUTING.md) for more information about licensing.

### Interactivity
The current *featured* system distributes notebook *statefiles*, which work the same way as Pluto's HTML export: people can read the notebook instantly, without having to wait for it to run. There is a button to *Edit and Run* a notebook that users can press to use the featured notebook as a template.

This means that sliders, buttons, etc don't immediately work, so notebooks that rely heavily on interactivity to tell a story are not a good fit. In the future, we plan to run a [PlutoSliderServer](https://github.com/JuliaPluto/PlutoSliderServer.jl) for sample notebooks, allowing instant interaction like https://computationalthinking.mit.edu/, but until then, keep this in mind.

## More instructions

Check out [these instructions](https://github.com/JuliaPluto/pluto-developer-instructions/blob/main/How%20to%20update%20the%20featured%20notebooks.md) to learn more about maintenance.
