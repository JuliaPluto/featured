# `featured`

This repository contains Pluto's *featured* notebooks! Learn more about our featured notebook system [here](https://github.com/fonsp/Pluto.jl/pull/2048).

## New submissions

Right now, while we are still building up the system, the Pluto featured notebooks are *invite-only*: you should only submit a PR with a new notebook if you received an email from us. In a couple of months, we will change the system to also allow applications from the public. So if you are interested in contributing, hold on!

## Contributing to existing notebooks

If you find a typo, bug, or another issue with an existing notebook, feel free to open a PR!

# How to add/change a notebook

To add a notebook, simply add the file to this repository! It will be picked up automatically.

**Important:** fill out *frontmatter*, using Pluto's [Frontmatter GUI](https://github.com/fonsp/Pluto.jl/pull/2104). To open it, click the share button ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/shapes-outline.svg" width=20> ), and then the frontmatter button in the top right. ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/newspaper-outline.svg" width=20> ). You need to fill in the following fields:

- `description`
- `license`
- `image`: should be a URL
- `author_name`: use `Pluto.jl` if authored by Pluto devs, your name otherwise
- `author_url`: your github user page URL
- `tags`: fill in as many tags as you wish! (lowercase, spaces allowed)

All notebook files in this repository will be rendered by PlutoSliderServer, but they will only show up in Pluto's main menu if they belong to a collection. 

### License
All current Pluto sample notebooks have had the `Unlicense` license, which means that people can copy code snippets from sample notebooks and use them freely. If you also want to use the `Unlicense`, great! If not, then also write a clear paragraph stating the license in the notebook itself.

### Interactivity
The current *featured* system distributes notebook *statefiles*, which work the same way as Pluto's HTML export: people can read the notebook instantly, without having to wait for it to run. There is a button to *Edit and Run* a notebook that users can press to use the featured notebook as a template.

This means that sliders, buttons, etc don't immediately work, so notebooks that rely heavily on interactivity to tell a story are not a good fit. In the future, we plan to run a [PlutoSliderServer](https://github.com/JuliaPluto/PlutoSliderServer.jl) for sample notebooks, allowing instant interaction like https://computationalthinking.mit.edu/, but until then, keep this in mind.

## More instructions

Check out [these instructions](https://github.com/JuliaPluto/pluto-developer-instructions/blob/main/How%20to%20update%20the%20featured%20notebooks.md) to learn more about maintenance.
