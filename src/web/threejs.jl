### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://github.com/JuliaPluto/featured/assets/6933510/ad13fe2d-1fc0-442f-9e7a-de8cf52baa6e"
#> order = "4"
#> title = "three.js – Example of JavaScript in Pluto"
#> date = "2024-05-27"
#> tags = ["web", "javascript", "3D"]
#> description = "A simple example of using a JavaScript library in Pluto to create a visualisation library."
#> license = "Unlicense"
#> 
#>     [[frontmatter.author]]
#>     name = "Fons van der Plas"
#>     url = "https://github.com/fonsp"

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 600b676e-19aa-11ef-0a02-cd61e0a3dff3
using HypertextLiteral

# ╔═╡ 48d03cad-0d61-4996-8458-ba39aa42efee
using PlutoUI

# ╔═╡ e1d35685-4024-476b-848f-1984ef8d12b4
md"""
!!! info "Read me first"
	You could look at the following notebooks before reading this one:
	- [JavaScript in Pluto](https://featured.plutojl.org/web/javascript)
	- for more context: [Overview of widget-making for Pluto](https://plutojl.org/en/docs/advanced-widgets/)
"""

# ╔═╡ c5c5eac7-df1c-4770-98f1-258f339559f9
md"""
# Using **three.js** in Pluto

Pluto makes it really easy to use existing JavaScript libraries to add visualisations to your Julia project! This notebook demonstrates how to use a JavaScript library in Pluto by taking three.js as an example.

> #### Idea of this notebook
> 
> I am going to follow the introductory example from the [three.js documentation](https://threejs.org/docs/index.html). Some things are different in Pluto, and I will explain *what*, *how* and *why*.
> 
> After I run their example, I show a couple of next steps that we can take, to further improve the integration with Pluto.

> #### Do I need to know JavaScript to read this?
> A little bit, yes! I want to show how you can use JavaScript in Pluto, with the purpose of making your Julia-based notebooks more interactive.
> 
> Also: the result of this notebook will be a tiny visualisation function that I could share in a package. That means that I need to know some JavaScript to write this function, but I can then share it with others who can benefit from my work without needing to know JavaScript!
"""

# ╔═╡ b44737dc-f36e-4c56-bf3d-e87d90da2d8d
PlutoUI.TableOfContents()

# ╔═╡ 121e6523-66ab-4a12-a491-181fbfa0d611
md"""
# Let's import three.js!

In the [documentation of three.js (_"Creating a scene"_)](https://threejs.org/docs/index.html#manual/en/introduction/Creating-a-scene), we see the following import statement:

```js
// ⛔️ this code needs to be changed
import * as THREE from 'three';
```

There are two things I need to change to make this work in Pluto:
1. the bare module name `"three"` needs to be replaced by a version-pinned URL.
2. the top-level `import` statement needs to be replaced by `await import("...")`


For the URL, I went to [jsdelivr.com](https://jsdelivr.com/), then used the "NPM search bar" and searched for `three`. This sent me to the "package page" [https://www.jsdelivr.com/package/npm/three](https://www.jsdelivr.com/package/npm/three) where I go to the "Files" tab where I found the entry-point ES6 import:
```
https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js
```

With changes 1 & 2 this gives me the import statement that works in Pluto:

```js
const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');
```

"""

# ╔═╡ 13bab004-afbb-4bd9-948e-5603272eb8e7
md"""
If you want to learn more about ES6 library imports in Pluto:
"""

# ╔═╡ 51cca7ca-f716-4738-8dea-008c33f7ddbb
md"""
Let's run this code, using [`@htl` from HypertextLiteral.jl](https://github.com/JuliaPluto/HypertextLiteral.jl). We use [`console.log`](https://github.com/JuliaPluto/pluto-developer-instructions/blob/main/How%20to%20open%20the%20Browser%20Dev%20Tools.md) to see what we got.
"""

# ╔═╡ b5065b18-6e2f-497d-ab03-178b17b350e8
@htl """
<script>
const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');

console.log("Imported the three.js module!", THREE)
</script>
"""

# ╔═╡ 6f0ce55c-4317-434d-968d-0d5870c0974f
md"""
# Creating the scene

The next step after importing the library is to create a 3D scene that we can place objects and lights in. We ask three.js to create a scene, and then we place the image somewhere in the DOM (the web page). The documentation gives:

```js
// ⛔️ this code from the three.js documentation needs to be changed
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );
```

There are some things I need to change:
1. 📐 **Size** – the width and height: I don't want to make a full-screen picture (`window.innerWidth`), but a small image within the cell output. Let's start by setting the width and height to `300`.
3. 🧹 **Cleanup** – the three.js example sets up a scene, but there is no code to clean it up. I found the necessary cleanup code [by asking in the three.js forum](https://discourse.threejs.org/t/webglrender-dispose-has-no-effect/66025), and we can use Pluto's [`invalidation API`](https://plutojl.org/en/docs/javascript-api/#invalidation) to call it when necessary.
2. 🏗️ **DOM** – `document.body.appendChild`: I want to place the rendered image inside the page (in the current cell), not at the end of the document. The easiest way to do this is to use Pluto's [`return API`](https://plutojl.org/en/docs/javascript-api/#return).
"""

# ╔═╡ 96d4f0c1-1405-4145-98f1-29b27e1d26e0
details("🙋 Do I need cleanup code?",
md"""
No... without cleanup code, your code will work. But you might notice that your notebook starts slowing down over time, until you reload the browser tab.

#### Old output
In Pluto, when a cell changes output, the old output becomes invisible. But what happens to this old output? Does it still take up CPU and memory?

In many cases, the browser is smart enough to release all memory, and it will be like it never existed. If you used JavaScript to create variables, then those variables can also be cleared automatically.

But if your output does something special with JavaScript, then you might need to clean it up manually. Examples are starting a loop ([`setInterval`](https://javascript.info/settimeout-setinterval)), adding an event listener to an element that does not disappear (like `window`), creating a WebGL rendering context, starting a webcam stream, and plenty more.

#### When is this a problem?
Imagine that we use three.js to create a visualisation library for Julia. We have a function that shows shapes, with syntax like:

```julia
visualise_shapes(cubes=5, spheres=9)
```

If your user uses Pluto and runs this code, a three.js scene is created that shows the 14 shapes. If the user now changes the code to:

```julia
visualise_shapes(cubes=10, spheres=10)
```

then the old visualisation with 14 shapes disappears, and the new one with 20 shapes gets rendered. Without cleanup, the 14-shape visualisation is still rendering and animating in the background.

Now imagine that our user adds two `PlutoUI.Slider`s to control the number of cubes and spheres. Moving the sliders around will quickly create lots of new WebGL scenes, all taking up more memory, gradually slowing down the notebook.

With cleanup code, we ensure that invisible outputs stop taking up resources.
""")

# ╔═╡ 1c896606-5414-4a14-8605-420f540c7164
md"""
With these three changes, I get:

```js
// 📐 Size
const width = 300, height = 300;
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, width / height, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( width, height );

// 🧹 Cleanup
invalidation.then(() => {
	renderer.forceContextLoss()
	renderer.dispose()
})

// 🏗️ DOM
return renderer.domElement
```

Let's try it out!
"""

# ╔═╡ d7f65f94-de39-4537-8242-038a8820a714
@htl """
<script>
const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');

// 📐 Size
const width = 300, height = 300;
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, width / height, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( width, height );

// 🧹 Cleanup
invalidation.then(() => {
	renderer.forceContextLoss()
	renderer.dispose()
})

// 🏗️ DOM
return renderer.domElement
</script>
"""

# ╔═╡ c6566d73-62a3-43ed-925e-d9ebad7e0187
md"""
Great! We see nothing (because the scene is empty), but we see that a 300x300 canvas was created: this is the empty space above the cell.
"""

# ╔═╡ 9dc795ed-81e7-4426-a8da-6f46e0e6d037
md"""
## Adding a cube

Continuing with the "Creating a scene" tutorial, I add the rest of the code that sets up a cube and an animation loop. I just need to make sure that `return renderer.domElement` is still at the end of the script.
"""

# ╔═╡ 8528832e-e134-45ed-a271-1743d607e288
@htl """
<div>

<script>
const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');

// 📐 Size
const width = 300, height = 300;
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, width / height, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( width, height );
renderer.setAnimationLoop( animate );

// 🧹 Cleanup
invalidation.then(() => {
	renderer.forceContextLoss()
	renderer.dispose()
})


const geometry = new THREE.BoxGeometry( 1, 1, 1 );
const material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
const cube = new THREE.Mesh( geometry, material );
scene.add( cube );

camera.position.z = 5;

function animate() {
	cube.rotation.x += 0.01;
	cube.rotation.y += 0.01;

	renderer.render( scene, camera );
}

// 🏗️ DOM
return renderer.domElement
</script>
</div>
"""

# ╔═╡ ee22bad5-d01c-4607-bf8a-c40a92dbc6e6
md"""
# Using data from Julia

Because I used `@htl` from [HypertextLiteral.jl](https://github.com/JuliaPluto/HypertextLiteral.jl), it is really easy to use values from Julia inside of our JavaScript code, simply by interpolating with `$`.

Until now, I always created an `@htl` object in a cell, and you can see the result above the code. In the next example, I put our cube example into a **function** that returns the `@htl` object:

```julia
function visualise_shapes(; cubes::Int64=0, spheres::Int64=0)
	return @htl ""\"
	
	... the code comes here

	""\"
end
```

If you call this function from another cell, you get a three.js scene as a result!

## Is this... a widget?!
By putting our `@htl` into a function, I went from a one-time experiment to an actual **Custom output widget**. 🎉 I can now publish this function in a package, so that others can use my visualisation for their own notebooks. You can read more about this philosophical point [in the plutojl.org docs](https://plutojl.org/en/docs/advanced-widgets/). What we created is a "Custom output – visualiser function".

Getting ahead of myself... let's actually visualise something! Right now it just shows one green cube. My idea is that calling the function `visualise_shapes(cubes=3, spheres=12)` should show a 3D scene with 3 cubes and 12 spheres. And the shapes should rotate!

## From Julia to JavaScript
In `visualise_shapes` below, I wrote some JavaScript that creates a scene with one row of red spheres, and one row of green cubes. The number of spheres and cubes is given by two Julia variables. You can read the code to learn exactly how I set up this scene with three.js, but what I want to highlight here is how I **used the Julia variables inside JavaScript**.

The basic idea is this:

```julia
function visualise_shapes(; cubes::Int64=0, spheres::Int64=0)
	return @htl ""\"
	<div>

	<script>
	
	const num_cubes = $(cubes)
	const num_spheres = $(spheres)

	// Now I can use the variables like regular numbers in JavaScript! 
	// For example:

	const num_shapes = num_cubes + num_spheres
	
	</script>
	</div>
	""\"
end
```

!!! info "Advanced"
	We provide more advanced API in [AbstractPlutoDingetjes.jl](https://plutojl.org/en/docs/abstractplutodingetjes/#published_to_js) for very large amounts of data or on-demand data requests. But for most cases, just interpolating with `$` into `@htl` should give the best results!

"""

# ╔═╡ b96b383a-ff06-42ee-bc33-a603da655ff6
md"""
## Demo of `visualise_shapes`
Let's see it in action! Move these sliders:
"""

# ╔═╡ 99cd53c8-ea02-483a-afd6-5809b4725d07
@bind spheres_test Slider(1:50)

# ╔═╡ 83d86f2e-55f5-42c7-b14a-19dc2901fc08
@bind cubes_test Slider(1:50; default=4)

# ╔═╡ 76ff5a12-0868-4fe3-b8ef-c76c52da493c
md"""
Cool right! I will never again have trouble understanding that 9 is bigger than 5!

Here is the implementation of `visualise_shapes`:
"""

# ╔═╡ 9bb20377-06a5-477b-8c87-9e66b3ebb507
function visualise_shapes(; cubes::Int64=0, spheres::Int64=0)
	return @htl """
	<div>
	<script>
	const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');
	
	// 📐 Size
	const width = 300, height = 300;
	const scene = new THREE.Scene();
	const camera = new THREE.PerspectiveCamera( 90, width / height, 0.1, 1000 );
	
	const renderer = new THREE.WebGLRenderer();
	renderer.setSize( width, height );
	renderer.setAnimationLoop( animate );
	
	// 🧹 Cleanup
	invalidation.then(() => {
		renderer.forceContextLoss()
		renderer.dispose()
	})

	const num_cubes = $(cubes)
	const num_spheres = $(spheres)

	// 🎁 Creating the scene
	const cubes = _.range(num_cubes).map((i) => {
		const geometry = new THREE.BoxGeometry( .7, .7, .7 );
		const material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
		const cube = new THREE.Mesh( geometry, material );
		cube.position.x = i
		return cube
	})
	const spheres = _.range(num_spheres).map((i) => {
		const geometry = new THREE.SphereGeometry( .5 );
		const material = new THREE.MeshBasicMaterial( { color: 0xee0000 } );
		const sphere = new THREE.Mesh( geometry, material );
		sphere.position.x = i
		sphere.position.y = 1.5
		return sphere
	})
	scene.add( ...cubes, ...spheres );

	// 🎥 I move the camera to keep all shapes in view
	camera.position.x = Math.max(num_cubes, num_spheres) / 2;
	camera.position.z = 3 + Math.max(num_cubes, num_spheres) / 2;
	
	function animate() {
		for(let shape of [...cubes, ...spheres]) {
			shape.rotation.x += 0.01;
			shape.rotation.y += 0.01;
		}
	
		renderer.render( scene, camera );
	}
	
	// 🏗️ DOM
	return renderer.domElement
	</script>
	</div>
	"""
end

# ╔═╡ 1c00f6c1-524f-4949-b6e4-c7800ab093d3
visualise_shapes(cubes=cubes_test, spheres=spheres_test)

# ╔═╡ 111382a2-ec1c-456d-8c53-94420241c82a
md"""
# Bonus: faster re-render

In the example `visualise_shapes` above, you might notice some flickering when moving the sliders: every time the scene renders, it takes a slight moment before the scene appears. Until then, nothing is shown, causing a flicker.

## Easy fix: create the canvas directly
The easiest solution to avoid some of the flicker is to create the canvas directly with `@htl`, to make sure that something is visible while waiting for three.js to initialize. This way, we see a black rectangle of the correct size while waiting for the display.

In the `@htl` string, we add the `<canvas>` element:

```html
<div>

<canvas width=300 height=300 style="background: black"></canvas>

<script>
...
</script>
</div>
```

And in the script, we tell three.js to use the canvas that is already there instead of creating a new one.

```js
// Before:
const renderer = new THREE.WebGLRenderer();

// After:
const canvas = currentScript.parentElement.querySelector("canvas")
const renderer = new THREE.WebGLRenderer({ canvas });
```
"""

# ╔═╡ 964903c9-e773-4db0-bd77-febe30ade0dc
md"""
## Fancy fix: re-use the previous canvas
Pluto provides a special API to allow you te re-use content from the previous cell render: [`this`](https://plutojl.org/en/docs/javascript-api/#this). We can use it in our case to re-use the canvas, and even the three.js renderer, so no new WebGL context needs to be created.

We need to make the following **three changes** to `visualise_shapes`. If you also followed the "Easy fix", you might need to start from the original before following these steps, although it should be easy to combine both fixes.

### 1. Script id
The `<script>` element needs its `id` attribute set for the `this` API to be enabled. This means changing `<script>` to `<script id=cubesandspheres>`.


### 2. Re-use
We need to get the previous canvas and renderer. First, let's attach the `renderer` as a property to the returned element, so we can access it on the re-render:



```js
// Before:
return renderer.domElement

// After:
renderer.domElement.the_previous_renderer = renderer
return renderer.domElement
```

Now we can access it when creating the renderer. If the previous renderer exists, we use it again, otherwise we create a new one.

```js
// Before:
const renderer = new THREE.WebGLRenderer();

// After:
const renderer = this?.the_previous_renderer ?? new THREE.WebGLRenderer();
```

### 3. Cleanup
With the two changes above, our renderer will be re-used, but now the `invalidation` cleanup will mess things up: the renderer gets destroyed before it can be re-used.

The solution is to check in the cleanup function whether the canvas is being reused, and cancel cleanup if so. We can do this by checking if we are still in the DOM, using [`.isConnected`](https://developer.mozilla.org/en-US/docs/Web/API/Node/isConnected).

```js
// Before:
invalidation.then(() => {
	renderer.forceContextLoss()
	renderer.dispose()
})

// After:
invalidation.then(() => {
	if(!renderer.domElement.isConnected) {
		renderer.forceContextLoss()
		renderer.dispose()
	}
})
```

"""

# ╔═╡ a92799fd-0e86-4031-ac29-52f98941473e
md"""
# Bonus: responsive width

In the examples above, we set the renderer size to 300x300 pixels. We can follow the [three.js documentation about responsive sizing](https://threejs.org/manual/#en/responsive) to make a window that fills the whole cell, and automatically resizes when the notebook changes size. Try resizing your window to see the size update:

I used a [`ResizeObserver`](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver) to get notified when a resize is necessary.

```js
const canvas = renderer.domElement;
canvas.style.width = "100%"

const updateSize = () => {
	const width = canvas.clientWidth, height = canvas.clientHeight

	camera.aspect = width / height;
	camera.updateProjectionMatrix();
	if(canvas.width !== width || canvas.height !== height) {
		renderer.setSize(width, height, false);
		renderer.render( scene, camera );
	}
}

const resiobs = new ResizeObserver(updateSize)
resiobs.observe(canvas)
invalidation.then(() => resiobs.disconnect())
```
"""

# ╔═╡ 7bebffcd-f35a-4980-bad2-0f9d043d84cb
@htl """
<div>

<script>
const THREE = await import('https://cdn.jsdelivr.net/npm/three@0.164.1/build/three.module.min.js');

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, 1, 0.1, 1000 );

const renderer = new THREE.WebGLRenderer();
renderer.setSize( 300, 300 );
renderer.setAnimationLoop( animate );

// 🧹 Cleanup
invalidation.then(() => {
	renderer.forceContextLoss()
	renderer.dispose()
})


// 📐 Size: make it responsive
const canvas = renderer.domElement;
canvas.style.width = "100%"

const updateSize = () => {
	const width = canvas.clientWidth, height = canvas.clientHeight

	camera.aspect = width / height;
	camera.updateProjectionMatrix();
	if(canvas.width !== width || canvas.height !== height) {
		renderer.setSize(width, height, false);
		renderer.render(scene, camera);
	}
}
const resiobs = new ResizeObserver(updateSize)
resiobs.observe(canvas)
invalidation.then(() => resiobs.disconnect())





// This is unchanged:
const geometry = new THREE.BoxGeometry( 1, 1, 1 );
const material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
const cube = new THREE.Mesh( geometry, material );
scene.add( cube );

camera.position.z = 5;

function animate() {
	cube.rotation.x += 0.01;
	cube.rotation.y += 0.01;

	renderer.render( scene, camera );
}

// 🏗️ DOM
return renderer.domElement
</script>
</div>
"""

# ╔═╡ 1ecc0095-5ef4-4661-9df9-3d7b34614b83
learn_about_importing_in_pluto = PlutoUI.details(
	"🙋 Importing a JS library in Pluto",

	md"""
	
	Pluto works best with [**ES6 imports**](https://javascript.info/import-export). This is the most reliable. You can recognize ES6 imports by the JavaScript **`import` keyword**. For example, this is an ES6 import from the `lodash` library:
	
	```js
	import * as lodash from "https://esm.sh/lodash-es@4.17.21"
	
	lodash.throttle(...)
	```
	
	In Pluto, you have to use the **`await import("...")`** function. The top-level `import` does not work, and the modern `<script type="importmap">` is also not supported (sorry!). This means rewriting the snippet above to:
	
	```js
	const lodash = await import("https://esm.sh/lodash-es@4.17.21")
	
	lodash.throttle(...)
	```
	
	The snippet above works in Pluto! (And also in any other browser environment.)
	
	### Not an ES6 library?
	Most popular modern libraries have an "official" option to import the library with ES6, and you can often find it by searching the internet.
	
	But some (older) libraries do not have an official ES6 import. Or for some reason, the official ES6 import does not work well. In that case, the service [esm.sh](https://esm.sh/) can be very useful! It will try to automatically convert any library on npm into a browser-compatible ES6 library, and it works pretty well!
	
	!!! info "Choosing a CDN"
		There are many JavaScript CDNs out there, like [jsdelivr.com](https://jsdelivr.com/), [esm.sh](https://esm.sh/), [unpkg.com](https://unpkg.com/), [cdnjs.com](cdnjs.com) and many more. Which one do you choose?
	
		Whenever possible, **jsdelivr.com is your best option**. They currently don't support ES6 conversion (but they have a beta product [esm.run](https://esm.run/) that looks promising), but for released assets from npm or github they are the most reliable, with redundancy, good support in China and outside the global north.
		
		If you need to have an **old library converted to ES6**, we recommend **esm.sh**. For the most reliable result, we recommend both *pinning the package version* and *pinning the esm.sh build version*. esm.sh is fairly reliable but not the best, and service outside the global north is not optimal.
	
		For your own material (like your own scripts or assets), a reliable way to get it online is to put in a public github repo, then make a release, and then use jsdelivr.com to get the assets from that release.
	"""
);

# ╔═╡ 302ebe5d-9637-47cf-8d56-064d14633511
learn_about_importing_in_pluto

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "65877c43b0e7adba5f4c93d8d0c98988bb337300"

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
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

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
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

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
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

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
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

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
# ╟─e1d35685-4024-476b-848f-1984ef8d12b4
# ╟─c5c5eac7-df1c-4770-98f1-258f339559f9
# ╟─b44737dc-f36e-4c56-bf3d-e87d90da2d8d
# ╟─121e6523-66ab-4a12-a491-181fbfa0d611
# ╟─13bab004-afbb-4bd9-948e-5603272eb8e7
# ╟─302ebe5d-9637-47cf-8d56-064d14633511
# ╟─51cca7ca-f716-4738-8dea-008c33f7ddbb
# ╠═600b676e-19aa-11ef-0a02-cd61e0a3dff3
# ╠═b5065b18-6e2f-497d-ab03-178b17b350e8
# ╟─6f0ce55c-4317-434d-968d-0d5870c0974f
# ╟─96d4f0c1-1405-4145-98f1-29b27e1d26e0
# ╟─1c896606-5414-4a14-8605-420f540c7164
# ╠═d7f65f94-de39-4537-8242-038a8820a714
# ╟─c6566d73-62a3-43ed-925e-d9ebad7e0187
# ╟─9dc795ed-81e7-4426-a8da-6f46e0e6d037
# ╠═8528832e-e134-45ed-a271-1743d607e288
# ╟─ee22bad5-d01c-4607-bf8a-c40a92dbc6e6
# ╟─b96b383a-ff06-42ee-bc33-a603da655ff6
# ╠═99cd53c8-ea02-483a-afd6-5809b4725d07
# ╠═83d86f2e-55f5-42c7-b14a-19dc2901fc08
# ╠═1c00f6c1-524f-4949-b6e4-c7800ab093d3
# ╟─76ff5a12-0868-4fe3-b8ef-c76c52da493c
# ╠═9bb20377-06a5-477b-8c87-9e66b3ebb507
# ╟─111382a2-ec1c-456d-8c53-94420241c82a
# ╟─964903c9-e773-4db0-bd77-febe30ade0dc
# ╟─a92799fd-0e86-4031-ac29-52f98941473e
# ╠═7bebffcd-f35a-4980-bad2-0f9d043d84cb
# ╠═48d03cad-0d61-4996-8458-ba39aa42efee
# ╟─1ecc0095-5ef4-4661-9df9-3d7b34614b83
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
