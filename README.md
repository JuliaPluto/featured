# `featured`

This repository contains Pluto's *featured* notebooks! Learn more about our featured notebook system [here](https://github.com/fonsp/Pluto.jl/pull/2048).

## Submit your notebook!

Consider **submitting your notebook**! This is not just for expert Julia users, beginners are especially welcome to submit!

Take a look at [`CONTRIBUTING.md`](https://github.com/JuliaPluto/featured/blob/main/CONTRIBUTING.md) to learn more about submitting your notebook!

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
When you visit Pluto's website: [plutojl.org](https://plutojl.org), you can click **Featured notebooks** on the top. This sends you to [featured.plutojl.org](featured.plutojl.org), the online website with all of our featured notebooks. You can read notebooks on this website without having to install Julia or Pluto, and it also works on your phone.

We use [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl) for this website, which means that people can interact with `@bind` interactions instantly on our website, without having to run the notebook!

<img src="https://github.com/JuliaPluto/featured/assets/6933510/dcd1968f-a3f2-479b-9436-48480dd68e7e" alt="Screenshot of featured.plutojl.org." width=400>


## 3. On julialang.org/learning
On Julia's [official *learning* page](https://julialang.org/learning/), we included a section about Pluto.jl. This includes a couple screenshots of featured notebooks, which will send people to our website with all featured notebooks.

<img src="https://github.com/JuliaPluto/featured/assets/6933510/a4e29293-65a3-42e0-a44f-f59be89b937f" alt="Screenshot of the learning page on the julialang website" width=400>

# Interactivity
The current *featured* system distributes notebook *statefiles*, which work the same way as Pluto's HTML export: people can read the notebook instantly, without having to wait for it to run. There is a button to *Edit and Run* a notebook that users can press to use the featured notebook as a template.

This means that sliders, buttons, etc don't immediately work, so notebooks that rely heavily on interactivity to tell a story are not a good fit. In the future, we plan to run a [PlutoSliderServer](https://github.com/JuliaPluto/PlutoSliderServer.jl) for sample notebooks, allowing instant interaction like https://computationalthinking.mit.edu/, but until then, keep this in mind.

# Contributing
Take a look at [`CONTRIBUTING.md`](https://github.com/JuliaPluto/featured/blob/main/CONTRIBUTING.md) to learn more about submitting your notebook!
