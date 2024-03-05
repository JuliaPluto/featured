Hello! Nice to hear that you are thinking about contributing a featured notebook. Before submitting your notebook, let's discuss what type of notebook we are looking for, and whether it would be a good fit.


# Can I write a notebook?

You don't need to be an expert to write a featured notebook! The notebooks are designed to help beginning Pluto users get underway with their own ideas; as such, short tutorials on basic Julia concepts, or short examples of neat ideas, are very much welcome, and are a great way to contribute to the Julia community when you're still learning yourself.

That said, we also very much welcome experienced Julia programmers to share their work. Featured notebooks can highlight how you use Julia in your domain, bring attention to a neat package, or share exercises that you created for a course.

![Motivational image – you got this!!](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOWwwOHV4bXg5bDBoamo2NG55OGhmZzkyM2lsNjN1emc5bzFubms2MCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/6VriQO3GFRwwBVPbi4/giphy.gif)


# What is a good fit?
Pluto's *featured* notebooks is a collection of notebooks from the Julia community and the Pluto developers to **showcase what you can do with Julia and Pluto**, and to help you get started. Featured notebooks are intended to **get people excited**, and to **teach new skills**.


## Suitable topics
If you have an idea that you want to share, something that you think others would be excited about, then it's probably a good fit! That being said, here are some suggestions for suitable topics, and some things you might not have thought about.

Some examples of great topics:
- Tutorials about core Julia programming concepts, like arrays.
- A visualisation that you are proud of.
- You are a teacher, and you wrote exercises for a course.
- An example of how Julia is used in your specific academic domain.
- A notebook to showcase a Julia package. This could be a package you like, or a package you develop yourself (although *featured* is not the right place to host your package documentation).




Things that might not be a good topic:
- Something very similar to an existing featured notebook. *(If this is your situation, consider contacting the author of the existing notebook to collaborate, or get in touch with us.)*
- Industry-specific knowledge that might not be understandable to the public.
- Notebooks that promote environmental or social harm.



## Thing we like to see
There are some things that make a featured notebook work extra well! Some examples:
- Many interactive elements using `@bind`. When reading featured notebooks, `@bind` will be interactive instantly, while editing takes some time.
- Pictures! Especially at the top of the notebook. Many people will quickly scroll through the notebook looking for cool visuals before deciding to read the text.
- Text! Explain what your code and interactions do, using simple language. Also think about labeling plots and interactive elements.
- Links! If your notebook uses difficult concepts, consider adding links to resources online where people can learn more about it.
- Code! Some featured notebooks have no visible code (the "magic demos"), but also consider showcasing your code! Can you make code part of the story? Perhaps you can put more technical code in helper functions that are hidden in the bottom.
- Clear code! Write code comments and descriptive variable names. Try splitting your code into more cells and functions with a descriptive name.


Things to avoid:
- Long cell runtimes or heavy memory usage. *(For example: training a machine learning model)*
- Importing large packages when smaller alternatives exist. *(For example: if you are using Makie.jl to create a simple plot, then consider using PlutoPlotly.jl or Plots.jl instead. Are you using Makie.jl for an awesome visualisation, then great!)*







# Technical information
The information below describes the technical details for making a notebook work well in our _featured_ system. If this is intimidating or unclear, don't worry! You can skip all of this and just make a Pull Request, and we will figure it out together ☺️

If you are experienced with these topics, you can also work through this list yourself, and make your own choices about the license, etc.

## Frontmatter
If you take a look at [featured.plutojl.org](https://featured.plutojl.org), you will notice that all notebooks have a nice title, description, image and author. This data is called *frontmatter*, which can be written using Pluto's [Frontmatter GUI](https://github.com/fonsp/Pluto.jl/pull/2104). To open it from the Pluto editor, click the share button ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/share-outline.svg" width=20> ), and then the frontmatter button in the top right. ( <img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/newspaper-outline.svg" width=20> ). You need to fill in the following fields:

- `description`
- `date`: the creation date
- `license`
- `license_url` (see below)
- `image`: should be a URL starting with `https://`. The image can be `.jpg`, `.png` or `.svg`, and about 600x400 pixels large. *(To use your own image, create a new issue in this repository, paste the image in the text to upload it to github and to get the URL. You can cancel creating the issue.)*
- At least one author, with:
  - `name`: your name to display
  - `url`: your user page URL, like `https://github.com/fonsp`. This is where people will go when they click on your name. If it's a github user URL, then it will also be used for the image.
  - `image` *(optional)*: if you did *not* provide a github `url` that can be used for the image, or if you want to choose another image, use this for a custom avatar URL.
- `tags`: fill in as many tags as you wish! This is where you choose in which category the notebook is listed, include at least one existing tag from [the collections configuration](https://github.com/JuliaPluto/featured/blob/main/src/pluto_export_configuration.json). *(lowercase, spaces allowed)*
- `order` *(optional)*: this can be a number that is used to sort notebooks within a collection. Notebooks with lower orders show up first.

All notebook files in this repository will be rendered by PlutoSliderServer, but they will only show up in Pluto's main menu if they belong to a collection. 


## Licensing

All notebooks MUST have an [OSI-approved licence](https://opensource.org/licenses/) or a [creative commons licence](https://creativecommons.org/share-your-work/cclicenses/). Whether a software licence or a creative licence is more appropriate for your notebook is up to you.

We like to use the [Unlicense](https://opensource.org/license/unlicense/) for featured notebooks, but you're free to pick a different one!

### Adding licence info to your notebook

First, specify the license in the frontmatter of your notebook. Add a `license` field with the name of your licence, and a `license_url` field with a link to the full text.

If the full text is already listed in [LICENSES](LICENSES/), you can link to that file. If not, we recommend that you add it to LICENSES yourself, so it will always be availalbe with the notebook, but you can also link to an external URL.

The Unlicense is a *public domain-equivalent* license, which means gives permission to share and reuse the code without any restrictions. There are a few other licenses like this, such as MIT No Attribution and CC-0. If you're using a license that isn't like this, add a clear paragraph in the content of your notebook to say this.


## Versions

Use Pluto's integrated package manager. *(If you are using an unregistered package, consider just registering it. Using it in a featured notebook is reason enough for registration!)*

[Update all package versions](https://plutojl.org/en/docs/packages/#updating-packages) before submitting the notebook.

Your notebook should be written in **Julia 1.6**. If you wrote it in another version, then start Pluto in Julia 1.6 and open and run your notebook. *(Since Pluto is designed for Julia 1.6 and above, we want the featured notebooks to work for the same versions. We also found that an embedded Manifest.toml generated with Julia 1.6 has the highest chance of working directly on other Julia versions.)*



# Future maintenance
Once a notebook is published

Here, we make a distinction between two types of notebooks: notebooks authored by JuliaPluto, and others.

TODO

## Notebooks authored by JuliaPluto
The purpose of 
TODO

## Notebooks authored by others

TODO


# Site maintenance

Check out [these instructions](https://github.com/JuliaPluto/pluto-developer-instructions/blob/main/How%20to%20update%20the%20featured%20notebooks.md) to learn more about maintenance.

