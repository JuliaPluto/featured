### A Pluto.jl notebook ###
# v0.20.27

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://raw.githubusercontent.com/damourChris/FeaturedPlutoNotebooks/738fc31/maths/ZombieAttackNotebookPreview.png"
#> title = "Modeling a Zombie Attack "
#> date = "2023-12-16"
#> license = "Unlicense"
#> description = "An introduction to modeling with ModelingToolkit.jl through a Zombie Attack.  "
#> tags = ["dynamical systems", "biology", "modelingtoolkit", "zombie outbreak", "modeling", "math"]
#> 
#>     [[frontmatter.author]]
#>     name = "Chris Damour"
#>     url = "https://github.com/damourChris"

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

# ╔═╡ e972417e-efc2-4fac-a775-843cedcd370f
using ModelingToolkit: t_nounits as t, D_nounits as D

# ╔═╡ c6daea2a-ce72-4b32-b828-48be9ba1f961
using ModelingToolkit: System

# ╔═╡ b0a09135-8cec-460c-88bb-c91ee832a55b
using ModelingToolkit:mtkcompile

# ╔═╡ edcdc582-e2ba-4aaa-b6c7-3c82c540502c
using ModelingToolkit: Pre

# ╔═╡ 00edd691-2b60-4d1d-b5e2-2fd4675469da
begin
	using ModelingToolkit: @named, @variables, @parameters, parameters, get_unknowns
	using OrdinaryDiffEq
	md"""
	!!! info "Modeling"
		[ModelingToolkit](https://juliapackages.com/p/ModelingToolkit): Use for modeling and setup ODE systems for each of the models.
	
		[OrdinaryDiffEq](https://www.juliapackages.com/p/OrdinaryDiffEq): Holds the differential equation solvers.
	"""
end

# ╔═╡ 7a937f2c-5808-4756-9bfc-6f84b0f03cc9
begin
	using Plots
	using PlotlyBase
	plotly()
	using PlutoUI
	import PlutoUI: combine
	using HypertextLiteral: @htl
	using Parameters
	md"""
	!!! info "Display Packages"
		[Plots](https://juliapackages.com/p/Plots): Plotting library for the several plots in the notebook.

		[PlutoUI](https://www.juliapackages.com/p/PlutoUI):  Extension for Pluto to handle interactivity, provides the Sliders.
	
		[HypertextLiteral](https://www.juliapackages.com/p/HypertextLiteral): Julia package for generating HTML, SVG, and other SGML tagged content.
	
		[Parameters](https://www.juliapackages.com/p/Parameters): Types with default field values with keyword constructors.
	"""
end

# ╔═╡ a72d89aa-6108-40a2-afbb-b9edd0c90b8f
begin
	TableOfContents()
end

# ╔═╡ 684ab7f8-a5db-4c39-a3cc-ce948dd026b0
md"""
!!! info "Story Mode" 
	For putting this notebook into context, story cards were addeed for each section. There are not necessary for following the notebook but makes the notebook a bit more entertaining. 
Activate story mode? $(@bind story_mode CheckBox(default=true))
"""

# ╔═╡ 19ea7ddf-f62b-4dd9-95bb-d71ac9c375a0
md"# Introduction"

# ╔═╡ ac777efc-f848-4358-afd2-a1af334752b3
md"
The world is facing a impending disaster. A virus broke out from a laboratory and is turning humans into zombies! 
Countries are closing down borders, flights are cancelled, chaos is spreading quickly accross the world...
"

# ╔═╡ fc95aba1-5f63-44ee-815c-e9f181219253
if(story_mode)
	md"""
	!!! tip "Is this the end of the world?" 

		It has been a couple of days since the news broke out to the world, and you are running low on supplies. As you heat up your last tin of tomato soup, you hear the familiar notification on your phone. It reads:

		"Calling to all survivors. Go your local survivor camp to find shelter and supplies. For directions, click [here](https://www.google.com/maps/place/Survivor-NRW/@51.6019909,6.695119,7.82z/data=!4m6!3m5!1s0x47b855f29754ec41:0x8211d767f947fb45!8m2!3d51.8130827!4d7.2971646!16s%2Fg%2F11rrp49wcv?entry=ttu)."
	
		*Maybe it's not a bad idea after all*. With no other options left, you decide to head to the camp for survival. After quickly packing up the basics in your backpack, you head off. 
		
		The major streets of the city, once packed with cars, are now empty. Banks and shops have been torn down and not a single soul is to be seen. As you approach the gate, you notice a big wall made of scraps assembled together: the survival camp.
		
			Anyone here?
		
		You wait anxiously for a response, but the only sound is the wind blowing through the scraps of metal. 
		
		*Has the camp already fallen to the zombies?* 
	
		You repeat your question, louder this time, but still no answer. After a couple of minutes, you hear sound of a sliding metal bar and a pair of eyes appear through a rough opening in the door. 
	
			- Who is this?
	
			I am a survivor. I heard about this camp in the emergency signal.
	
			- Have you had any interaction with the zombies? Did you get bitten?
	
			No, I have not seen a single one.
	
		The opening closes and a loud mechanical noise starts, the door opens. A young blond man, with the biggest goggles you have ever seen, greets you: 
		
			Hey! My name is Hans, welcome to the camp! 

		After showing you around the camp, Hans brings you to the biggest tent: the headquarters. It's covered in maps and scientific diagrams. In the back of the room, a woman is deep in thought, looking a notepad. Hans calls her: 

			- Hey Zara, we have a new member!
		
		Zara looks up from her notepad, her eyes scanning you from head to toe. After a few seconds, she smiles and extends her hand. 

			- Welcome! We definitely need as much help as we can get. 
			- Do you know much about this virus?

			No but I have worked on epidemiology before, so maybe I can help?

		After a long exchange, Hans announces that he has to leave and you are left with Zara in the tent. She turns to you, and gravely announces:
			
			- There are only 2 outcomes.
			- Either the zombies take over the world...
			- Or we find a solution to fight them and survive this terrible apocalpyse.

			Any chance of a cure?

			- We heard from our friends that a group is trying to develop something, but so far nothing. 

			Well, I don't know much about vaccines and cures but I can try to predict what could happen?

			- Oh yeah? And how so?

			Let me show you.
	
	"""
end

# ╔═╡ bf5da9c2-bb7b-46d2-8b39-a362eaf9e6f9
md"## The Zombie Outbreak Model"

# ╔═╡ cc1a1a9a-7a45-4231-8471-0fb90b994357
md"""Let's start with the simplest model. In this model, there are healthy humans (susceptible) and zombies. So what happens when a zombie meets a human? 

We note ``😟(t)`` the number of susceptible humans at a given time ``t`` and and ``🧟(t)`` for the number of zombies.

We can say that there is a positive rate 🦠 that describes the chance of a zombie converting a human into another human. We also define the term ``😟(t)🧟(t)`` to capture the interaction between a zombie and a susceptible human. 
We can then define the following system of equation: 
"""

# ╔═╡ 4c3f3770-ef33-41a5-89a6-274101b06c87
md"""However since 🦠 is defined to be positive this model is quite pessimistic, every scenario will eventually end up with all susceptible humans turning into zombies and taking over the world. 

Let's give the humans some chance of fighting back. We can introduce a new class of individuals in our model, which we call 'Removed', noted ``😵(t)``. This class represents the zombies that were killed by humans. 

We now have: 

- ``😟(t)``: Humans susceptible to be converted 
- ``🧟(t)``: Zombies 
- ``😵(t)``: Removed 

We define ⚔ as the rate at which the susceptible humans kill the zombies. 

Additionally, these zombies will be hard to get rid of since there is a small chance (noted 💀) that a removed "comes back from the dead" and is reintroduced as a zombie. 
"""

# ╔═╡ 71baff78-d298-4c6a-99d5-6b65c1c27e6f
md"""Our model now looks like this:"""

# ╔═╡ 77d94a92-f058-4b9f-9df8-9de58603c293
md"## Setting up the system"

# ╔═╡ e0581cf3-f942-45a6-bcf2-9e72ba2379a4
md"""

!!! info "Acausal Modeling"
	To set up this model, we will be using the *acausal modeling library* [ModelingToolkit](https://github.com/SciML/ModelingToolkit.jl) from [SciML](https://sciml.ai/). The idea is that we can define equations and systems using the equations that we have defined directly. (You can actually check that the system that is mentioned earlier is actually a ModelingToolkit system.)

"""

# ╔═╡ 28def719-c8e2-43d6-b20e-6141e423add2
md"""
The first step is to define the variables that will be needed for the model. That is, our dependent time variable ``t``, the differential operator ``D``, the independent variables ``😟(t)``, ``🧟(t)``, ``😵(t)`` and the model parameters ``⚔``,``🦠``, and ``💀``.
"""

# ╔═╡ 01ce7903-0ba3-45bc-816a-f8288583b4d4
@variables 😟(t) 🧟(t) 😵(t)  

# ╔═╡ 6bfa46a7-f50d-49b6-bebc-b7821f89100f
@parameters ⚔️ 🦠 💀  

# ╔═╡ ad15095c-a5bb-46e0-84a3-a20ce765b6c0
D(😟) ~ -🦠*😟*🧟

# ╔═╡ fd5ac3bd-4190-4242-a460-b9f755082b8d
D(🧟) ~  🦠*😟*🧟

# ╔═╡ 52d9452b-5c1e-42ea-8976-0ec2f30eaaf8
md"Once we have defined everything, we can put them together to define the system via the System constructor:"

# ╔═╡ 43593199-0107-4b69-a239-f9f68c14b8eb
@named simple_attack_sys = System(
	[
		D(😟) ~ -🦠*😟*🧟,
		D(🧟) ~  🦠*😟*🧟  -	⚔️*😟*🧟 + 💀*😵,
		D(😵) ~ 		  	 	⚔️*😟*🧟 - 💀*😵
	], t
)

# ╔═╡ 70547a7e-c357-4787-9c34-d2789bb60860
simple_attack_sys

# ╔═╡ 4b731a5f-3fe2-4691-8f89-c37f05d623ab
md"Now in order to simulate what would happen to our model we need to set some values for each of the variables and parameter of the system"

# ╔═╡ 416dc725-d1c1-4b14-9315-aa57d9e1127d
md"""

!!! info "Sliders"
	Throughout this notebook I use sliders to add interactivity to the system. For each parameter, a default slider is defined and given some default values, upper/lower bounds. More information is available in the [appendix](#6b4feee8-f8bb-4639-a423-97e7ab82cad0). 
"""

# ╔═╡ 56714c4c-daed-47e2-bda7-ab5518e16faa
md"
Great, now that we have an idea of what we will start with, the next step is to define a [ODEProblem](https://docs.sciml.ai/DiffEqDocs/stable/types/ode_types/), which allows us to solve the problem, given the values that we just defined. 

"

# ╔═╡ 63181343-9e48-4cdc-8888-c5476b4d75cd
md"""
!!! info "Solving the problem" 

	To solve the problem one can simply call the `solve()` function on the problem to get a set of values representing the population at each timestep. You can then plot the solution by calling `plot()`.

	```julia
	 simple_attack_sol = solve(simple_attack_prob)

	 p = plot(simple_attack_sol)

	```

	However, in order to explore different parameters, sliders are used for interactivity. To prevent compiling the problem over and over again, we can call `remake()` on the problem with new parameters. This is optimized to recreate the problem much faster, because much of the code required to solve the problem does not actually change when changing parameters or the initial values. 
"""

# ╔═╡ c32431fb-0cf4-4ef0-8b6e-5a76a93de260
md"""
!!! warning "DifferentialEquations.jl vs OrdinaryDiffEq"
	Note that the `solve(prob)` syntax is only valid when using the DifferentialEquations.jl package, which covers a lot of cases and dispatches the correct solver for any given situatin. However, here for simplicity I only use OrdinaryDiffEq so each solve() call has a solver attached to it. In the notebook, Tsit5() and Rosenbrock23() are used. 
"""

# ╔═╡ 637ef564-718f-4a4c-ac6c-cd9fd2802e16
md"""
If all went well, the model predicts that humans will survive only a couple months, and there does not seem to be a way out...
"""

# ╔═╡ 14b18562-5701-4a08-aba0-fc31e8d6306f
md"""
!!! info "Parameters"
	If you lose track of what each parameters represent, check the [Appendix](#0dd7fd47-6575-4b9d-938f-012cff42692d).
"""

# ╔═╡ 3f6c6d86-0ba1-4b63-ac50-f1d4460ea90a
if(story_mode) md"---" end

# ╔═╡ ec47f63d-36eb-4331-aec9-9f1af15a3eab
if(story_mode)
	md"""
	!!! tip "Updating the model"

		As you show Zara your model, she looks disapointed. 
			
			- This is not very hopeful...
			- We are fighting back though! We are getting rid of some zombies, but they keep coming back...
		
			Well this is the simplest version, let me add more complexity to it.  
	
		You begin to add more parameters to the model, incorporating factors such as the rate of zombie infection. As you input the data, the model begins to paint a bleak picture of the future. Zara's disappointment deepens as she sees the projected outcome."This is worse than I thought." she says, her voice heavy with despair. "We need to come up with a new plan, something that will give us a fighting chance."
		You nod in agreement, knowing that the situation is dire. Despite the survivors' best efforts, the zombie horde continues to grow, and resources are dwindling. As you continue to tweak the model, you realize that time is running out. The survivors must act quickly if they hope to turn the tide of the apocalypse.
	
	
	"""
end

# ╔═╡ 0f22c808-a413-415e-95d1-98317ca6ed25
md"# Latent Infection"

# ╔═╡ c1918d6a-3b5a-4046-b084-e6f98eaabee6
md"""	
Let's introduce the concept of **latent infection**. In this scenario, when a zombie bites a human, that human first becomes infected, and after some time, turns into a zombie. 
	
We can introduce a new class for the infected (noted `🤮(t)`) and the parameter 🌡️  to capture the rate at which the infected turn into zombies.
"""

# ╔═╡ ab1836a1-290d-4bde-bf1b-cc8287734e1e
md"## Setup"

# ╔═╡ dc366710-6f43-434c-8787-d6d1a7dd3920
begin
	@variables 🤮(t)
	@parameters 🌡️ 
end;

# ╔═╡ 6aa3249f-4751-45d9-b13d-f748cc950d47
md"We can define the new equations and follow the same workflow as before to solve this system."

# ╔═╡ d4446f64-8d69-4ded-90b3-59544800d6fa
begin
	lattent_infection_eqs = [
		D(😟) ~ 		-🦠*😟*🧟 ,
		D(🤮) ~ 		 🦠*😟*🧟 	- 🌡️*🤮, 
		D(🧟) ~ -⚔️*😟*🧟 			+ 🌡️*🤮  	+ 💀*😵,
		D(😵) ~  ⚔️*😟*🧟 		 				- 💀*😵
	]
end;

# ╔═╡ 9358905f-8d2f-40f6-a9d9-38e39ae3ee85
begin
	@named lattent_infection_sys = System(lattent_infection_eqs, t) 
end

# ╔═╡ 4a97986a-e5d0-4b56-bfb3-022ed9037dd7
md"## Visualization"

# ╔═╡ 8c51a878-6466-4832-ad74-c90683614ebc
md"""
In this model, we are able to survive a bit longer, but there still does not seem to be a way to overcome all the zombies. 

"""

# ╔═╡ b2e6544a-2e87-439c-9b25-de60518f1970
if(story_mode)
	md"""
	--- 
	
	!!! tip "New development!"
		As the days go by, zombie numbers are increasing, but few survivors have arrived at the camp lately.. The last group arrived 4 days ago, and there has not been another sighting since. 
	
		As you have been doing every day since the start, you switch to the information channel on your phone, but today it's different. There is a new blog post with a report attached to it.
	
		*The cure has been developed!*
	
		The first patient has been tested with the cure and has shown no signs of transformation so far. You might be able to stop infected patients turning into zombies afterall. The cure only works on infected individuals and does not seem to be effective on fully transformed zombies..
	
		The post mentioned that the cure will be delivered to all survivor camps in the next few weeks, so as you wait patiently you decide to set up a section of our camp. This will help to isolate the infected so that you are ready when you get the cure... 

		Although the virus has only been observed to transmit through biting, there is no warning for when this might occur. Reports indicate that it can take anywhere from a couple of days to a couple of weeks after the bite for the infected individual to turn into a zombie.
		To reduce the risk of infected individuals spreading the virus, a quarantine has been set up to isolate new cases from the rest of the camp.
		
		After setting up the tent and securing everything, you now have a dedicated section of the camp where any new infected patient can stay. 
	"""
end

# ╔═╡ e831d3ab-8122-4cb6-9dfc-ebbfb241f0c9
md"# Setting up a quarantine"

# ╔═╡ 51f33f5c-06c4-4a6c-9f91-6dd5f0822043
md"""Let's add a quarantine into our model. We will represent the number of people in the quarantine section with the state `😷(t)` and introduce 2 new parameters.

- `🚑`: Infected to Quarantine rate
- `🗡️`: Quarantine to Removed rate 
"""

# ╔═╡ e515330c-d97a-4b66-b40c-fe44ea300bb2
if(story_mode)
	md"""
	!!! tip "Did you get bitten?"
		We have a big camp and getting bitten has now become taboo, hence a few people have not directly said openly that they have be bitten... 
	"""
end

# ╔═╡ 42d42106-a896-4ac0-a476-8590a87b1428
md"""
The `🚑` parameter will represent how much of the infected are placed in quarantine. 
"""

# ╔═╡ 4af55826-0499-4397-bf44-1ea28ab8de80
if(story_mode)
	md"""
	!!! tip "A unfortunate futur" 
		Unfortunately the quarantine is not a very solid area and the first infected patient that was admitted turned into zombie, wreaking havoc inside the camp. You take the hard decision to remove the patients that have turned into zombies from the quarantine. 
	"""
end

# ╔═╡ d923c200-843d-44e8-8870-6b44183a779a
md"""
The `🗡️` parameter represents all the quarantined that have turned into zombies and who are then removed.
"""

# ╔═╡ 5141dd63-ebfb-4b75-a0a3-8a0dd1163169
md"## Setup"

# ╔═╡ 2cb27c2f-edae-4386-a68d-77b2050924a0
begin
	@variables 😷(t)
	@parameters 🚑 🗡️
end;

# ╔═╡ 6467d83d-0e9c-4025-aecf-ab19807e6ba7
begin
	simple_quarantine_eqs = [
		D(😟) ~ -🦠*😟*🧟,
		D(🤮) ~  🦠*😟*🧟  			- 🌡️*🤮- 🚑*🤮, 		   
		D(🧟) ~ 		 - 	⚔️*😟*🧟  	+ 🌡️*🤮 		+ 💀*😵,
		D(😵) ~  			⚔️*😟*🧟  		 			- 💀*😵+ 🗡️*😷, 
		D(😷) ~          		 				+ 🚑*🤮 		- 🗡️*😷  
	]
end;

# ╔═╡ 26050146-bacf-42c2-b56b-4e2ddf27b19d
begin
	@named simple_quarantine_sys = System(simple_quarantine_eqs, t)
end

# ╔═╡ bb435da5-5bd0-4944-abf1-5d54888efa53
md"## Visualization"

# ╔═╡ 874323d9-2910-4c77-8aa1-902df4990105
if(story_mode)
	md"""
	---
	
	!!! tip "The white van at the gate"
		As you wake up to another day of fighting zombies, you receive a call from the main gate. A white van is trying to get in. As soon as you hear this, you rush to the gate. 
	
		"We have the cure!!" you hear, and suddenly the whole camp erupts in joy. You finally have a chance to fight off this pandemic. 

		You rush to the headquarter, extatic to announce the wonderful news to Zara and Hans. As you burst into the tent, you find only find Zara, head deep into her hand. 
		
			Zara! We got the cure!

		She does not react, and you can hear sobbing.
		
			Hans? Hans, we got the cure!
	
		No reponse. 
	
			- I lost him... I.. We went to gather some supplies from the abandonned warehouse up north and... They showed up out of nowhere... I barely managed to escape
			But...
			Oh Hans...
		She burst into tears. You take Zara into your arms. 

		*If we can find him, we might still be able to cure him*. 
		
	"""
end

# ╔═╡ 79489f1f-b8a7-4800-b9ec-feaf6fa134b1
md"# Treating the infected!"

# ╔═╡ f804a947-4e16-4871-84e3-8654d4fb0a46
md"To incorporate a cure into the model, we can define a new parameter (noted 💊) that will determine how effective the cure is in treating the infected. This parameter represents the time it takes for the cure to work, the amount of infected patient the camp can treat, the supply etc..."

# ╔═╡ 5e8a9df5-26ac-4ee0-a647-5088bfb43b25
md"## Setup"

# ╔═╡ 3d9aacb9-1307-4a80-a277-60fe3a66e7ed
begin
	@parameters 💊
end;

# ╔═╡ 06efabb8-15dc-4952-9f5b-fabadd13a87a
begin
	treatment_model_eqs = [
		D(😟) ~ 		-🦠*😟*🧟 		  +	💊*🤮,
		D(🤮) ~  		 🦠*😟*🧟- 🌡️*🤮 -	💊*🤮, 
		D(🧟) ~ -⚔️*😟*🧟 		  +	🌡️*🤮 			+ 💀*😵,
		D(😵) ~  ⚔️*😟*🧟  							- 💀*😵,
	]
end;

# ╔═╡ 8a8733d1-89ae-4a0b-a218-72127fd14e0b
begin
	@named treatment_model_sys = System(treatment_model_eqs, t)
end

# ╔═╡ fcbc4792-866f-4dd1-9b41-a7bb7b1db5fd
md"## Visualization"

# ╔═╡ bc1471e4-925f-4583-b9b1-193ca59748be
if(story_mode)
	md"""

	---
	
	!!! tip "A misterious delivery"
		A big crate just got delivered at the camp, with a note that simply states: "A gift from your friends!". 
	
		After some debate, you anxiously open the crate to find a large number of steel components. You also find a manual at the top: it's a turret! 
	
		The turret is a next-generation plasma beam turret that send orbs of energy. You are now equipped to handle large waves of zombies. The manual indicates that the turret needs a lot of energy to work. With the current supply of energy you have, you can only shoot once every 2 days. 

		*If only Hans was here..., he would absolutely love to put it together.*
	"""
end

# ╔═╡ aee9374d-fefc-409b-99f0-67de38071f52
md"# Let's fight back..."

# ╔═╡ f7e79c80-1da8-4b95-9447-6107a9e8f2df
md"""
To model the behaviour of our new turret, we can introduce the concept of events into our model. 
ModelingToolkit enables the possibility to define discrete events which affect the values of a state or parameter at a given ``t``. 

In our case, we can define the parameter 💣 to define the efficacy of the turret.

"""

# ╔═╡ 4c4cd287-71d4-4845-b466-3d135610858b
md"## Setup"

# ╔═╡ 806d844d-a02e-4b50-bb51-132513003cbf
begin
	@parameters 💣
end;

# ╔═╡ edd1f38c-60a9-4dee-afe1-c674907a652c
turret_reload_time = 20.0

# ╔═╡ 7f08a0fa-7cec-4a76-81ec-1076243ed670
md"We can define the effect of the turret as removing a portion of the zombie population every $turret_reload_time s"

# ╔═╡ bbe1d37f-2517-4c61-820a-e0ca5876e435
md"""
!!! info "Reload Time" 
	At the moment there is not a way to remake the ODEProblem with a different value for `turret_reload_time` so there is no slider to control this parameter (as recompling the system takes a couple seconds), but you can still change this value and see how it affect the system!
"""

# ╔═╡ 59a77cd5-35de-4e27-9539-43f0d6c791ac
# We use Pre here to indicate that the term indicates the population before the event. 
impulsive_eradication_impulse = [
		turret_reload_time => [🧟 ~ Pre(🧟) - (💣*🧟)]
]

# ╔═╡ 9eecf8d1-9e97-4965-92b8-510646bfe273
md"""
!!! info "Event Handling"
	The impulse is defined such that at every timestep the condition on the right is tested. The test is implicitly defined, as: 
	
	``t == 0 \mod \text{turret\_reload\_time}`` 

	That is, if the current timestep is a multiple of the value supplied. If the condition is true, the right side executes. One can explicilty put a condition such as ``t == 15.0`` for the event to trigger only once.
	For more information, read the SciMl docs on handling discrete events [here](https://docs.sciml.ai/ModelingToolkit/stable/basics/Events/#Discrete-events-support).
"""

# ╔═╡ c841be91-502b-4b30-9af0-ba10e5d71558
begin
	impulsive_eradication_eqs = [
		D(😟) ~ -🦠*😟*🧟 			  		+ 	💊*🤮,
		D(🤮) ~  🦠*😟*🧟 - 🌡️*🤮 	  	- 	💊*🤮, 
		D(🧟) ~ 		   + 🌡️*🤮 +	💀*😵 		 -	⚔️*😟*🧟 ,
		D(😵) ~  	  			 	- 	💀*😵 		 + 	⚔️*😟*🧟,
	]
end;

# ╔═╡ 89a66b68-dfaf-454f-b787-96fabb978e7a
begin
	@named impulsive_eradication_sys = System(
		impulsive_eradication_eqs,
		t,
		[😟,🧟,🤮,😵],
		[⚔️, 🦠, 💀, 💣, 🌡️, 💊];
		
		discrete_events = impulsive_eradication_impulse
	)
end

# ╔═╡ 333e8b9c-0595-4908-9741-ab75d6e6b3b9
md"## Visualization"

# ╔═╡ faa4969c-7c76-48bc-a4f8-9a08d2cd16a0
md"In this new scenario we are now able to survive way longer than before. We could survive for years to come. But even with the cure, we will still lose some people to the zombies, and they can never come back. If only there was a way around this..."

# ╔═╡ 8b7b8608-8d85-4920-a452-b32706adfc17
if(story_mode)
	md"""
	---
	!!! tip "The vaccine has arrived!"
		You did not sleep very well last night, you could hear that all to familar groan all night and could barely shut an eye. The zombies have now been gathering in increasing numbers around the camp. They know that this is one of the last place where human survivors are.
	
		As you painfully try to get out of bed, you hear loud steps approaching your tent. 
		
			Wake up!!! Wake up!!!
		Zara stroms in your tent, a bright smile on her face.
	
			We got it! We finally got it!
		You look at her confused, as you try to make sense of the situation. 
	
			The vaccine! 
			We finally have a chance against these damn zombies! The group sent us a whole 
			crate! 
			They also improved the cure, we can cure zombies now! 
			We can save Hans!!
		The group that developed the cure has managed to develop a vaccine. They extensively tested it and now vaccinated survivors are immune to the deadly bite. 
	
		*Could this be the begining of the end for these zombies?*
		
		
	"""
end

# ╔═╡ 3919e8ab-487d-4a6e-b462-73a9dfbac5e7
md"# The vaccine model "

# ╔═╡ 9148f8b0-e379-43aa-88f5-8c41a2ea62ca
md"""
Let's introduce a vaccine into the model, we can add a new class that will represent how many vaccinated individuals there are. We can also introduce a new parameter 💉 that indicates the vaccination rate. 

We define the new equation such that only the healthy susceptible humans are able to get a vaccine. We'll also upgrade the cure to now be able to cure Zombies and infected in Quarantine.
"""

# ╔═╡ 74955738-33ca-4e6a-bde2-8080b32099c6
md"## Setup"

# ╔═╡ c3e21fa0-ce32-4919-bc18-16616dadcee1
@variables 😊(t)

# ╔═╡ ebad16ee-5c44-4313-9cdf-413ccd4fcfa0
@parameters 💉

# ╔═╡ 8a0b1af6-2df6-4f98-9f3e-0714b19b9b69
begin
	vaccine_model_eqs = [
		D(😟) ~ -💉*😟 - 🦠*😟*🧟   + 💊*🧟 + 💊*😷,
		D(🤮) ~  	  	  🦠*😟*🧟  				  - 🌡️*🤮 		  - 🚑*🤮, 	
		D(😊) ~  💉*😟,
		D(🧟) ~  	-⚔️*😟*🧟         - 💊*🧟  		  +	🌡️*🤮 	  + 💀*😵,
		D(😵) ~  	 ⚔️*😟*🧟  		 	 				 + 🗡️*😷 - 💀*😵, 
		D(😷) ~          		 		 	  - 💊*😷	 - 🗡️*😷      + 🚑*🤮
	]
end;

# ╔═╡ a1c2d060-912b-441c-b986-2bac1a433c49
begin
	@named vaccine_model_sys = System(
		vaccine_model_eqs,
		t,
		[😟,🤮,🧟,😷,😵, 😊],
		[⚔️, 🦠, 💀,💉, 💣, 🌡️, 🚑,🗡️, 💊];
		
		# We reuse the turret impusle for the last model
		discrete_events = impulsive_eradication_impulse
	)
end

# ╔═╡ 711bd169-61c7-4dc4-afc9-8829155d71fe
md"## Visualization"

# ╔═╡ dc1d776f-a7ad-494d-8dc2-b4e28ce623d3


# ╔═╡ d1b89ad6-9116-48b4-805f-f1ba6b15b3dc
md"""
By introducing the vaccine, we were now able to survive the zombie attack: once a human got vaccinated, they cannot be transformed back into a zombie. This allows the vaccination class to grow while the zombies slowly decline in numbers. 

Although if the cure becomes completely inefficient ``💊 =  0`` then any zombies are now trapped in their class and cannot be converted back to suseceptible, which only leaves a fix number of vaccinated and zombies getting slowly destroyed with the turret. In any case, in this scenario there are always humans surviving at the end. Yay!
"""

# ╔═╡ 427d7fd4-af60-4b3b-9d43-3cc6511e281d
if(story_mode)
	md"""
	---
	
	!!! tip "The End"
		Everyone at the camp is now vaccinated. You have started to cure some of the zombies. 
		You decide to go for the yet another trip outside the camp. After stashing twelve syringes of the miraculous cure and a couple of the vaccine, you head to the gate. After making it out the gate, you start walking on the deserted highway that was once crowded with people. 
		*This is the one, I will find him this time*
		You decide to go to the abandoned warehouse, as there always seems to be a new group of zombies around there. As you approach the warehouse, you find a large group of zombies, aimlessly wondering around. You scanned each of them from head to toe. And, finally, you see him. A zombie with a couple of blond hair on his head, and the biggest pair of goggles.

			Hans!! It's me!! 

		Unfortunately, he does not react to his name, but you instinctively know that it is him. You approach and he tries to bite you. 
		*Does not matter, I found him. *
		The cure in one hand, you pull his arm and inject him with it. Tomorrow, he will be back to normal. 
		You rush back to the camp, dragging him by the hand, and announce the great news to Zara. She jumps of joy, and you sense a feeling or relief that you have not seen in her since you arrived here. 

		The next day, you go to the quarantine to check up on Hans. After entering the wrong room twice, you find Hans room. He is awake and shows little symptoms of the virus. As you enter, he turns around. At first looking confused but after a couple seconds, his eyes brighten up and rushes towards you. 

			Thank you so much!! The nurse told me that you found me and gave me the cure! 

		As you share with Hans what has happen to the camp over the last few weeks, Zara appears in the room. 

			Hans!
			I thought I'd never see your little face again.
			
		They share a hug, and you all walk back to the centre of the camp. 

		Over the next months, you manage to cure all the remaining zombies that are still roaming in the city. People have started moving out from the camp, trying to restore what was left of their homes. Although the city has lost many of its inhabitant, it has slowly started to reconstruct itself. 
		
		The humans have survived the apocalypse. 

	"""
end

# ╔═╡ a7819b3e-6929-4d97-8860-b5eeb0c4d39a
md"# Conclusion"

# ╔═╡ 42094ddf-3b6e-496d-9624-30723db25590
md"""
The chances of a zombie apocalypse hitting earth is *almost* zero but if it were to happen, than we know that our only chance to survive them is to kill them quickly and develop a cure and a vaccine when the attack persists. Otherwise, the zombies will take over and we, as humans, don't stand a chance. 
Being able to "destroy" zombies would also be ideal since the ability of zombies to simply come back is the most difficult aspect of surviving.  
"""

# ╔═╡ 63e7170f-a3b4-4403-830c-7351ae309a3d
md"""

!!! info "Analysis, Accuracy, and Complexity"

	The aim of this notebook was to introduce the basics of creating a system of equations and design a model with ModelingToolkit. I glossed over a lot of analysis to keep it simple but if you are interested in a more in depth analysis of this model using the theory of dynamical systems, give the paper that inspired this notebook a read. 
	
	You also might have realized that there are a lot of simplifications made throughout this model. We consider the system to be continuous and we dont take into account spatial interactions. When desiging models, especially biological models, there is a balance between complexity and accuracy. There is an *almost* infinite different ways make the system more acurate, but that requires adding more complexity. In a real life scenario, we would also like to know precise values for the parameters, as you might of see that they can lead to widly different outcomes. This is usually achieved by fitting the model to existing real data and a variety of methods exist on this. Such methods include using stastical analysis such as least-square fit, bayesian inference or even deep learning.


	Can you think of other ways to extend the model?
	Here's a few ideas:
	
	- What if the susceptible have a small chance of destroying zombies when interacting with them?
	- What if the cure does not have a 100% sucess rate?
	- Vacine development takes time, how can you integrate this?
	- What if the turret requires someone to operate? 

This wraps up this notebook! I hope you enjoyed it. :)
"""


# ╔═╡ 14945142-2a86-43dc-ae4d-92a3270ed725
md"# Further Reading

- [When Zombies Attack!: Mathematical Modelling of an outbreak of zombie infection. Munz et al. (2009) ]( https://pdodds.w3.uvm.edu/files/papers/others/2009/munz2009a.pdf) (This paper highly inspired this notebook and the models were taken from the paper, with some slight modifcations. Highly recommend giving it a read!)
- [ModelingToolkit.jl](https://docs.sciml.ai/ModelingToolkit/stable/)
- [Turing.jl](https://turinglang.org/stable/) (Bayesian Inference is very cool!)
- [DiffEqFlux] (https://docs.sciml.ai/DiffEqFlux/stable/) (Deep Learning)
- [SymbolicRegression](https://docs.sciml.ai/SymbolicRegression/stable/) (Find symbolic expression that matches data)
- [DynamicalSystems.jl] (https://juliadynamics.github.io/DynamicalSystemsDocs.jl/dynamicalsystems/dev/)
"

# ╔═╡ fac12d85-045d-4e67-b3e8-d76f9285a297
md"#  "

# ╔═╡ e2ce7fa8-83d6-4fa0-9c42-6148c7884b96
md"# "

# ╔═╡ 6b4feee8-f8bb-4639-a423-97e7ab82cad0
md"# Appendix"

# ╔═╡ 61897e7f-eac1-4eea-a679-4cb53757ee7f
md"# Sliders Setup"

# ╔═╡ 19b3047c-6b4d-4e54-a932-1030a31dd713
@with_kw struct SliderParameter 
	"(REQUIRED) Name of parameter"
	label::String 
	"Lower Bound"
	lb::Float64 = 0.0
	"Upper Bound"
	ub::Float64 = 100.0
	"Slider Step"
	step::Float64 = 1.0
	"Initial Value"
	default::Float64 = lb
	"Text to show next to slider"
	description::String = "" 
	"Symbolic reference"
	alias::Symbol = Symbol(label)
	function SliderParameter(label::String, lb,ub,step,default, description::String, alias::Union{String, Symbol})
		 if ub < lb error("Invalid Bounds") end 
		 return new(label,lb,ub,step,default,description,Symbol(alias))
	end
end

# ╔═╡ 6d79981a-47ac-4434-90e1-81b4c841108e
# Extend show to make a card to display fields of the sliderparameter using html
function Base.show(io::IO, m::MIME"text/html", s::SliderParameter)
    show(io, m, @htl(
        """
        <div style="
					display: flex;
					flex-direction: column;
					gap:.5rem;
					padding: 0.5rem; 
					border-radius: 0.5rem; 
					background: rgb(72 72 72);"
		>
			<div>
			<h6>Slider Parameter</h6>
			</div>
			<div>
        		<b>Label</b>: $(s.label)
			</div>
			<div>
				  <b>alias</b>: $(s.alias)
			</div>
			<div>
				  <b>Lower Bound</b>: $(s.lb)
			</div>
			<div>
				  <b>Upper Bound</b>: $(s.ub)
			</div>
			<div>
				  <b>Step</b>: $(s.step)
			</div>
			<div>
				  <b>Default</b>: $(s.default)
			</div>
			<div>
				  <b>Description</b>: $(s.description)
			</div>
		</div>
		
        """
    ))
end


# ╔═╡ 2462b985-9c4a-446a-b8ea-3d5f6c7543c0
md"## Initial Values"

# ╔═╡ 2a5599e2-77ff-4951-8873-a3bd145b614f
susceptibleInitSlider = SliderParameter(
			lb 		= 1,
			ub 	 	= 1000,
			step 	= 1,
			default = 50,
			label 	= "😟"
		)

# ╔═╡ ca777958-84f4-42ef-95f7-1b0778620e0c
zombieInitSlider = SliderParameter(
			lb 		= 1,
			ub 	 	= 1000,
			step 	= 1,
			default = 10,
			label = "🧟"
		)

# ╔═╡ 0dd7fd47-6575-4b9d-938f-012cff42692d
md"## Parameters"

# ╔═╡ 2c4171e0-8fc6-49d2-ba39-f987b634abda
md"""
 - [tspan](#90673d7c-9ebf-4d31-8f89-7a3e1325c373)
 - [⚔️](#a2fe2c48-bbb1-4601-96b2-470e1768c102)
 - [🦠](#91a92730-965a-44a6-87a9-ba350f6614ca)
 - [💀](#b7213dcc-a2de-4507-a869-7f109d5a52ca)
 - [🌡️](#f21ad23e-dcdd-46fa-b10e-fd115c17eb98)
 - [💣](#7fb8d441-3685-4673-a959-75901d5ad06d)
 - [🚑](#89e74250-9d4b-49cc-9f12-2a4e6d921b90)
 - [🗡️](#8c37e496-4f0b-4151-991a-4bccf66e35f8)
 - [💉](#7df920cf-b634-40c9-913a-bc26732f486e)
 - [💊](#89b55225-e4df-4be3-a34e-e0fe31c1ba0a)
"""

# ╔═╡ 90673d7c-9ebf-4d31-8f89-7a3e1325c373
begin
	tspanSlider = SliderParameter(
		lb 		= 0.0,
		ub 	 	= 1000.0,
		step 	= 10.0,
		default = 250.0,
		alias 	= :duration,
		label = "Duration"
	)
	
	md"""
	**tspan**
	
	This parameter controls how long the system is simulated for. It is used in every model defined in this notebook.
	
	$(tspanSlider)
	"""
end

# ╔═╡ a2fe2c48-bbb1-4601-96b2-470e1768c102
begin

	⚔️ # Ctrl-Click to go to parameter definition!
	
	αSlider = SliderParameter(
		lb 		= 0.0,
		ub 		= 0.8,
		step  	= 0.01,
		default = 0.5,
		label 	= "⚔️",
		description = "Zombie Defeating Rate" 
	)
	
	md"""
	**⚔️**
	
	This parameter controls the rate at which zombies are defeated by the susceptible. When a zombie is defeated, it is moved to the Removed (``R(t)``) class. 
	
	$(αSlider)
	"""
end

# ╔═╡ 91a92730-965a-44a6-87a9-ba350f6614ca
begin
	
	🦠 # Ctrl-Click to go to parameter definition!
	
	βSlider = SliderParameter(
		lb  	= 0.01, 
		ub 		= 1.0, 
		step   	= 0.01, 
		default = 0.25,
		label  	= "🦠",
		description = "Infection Rate"
	)
	
	md"""
	**🦠**
	
	This parameter controls how infectious the Zombies are and at what rate do they transform Susceptibles into Zombies. Depending on the model, when a Susceptible is transformed, it is either moved to the Zombie class or the Infected class.
	
	$(βSlider)
	"""
end

# ╔═╡ b7213dcc-a2de-4507-a869-7f109d5a52ca
begin
	
	💀 # Ctrl-Click to go to parameter definition!
	
	ζSlider = SliderParameter(
		lb 		= 0.01,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.05, 
		label 	= "💀",
		description = "Back from the dead Rate"
	)
	
	md"""
	**💀**
	
	This parameter controls how effective the Zombies (``Z(t)``) are at coming back from the dead. In each model, a small section of the Removed (``R(t)``) class is moved to the Zombie class.  
	
	$(ζSlider)
	"""
end

# ╔═╡ 671ad109-4bea-426f-b5c2-2dcabb53a7be
simple_attack_params =  [
	😟 	=> 50.0,  
	🧟 	=> 10.0,  
	😵 	=> 0, 				    # we will always start with 0 removed 	 
	⚔️ 	=> αSlider.default,  	
	🦠 	=> βSlider.default, 	 
	💀  => ζSlider.default, 	 
]

# ╔═╡ f21ad23e-dcdd-46fa-b10e-fd115c17eb98
begin 

	🌡️ # Ctrl-Click to go to parameter definition!
	
	ρSlider = SliderParameter(
		lb 		= 0.05,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.4,
		label 	= "🌡️",
		description = "Zombie Transformation Rate"
	)
	
	md"""
	**🌡️**
	
	In the more complex model, this parameter controls the rate at which a Infected (``I(t)``) is transformed into a Zombie (``Z(t)``). 
	
	$(ρSlider)
	"""
end

# ╔═╡ 68c6f9c8-2e76-4b08-8b9b-f18b13a4a50b
begin	
	lattent_infection_params =  [
		😟=> 50.0, 
	 	🧟 => 10.0, 
	 	🤮 => 0, 					  
		😵 => 0, 					  
		⚔️ => αSlider.default,  
		🦠 => βSlider.default,   
		💀 => ζSlider.default,  
		🌡️ => ρSlider.default,   
	]
end

# ╔═╡ 7fb8d441-3685-4673-a959-75901d5ad06d
begin

	💣 # Ctrl-Click to go to parameter definition!
	
	kSlider = SliderParameter(
		lb 		= 0.0,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.05,
		label 	= "💣",
		description = "Turret Effectiveness"
	)
	
	md"""
	**💣**
	
	This parameter controls the effectivness of the turret, killing and removing zombies for the systems. In the models implementing discrete events, it act by scaling down the zombie population via ``Z(t) = Z(t) - kZ(t)``.
	
	$(kSlider)
	"""
	
end

# ╔═╡ 89e74250-9d4b-49cc-9f12-2a4e6d921b90
begin
	
	🚑 # Ctrl-Click to go to parameter definition!
	
	κSlider = SliderParameter(
		lb 		= 0.05,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.05,
		label 	= "🚑",
		description = "Infected into Quarantine rate"
	)
	
	md"""
	**🚑**

	This parameter controls the rate at which infected are transfered to the quarantine. 

	$(κSlider)
	"""
end

# ╔═╡ 8c37e496-4f0b-4151-991a-4bccf66e35f8
begin

	🗡️ # Ctrl-Click to go to parameter definition!

	
	γSlider = SliderParameter(
		lb 		= 0.5,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.05,
		label 	= "🗡️",
		description = "Tried to escape Quarantine rate"
	)

	md"""
	**🗡️**

	This parameter establishes the chance of a "new" Zombie trying to escape the quarantine. In the models implementing the quaranting, the escapee is then killed and moved to the Removed class.

	$(γSlider)
	"""
end

# ╔═╡ 2847c8b9-0ac8-4b90-a23b-6323414b3d1b
begin	
	simple_quarantine_params =  [
		😟 => 50.0,  
	 	🧟=> 10.0,  
	 	🤮 => 0, 					   
		😵 => 0, 					   
		😷 => 0, 					   
		⚔️ 	=> αSlider.default,
		🦠 	=> βSlider.default,
		💀  => ζSlider.default,
		🌡️  => ρSlider.default,
		🚑 	=> κSlider.default,
		🗡️  => γSlider.default,
	]
end

# ╔═╡ 7df920cf-b634-40c9-913a-bc26732f486e
begin

	💉 # Ctrl-Click to go to parameter definition!
	
	νSlider =  SliderParameter(
		lb 		= 0.0,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.8,
		label 	= "💉",
		description = "Vaccination Rate"
	)

	md"""
	**💉**

	This parameter controls the rate of vaccination, that is how many susceptible are moved to the Vaccinated class.

	$(νSlider)
	"""
end

# ╔═╡ 89b55225-e4df-4be3-a34e-e0fe31c1ba0a
begin
	💊 # Ctrl-Click to go to parameter definition!
	
	cSlider = SliderParameter(
		lb 		= 0.0,
		ub 		= 1.0,
		step 	= 0.01,
		default = 0.5,
		label 	= "💊",
		description = "Curation Rate" 
	)
	
	md"""
	**💊**
	
	This parameter controls the rate at which individuals are able to be cured and placed back in the susceptible class. 

	$(cSlider)
	"""
end

# ╔═╡ e5fc55c6-c292-494d-9a56-9506eb95c80d
begin	
	treatment_model_params =  [
		😟 => 50.0, 
	 	🧟 => 10.0, 
	 	🤮 => 0, 				
		😵 => 0, 				
		⚔️  => αSlider.default, 
		🦠 => βSlider.default, 
		💀 => ζSlider.default, 
		🌡️ => ρSlider.default, 
		💊 => cSlider.default, 
		
	]
end

# ╔═╡ 1e457fe1-6cc5-4d2e-812e-13f666747d81
begin	
	impulsive_eradication_params =  [
		😟 => 50.0, 
	 	🧟 => 10.0, 
		🤮 => 0,
		😵 => 0, 			
		⚔️  => αSlider.default, 
		🦠 => βSlider.default, 
		💀 => ζSlider.default, 
		🌡️ => βSlider.default,  
		💣 => kSlider.default, 
		💊 => cSlider.default, 
		
	]
end;

# ╔═╡ 80aeb76f-4ab2-468f-95ef-f36491f4642e
begin	
	vaccine_model_params =  [
		😟 => 50.0, 
	 	🧟 => 10.0, 
		😊 => 0,
		😷 => 0,
		🤮 => 0,
		😵 => 0,
		⚔️ => αSlider.default, 
		🦠 => βSlider.default, 
		💀 => ζSlider.default, 
		🌡️ => βSlider.default, 
		🚑 => κSlider.default,
		🗡️ => γSlider.default,
		💉 => νSlider.default,
		💣 => kSlider.default, 
		💊 => cSlider.default, 
		
	]
end;

# ╔═╡ aa1fb294-a0d2-41b0-8237-3590d16d0573
md"# Utils"

# ╔═╡ f440930e-c68f-40ee-8d1b-cc510400e872
md"## Interactivity extensions"

# ╔═╡ 5fa09f27-7cea-44db-80f9-0eda7f483860
md"""

- [solutionAnalytics](#230a4e8a-6eb7-4b0a-84a7-c86019060062)
- [plotZombieModelEvolution](#daf4dd3e-9427-4baa-836e-e1d524c0a170)
- [systemDiffTable](#66de57a4-18db-41fc-ba0f-8b889c4c4e66)


- [format_sliderParameter](#2c33a46c-6024-4a55-a7a5-5b7838cd4c9d)
- [collapsiblePanel](#af04b82f-fb35-4eda-a941-34d9f798b035)
- [sideBarWrapper](#4da94e9b-f009-48e5-b9ac-cae6e4d7495e)
- [sideBarPanelsWithCollapsible](#411354b2-f9b7-46cc-9fe2-358f2d691dfe)


- [CSS - Slider](#24c846f3-3c61-4f9b-b243-d303451bcfdf)
- [CSS - Collapsible](#53b2a3e8-c8a9-4dae-92df-f3b9af112fda)
- [CSS - SideBar](#6f38c085-ffaf-4df5-9d83-217dc045d615)

"""


# ╔═╡ 5300382d-e093-4e13-ba61-ab3dd3337f3f
md"---"

# ╔═╡ 6cd0ec91-dc46-48e1-ab69-425780b03a16
# """
#     format_sliderParameter(sliderParams::Vector{SliderParameter}; title::String = "")

# Create a formatted HTML slider with labels and descriptions from a vector of `SliderParameter` objects.

# # Arguments
# - `sliderParams::Vector{SliderParameter}`: A vector of `SliderParameter` objects. 
# - `title::String=""`: An optional title for the slider container. If not provided, no title will be displayed.

# # Returns
# - A Pluto Bond containing the slider container, with each slider, its label, and description. To access the value generated by the slider, use the @bind macro from PlutoUI.

# # Example

# ```julia
# > sliderParams = [SliderParameter(label="Slider1", alias=:s1, lb=0, ub=10, step=1, ? 
# > default=5, description="This is Slider 1"),
#                 SliderParameter(label="Slider2", alias=:s2, lb=0, ub=100, step=10, default=50, description="This is Slider 2")]
# > @bind params format_sliderParameter(sliderParams, title="My Sliders")
# > params
# (s1 = 5.0, s2 = 50.0)
# ```
# """
function format_sliderParameter(sliderParams;title::String = "")

	return combine() do Child
		mds = []
		for sliderParam in sliderParams
		push!(mds,
			@htl("""
			<div class="slider-container-content">
				<div class="slider-container-content-inner"> 
					<div class="label-chip"> 
						<h4>$(sliderParam.label)</h4>
					</div>
					<div>
						$(Child(
							sliderParam.alias, 
							PlutoUI.Slider(
								sliderParam.lb:sliderParam.step:sliderParam.ub,
								default = sliderParam.default, 
								show_value = true)
							)
						) 
					</div>
				</div>
			
				<div class="slider-container-content-inner"> 
					<p>$(sliderParam.description)
				</div>
			</div>
			
			"""))
		end
		if(title == "") 
			titleDiv = @htl("<div></div>") 
		else
			titleDiv = @htl("""
				<div class="slider-container-title">
					<h4>
					$title
					</h4>
				</div>"""
			)
		end
		
		@htl("""
		
		<div class="slider-container">
			
			$titleDiv
			
			<div class="slider-container-content-wrapper">
				$(mds)
			</div>
		</div>
		""")
	end
end

# ╔═╡ 49f7ca3c-4b9d-4145-9faa-70d082a5c8d9
begin
	
	# These are the main sliders definition for defining the system definition
	
	simple_attack_u0s_sliders = @bind simple_attack_u0s format_sliderParameter(
		title = "Initial Values",
		[
			susceptibleInitSlider,
			zombieInitSlider,
		],
	)
	simple_attack_ps_sliders = @bind simple_attack_ps format_sliderParameter(
		title = "Model Parameters",
		[
			αSlider,
			βSlider,
			ζSlider
		],
	)
	simple_attack_tspan_sliders = @bind simple_attack_tspan format_sliderParameter(
		[
			tspanSlider
		],
	)
	
end;

# ╔═╡ 3bd175bd-0019-40bc-a1f7-9f94e94ddb87
begin
	# Remember to call mtkcompile before creating a ODEProblem!
	simple_attack_prob = ODEProblem(
		mtkcompile(simple_attack_sys),
		simple_attack_params, 
		(0.0, simple_attack_tspan.duration)
	)
end

# ╔═╡ 7551684a-04cd-4d6d-bb9e-b7f4aa46aceb
begin

	# These sliders are for dealing with interactivity of the plots
		
	simple_attack_plots_params_sliders = @bind simple_attack_plots_params format_sliderParameter(
		[
			SliderParameter(
				lb 		= 0.0,
				ub 	 	= simple_attack_tspan.duration,
				step 	= 10.0,
				default = 0.0,
				alias 	= :ts,
				label = "Starting time"
			),
			SliderParameter(
				lb 		= 0.0,
				ub 	 	= simple_attack_tspan.duration,
				step 	= 10.0,
				default = simple_attack_tspan.duration,
				alias 	= :te,
				label = "End time"
			)
		],
	);
		

end;

# ╔═╡ e5deaa27-54cb-4f48-8f56-b55c3a797dcf
begin
	lattent_infection_u0s_sliders = @bind lattent_infection_u0s format_sliderParameter([
		susceptibleInitSlider,
		zombieInitSlider
		],
		title = "Initial Values",
	);
	
	lattent_infection_ps_sliders = @bind lattent_infection_ps format_sliderParameter([
			αSlider,
			βSlider,
			ζSlider,
			ρSlider,
		],
		title = "Model Parameters",
	);
	
	lattent_infection_tspan_sliders = @bind lattent_infection_tspan format_sliderParameter([
			tspanSlider
		]
	);
end;

# ╔═╡ d04d419b-2fc0-4b3a-bb78-ea3b6b76bc64
begin
	lattent_infection_prob = ODEProblem(
		mtkcompile(lattent_infection_sys), 
		lattent_infection_params, 
		(0.0, lattent_infection_tspan.duration)
	)			
end

# ╔═╡ d59c9761-382e-4450-b654-dc4b8b203f15
lattent_infection_plots_params_sliders = @bind lattent_infection_plots_params format_sliderParameter([
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= lattent_infection_tspan.duration,
			step 	= 10.0,
			default = 0.0,
			alias 	= :ts,
			label = "Starting time (Plot)"
		),
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= lattent_infection_tspan.duration,
			step 	= 10.0,
			default = 1000.0,
			alias 	= :te,
			label = "End time (Plot)"
		),
	]
);

# ╔═╡ 7d8c6ed0-f70c-42ae-9f89-1eb5a4a1447b
simple_quarantine_u0s_sliders = @bind simple_quarantine_u0s format_sliderParameter(
		title = "Initial Values",
		[
			susceptibleInitSlider,
			zombieInitSlider
		],
	);

# ╔═╡ 94b4f52b-ae28-4e26-93d2-7e7d32c739d5
simple_quarantine_ps_sliders = @bind simple_quarantine_ps format_sliderParameter(
		title = "Model Parameters",
		[
			αSlider,
			βSlider,
			ζSlider,
			ρSlider,
			κSlider,
			γSlider
		],
	);

# ╔═╡ f13c3c52-7c73-4aa3-a233-3d64f4623b89
simple_quarantine_tspan_sliders = @bind simple_quarantine_tspan format_sliderParameter(
		[
			tspanSlider
		],
	);

# ╔═╡ d60f5b1d-132d-4d76-8060-d6365b95e923
begin
	simple_quarantine_prob = ODEProblem(
		mtkcompile(simple_quarantine_sys), 
		simple_quarantine_params, 
		(0.0, simple_quarantine_tspan.duration)
	)			
	simple_quarantine_prob
end

# ╔═╡ 97564904-a6ce-497b-9bbc-e978c6877f0c
begin
	simple_quarantine_plots_params_sliders = @bind simple_quarantine_plots_params format_sliderParameter([
			SliderParameter(
				lb 		= 0.0,
				ub 	 	= simple_quarantine_tspan.duration,
				step 	= 10.0,
				default = 0.0,
				alias 	= :ts,
				label = "Starting time"
			),
			SliderParameter(
				lb 		= 0.0,
				ub 	 	= simple_quarantine_tspan.duration,
				step 	= 10.0,
				default = simple_quarantine_tspan.duration,
				alias 	= :te,
				label = "End time"
			),
		]
	);
end;

# ╔═╡ 00b880d1-3db4-40a6-aff4-03a4900df99d
treatment_model_u0s_sliders = @bind treatment_model_u0s format_sliderParameter([
		susceptibleInitSlider,
		zombieInitSlider
	],
	title = "Initial Values",
);

# ╔═╡ d5c896f3-1aa8-4334-8c7c-7b01b122aa1b
treatment_model_ps_sliders = @bind treatment_model_ps format_sliderParameter(
		title = "Model Parameters",
		[
			αSlider
			βSlider
			ζSlider
			ρSlider
			cSlider	
		],
	);

# ╔═╡ 53c4ef85-6f0c-46d8-a08a-28f8ab368309
treatment_model_tspan_sliders = @bind treatment_model_tspan format_sliderParameter(
		[
			tspanSlider
		],
	);

# ╔═╡ 7b660a3d-3fe3-4d48-be37-49754fa70b16
begin
	treatment_model_prob = ODEProblem(
		mtkcompile(treatment_model_sys), 
		treatment_model_params, 
		(0.0, treatment_model_tspan.duration)
	)			
	
end

# ╔═╡ 22d85cbc-0e8f-49c9-9045-3b56d2a3c2f0
treatment_model_plots_params_sliders = @bind treatment_model_plots_params format_sliderParameter([
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= treatment_model_tspan.duration,
			step 	= 10.0,
			default = 0.0,
			alias 	= :ts,
			label = "Starting time (Plot)"
		),
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= treatment_model_tspan.duration,
			step 	= 10.0,
			default = treatment_model_tspan.duration,
			alias 	= :te,
			label = "End time (Plot)"
		),
	]
);

# ╔═╡ 028b2237-e62a-403b-8d6c-786accb8c782
impulsive_eradication_u0s_sliders = @bind impulsive_eradication_u0s format_sliderParameter(
	title = "Initial Values",
	[
		susceptibleInitSlider,
		zombieInitSlider
	],
);

# ╔═╡ 4e947fbc-84f4-460d-9079-0e7397f5d05f
begin
	impulsive_eradication_ps_sliders = @bind impulsive_eradication_ps format_sliderParameter(
		title = "Model Parameters",
		[
			αSlider, 
			βSlider,
			ζSlider,
			ρSlider,
			cSlider,
			kSlider,
			
		],
	);
	impulsive_eradication_tspan_sliders = @bind impulsive_eradication_tspan format_sliderParameter([
			tspanSlider
		],
		title = "",
	);
end; 

# ╔═╡ 2cfac784-ec48-4963-a12d-d8bac6ae41cc
begin
	impulsive_eradication_prob = ODEProblem(
		mtkcompile(impulsive_eradication_sys), 
		impulsive_eradication_params, 
		(0.0, impulsive_eradication_tspan.duration)
	)			
end

# ╔═╡ 5efa346c-4d46-4c5c-9e14-08015a96bd85
impulsive_eradication_plots_params_sliders = @bind impulsive_eradication_plots_params format_sliderParameter([
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= impulsive_eradication_tspan.duration,
			step 	= 10.0,
			default = 0.0,
			alias 	= :ts,
			label 	= "Start",
			description = "Starting time (Plot)"
		),
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= impulsive_eradication_tspan.duration,
			step 	= 10.0,
			default = 1000.0,
			alias 	= :te,
			label   = "End", 
			description = "End time (Plot)"
		),
	]
);

# ╔═╡ e5a804cc-0cbe-4645-974b-0fca7cb366e0
vaccine_model_u0s_sliders = @bind vaccine_model_u0s format_sliderParameter(
	title = "Initial Values",
	[
		susceptibleInitSlider,
		zombieInitSlider
	],
);

# ╔═╡ c3ba93bf-710b-4ccf-8800-c34af7b61a42
begin
	vaccine_model_ps_sliders = @bind vaccine_model_ps format_sliderParameter(
		title = "Model Parameters",
		[
			αSlider, 
			βSlider,
			νSlider,
			cSlider,
			ζSlider,
			ρSlider,
			κSlider,
			γSlider,
			kSlider,
			
		],
	);
	vaccine_model_tspan_sliders = @bind vaccine_model_tspan format_sliderParameter([
			tspanSlider
		]
	);
end; 

# ╔═╡ 3eb51a7d-3a7e-4d5b-a635-71a4962dd2d9
begin
	vaccine_model_prob = ODEProblem(
		mtkcompile(vaccine_model_sys), 
		vaccine_model_params, 
		(0.0, vaccine_model_tspan.duration)
	)			
end

# ╔═╡ 12d39fca-5e5c-4b01-8080-7099c151e5ec
vaccine_model_plots_params_sliders = @bind vaccine_model_plots_params format_sliderParameter([
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= vaccine_model_tspan.duration,
			step 	= 10.0,
			default = 0.0,
			alias 	= :ts,
			label = "Starting time (Plot)"
		),
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= vaccine_model_tspan.duration,
			step 	= 10.0,
			default = 1000.0,
			alias 	= :te,
			label = "End time (Plot)"
		),
	]
);

# ╔═╡ 925feb4c-6f29-4dff-8e9e-f5032b47ac22
# """
#     isSymbolicInArray(sym, arr)

# Check if a given symbolic object `sym` is in the array `arr`.

# # Arguments
# - `sym`: A symbolic variable as defined in ModelingTooolkit( or Symbolics) to check.
# - `arr`: The array of symbolic variables to to check in.

# # Returns
# - `Bool`: Returns `true` if `sym` is not in `arr`, and `false` otherwise.

# # Examples
# ```julia

# > @variables a, b, c

# > @variables d, e

# > arr = [a, b, e]
# > isSymbolicInArray(a, arr) 
# true
# > isSymbolicInArray(c, arr) 
# false
# ```
# """
function isSymbolicInArray(sym, arr)
	isequal(setdiff(arr, [sym]), arr)
end

# ╔═╡ 72977094-d304-4c01-86e2-d9ef5742dea3


# ╔═╡ 1c31fe3f-2b18-4c4d-a1b1-3304c3d779d7


# ╔═╡ ceb98ac3-7a3d-4dbe-a5df-8183878afb1f


# ╔═╡ 24c846f3-3c61-4f9b-b243-d303451bcfdf
# """
# 	loadSliderCSS()

# Helper function to generate the CSS needed for styling the sliders.
# Generates the following classes:
#  - slider-container
#  - slider-container-title
#  - slider-container-content-wrapper
#  - slider-container-content 
#  - slider-container-content-inner
#  - label-chip
# """
function loadSliderCSS()
	slider_containerCSS = Dict(
			:min_width 		=> "27rem",
			:border_radius 	=> "1rem",
			:gap 			=> "0.5rem",
			:width 			=> "100%",
			:background 	=> "rgba(0, 105, 255)"
	)
	
	slider_container_titleCSS = Dict(
			:display 		=> "block",
			:text_align 	=> "center",
			:padding 		=> "1rem",
			:color 			=> "#ddd",
			:background 	=> "#0069ff",
			:border_radius 	=> "7px",
			:transition 	=> "all 0.25s ease-out",
	)
	
	slider_container_content_wrapperCSS = Dict(	
			:background 	=> "rgb(32 41 120)",
			:display 		=> "flex",
			:flex_direction => "column",
			:padding 		=> "0.5rem",
			:gap 			=> "0.25rem",
	)
	
	slider_container_contentCSS = Dict(
			:min_width 		=> "30rem",
			:display 		=> "flex",
			:flex_direction => "column",
			:padding 		=> "0.5rem",
			:gap 			=> "0.5rem"
	)
		
	slider_container_content_innerCSS = Dict(
			:display 		=> "flex",
			:align_items 	=> "center",
			:gap 			=> "1.5rem"
	)
	
	label_chipCSS = Dict(
		:border_radius => "1.5rem",
	    :background => "rgb(36 77 88)",
	    :padding => "0 0.5rem 0 0.5rem"
	)	
		
	
return @htl("""
	<style>
		.slider-container{
			$slider_containerCSS
		}
		.slider-container-title{
			$slider_container_titleCSS
		}		
		.slider-container-content-wrapper{
			$slider_container_content_wrapperCSS
		}
		.slider-container-content{
			$slider_container_contentCSS
		}
		.slider-container-content-inner{
			$slider_container_content_innerCSS
		}
		.label-chip {
			$label_chipCSS
		}
	</style>
	"""
	)
end


# ╔═╡ 53b2a3e8-c8a9-4dae-92df-f3b9af112fda
# """
# 	loadCollapsibleCSS()

# Helper function to generate the CSS needed for styling the sliders.

# Generates the following classes:
# - collpasible-content
# - toggle:checked
# - toggle-label:hover
# - toggle-label::before

# Also controls how big the collapsible panel should be via "max-height". To change this, change the value of "max-height" in `extendedPanelHeightCSS`.

# """
function loadCollapsibleCSS()
	collapsibleContentCSS = Dict(
		:max_height => "0px",
		:overflow => "hidden",
		:transition => "max-height 0.25s ease-in-out",	
	)

	toggleLabelCSS = Dict(
		  :display => "block",
		  :font_weight => "bold",
		  :font_family => "monospace",
		  :font_size => "1.2rem",
		  :text_align => "center",
		  :padding => "1rem",
		  :color => "#ddd",
		  :background => "#0069ff",
		  :cursor => "pointer",
		  :border_radius => "7px",
		  :transition => "all 0.25s ease-out"
	)

	toggleLabelHoverCSS = Dict(
		:color => "#fff"
	)

	toggleLabel_beforeCSS = Dict(
		:content => "' '",
		:display => "inline-block",
		:border_top => "5px solid transparent",
		:border_bottom => "5px solid transparent",
		:border_left => "5px solid currentColor",
		:vertical_align => "middle",
		:margin_right => "0.7rem",
		:transform => "translateY(-2px)",
		:transition => "transform 0.2s ease-out"
	)

	extendedPanelHeightCSS = Dict(
		:max_height => "100rem";
	)

	@htl("""
		<style>
			.collapsible-content {
			  $collapsibleContentCSS
			}
	
			.toggle-label {
				$toggleLabelCSS
			}
	
			.toggle-label:hover {
				$toggleLabelHoverCSS
			}
			.toggle-label::before {
				$toggleLabel_beforeCSS
			}
			
			.toggle:checked + .toggle-label + .collapsible-content {
			  $extendedPanelHeightCSS 
			}
	
			.toggle:checked + .toggle-label::before {
				transform: rotate(90deg) translateX(-3px);
			}
	
			.toggle:checked + .toggle-label {
			  border-bottom-right-radius: 0;
			  border-bottom-left-radius: 0;
			}
		</style>
	""")
end

# ╔═╡ af04b82f-fb35-4eda-a941-34d9f798b035
# """
#     collapsiblePanel(child; title::String=nothing)

# Create a collapsible panel with a unique id.

# # Arguments
# - `child`: The content to be displayed when the panel is expanded.
# - `title::String=nothing`: The title of the collapsible panel. If not provided, no title will be displayed.

# # Returns
# - A HTML node that represents a collapsible panel.

# """
function collapsiblePanel(child; title::String=nothing)
	
	# generate unique id for panel collapse
	toggleId = join(rand(["a","b","c","d"],20))

	
	return @htl("""
		<div class="wrap-collabsible">
			<input 
				id="$(toggleId)" 
				class="toggle"  
				style="display: none" 
				type="checkbox" 
				checked="" 
			/>
			<label for="$(toggleId)" class="toggle-label">
				$title
			</label>
			<div class="collapsible-content">
					$child
			</div>
		</div>
	""")
end

# ╔═╡ 6f38c085-ffaf-4df5-9d83-217dc045d615
# """
# 	loadSideBarCSS()

# Helper function to generate the CSS needed for styling the sliders.
# Generate the following classes:
# - side-bar

# """
function loadSideBarCSS()
	sideBarCSS = Dict(
		:display => "flex",
		:top => "100%",
		:position => "absolute",
		:min_width => "0",
		:max_width => "17rem",
		:z_index => "35",
	)
	
	@htl("""
		<style>
			.side-bar{
				$sideBarCSS
			}
		</style>
	""")
end

# ╔═╡ 4da94e9b-f009-48e5-b9ac-cae6e4d7495e
# """
#     sideBarWrapper(child; location=:right)

# Create a sidebar wrapper for a given HTML child.

# # Arguments
# - `child`: The HTML node to be wrapped.
# - `location` (optional): The location of the sidebar. Default is `:right`. 
  
# # Returns
# - A HTML node that wraps the provided div in a sidebar.

# """
function sideBarWrapper(child; location=:right)

	# swap left-right cos css is weird
	location = (location == :left ) ? :right : :left
	
	return @htl("""
	<div class="on-small-show">
		<div class="side-bar" style="$location: 105%"> 
			$child
		</div>
	</div>
	<div class="on-tiny-show">
		<div style="display: flex"> 
			$child
		</div>
	</div>
	""")
end

# ╔═╡ 66de57a4-18db-41fc-ba0f-8b889c4c4e66
# """
#     systemDiffTable(systems::Vector{ODESystem}; headers::Union{Vector{String},Nothing}=nothing)

# Generate an HTML table that shows the differences between multiple ODE systems.

# # Arguments
# - `systems::Vector{ODESystem}`: A vector of ODE systems to compare.
# - `headers::Union{Vector{String},Nothing}= nothing`: An optional vector of strings to use as headers for the table. If not provided, the names of the systems will be used. The number of headers must match the number of systems.

# # Returns
# - An HTML string wrapped in a sidebar, which represents a table. The table has a row for each parameter and state in the systems. Each column represents a system. A checkmark ("✓") in a cell indicates that the corresponding parameter or state is present in the corresponding system.

# # Throws
# - `DimensionMismatch`: If the number of headers provided does not match the number of systems.

# # Example
# ```julia
# > system1 = ODESystem(...)
# > system2 = ODESystem(...)
# > systemDiffTable([system1, system2], headers=["System 1", "System 2"])
# ```
# """
function systemDiffTable(
	systems::Vector{System}; 
	headers::Union{Vector{String},Nothing}= nothing
)

	# if(!isnothing(headers) && length(systems) !== length(headers)) 		
	# 	throw(DimensionMismatch("Number of headers must match the number of systems.")) 
	# end
	
	
    paramsList = parameters.(systems)
    statesList = get_unknowns.(systems)

    all_params = union(paramsList...)
    all_states = union(statesList...)

	headers = isnothing(headers) ? getproperty.(systems, :name) : headers
	headersHTML = []
	for header in headers
		push!(headersHTML, @htl("
			<th>
				$(header)
			</th>"
		))
	end

	
	paramsRowsHTML = []
	for p in all_params
		innerparamsRowsHTML = []
		
		push!(innerparamsRowsHTML, @htl("""<td>$p</td>"""))
		
		for (index) in 1:length(systems)
		is_param_in_sys = isSymbolicInArray(p, paramsList[index])
		cell_color_style = is_param_in_sys ? "background-color: black" : "background-color: green" 
		push!(innerparamsRowsHTML, @htl("""
			<td style="$cell_color_style"> 					
				$(is_param_in_sys ? "" : "✓" )
			</td> 
		"""))
			
		end
		final_row = @htl """
			<tr>
				$innerparamsRowsHTML
			</tr>
		"""
		push!(paramsRowsHTML, final_row)
	end

	statesRowsHTML = []
	for s in all_states
		innerstateRowsHTML = []
		push!(innerstateRowsHTML, @htl("""<td>$s</td>"""))
		
		for (index) in 1:length(systems)

		is_state_in_sys = isSymbolicInArray(s, statesList[index])
		cell_color_style = is_state_in_sys ? "background-color: black" : "background-color: green" 
			
		push!(innerstateRowsHTML, @htl("""
								   
			<td style="$cell_color_style">
				$(is_state_in_sys ? "" : "✓" )
			</td> 
		"""))
			
		end
		final_row = @htl """
			<tr>
				$innerstateRowsHTML
			</tr>
		"""
		push!(statesRowsHTML, final_row)
	end


    diffTable = @htl """
		<table>
			<tr>
				<th>
	
				</th>
				$(headersHTML)
	
			</tr>
			
	
			<tr>
				<th>
					States
				</th>
			</tr>
	
			$(statesRowsHTML)

			<tr>
				<th>
					Parameter
				</th>
	
			</tr>
			<tr>
			$(paramsRowsHTML)
			</tr>
			
	
		</table>
	"""

	return sideBarWrapper(
		@htl("""	

			<div>
		
				$diffTable
			</div>
			
		"""
		)
	)
end


# ╔═╡ 1a6574d3-a3d3-4b77-a481-8f0dfad1628a
systemDiffTable([simple_attack_sys, lattent_infection_sys], headers=["Simple", "Lattent Infection"])

# ╔═╡ a0f73d60-1f65-4b1d-9f13-e4f3ba842ca6
systemDiffTable([simple_attack_sys, lattent_infection_sys, simple_quarantine_sys], headers=["Simple", "Lattent Infection", "Quarantine"])

# ╔═╡ 68a8c259-1388-476d-be13-cd4e0f9eecd1
systemDiffTable([lattent_infection_sys, simple_quarantine_sys,treatment_model_sys], headers=["Lattent Infection", "Quarantine","Treatment"])

# ╔═╡ bec60bab-cce9-44a3-980e-6b9a5bad3b0a
systemDiffTable([simple_quarantine_sys,treatment_model_sys,impulsive_eradication_sys], headers=["Quarantine", "Treatment","Impulse Eradication"])

# ╔═╡ e28d682e-f392-4e58-8917-b47b6423c7e4
# ╠═╡ skip_as_script = true
#=╠═╡
systemDiffTable([simple_quarantine_sys, impulsive_eradication_sys, vaccine_model_sys], headers=["Quarantine","Impulse Eradication", "Vaccine"])
  ╠═╡ =#

# ╔═╡ 411354b2-f9b7-46cc-9fe2-358f2d691dfe
# """
#     sideBarPanelsWithCollapsible(main, extra; location=:right, collapsibleTitle="Extra Parameters")

# Create a sidebar with two panels. The second panel is collapsible.

# # Arguments
# - `main`: The main content to be displayed in the sidebar.
# - `extra`: The extra content to be displayed in the collapsible panel.
# - `location` (optional, default=:right): The location of the sidebar. It can be either `:right` or `:left`.
# - `collapsibleTitle` (optional, default="Extra Parameters"): The title of the collapsible panel.

# # Returns
# - A sidebar with the main content and an extra collapsible panel.

# # Examples 

# ```julia
# > main = html"<p>Main content"
# > extra = html"<p>Extra content"
# > sideBarPanelsWithCollapsible(main, extra)
# ```
# """
function sideBarPanelsWithCollapsible(main, extra; location=:right, collapsibleTitle="Extra Parameters")
	
	return sideBarWrapper(
		@htl(
			"""
			<div>
			
				$main
				$(collapsiblePanel(extra; title=collapsibleTitle))
				
			</div>
			"""
		); location
	)
end

# ╔═╡ 122b4bc2-24df-423c-904b-158cc0790abe
sideBarPanelsWithCollapsible(
		[
			simple_attack_ps_sliders,
			simple_attack_u0s_sliders],
		[
			simple_attack_tspan_sliders,
			simple_attack_plots_params_sliders
		]
	)

# ╔═╡ 572dff66-18d8-4b0f-be6e-75767ac33be0
sideBarPanelsWithCollapsible(
	[
		lattent_infection_ps_sliders,
		lattent_infection_u0s_sliders
	],
	[
		lattent_infection_tspan_sliders,
		lattent_infection_plots_params_sliders
	])

# ╔═╡ 33ba58f3-9959-48ec-a7f0-098b864ba02f
sideBarPanelsWithCollapsible(
	[
		simple_quarantine_ps_sliders,
		simple_quarantine_u0s_sliders
	],
	[
		simple_quarantine_tspan_sliders,
		simple_quarantine_plots_params_sliders
	]
)

# ╔═╡ ab916a56-52ff-4f35-b8ba-72f2d3d7ba9a
sideBarPanelsWithCollapsible(
	[
		treatment_model_ps_sliders,
		treatment_model_u0s_sliders
	],
	[
		treatment_model_tspan_sliders,
		treatment_model_plots_params_sliders
	]
)

# ╔═╡ 63c5fab1-fb11-4d9a-b2fc-8a23598602ba
sideBarPanelsWithCollapsible(
	[
		impulsive_eradication_ps_sliders,
		impulsive_eradication_u0s_sliders
	],
	[
		impulsive_eradication_tspan_sliders, impulsive_eradication_plots_params_sliders
	]
)

# ╔═╡ 70de0532-94df-4466-acc4-7a8157bd0262
sideBarPanelsWithCollapsible(
	[
		vaccine_model_ps_sliders,
		vaccine_model_u0s_sliders
	],
	[
		vaccine_model_tspan_sliders, 
		vaccine_model_plots_params_sliders
	]
)

# ╔═╡ 491f715e-048f-4bc4-b62b-9d9f622d835b
md"## Plotting / Analytics "

# ╔═╡ 230a4e8a-6eb7-4b0a-84a7-c86019060062
# """
#     solutionAnalytics(sol::ODESolution)

# This function generates an analytics card for a ODE solution of a Zombie Model. The analytics card displays the number of days survived and the day when everyone becomes a zombie.

# # Arguments
# - `sol::ODESolution`: An object of type ODESolution. This object should contain the solution to an ODE system with variables 
# - Survivor variable: Default `😟(t)` 
# - Zombie varaible: Default `🧟(t)`.

# # Returns
# - A HTML node that represents an analytics card. The card contains the number of days survived and the day when everyone becomes a zombie.

# """
function solutionAnalytics(sol::ODESolution; survivor=😟, zombie=🧟)

	totalPop =  sum(sol.prob.u0) 
	daysAllZombiesIndex = findfirst( x-> x >= totalPop-0.01*totalPop, collect(sol[zombie]))
	

	lastDayIndex = findfirst(x -> x<=1, sol[survivor])
	daysSurvived = isnothing(lastDayIndex) ? round(Int, sol[:t][end]) : round(Int, sol[:t][lastDayIndex])
	
	
	daysAllZombies = isnothing(daysAllZombiesIndex) ? "Not reached yet " : round(Int, sol[:t][daysAllZombiesIndex])

	analyticsCardCSS = Dict(
		:display =>  "flex",
		:gap =>  "0.5rem",
		:padding =>  "0.75rem",
		:flex_direction =>  "column",
		:border_radius =>  "0.5rem",
		:background_color =>  "#125555",
	)
	
	@htl("""
		<style>
		.analytics-card{
			$analyticsCardCSS
		}
		</style>
		<div class="analytics-card"> 
		<div>
		<b>Days survived:</b> $daysSurvived out of $(round(Int, sol[:t][end]))
		</div>
		
		<div>
		<b>Doomsday (Everyone is a zombie):</b> $daysAllZombies
		</div>
		</div> 
	""")
end

# ╔═╡ daf4dd3e-9427-4baa-836e-e1d524c0a170
# """
# 	$(TYPEDSIGNATURES)

# Ploting shortcut for plotting model evolution of a zombie model. 

# # Arguments

# - `title`: Title of the plot Default: "Time Evolution of the system"
# - `xlim:` X axis limits Default: `(0.0,100.0)`
# - `label`: Labels for plot Default: `["Susceptible 😟" "Zombies 🧟" "Removed 😵" ]`
# - `kwargs`: any other plot parameter, passed to `plot()`

# """
function plotZombieModelEvolution(sol::ODESolution; xlim=(0.0,100.0), title="Time Evolution of the system", label=["Susceptible 😟" "Zombies 🧟" "Removed 😵" ], kwargs...,)
	plot(sol; kwargs..., label)
	xlims!(xlim)
	title!(title)
	xlabel!("Days")
	ylabel!("Population")
end

# ╔═╡ dd6bea4d-35fc-4cea-956c-00db08a1f511
begin
	simple_attack_prob_remake = remake(
		simple_attack_prob;
		u0 = [
				 😟 => simple_attack_u0s.😟, 
				 🧟 => simple_attack_u0s.🧟,
				 😵 => 0,
			]
		,p = [
				 ⚔️ => simple_attack_ps.⚔️, 
				 🦠 => simple_attack_ps.🦠,
				 💀 => simple_attack_ps.💀,
			]
		,
		tspan = (0.0, simple_attack_tspan.duration)
	)

	simple_attack_sol = solve(simple_attack_prob_remake, Tsit5())
	
	plotZombieModelEvolution(
		simple_attack_sol; 
		xlim = (simple_attack_plots_params.ts,simple_attack_plots_params.te)
	)
end

# ╔═╡ 6bc0dccf-eacd-4261-a9ff-fb67a4fbd5c6
solutionAnalytics(simple_attack_sol)

# ╔═╡ 603aea40-5cb1-4ef0-9bee-f7476c815833
begin

	lattent_infection_prob_remake = remake(lattent_infection_prob;
		u0 = [
				 😟 => lattent_infection_u0s.😟, 
				 🧟 => lattent_infection_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
			],
		p = [
				 ⚔️ => lattent_infection_ps.⚔️, 
				 🦠 => lattent_infection_ps.🦠,
				 💀 => lattent_infection_ps.💀,
				 🌡️ => lattent_infection_ps.🌡️
			],
		tspan = (0, lattent_infection_tspan.duration)
	)
	
	lattent_infection_sol = solve(lattent_infection_prob_remake, Tsit5())
	
    plotZombieModelEvolution(lattent_infection_sol;
		title = "Latent Infection Model",
		labels=["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Removed 👵" ],
		xlim = (lattent_infection_plots_params.ts,lattent_infection_plots_params.te)
	)
	
end

# ╔═╡ 10febcf4-5c69-436b-af91-f886ac6e34ad
solutionAnalytics(lattent_infection_sol)

# ╔═╡ f2bfba1b-6be2-4e30-a886-617c30f8b027
begin

	simple_quarantine_prob_remake = remake(simple_quarantine_prob;
		u0 = [
				 😟 => simple_quarantine_u0s.😟, 
				 🧟 => simple_quarantine_u0s.🧟,
				 😷 => 0,
				 🤮 => 0,
				 😵 => 0,
		],
		p = [
				 ⚔️ => simple_quarantine_ps.⚔️, 
				 🦠 => simple_quarantine_ps.🦠,
				 💀 => simple_quarantine_ps.💀,
				 🌡️ => simple_quarantine_ps.🌡️,
				 🗡️ => simple_quarantine_ps.🗡️,
				 🚑 => simple_quarantine_ps.🚑
		],
		tspan = (0, simple_quarantine_tspan.duration)
	)
	
	simple_quarantine_sol = solve(simple_quarantine_prob_remake, Tsit5())
	plot(simple_quarantine_sol,  )
	plotZombieModelEvolution(simple_quarantine_sol, 
		title= "Quarantine Model", 
	labels=["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Removed 👵" "Quarantine 😷" ],
		xlim = (simple_quarantine_plots_params.ts,simple_quarantine_plots_params.te)
	)
	
end

# ╔═╡ cd316741-bb6b-4000-87a8-5d5daf0bbb6b
solutionAnalytics(simple_quarantine_sol)

# ╔═╡ 2a3e5049-9ded-427b-b719-f9ef48164bb6
begin

	treatment_model_prob_remake = remake(treatment_model_prob; 
		u0 = [
				 😟 => treatment_model_u0s.😟, 
				 🧟 => treatment_model_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
		],
		p = [
				 ⚔️ => treatment_model_ps.⚔️, 
				 🦠 => treatment_model_ps.🦠,
				 💀 => treatment_model_ps.💀,
				 💊 => treatment_model_ps.💊,
				 🌡️ => treatment_model_ps.🌡️,
		],
		tspan = (0.0, treatment_model_tspan.duration)
	)
	
	treatment_model_sol = solve(treatment_model_prob_remake, Tsit5())
	
	plotZombieModelEvolution(treatment_model_sol,
		title = "Treatment Model",
		labels = labels=["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Removed 👵"],
		xlim = (treatment_model_plots_params.ts,treatment_model_plots_params.te)
	)
	
end

# ╔═╡ 6642ec56-0093-4497-9bea-a05afd8e7507
solutionAnalytics(treatment_model_sol)

# ╔═╡ 1d6f6649-ddee-42d7-a0b8-29e03f3ac0f8
begin

	impulsive_eradication_prob_remake = remake(impulsive_eradication_prob;
		u0 = [
				 😟 => impulsive_eradication_u0s.😟, 
				 🧟 => impulsive_eradication_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
		],
		p = [
				 ⚔️  => impulsive_eradication_ps.⚔️, 
				 🦠 => impulsive_eradication_ps.🦠,
				 💀 => impulsive_eradication_ps.💀,
				 🌡️ => impulsive_eradication_ps.🌡️,
				 💣 => impulsive_eradication_ps.💣,
				 💊 => impulsive_eradication_ps.💊,
		],
		tspan = (0.0, impulsive_eradication_tspan.duration)
	)
	
	
	impulsive_eradication_sol = solve(
		impulsive_eradication_prob_remake, Rosenbrock23()
	)
	
	plotZombieModelEvolution(impulsive_eradication_sol,
		title = "Impulsive Eradication Model",
		labels = ["Susceptible 👩"  "Zombies 🧟" "Infected 😱" "Removed 👵"],
		xlim = (impulsive_eradication_plots_params.ts,impulsive_eradication_plots_params.te)
	)
end

# ╔═╡ 25089138-341a-413c-a19e-b56860faaf8d
solutionAnalytics(impulsive_eradication_sol)

# ╔═╡ bc872c1c-0b47-47d6-840b-3b988955dfc8
begin

	vaccine_model_prob_remake = remake(vaccine_model_prob;
		u0 = [
				 😟 => vaccine_model_u0s.😟, 
				 🧟 => vaccine_model_u0s.🧟,
				 😊 => 0,
			     😷 => 0,
				 🤮 => 0,
				 😵 => 0,
		],
		p = [
				 ⚔️  => vaccine_model_ps.⚔️, 
				 🦠 => vaccine_model_ps.🦠,
				 💀 => vaccine_model_ps.💀,
				 🌡️ => vaccine_model_ps.🌡️,
				 💣 => vaccine_model_ps.💣,
				 💊 => vaccine_model_ps.💊,
				 🚑 => vaccine_model_ps.🚑,
				 💉 => vaccine_model_ps.💉,
				🗡️  => vaccine_model_ps.🗡️
		],
		tspan = (0.0, vaccine_model_tspan.duration)
	)
	
	# Tsit5() can't handle problems in mass form/ discrete events so we use Rosenbrock23(), more info: https://docs.sciml.ai/DiffEqDocs/stable/solvers/ode_solve/
	vaccine_model_sol = solve(vaccine_model_prob_remake, Rosenbrock23())
	
	plotZombieModelEvolution(vaccine_model_sol,
		title = "Vaccine Model",
		labels = ["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Quarantine 😷" "Removed 👵" "Vaccinated 💉"], 
		xlim = (vaccine_model_plots_params.ts,vaccine_model_plots_params.te)
	)
end

# ╔═╡ 88b3d429-4acd-4115-82da-972db1c5b501
md"## CSS"

# ╔═╡ ad0b76a6-46ce-42e0-82a5-e2230efc5d3b
function loadDynamicViewCSS()
	@htl("""
	<style>
		@media screen and (min-width: 600px) {
			
			.on-tiny-show {
				display: flex;
			}
			.on-small-show {
				display: none;
			}
			.on-big-show {
				display: none;
			}
		}
		@media screen and (min-width: 1200px) {
			.on-tiny-show {
				display: none;
			}
			.on-small-show {
				display: flex;
			}
			.on-big-show {
				display: none;
			}
		}
		@media screen and (min-width: 1800px) {
			.on-tiny-show {
				display: none;
			}
			.on-small-show {
				display: flex;
			}
			.on-big-show {
				display: flex;
			}
		}
	</style>
	""")
end

# ╔═╡ ac29d04e-1c97-4062-85c9-522d094a8749
function loadExtraCSS()
	@htl("""
		
		<style>
			bond {
				width: 100%
				
			}
		</style>
	""")
end

# ╔═╡ 5d7d7822-61c9-47a1-830b-6b0294531d5c
begin
	# CSS Styles used in notebook  	
	function loadCSS()		
		return @htl("""
			$(loadSideBarCSS())
			$(loadCollapsibleCSS())
			$(loadSliderCSS())
			$(loadDynamicViewCSS())
			$(loadExtraCSS())
			"""
		)
	end
end

# ╔═╡ 1e7b849d-2b10-4fec-93b4-c33d231abfa9
begin
	
	loadCSS()

end

# ╔═╡ 813fc6b1-460a-49cb-9ae5-909e38e18e71
md"## Packages"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
OrdinaryDiffEq = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~1.0.0"
ModelingToolkit = "~11.26.5"
OrdinaryDiffEq = "~7.0.0"
Parameters = "~0.12.3"
PlotlyBase = "~0.8.23"
Plots = "~1.41.6"
PlutoUI = "~0.7.81"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.5"
manifest_format = "2.0"
project_hash = "86036e601c5d5b36c5130cd85762d18710656a4b"

[[deps.ADTypes]]
git-tree-sha1 = "bbc22a9a08a0ef6460041086d8a7b27940ed4ffd"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.22.0"

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesConstructionBaseExt = "ConstructionBase"
    ADTypesEnzymeCoreExt = "EnzymeCore"

    [deps.ADTypes.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.AbstractPlutoDingetjes]]
git-tree-sha1 = "6c3913f4e9bdf6ba3c08041a446fb1332716cbc2"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.4.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "MacroTools"]
git-tree-sha1 = "2eeb2c9bef11013efc6f8f97f32ee59b146b09fb"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.44"

    [deps.Accessors.extensions]
    AxisKeysExt = "AxisKeys"
    IntervalSetsExt = "IntervalSets"
    LinearAlgebraExt = "LinearAlgebra"
    StaticArraysExt = "StaticArrays"
    StructArraysExt = "StructArrays"
    TestExt = "Test"
    UnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "28e1637322d4019ed2577cbec9268fab9b7da117"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.6.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "3d0cabd25fab32390e3bcb82cd67e700aebd9816"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.25.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceAMDGPUExt = "AMDGPU"
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = ["CUDSS", "CUDA"]
    ArrayInterfaceChainRulesCoreExt = "ChainRulesCore"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceMetalExt = "Metal"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "e0b47732a192dd59b9d079a06d04235e2f833963"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.12.2"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "PrecompileTools"]
git-tree-sha1 = "02fa77c70ba84361b9bc9ff28523bd9d78519265"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "1.11.0"

    [deps.BandedMatrices.extensions]
    BandedMatricesSparseArraysExt = "SparseArrays"
    CliqueTreesExt = "CliqueTrees"

    [deps.BandedMatrices.weakdeps]
    CliqueTrees = "60701a23-6482-424a-84db-faee86b9b1f8"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Bijections]]
git-tree-sha1 = "a2d308fcd4c2fb90e943cf9cd2fbfa9c32b69733"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.2.2"

[[deps.BipartiteGraphs]]
deps = ["DataStructures", "DocStringExtensions", "Graphs", "PrecompileTools"]
git-tree-sha1 = "3b050c43d6156f7115f37cf206d3fa34d118c61b"
uuid = "caf10ac8-0290-4205-88aa-f15908547e8d"
version = "0.1.7"
weakdeps = ["SparseArrays"]

    [deps.BipartiteGraphs.extensions]
    BipartiteGraphsSparseArraysExt = "SparseArrays"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BlockArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra"]
git-tree-sha1 = "0f606a9894e2bcda541ceb82a91a13c5d450ed97"
uuid = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
version = "1.9.3"
weakdeps = ["Adapt", "BandedMatrices"]

    [deps.BlockArrays.extensions]
    BlockArraysAdaptExt = "Adapt"
    BlockArraysBandedMatricesExt = "BandedMatrices"

[[deps.BracketingNonlinearSolve]]
deps = ["CommonSolve", "ConcreteStructs", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "7ad7171d693ae5552ac43862e7f6b61df4471c2b"
uuid = "70df07ce-3d50-431d-a3e7-ca6ddb60ac1e"
version = "1.12.1"

    [deps.BracketingNonlinearSolve.extensions]
    BracketingNonlinearSolveChainRulesCoreExt = ["ChainRulesCore", "ForwardDiff"]
    BracketingNonlinearSolveForwardDiffExt = "ForwardDiff"

    [deps.BracketingNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1fa950ebc3e37eccd51c6a8fe1f92f7d86263522"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.7+0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "8b3b6f87ce8f65a2b4f857528fd8d70086cd72b1"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.11.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "78ea4ddbcf9c241827e7035c3a03e2e456711470"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.6"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.CompositeTypes]]
git-tree-sha1 = "bce26c3dab336582805503bed209faab1c279768"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.4"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcreteStructs]]
git-tree-sha1 = "ed1da4eac5ba9b3f6d061c90f3ca6ba190dd6595"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.4"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "21d088c496ea22914fe80906eb5bce65755e5ec8"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.1"

[[deps.ConstructionBase]]
git-tree-sha1 = "b4b092499347b18a015186eae3042f72267106cb"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.6.0"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["OrderedCollections"]
git-tree-sha1 = "e86f4a2805f7f19bec5129bc9150c38208e5dc23"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.4"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "a55766a9c8f66cf19ffcdbdb1444e249bb4ace33"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.4.6"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "BracketingNonlinearSolve", "ConcreteStructs", "DocStringExtensions", "FastBroadcast", "FastClosures", "FastPower", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLLogging", "SciMLOperators", "SciMLStructures", "Setfield", "StaticArraysCore", "SymbolicIndexingInterface", "TruncatedStacktraces"]
git-tree-sha1 = "86932ebaae0425f3d69c398dd37d57745b7cf524"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "7.5.0"

    [deps.DiffEqBase.extensions]
    DiffEqBaseCUDAExt = "CUDA"
    DiffEqBaseChainRulesCoreExt = "ChainRulesCore"
    DiffEqBaseDynamicQuantitiesExt = "DynamicQuantities"
    DiffEqBaseEnzymeExt = ["ChainRulesCore", "Enzyme"]
    DiffEqBaseFlexUnitsExt = "FlexUnits"
    DiffEqBaseForwardDiffExt = ["ForwardDiff"]
    DiffEqBaseGTPSAExt = "GTPSA"
    DiffEqBaseGeneralizedGeneratedExt = "GeneralizedGenerated"
    DiffEqBaseMPIExt = "MPI"
    DiffEqBaseMeasurementsExt = "Measurements"
    DiffEqBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    DiffEqBaseMooncakeExt = "Mooncake"
    DiffEqBaseReverseDiffExt = "ReverseDiff"
    DiffEqBaseSparseArraysExt = "SparseArrays"
    DiffEqBaseTrackerExt = "Tracker"
    DiffEqBaseUnitfulExt = "Unitful"

    [deps.DiffEqBase.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    DynamicQuantities = "06fc5a27-2a28-4c7c-a15d-362465fb6821"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    FlexUnits = "76e01b6b-c995-4ce6-8559-91e72a3d4e95"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    GTPSA = "b27dd330-f138-47c5-815b-40db9dd9b6e8"
    GeneralizedGenerated = "6b9d7cbe-bcb9-11e9-073f-15a7a543e2eb"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.DiffEqCallbacks]]
deps = ["ConcreteStructs", "DataStructures", "DiffEqBase", "DifferentiationInterface", "LinearAlgebra", "Markdown", "PrecompileTools", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "51f445c25b80c26c83c61520cde214adf8c05227"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "4.17.0"

    [deps.DiffEqCallbacks.extensions]
    DiffEqCallbacksFunctorsExt = "Functors"

    [deps.DiffEqCallbacks.weakdeps]
    Functors = "d9f16b24-f501-4c13-a1f2-28368ffc5196"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentiationInterface]]
deps = ["ADTypes", "LinearAlgebra"]
git-tree-sha1 = "2147a95a217cc8a78ec96ee03581adf129468e49"
uuid = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
version = "0.7.18"

    [deps.DifferentiationInterface.extensions]
    DifferentiationInterfaceChainRulesCoreExt = "ChainRulesCore"
    DifferentiationInterfaceDiffractorExt = "Diffractor"
    DifferentiationInterfaceEnzymeExt = ["EnzymeCore", "Enzyme"]
    DifferentiationInterfaceFastDifferentiationExt = "FastDifferentiation"
    DifferentiationInterfaceFiniteDiffExt = "FiniteDiff"
    DifferentiationInterfaceFiniteDifferencesExt = "FiniteDifferences"
    DifferentiationInterfaceForwardDiffExt = ["ForwardDiff", "DiffResults"]
    DifferentiationInterfaceGPUArraysCoreExt = ["GPUArraysCore", "Adapt"]
    DifferentiationInterfaceGTPSAExt = "GTPSA"
    DifferentiationInterfaceHyperHessiansExt = "HyperHessians"
    DifferentiationInterfaceMooncakeExt = "Mooncake"
    DifferentiationInterfacePolyesterForwardDiffExt = ["PolyesterForwardDiff", "ForwardDiff", "DiffResults"]
    DifferentiationInterfaceReverseDiffExt = ["ReverseDiff", "DiffResults"]
    DifferentiationInterfaceSparseArraysExt = "SparseArrays"
    DifferentiationInterfaceSparseConnectivityTracerExt = "SparseConnectivityTracer"
    DifferentiationInterfaceSparseMatrixColoringsExt = "SparseMatrixColorings"
    DifferentiationInterfaceStaticArraysExt = "StaticArrays"
    DifferentiationInterfaceSymbolicsExt = "Symbolics"
    DifferentiationInterfaceTrackerExt = "Tracker"
    DifferentiationInterfaceZygoteExt = ["Zygote", "ForwardDiff"]

    [deps.DifferentiationInterface.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffResults = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
    Diffractor = "9f5e2b26-1114-432f-b630-d3fe2085c51c"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastDifferentiation = "eb9bf01b-bf85-4b60-bf87-ee5de06c00be"
    FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    GTPSA = "b27dd330-f138-47c5-815b-40db9dd9b6e8"
    HyperHessians = "06b494a0-c8e0-40cc-ad32-d99506a00a6c"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseConnectivityTracer = "9f842d2f-2579-4b1d-911e-f412cf18a3f5"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.DomainSets]]
deps = ["CompositeTypes", "FunctionMaps", "IntervalSets", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4599e0cd684f3ff6cbbab73c77553a3d01a8d74d"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.7.18"

    [deps.DomainSets.extensions]
    DomainSetsMakieExt = "Makie"
    DomainSetsRandomExt = "Random"

    [deps.DomainSets.weakdeps]
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.DynamicPolynomials]]
deps = ["LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Reexport", "StarAlgebras", "Test"]
git-tree-sha1 = "5bfabc3827dfdd164359bad6800c115a81280c00"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.6.6"

[[deps.EnumX]]
git-tree-sha1 = "c49898e8438c828577f04b92fc9368c388ac783c"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.7"

[[deps.EnzymeCore]]
git-tree-sha1 = "c6ee69ee502060982d12dbaaf3d8fcb4e835a0d1"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.8.20"

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"
    EnzymeCoreChainRulesCoreExt = "ChainRulesCore"

    [deps.EnzymeCore.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8f05e9a2e7c2e3eb524102bb2926c5743c07fbe1"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.8.0+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "95ecf07c2eea562b5adbd0696af6db62c0f52560"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.5"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libva_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "cac41ca6b2d399adfc95e51240566f8a60a80806"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "8.1.0+0"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra"]
git-tree-sha1 = "7feeed2c9a7fa272189a5561bebf0c4ccaedb6ec"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "1.3.2"

    [deps.FastBroadcast.extensions]
    FastBroadcastPolyesterExt = "Polyester"
    FastBroadcastStaticExt = "Static"

    [deps.FastBroadcast.weakdeps]
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    Static = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastPower]]
git-tree-sha1 = "862831f78c7a48681a074ecc9aac09f2de563f71"
uuid = "a4df4552-cc26-4903-aec0-212e50a0e84b"
version = "1.3.1"

    [deps.FastPower.extensions]
    FastPowerEnzymeExt = "Enzyme"
    FastPowerForwardDiffExt = "ForwardDiff"
    FastPowerMeasurementsExt = "Measurements"
    FastPowerMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    FastPowerMooncakeExt = "Mooncake"
    FastPowerReverseDiffExt = "ReverseDiff"
    FastPowerTrackerExt = "Tracker"

    [deps.FastPower.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2f979084d1e13948a3352cf64a25df6bd3b4dca3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.16.0"

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStaticArraysExt = "StaticArrays"
    FillArraysStatisticsExt = "Statistics"

    [deps.FillArrays.weakdeps]
    PDMats = "90014a1f-27ba-587c-ab20-58faa44d9150"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.FindFirstFunctions]]
deps = ["PrecompileTools"]
git-tree-sha1 = "27b495de668ccea58de6b06d6d13181396598ea0"
uuid = "64ca27bc-2ba2-4a57-88aa-44e436879224"
version = "1.8.0"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Setfield"]
git-tree-sha1 = "f7017a4f337f8df189fcce98e32b67a1298a2115"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.31.0"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffSparseArraysExt = "SparseArrays"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "f85dac9a96a01087df6e3a749840015a0ca3817d"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.17.1+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cddeab6487248a39dae1a960fff0ac17b2a28888"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "1.3.3"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "70329abc09b886fd2c5d94ad2d9527639c421e3e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.14.3+1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.FunctionMaps]]
deps = ["CompositeTypes", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "31bd99a57edf98990d1c21486032963955450e8d"
uuid = "a85aefff-f8ca-4649-a888-c8e5398bc76c"
version = "0.1.2"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers", "PrecompileTools", "TruncatedStacktraces"]
git-tree-sha1 = "1ccaffbe23a2b91084ff6af8e67ab24ad8937dee"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "1.9.0"

    [deps.FunctionWrappersWrappers.extensions]
    FunctionWrappersWrappersEnzymeExt = ["Enzyme", "EnzymeCore"]
    FunctionWrappersWrappersMooncakeExt = "Mooncake"

    [deps.FunctionWrappersWrappers.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "9e0fb9e54594c47f278d75063980e43066e26e20"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.1+1"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "83cf05ab16a73219e5f6bd1bdfa9848fa24ac627"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.2.0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "44716a1a667cb867ee0e9ec8edc31c3e4aa5afdc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.24"

    [deps.GR.extensions]
    IJuliaExt = "IJulia"

    [deps.GR.weakdeps]
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "be8a1b8065959e24fdc1b51402f39f3b6f0f6653"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.24+0"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "24f6def62397474a297bfcec22384101609142ed"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.86.3+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Inflate", "LinearAlgebra", "Random", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "7eb45fe833a5b7c51cf6d89c5a841d5967e44be3"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.14.0"

    [deps.Graphs.extensions]
    GraphsSharedArraysExt = "SharedArrays"

    [deps.Graphs.weakdeps]
    Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"
    SharedArrays = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.ImplicitDiscreteSolve]]
deps = ["ConcreteStructs", "DiffEqBase", "NonlinearSolveBase", "NonlinearSolveFirstOrder", "OrdinaryDiffEqCore", "Reexport", "SciMLBase", "SymbolicIndexingInterface"]
git-tree-sha1 = "bfd3403d5f02010d486995c38f44c61ca0361048"
uuid = "3263718b-31ed-49cf-8a0f-35a466e8af96"
version = "2.1.0"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "4c1acff2dc6b6967e7e750633c50bc3b8d83e617"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "ec1debd61c300961f98064cfb21287613ad7f303"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2025.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IntervalSets]]
git-tree-sha1 = "79d6bd28c8d9bccc2229784f1bd637689b256377"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.14"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7204148362dafe5fe6a273f855b8ccbe4df8173e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.8.0"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "f76f7560267b840e492180f9899b472f30b88450"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.6.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.Jieko]]
deps = ["ExproniconLite"]
git-tree-sha1 = "2f05ed29618da60c06a87e9c033982d4f71d0b6c"
uuid = "ae98c720-c025-4a4a-838c-29b094483192"
version = "0.2.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c0c9b76f3520863909825cbecdef58cd63de705a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.5+0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "PoissonRandom", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "SymbolicIndexingInterface"]
git-tree-sha1 = "2a8e5b9b90ef0da05f61904d0a39a7b1c0a83310"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.28.0"

    [deps.JumpProcesses.extensions]
    JumpProcessesKernelAbstractionsExt = ["Adapt", "KernelAbstractions"]
    JumpProcessesOrdinaryDiffEqCoreExt = "OrdinaryDiffEqCore"

    [deps.JumpProcesses.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    OrdinaryDiffEqCore = "bbf590c4-e513-4bbe-9b18-05decba2e5d8"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "c4d19f51afc7ba2afbe32031b8f2d21b11c9e26e"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.10.6"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "17b94ecafcfa45e8360a4fc9ca6b583b049e4e37"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.1.0+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc3ad4faf30015a3e8094c9b5b7f19e85bdf2386"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.42.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d620582b1f0cbe2c72dd1d5bd195a9ce73370ab1"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.42.0+0"

[[deps.LineSearch]]
deps = ["ADTypes", "CommonSolve", "ConcreteStructs", "FastClosures", "LinearAlgebra", "MaybeInplace", "PrecompileTools", "SciMLBase", "SciMLJacobianOperators", "StaticArraysCore"]
git-tree-sha1 = "fd58a77c92e7c8f1db25c9839127d52943a49349"
uuid = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
version = "0.1.9"

    [deps.LineSearch.extensions]
    LineSearchLineSearchesExt = "LineSearches"

    [deps.LineSearch.weakdeps]
    LineSearches = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "ConcreteStructs", "DocStringExtensions", "EnumX", "GPUArraysCore", "InteractiveUtils", "Krylov", "Libdl", "LinearAlgebra", "MKL_jll", "Markdown", "OpenBLAS_jll", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLLogging", "SciMLOperators", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "e9b3951e6818eb2dad05df3020181fa60d901864"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "3.81.0"

    [deps.LinearSolve.extensions]
    LinearSolveAMDGPUExt = "AMDGPU"
    LinearSolveAlgebraicMultigridExt = "AlgebraicMultigrid"
    LinearSolveBLISExt = ["blis_jll", "LAPACK_jll"]
    LinearSolveBandedMatricesExt = "BandedMatrices"
    LinearSolveBlockDiagonalsExt = "BlockDiagonals"
    LinearSolveCUDAExt = ["cuSOLVER"]
    LinearSolveCUDSSExt = "CUDSS"
    LinearSolveCUSOLVERRFExt = ["CUSOLVERRF", "SparseArrays"]
    LinearSolveChainRulesCoreExt = "ChainRulesCore"
    LinearSolveCliqueTreesExt = ["CliqueTrees", "SparseArrays"]
    LinearSolveElementalExt = "Elemental"
    LinearSolveEnzymeExt = ["EnzymeCore", "SparseArrays"]
    LinearSolveFastAlmostBandedMatricesExt = "FastAlmostBandedMatrices"
    LinearSolveFastLapackInterfaceExt = "FastLapackInterface"
    LinearSolveForwardDiffExt = "ForwardDiff"
    LinearSolveGinkgoExt = ["Ginkgo", "SparseArrays"]
    LinearSolveHYPREExt = "HYPRE"
    LinearSolveIterativeSolversExt = "IterativeSolvers"
    LinearSolveKernelAbstractionsExt = "KernelAbstractions"
    LinearSolveKrylovKitExt = "KrylovKit"
    LinearSolveMetalExt = "Metal"
    LinearSolveMooncakeExt = "Mooncake"
    LinearSolvePETScExt = ["PETSc", "SparseArrays", "SparseMatricesCSR"]
    LinearSolvePETScMPIExt = ["PETSc", "PartitionedArrays", "SparseArrays", "SparseMatricesCSR"]
    LinearSolveParUExt = ["ParU_jll", "SparseArrays"]
    LinearSolvePardisoExt = ["Pardiso", "SparseArrays"]
    LinearSolveRecursiveFactorizationExt = "RecursiveFactorization"
    LinearSolveSTRUMPACKExt = ["SparseArrays", "STRUMPACK_jll"]
    LinearSolveSparseArraysExt = "SparseArrays"
    LinearSolveSparspakExt = ["SparseArrays", "Sparspak"]

    [deps.LinearSolve.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    AlgebraicMultigrid = "2169fc97-5a83-5252-b627-83903c6c433c"
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockDiagonals = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    CUSOLVERRF = "a8cc9031-bad2-4722-94f5-40deabb4245c"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    CliqueTrees = "60701a23-6482-424a-84db-faee86b9b1f8"
    Elemental = "902c3f28-d1ec-5e7e-8399-a24c3845ee38"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastAlmostBandedMatrices = "9d29842c-ecb8-4973-b1e9-a27b1157504e"
    FastLapackInterface = "29a986be-02c6-4525-aec4-84b980013641"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Ginkgo = "4c8bd3c9-ead9-4b5e-a625-08f1338ba0ec"
    HYPRE = "b5ffcf37-a2bd-41ab-a3da-4bd9bc8ad771"
    IterativeSolvers = "42fd0dbc-a981-5370-80f2-aaf504508153"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
    LAPACK_jll = "51474c39-65e3-53ba-86ba-03b1b862ec14"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PETSc = "ace2c81b-2b5f-4b1e-a30d-d662738edfe0"
    ParU_jll = "9e0b026c-e8ce-559c-a2c4-6a3d5c955bc9"
    Pardiso = "46dd5b70-b6fb-5a00-ae2d-e8fea33afaf2"
    PartitionedArrays = "5a9dfac6-5c52-46f7-8278-5e2210713be9"
    RecursiveFactorization = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
    STRUMPACK_jll = "86fbd0b9-476f-557c-b766-62c724b42d8c"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatricesCSR = "a0a7dd2c-ebf4-11e9-1f05-cf50bc540ca1"
    Sparspak = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
    blis_jll = "6136c539-28a5-5bf0-87cc-b183200dce32"
    cuSOLVER = "887afef0-6a32-4de5-add4-7827692ba8fc"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "282cadc186e7b2ae0eeadbd7a4dffed4196ae2aa"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2025.2.0+0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MaybeInplace]]
deps = ["ArrayInterface", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "54e2fdc38130c05b42be423e90da3bade29b74bd"
uuid = "bb5d69b7-63fc-4a16-80bd-7e42200c7bdb"
version = "0.1.4"
weakdeps = ["SparseArrays"]

    [deps.MaybeInplace.extensions]
    MaybeInplaceSparseArraysExt = "SparseArrays"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ff69a2b1330bcb730b9ac1ab7dd680176f5896b8"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.Measures]]
git-tree-sha1 = "b513cedd20d9c914783d8ad83d08120702bf2c77"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.3"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.ModelingToolkit]]
deps = ["ADTypes", "BipartiteGraphs", "BlockArrays", "Combinatorics", "CommonSolve", "ConstructionBase", "DataStructures", "DiffEqBase", "DifferentiationInterface", "DocStringExtensions", "FillArrays", "ForwardDiff", "Graphs", "InteractiveUtils", "Libdl", "LinearAlgebra", "ModelingToolkitBase", "ModelingToolkitTearing", "Moshi", "OffsetArrays", "OrderedCollections", "PreallocationTools", "PrecompileTools", "REPL", "Reexport", "RuntimeGeneratedFunctions", "SCCNonlinearSolve", "SciMLBase", "SciMLPublic", "Serialization", "Setfield", "SimpleNonlinearSolve", "SparseArrays", "StateSelection", "StaticArrays", "SymbolicIndexingInterface", "SymbolicUtils", "Symbolics", "UnPack"]
git-tree-sha1 = "848e5f3a5ab2ede0d291dde3365c7b5da664052d"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "11.26.5"

    [deps.ModelingToolkit.extensions]
    MTKFMIExt = "FMIImport"
    MTKOrdinaryDiffEqBDFExt = "OrdinaryDiffEqBDF"
    MTKOrdinaryDiffEqDefaultExt = "OrdinaryDiffEqDefault"
    MTKOrdinaryDiffEqRosenbrockExt = "OrdinaryDiffEqRosenbrock"

    [deps.ModelingToolkit.weakdeps]
    FMIImport = "9fcbc62e-52a0-44e9-a616-1359a0008194"
    OrdinaryDiffEqBDF = "6ad6398a-0878-4a85-9266-38940aa047c8"
    OrdinaryDiffEqDefault = "50262376-6c5a-4cf5-baba-aaf4f84d72d7"
    OrdinaryDiffEqRosenbrock = "43230ef6-c299-4910-a778-202eb28ce4ce"

[[deps.ModelingToolkitBase]]
deps = ["ADTypes", "AbstractTrees", "ArrayInterface", "BandedMatrices", "BipartiteGraphs", "BlockArrays", "Combinatorics", "CommonSolve", "Compat", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffRules", "DifferentiationInterface", "DocStringExtensions", "DomainSets", "EnumX", "EnzymeCore", "ExprTools", "FillArrays", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "Graphs", "ImplicitDiscreteSolve", "InteractiveUtils", "JumpProcesses", "Libdl", "LinearAlgebra", "Moshi", "NaNMath", "OffsetArrays", "OrderedCollections", "PreallocationTools", "PrecompileTools", "REPL", "Random", "ReadOnlyDicts", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SCCNonlinearSolve", "SciMLBase", "SciMLPublic", "SciMLStructures", "Serialization", "Setfield", "SimpleNonlinearSolve", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "SymbolicUtils", "Symbolics", "UnPack"]
git-tree-sha1 = "9cb2ac6e091c67d4a5c364846a0ba90d4c010df4"
uuid = "7771a370-6774-4173-bd38-47e70ca0b839"
version = "1.37.0"

    [deps.ModelingToolkitBase.extensions]
    MTKBifurcationKitExt = "BifurcationKit"
    MTKCasADiDynamicOptExt = "CasADi"
    MTKChainRulesCoreExt = "ChainRulesCore"
    MTKDiffEqNoiseProcessExt = "DiffEqNoiseProcess"
    MTKDynamicQuantitiesExt = "DynamicQuantities"
    MTKInfiniteOptExt = "InfiniteOpt"
    MTKJuliaFormatterExt = "JuliaFormatter"
    MTKLabelledArraysExt = "LabelledArrays"
    MTKLatexifyExt = "Latexify"
    MTKMooncakeExt = "Mooncake"
    MTKPyomoDynamicOptExt = "Pyomo"
    MTKTrackerExt = "Tracker"

    [deps.ModelingToolkitBase.weakdeps]
    BifurcationKit = "0f109fa4-8a5d-4b75-95aa-f515264e7665"
    CasADi = "c49709b8-5c63-11e9-2fb2-69db5844192f"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffEqNoiseProcess = "77a26b50-5914-5dd7-bc55-306e6241c503"
    DynamicQuantities = "06fc5a27-2a28-4c7c-a15d-362465fb6821"
    InfiniteOpt = "20393b10-9daf-11e9-18c9-8db751c92c57"
    JuliaFormatter = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    Pyomo = "0e8e1daf-01b5-4eba-a626-3897743a3816"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ModelingToolkitTearing]]
deps = ["BipartiteGraphs", "CommonSolve", "DocStringExtensions", "Graphs", "LinearAlgebra", "ModelingToolkitBase", "Moshi", "OffsetArrays", "OrderedCollections", "SciMLBase", "Setfield", "SparseArrays", "StateSelection", "SymbolicIndexingInterface", "SymbolicUtils", "Symbolics", "UUIDs"]
git-tree-sha1 = "33cae39d4c63ec574227ececb962f86e6ae46689"
uuid = "6bb917b9-1269-42b9-9f7c-b0dca72083ab"
version = "1.13.5"

[[deps.Moshi]]
deps = ["ExproniconLite", "Jieko"]
git-tree-sha1 = "53f817d3e84537d84545e0ad749e483412dd6b2a"
uuid = "2e0e35c7-a2e4-4343-998d-7ef72827ed2d"
version = "0.3.7"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.11.4"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.MultivariatePolynomials]]
deps = ["DataStructures", "LinearAlgebra", "MutableArithmetics", "StarAlgebras"]
git-tree-sha1 = "4838893d9b035c2f6967c0d533350e1755b58a70"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.5.19"

    [deps.MultivariatePolynomials.extensions]
    MultivariatePolynomialsChainRulesCoreExt = "ChainRulesCore"

    [deps.MultivariatePolynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "dc5b2c4c111c46bc79ac4405eeb563523b39c004"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.8.0"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.NonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "BracketingNonlinearSolve", "CommonSolve", "ConcreteStructs", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "NonlinearSolveBase", "NonlinearSolveFirstOrder", "NonlinearSolveQuasiNewton", "NonlinearSolveSpectralMethods", "PrecompileTools", "Preferences", "Reexport", "SciMLBase", "Setfield", "SimpleNonlinearSolve", "StaticArraysCore", "SymbolicIndexingInterface"]
git-tree-sha1 = "a6c5719bbb42985c72f4cacbfa49e86bab850d66"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "4.19.1"

    [deps.NonlinearSolve.extensions]
    NonlinearSolveFastLevenbergMarquardtExt = "FastLevenbergMarquardt"
    NonlinearSolveFixedPointAccelerationExt = "FixedPointAcceleration"
    NonlinearSolveLeastSquaresOptimExt = "LeastSquaresOptim"
    NonlinearSolveMINPACKExt = "MINPACK"
    NonlinearSolveNLSolversExt = "NLSolvers"
    NonlinearSolveNLsolveExt = ["NLsolve", "LineSearches"]
    NonlinearSolvePETScExt = ["PETSc", "MPI", "SparseArrays"]
    NonlinearSolveSIAMFANLEquationsExt = "SIAMFANLEquations"
    NonlinearSolveSpeedMappingExt = "SpeedMapping"
    NonlinearSolveSundialsExt = "Sundials"

    [deps.NonlinearSolve.weakdeps]
    FastLevenbergMarquardt = "7a0df574-e128-4d35-8cbd-3d84502bf7ce"
    FixedPointAcceleration = "817d07cb-a79a-5c30-9a31-890123675176"
    LeastSquaresOptim = "0fc2ff8b-aaa3-5acd-a817-1944a5e08891"
    LineSearches = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
    MINPACK = "4854310b-de5a-5eb6-a2a5-c1dee2bd17f9"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    NLSolvers = "337daf1e-9722-11e9-073e-8b9effe078ba"
    NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
    PETSc = "ace2c81b-2b5f-4b1e-a30d-d662738edfe0"
    SIAMFANLEquations = "084e46ad-d928-497d-ad5e-07fa361a48c4"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SpeedMapping = "f1835b91-879b-4a3f-a438-e4baacf14412"
    Sundials = "c3572dad-4567-51f8-b174-8c6c989267f4"

[[deps.NonlinearSolveBase]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "CommonSolve", "Compat", "ConcreteStructs", "DifferentiationInterface", "EnzymeCore", "FastClosures", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "LogExpFunctions", "Markdown", "MaybeInplace", "PreallocationTools", "PrecompileTools", "Preferences", "Printf", "RecursiveArrayTools", "SciMLBase", "SciMLJacobianOperators", "SciMLLogging", "SciMLOperators", "SciMLStructures", "Setfield", "StaticArraysCore", "SymbolicIndexingInterface", "TimerOutputs"]
git-tree-sha1 = "36f063516ea7b8c355ec94819b409b89db436358"
uuid = "be0214bd-f91f-a760-ac4e-3421ce2b2da0"
version = "2.26.0"

    [deps.NonlinearSolveBase.extensions]
    NonlinearSolveBaseBandedMatricesExt = "BandedMatrices"
    NonlinearSolveBaseChainRulesCoreExt = "ChainRulesCore"
    NonlinearSolveBaseEnzymeExt = ["ChainRulesCore", "Enzyme"]
    NonlinearSolveBaseForwardDiffExt = "ForwardDiff"
    NonlinearSolveBaseLineSearchExt = "LineSearch"
    NonlinearSolveBaseLinearSolveExt = "LinearSolve"
    NonlinearSolveBaseMooncakeExt = "Mooncake"
    NonlinearSolveBaseReverseDiffExt = "ReverseDiff"
    NonlinearSolveBaseSparseArraysExt = "SparseArrays"
    NonlinearSolveBaseSparseMatrixColoringsExt = "SparseMatrixColorings"
    NonlinearSolveBaseTrackerExt = "Tracker"

    [deps.NonlinearSolveBase.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    LineSearch = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
    LinearSolve = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.NonlinearSolveFirstOrder]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConcreteStructs", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLJacobianOperators", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "ce68820a4f421fb5bee7ec4dcf875aff33886bfb"
uuid = "5959db7a-ea39-4486-b5fe-2dd0bf03d60d"
version = "2.1.1"

[[deps.NonlinearSolveQuasiNewton]]
deps = ["ArrayInterface", "CommonSolve", "ConcreteStructs", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLOperators", "StaticArraysCore"]
git-tree-sha1 = "538432ca1aea8bf63db02929bf870501f8a7c64c"
uuid = "9a2c21bd-3a47-402d-9113-8faf9a0ee114"
version = "1.13.1"
weakdeps = ["ForwardDiff"]

    [deps.NonlinearSolveQuasiNewton.extensions]
    NonlinearSolveQuasiNewtonForwardDiffExt = "ForwardDiff"

[[deps.NonlinearSolveSpectralMethods]]
deps = ["CommonSolve", "ConcreteStructs", "LineSearch", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "a3781e12becdf0ce5520bd97ec617e879bf4e9f2"
uuid = "26075421-4e9a-44e1-8bd1-420ed7ad02b2"
version = "1.7.1"
weakdeps = ["ForwardDiff"]

    [deps.NonlinearSolveSpectralMethods.extensions]
    NonlinearSolveSpectralMethodsForwardDiffExt = "ForwardDiff"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6aa4566bb7ae78498a5e68943863fa8b5231b59"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.6+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e2bb57a313a74b8104064b7efd01406c0a50d2ff"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.6.1+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "CommonSolve", "DocStringExtensions", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqDefault", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "SciMLBase"]
git-tree-sha1 = "4c411ca0fa291015bc4c23058799a7280c4223e4"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "7.0.0"

[[deps.OrdinaryDiffEqBDF]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqSDIRK", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "91e905c2224aa865ec545c5e7fd53c9a1020afa9"
uuid = "6ad6398a-0878-4a85-9266-38940aa047c8"
version = "2.1.1"

[[deps.OrdinaryDiffEqCore]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "ConcreteStructs", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "EnzymeCore", "FastBroadcast", "FastClosures", "FastPower", "FunctionWrappersWrappers", "InteractiveUtils", "LinearAlgebra", "Logging", "MacroTools", "MuladdMacro", "PrecompileTools", "Preferences", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLLogging", "SciMLOperators", "SciMLStructures", "SymbolicIndexingInterface", "TruncatedStacktraces"]
git-tree-sha1 = "a520345feb7ad2374786d748fad064cb3eef2a29"
uuid = "bbf590c4-e513-4bbe-9b18-05decba2e5d8"
version = "4.2.1"

    [deps.OrdinaryDiffEqCore.extensions]
    OrdinaryDiffEqCoreMooncakeExt = "Mooncake"
    OrdinaryDiffEqCorePolyesterExt = "Polyester"
    OrdinaryDiffEqCoreSparseArraysExt = "SparseArrays"

    [deps.OrdinaryDiffEqCore.weakdeps]
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.OrdinaryDiffEqDefault]]
deps = ["ADTypes", "DiffEqBase", "EnumX", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "PrecompileTools", "Preferences", "Reexport", "SciMLBase"]
git-tree-sha1 = "60c06fe39b257d1b222f188902f9648681386652"
uuid = "50262376-6c5a-4cf5-baba-aaf4f84d72d7"
version = "2.2.0"

[[deps.OrdinaryDiffEqDifferentiation]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "ConstructionBase", "DiffEqBase", "DifferentiationInterface", "FastBroadcast", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqCore", "SciMLBase", "SciMLOperators", "SparseMatrixColorings", "StaticArraysCore"]
git-tree-sha1 = "d9e7e8b9a6f7edf8c8ce9bba1f2cc9f8ad3a6752"
uuid = "4302a76b-040a-498a-8c04-15b101fed76b"
version = "3.1.1"
weakdeps = ["SparseArrays"]

    [deps.OrdinaryDiffEqDifferentiation.extensions]
    OrdinaryDiffEqDifferentiationSparseArraysExt = "SparseArrays"

[[deps.OrdinaryDiffEqNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FastClosures", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "PreallocationTools", "RecursiveArrayTools", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "SparseArrays", "StaticArraysCore"]
git-tree-sha1 = "c3e92bdb7bf16385e6f7b505f78601a2708eff28"
uuid = "127b3ac7-2247-4354-8eb6-78cf4e7c58e8"
version = "2.0.0"

[[deps.OrdinaryDiffEqRosenbrock]]
deps = ["ADTypes", "DiffEqBase", "DifferentiationInterface", "FastBroadcast", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqRosenbrockTableaus", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "4b2fca93815c1b15eb9cb32cacd782b487654ea4"
uuid = "43230ef6-c299-4910-a778-202eb28ce4ce"
version = "2.2.0"

[[deps.OrdinaryDiffEqRosenbrockTableaus]]
git-tree-sha1 = "66acd57301ea9c79ff92b13b72135af258c141ab"
uuid = "b4bd8bb3-f80f-41d2-9b21-73a655b304b9"
version = "2.0.0"

[[deps.OrdinaryDiffEqSDIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "2cb0775d8a6e68b901868f897ee7680e7272a9d8"
uuid = "2d112036-d095-4a1e-ab9a-08536f3ecdbf"
version = "2.4.0"

[[deps.OrdinaryDiffEqTsit5]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "21f58fc5ef0103d7708fc3a2b7b24ef16353d883"
uuid = "b1df2697-797e-41e3-8120-5422d3b24e4a"
version = "2.0.1"

[[deps.OrdinaryDiffEqVerner]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "6061884927ecbd67f44d1ea655379ada4e3fdac9"
uuid = "79d7bb75-1356-48c1-b8c0-6832512096c2"
version = "2.1.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.44.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58e5ed5e386e156bd93e86b305ebd21ac63d2d04"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.57.1+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "5d5e0a78e971354b1c7bff0655d11fdc1b0e12c8"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "e4a6721aa89e62e5d4217c0b21bd714263779dda"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.46.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.1"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "26ca162858917496748aad52bb5d3be4d26a228a"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.4"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Colors", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "6256ab3ee24ef079b3afa310593817e069925eeb"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.23"

    [deps.PlotlyBase.extensions]
    DataFramesExt = "DataFrames"
    DistributionsExt = "Distributions"
    IJuliaExt = "IJulia"
    JSON3Ext = "JSON3"

    [deps.PlotlyBase.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "cb20a4eacda080e517e4deb9cfb6c7c518131265"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.41.6"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "79436d2d6f29a5d5b4e4749043a3f190d55631a3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.81"

[[deps.PoissonRandom]]
deps = ["LogExpFunctions", "PrecompileTools", "Random"]
git-tree-sha1 = "9aa6eddbbe82a0b472b9b0bb93c3d5cd13b60950"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.8"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "PrecompileTools"]
git-tree-sha1 = "e16b73bf892c55d16d53c9c0dbd0fb31cb7e25da"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "1.2.0"

    [deps.PreallocationTools.extensions]
    PreallocationToolsForwardDiffExt = "ForwardDiff"
    PreallocationToolsReverseDiffExt = "ReverseDiff"
    PreallocationToolsSparseConnectivityTracerExt = "SparseConnectivityTracer"

    [deps.PreallocationTools.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseConnectivityTracer = "9f842d2f-2579-4b1d-911e-f412cf18a3f5"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "25cdd1d20cd005b52fc12cb6be3f75faaf59bb9b"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "144895f6166994730ee7ff8113b981fc360638f1"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.10.2+2"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll", "Qt6Svg_jll"]
git-tree-sha1 = "d5b7dd0e226774cbd87e2790e34def09245c7eab"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.10.2+1"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "4d85eedf69d875982c46643f6b4f66919d7e157b"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.10.2+1"

[[deps.Qt6Svg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "81587ff5ff25a4e1115ce191e36285ede0334c9d"
uuid = "6de9746b-f93d-5813-b365-ba18ad4a9cf3"
version = "6.10.2+0"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "672c938b4b4e3e0169a07a5f227029d4905456f2"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.10.2+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.ReadOnlyArrays]]
git-tree-sha1 = "e6f7ddf48cf141cb312b078ca21cb2d29d0dc11d"
uuid = "988b38a3-91fc-5605-94a2-ee2116b3bd83"
version = "0.2.0"

[[deps.ReadOnlyDicts]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "711acef70140078d808be9cd33040f510af57f5e"
uuid = "795d4caa-f5a7-4580-b5d8-c01d53451803"
version = "1.0.1"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "LinearAlgebra", "PrecompileTools", "RecipesBase", "StaticArraysCore", "SymbolicIndexingInterface"]
git-tree-sha1 = "57b6fb3932fc8d1fc911f840d2c9de5fe3ba5008"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "4.3.0"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsCUDAExt = "CUDA"
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsFastBroadcastPolyesterExt = ["FastBroadcast", "Polyester"]
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsKernelAbstractionsExt = "KernelAbstractions"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsMooncakeExt = "Mooncake"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsSparseArraysExt = ["SparseArrays"]
    RecursiveArrayToolsStatisticsExt = "Statistics"
    RecursiveArrayToolsStructArraysExt = "StructArrays"
    RecursiveArrayToolsTablesExt = ["Tables"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "28154d426e557495aa75097861b18c11f2541ded"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.19"

[[deps.SCCNonlinearSolve]]
deps = ["CommonSolve", "PrecompileTools", "Reexport", "SciMLBase", "SymbolicIndexingInterface"]
git-tree-sha1 = "521a298294a6fd11068df0148b4d57bb31550453"
uuid = "9dfe8606-65a1-4bb3-9748-cb89d1561431"
version = "1.13.0"

    [deps.SCCNonlinearSolve.extensions]
    SCCNonlinearSolveChainRulesCoreExt = "ChainRulesCore"

    [deps.SCCNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SafeTestsets]]
git-tree-sha1 = "81ec49d645af090901120a1542e67ecbbe044db3"
uuid = "1bc83da4-3b8d-516f-aca4-4fe02f6d838f"
version = "0.1.0"

[[deps.SciMLBase]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PreallocationTools", "PrecompileTools", "Preferences", "Printf", "Random", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLLogging", "SciMLOperators", "SciMLPublic", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "a72c70a892d86b2216722f354d14013972129346"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "3.14.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseDifferentiationInterfaceExt = "DifferentiationInterface"
    SciMLBaseDistributionsExt = "Distributions"
    SciMLBaseEnzymeExt = "Enzyme"
    SciMLBaseForwardDiffExt = "ForwardDiff"
    SciMLBaseMakieExt = "Makie"
    SciMLBaseMeasurementsExt = "Measurements"
    SciMLBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    SciMLBaseMooncakeExt = "Mooncake"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseReverseDiffExt = "ReverseDiff"
    SciMLBaseTrackerExt = "Tracker"
    SciMLBaseZygoteExt = ["Zygote", "ChainRulesCore"]

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DifferentiationInterface = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLJacobianOperators]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "ConstructionBase", "DifferentiationInterface", "FastClosures", "LinearAlgebra", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "7156a5b51cba1bea33a82a036939ead4131f92bc"
uuid = "19f34311-ddf3-4b8b-af20-060888a46c0e"
version = "0.1.13"

[[deps.SciMLLogging]]
deps = ["Logging", "LoggingExtras", "Preferences"]
git-tree-sha1 = "3f98a53703f925cbd5aac5da4924f82ca34d09ab"
uuid = "a6db7da4-7206-11f0-1eab-35f2a5dbe1d1"
version = "2.0.0"

    [deps.SciMLLogging.extensions]
    SciMLLoggingTracyExt = "Tracy"

    [deps.SciMLLogging.weakdeps]
    Tracy = "e689c965-62c8-4b79-b2c5-8359227902fd"

[[deps.SciMLOperators]]
deps = ["Accessors", "Adapt", "ArrayInterface", "DocStringExtensions", "LinearAlgebra", "SafeTestsets"]
git-tree-sha1 = "50e6ec6879eab12b039924d5a10b91c95bf9bf7f"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "1.21.0"

    [deps.SciMLOperators.extensions]
    SciMLOperatorsLoopVectorizationExt = "LoopVectorization"
    SciMLOperatorsSparseArraysExt = "SparseArrays"
    SciMLOperatorsStaticArraysCoreExt = "StaticArraysCore"

    [deps.SciMLOperators.weakdeps]
    LoopVectorization = "bdcacae8-1622-11e9-2a5c-532679323890"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"

[[deps.SciMLPublic]]
git-tree-sha1 = "0ba076dbdce87ba230fff48ca9bca62e1f345c9b"
uuid = "431bcebd-1456-4ced-9d72-93c2757fff0b"
version = "1.0.1"

[[deps.SciMLStructures]]
deps = ["ArrayInterface", "PrecompileTools"]
git-tree-sha1 = "607f6867d0b0553e98fc7f725c9f9f13b4d01a32"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.10.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "c5391c6ace3bc430ca630251d02ea9687169ca68"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.2"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "BracketingNonlinearSolve", "CommonSolve", "ConcreteStructs", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "d688de789b7e643326caf9a1051376dadbcd8873"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "2.11.1"

    [deps.SimpleNonlinearSolve.extensions]
    SimpleNonlinearSolveChainRulesCoreExt = "ChainRulesCore"
    SimpleNonlinearSolveReverseDiffExt = "ReverseDiff"
    SimpleNonlinearSolveTrackerExt = "Tracker"

    [deps.SimpleNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "7ddb0b49c109481b046972c0e4ab02b2127d6a75"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.6"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.SparseMatrixColorings]]
deps = ["ADTypes", "DocStringExtensions", "LinearAlgebra", "PrecompileTools", "Random", "SparseArrays"]
git-tree-sha1 = "f63d76c7b7c329cf11badd564fd8ba877b09c3fe"
uuid = "0a514795-09f3-496d-8182-132a7b665d35"
version = "0.4.27"

    [deps.SparseMatrixColorings.extensions]
    SparseMatrixColoringsCUDAExt = ["CUDA", "cuSPARSE"]
    SparseMatrixColoringsCliqueTreesExt = "CliqueTrees"
    SparseMatrixColoringsColorsExt = "Colors"
    SparseMatrixColoringsGPUArraysExt = "GPUArrays"
    SparseMatrixColoringsJuMPExt = ["JuMP", "MathOptInterface"]

    [deps.SparseMatrixColorings.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CliqueTrees = "60701a23-6482-424a-84db-faee86b9b1f8"
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
    GPUArrays = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
    JuMP = "4076af6c-e467-56ae-b986-b466b2749572"
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
    cuSPARSE = "b26da814-b3bc-49ef-b0ee-c816305aa060"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2700b235561b0335d5bef7097a111dc513b8655e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.7.2"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "4f96c596b8c8258cc7d3b19797854d368f243ddc"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.4"

[[deps.StarAlgebras]]
deps = ["LinearAlgebra", "MutableArithmetics", "SparseArrays"]
git-tree-sha1 = "235b1f9d287bbf34083b3d0829343a7942c0ad1c"
uuid = "0c0c59c1-dc5f-42e9-9a8b-b5dc384a6cd1"
version = "0.3.0"

[[deps.StateSelection]]
deps = ["BipartiteGraphs", "DocStringExtensions", "FindFirstFunctions", "Graphs", "LinearAlgebra", "OrderedCollections", "Setfield", "SparseArrays"]
git-tree-sha1 = "824641f6d414f0885200e034e3853c3c2f61ac43"
uuid = "64909d44-ed92-46a8-bbd9-f047dfbdc84b"
version = "1.9.2"

    [deps.StateSelection.extensions]
    StateSelectionDeepDiffsExt = "DeepDiffs"

    [deps.StateSelection.weakdeps]
    DeepDiffs = "ab62b9b5-e342-54a8-a765-a90f495de1a6"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "246a8bb2e6667f832eea063c3a56aef96429a3db"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.18"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6ab403037779dae8c514bad259f32a447262455a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "aceda6f4e598d331548e04cc6b2124a6148138e3"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.10"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "82bee338d650aa515f31866c460cb7e3bcef90b8"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.8.2"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsStaticArraysCoreExt = ["StaticArraysCore"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.SymbolicIndexingInterface]]
deps = ["Accessors", "ArrayInterface", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "64b15330b9e3c91a86bcac92f369c58e382981c6"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.48"

    [deps.SymbolicIndexingInterface.extensions]
    SymbolicIndexingInterfacePrettyTablesExt = "PrettyTables"

    [deps.SymbolicIndexingInterface.weakdeps]
    PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[[deps.SymbolicLimits]]
deps = ["SymbolicUtils", "TermInterface"]
git-tree-sha1 = "5085671d2cba1eb02136a3d6661c583e801984c1"
uuid = "19f23fe9-fdab-4a78-91af-e7b7767979c3"
version = "1.1.0"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "ArrayInterface", "Combinatorics", "ConstructionBase", "DataStructures", "Dictionaries", "DocStringExtensions", "DynamicPolynomials", "EnumX", "ExproniconLite", "Graphs", "LinearAlgebra", "MacroTools", "Moshi", "MultivariatePolynomials", "MutableArithmetics", "NaNMath", "PrecompileTools", "ReadOnlyArrays", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArraysCore", "SymbolicIndexingInterface", "TaskLocalValues", "TermInterface", "WeakCacheSets"]
git-tree-sha1 = "34dc235ba7eff386571020afc6317072f61fa3b5"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "4.30.1"

    [deps.SymbolicUtils.extensions]
    SymbolicUtilsChainRulesCoreExt = "ChainRulesCore"
    SymbolicUtilsDistributionsExt = "Distributions"
    SymbolicUtilsLabelledArraysExt = "LabelledArrays"
    SymbolicUtilsReverseDiffExt = "ReverseDiff"

    [deps.SymbolicUtils.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.Symbolics]]
deps = ["ADTypes", "AbstractPlutoDingetjes", "ArrayInterface", "Bijections", "CommonWorldInvalidations", "ConstructionBase", "DataStructures", "DiffRules", "DocStringExtensions", "DomainSets", "DynamicPolynomials", "Libdl", "LinearAlgebra", "LogExpFunctions", "MacroTools", "Markdown", "Moshi", "MultivariatePolynomials", "MutableArithmetics", "NaNMath", "PrecompileTools", "Preferences", "Primes", "RecipesBase", "Reexport", "RuntimeGeneratedFunctions", "SciMLPublic", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArraysCore", "SymbolicIndexingInterface", "SymbolicLimits", "SymbolicUtils", "TermInterface"]
git-tree-sha1 = "0ce0417bfcb78e8304552f15fe3de4f1b477b925"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "7.24.2"

    [deps.Symbolics.extensions]
    SymbolicsD3TreesExt = "D3Trees"
    SymbolicsDistributionsExt = "Distributions"
    SymbolicsForwardDiffExt = "ForwardDiff"
    SymbolicsGroebnerExt = "Groebner"
    SymbolicsHypergeometricFunctionsExt = "HypergeometricFunctions"
    SymbolicsLatexifyExt = ["Latexify", "LaTeXStrings"]
    SymbolicsNemoExt = "Nemo"
    SymbolicsPreallocationToolsExt = ["PreallocationTools", "ForwardDiff"]
    SymbolicsSymPyExt = "SymPy"
    SymbolicsSymPyPythonCallExt = "SymPyPythonCall"

    [deps.Symbolics.weakdeps]
    D3Trees = "e3df1716-f71e-5df9-9e2d-98e193103c45"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Groebner = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
    HypergeometricFunctions = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
    LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
    Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
    Nemo = "2edaba10-b0f1-5616-af89-8c11ac63239a"
    PreallocationTools = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
    SymPyPythonCall = "bc8888f7-b21e-4b7c-a06a-5d9c9496438c"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TaskLocalValues]]
git-tree-sha1 = "67e469338d9ce74fc578f7db1736a74d93a49eb8"
uuid = "ed4db957-447d-4319-bfb6-7fa9ae7ecf34"
version = "0.1.3"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TermInterface]]
git-tree-sha1 = "d673e0aca9e46a2f63720201f55cc7b3e7169b16"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "2.0.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "3748bd928e68c7c346b52125cf41fff0de6937d0"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.29"

    [deps.TimerOutputs.extensions]
    FlameGraphsExt = "FlameGraphs"

    [deps.TimerOutputs.weakdeps]
    FlameGraphs = "08572546-2f56-4bcf-ba4e-bab62c3a3f89"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "96478df35bbc2f3e1e791bc7a3d0eeee559e60e9"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.24.0+0"

[[deps.WeakCacheSets]]
git-tree-sha1 = "386050ae4353310d8ff9c228f83b1affca2f7f38"
uuid = "d30d5f5c-d141-4870-aa07-aabb0f5fe7d5"
version = "0.1.0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b29c22e245d092b8b4e8d3c09ad7baa586d9f573"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.3+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "808090ede1d41644447dd5cbafced4731c56bd2f"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.13+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "1a4a26870bf1e5d26cd585e38038d399d7e65706"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.8+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "75e00946e43621e09d431d9b95818ee751e6b2ef"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.2+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "0ba01bc7396896a4ace8aab67db31403c71628f4"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.7+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c174ef70c96c76f4c3f4d3cfbe09d018bcd1b53"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libpciaccess_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "58972370b81423fc546c56a60ed1a009450177c3"
uuid = "a65dc6b1-eb27-53a1-bb3e-dea574b5389e"
version = "0.19.0+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "ed756a03e95fff88d8f738ebc2849431bdd4fd1a"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.2.0+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "9750dc53819eba4e9a20be42349a6d3b86c7cdf8"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.6+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f4fc02e384b74418679983a97385644b67e1263b"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll"]
git-tree-sha1 = "68da27247e7d8d8dafd1fcf0c3654ad6506f5f97"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "44ec54b0e2acd408b0fb361e1e9244c60c9c3dd4"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "5b0263b6d080716a02544c55fdff2c8d7f9a16a0"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.10+0"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f233c83cad1fa0e70b7771e0e21b061a116f2763"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.2+0"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "ed349d26affcacafbc7fc2941ace1fb98f71e715"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.47.0+1"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c3b0e6196d50eab0c5ed34021aaa0bb463489510"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.14+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "850b06095ee71f0135d644ffd8a52850699581ed"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.13.3+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libdrm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libpciaccess_jll"]
git-tree-sha1 = "63aac0bcb0b582e11bad965cef4a689905456c03"
uuid = "8e53e030-5e6c-5a89-a30b-be5b7263a166"
version = "2.4.125+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56d643b57b188d30cccc25e331d416d3d358e557"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.13.4+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "646634dd19587a56ee2f1199563ec056c5f228df"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.4+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "91d05d7f4a9f67205bd6cf395e488009fe85b499"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.28.1+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e51150d5ab85cee6fc36726850f0e627ad2e4aba"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.58+0"

[[deps.libva_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "libdrm_jll"]
git-tree-sha1 = "7dbf96baae3310fe2fa0df0ccbb3c6288d5816c9"
uuid = "9a156e7d-b971-5f62-b2c9-67348b8fb97c"
version = "2.23.0+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll"]
git-tree-sha1 = "11e1772e7f3cc987e9d3de991dd4f6b2602663a5"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.8+0"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b4d631fd51f2e9cdd93724ae25b2efc198b059b1"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.7+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "da8c1f6eee04831f14edcfa5dae611d309807e57"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2022.3.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.7.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e7b67590c14d487e734dcb925924c5dc43ec85f3"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "4.1.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "a1fc6507a40bf504527d0d4067d718f8e179b2b8"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.13.0+0"
"""

# ╔═╡ Cell order:
# ╟─a72d89aa-6108-40a2-afbb-b9edd0c90b8f
# ╟─1e7b849d-2b10-4fec-93b4-c33d231abfa9
# ╟─684ab7f8-a5db-4c39-a3cc-ce948dd026b0
# ╟─19ea7ddf-f62b-4dd9-95bb-d71ac9c375a0
# ╟─ac777efc-f848-4358-afd2-a1af334752b3
# ╟─fc95aba1-5f63-44ee-815c-e9f181219253
# ╟─bf5da9c2-bb7b-46d2-8b39-a362eaf9e6f9
# ╟─cc1a1a9a-7a45-4231-8471-0fb90b994357
# ╟─ad15095c-a5bb-46e0-84a3-a20ce765b6c0
# ╟─fd5ac3bd-4190-4242-a460-b9f755082b8d
# ╟─4c3f3770-ef33-41a5-89a6-274101b06c87
# ╟─71baff78-d298-4c6a-99d5-6b65c1c27e6f
# ╟─70547a7e-c357-4787-9c34-d2789bb60860
# ╟─77d94a92-f058-4b9f-9df8-9de58603c293
# ╟─e0581cf3-f942-45a6-bcf2-9e72ba2379a4
# ╟─28def719-c8e2-43d6-b20e-6141e423add2
# ╠═e972417e-efc2-4fac-a775-843cedcd370f
# ╠═01ce7903-0ba3-45bc-816a-f8288583b4d4
# ╠═6bfa46a7-f50d-49b6-bebc-b7821f89100f
# ╟─52d9452b-5c1e-42ea-8976-0ec2f30eaaf8
# ╠═c6daea2a-ce72-4b32-b828-48be9ba1f961
# ╠═43593199-0107-4b69-a239-f9f68c14b8eb
# ╟─4b731a5f-3fe2-4691-8f89-c37f05d623ab
# ╟─416dc725-d1c1-4b14-9315-aa57d9e1127d
# ╠═671ad109-4bea-426f-b5c2-2dcabb53a7be
# ╟─56714c4c-daed-47e2-bda7-ab5518e16faa
# ╠═b0a09135-8cec-460c-88bb-c91ee832a55b
# ╠═3bd175bd-0019-40bc-a1f7-9f94e94ddb87
# ╟─63181343-9e48-4cdc-8888-c5476b4d75cd
# ╟─c32431fb-0cf4-4ef0-8b6e-5a76a93de260
# ╟─122b4bc2-24df-423c-904b-158cc0790abe
# ╠═dd6bea4d-35fc-4cea-956c-00db08a1f511
# ╟─6bc0dccf-eacd-4261-a9ff-fb67a4fbd5c6
# ╟─637ef564-718f-4a4c-ac6c-cd9fd2802e16
# ╟─49f7ca3c-4b9d-4145-9faa-70d082a5c8d9
# ╟─7551684a-04cd-4d6d-bb9e-b7f4aa46aceb
# ╟─14b18562-5701-4a08-aba0-fc31e8d6306f
# ╟─3f6c6d86-0ba1-4b63-ac50-f1d4460ea90a
# ╟─ec47f63d-36eb-4331-aec9-9f1af15a3eab
# ╟─0f22c808-a413-415e-95d1-98317ca6ed25
# ╟─c1918d6a-3b5a-4046-b084-e6f98eaabee6
# ╟─ab1836a1-290d-4bde-bf1b-cc8287734e1e
# ╠═dc366710-6f43-434c-8787-d6d1a7dd3920
# ╟─6aa3249f-4751-45d9-b13d-f748cc950d47
# ╠═d4446f64-8d69-4ded-90b3-59544800d6fa
# ╟─1a6574d3-a3d3-4b77-a481-8f0dfad1628a
# ╠═9358905f-8d2f-40f6-a9d9-38e39ae3ee85
# ╠═68c6f9c8-2e76-4b08-8b9b-f18b13a4a50b
# ╠═d04d419b-2fc0-4b3a-bb78-ea3b6b76bc64
# ╟─572dff66-18d8-4b0f-be6e-75767ac33be0
# ╟─4a97986a-e5d0-4b56-bfb3-022ed9037dd7
# ╟─603aea40-5cb1-4ef0-9bee-f7476c815833
# ╟─10febcf4-5c69-436b-af91-f886ac6e34ad
# ╟─8c51a878-6466-4832-ad74-c90683614ebc
# ╟─e5deaa27-54cb-4f48-8f56-b55c3a797dcf
# ╟─d59c9761-382e-4450-b654-dc4b8b203f15
# ╟─b2e6544a-2e87-439c-9b25-de60518f1970
# ╟─e831d3ab-8122-4cb6-9dfc-ebbfb241f0c9
# ╟─51f33f5c-06c4-4a6c-9f91-6dd5f0822043
# ╟─e515330c-d97a-4b66-b40c-fe44ea300bb2
# ╟─42d42106-a896-4ac0-a476-8590a87b1428
# ╟─4af55826-0499-4397-bf44-1ea28ab8de80
# ╟─d923c200-843d-44e8-8870-6b44183a779a
# ╟─5141dd63-ebfb-4b75-a0a3-8a0dd1163169
# ╠═2cb27c2f-edae-4386-a68d-77b2050924a0
# ╠═6467d83d-0e9c-4025-aecf-ab19807e6ba7
# ╟─a0f73d60-1f65-4b1d-9f13-e4f3ba842ca6
# ╠═26050146-bacf-42c2-b56b-4e2ddf27b19d
# ╠═2847c8b9-0ac8-4b90-a23b-6323414b3d1b
# ╠═d60f5b1d-132d-4d76-8060-d6365b95e923
# ╟─33ba58f3-9959-48ec-a7f0-098b864ba02f
# ╟─bb435da5-5bd0-4944-abf1-5d54888efa53
# ╟─f2bfba1b-6be2-4e30-a886-617c30f8b027
# ╟─cd316741-bb6b-4000-87a8-5d5daf0bbb6b
# ╟─7d8c6ed0-f70c-42ae-9f89-1eb5a4a1447b
# ╟─94b4f52b-ae28-4e26-93d2-7e7d32c739d5
# ╟─f13c3c52-7c73-4aa3-a233-3d64f4623b89
# ╟─97564904-a6ce-497b-9bbc-e978c6877f0c
# ╟─874323d9-2910-4c77-8aa1-902df4990105
# ╟─79489f1f-b8a7-4800-b9ec-feaf6fa134b1
# ╟─f804a947-4e16-4871-84e3-8654d4fb0a46
# ╟─5e8a9df5-26ac-4ee0-a647-5088bfb43b25
# ╠═3d9aacb9-1307-4a80-a277-60fe3a66e7ed
# ╠═06efabb8-15dc-4952-9f5b-fabadd13a87a
# ╟─68a8c259-1388-476d-be13-cd4e0f9eecd1
# ╠═8a8733d1-89ae-4a0b-a218-72127fd14e0b
# ╠═e5fc55c6-c292-494d-9a56-9506eb95c80d
# ╠═7b660a3d-3fe3-4d48-be37-49754fa70b16
# ╟─ab916a56-52ff-4f35-b8ba-72f2d3d7ba9a
# ╟─fcbc4792-866f-4dd1-9b41-a7bb7b1db5fd
# ╟─2a3e5049-9ded-427b-b719-f9ef48164bb6
# ╟─6642ec56-0093-4497-9bea-a05afd8e7507
# ╟─00b880d1-3db4-40a6-aff4-03a4900df99d
# ╟─d5c896f3-1aa8-4334-8c7c-7b01b122aa1b
# ╟─53c4ef85-6f0c-46d8-a08a-28f8ab368309
# ╟─22d85cbc-0e8f-49c9-9045-3b56d2a3c2f0
# ╟─bc1471e4-925f-4583-b9b1-193ca59748be
# ╟─aee9374d-fefc-409b-99f0-67de38071f52
# ╟─f7e79c80-1da8-4b95-9447-6107a9e8f2df
# ╟─4c4cd287-71d4-4845-b466-3d135610858b
# ╠═806d844d-a02e-4b50-bb51-132513003cbf
# ╟─7f08a0fa-7cec-4a76-81ec-1076243ed670
# ╠═edd1f38c-60a9-4dee-afe1-c674907a652c
# ╟─bbe1d37f-2517-4c61-820a-e0ca5876e435
# ╠═edcdc582-e2ba-4aaa-b6c7-3c82c540502c
# ╠═59a77cd5-35de-4e27-9539-43f0d6c791ac
# ╟─9eecf8d1-9e97-4965-92b8-510646bfe273
# ╠═c841be91-502b-4b30-9af0-ba10e5d71558
# ╟─bec60bab-cce9-44a3-980e-6b9a5bad3b0a
# ╠═89a66b68-dfaf-454f-b787-96fabb978e7a
# ╠═1e457fe1-6cc5-4d2e-812e-13f666747d81
# ╠═2cfac784-ec48-4963-a12d-d8bac6ae41cc
# ╟─63c5fab1-fb11-4d9a-b2fc-8a23598602ba
# ╟─333e8b9c-0595-4908-9741-ab75d6e6b3b9
# ╟─1d6f6649-ddee-42d7-a0b8-29e03f3ac0f8
# ╟─25089138-341a-413c-a19e-b56860faaf8d
# ╟─faa4969c-7c76-48bc-a4f8-9a08d2cd16a0
# ╟─028b2237-e62a-403b-8d6c-786accb8c782
# ╟─4e947fbc-84f4-460d-9079-0e7397f5d05f
# ╟─5efa346c-4d46-4c5c-9e14-08015a96bd85
# ╟─8b7b8608-8d85-4920-a452-b32706adfc17
# ╟─3919e8ab-487d-4a6e-b462-73a9dfbac5e7
# ╟─9148f8b0-e379-43aa-88f5-8c41a2ea62ca
# ╟─74955738-33ca-4e6a-bde2-8080b32099c6
# ╠═c3e21fa0-ce32-4919-bc18-16616dadcee1
# ╠═ebad16ee-5c44-4313-9cdf-413ccd4fcfa0
# ╠═8a0b1af6-2df6-4f98-9f3e-0714b19b9b69
# ╟─e28d682e-f392-4e58-8917-b47b6423c7e4
# ╠═a1c2d060-912b-441c-b986-2bac1a433c49
# ╠═80aeb76f-4ab2-468f-95ef-f36491f4642e
# ╠═3eb51a7d-3a7e-4d5b-a635-71a4962dd2d9
# ╟─70de0532-94df-4466-acc4-7a8157bd0262
# ╟─711bd169-61c7-4dc4-afc9-8829155d71fe
# ╟─bc872c1c-0b47-47d6-840b-3b988955dfc8
# ╠═dc1d776f-a7ad-494d-8dc2-b4e28ce623d3
# ╟─d1b89ad6-9116-48b4-805f-f1ba6b15b3dc
# ╠═e5a804cc-0cbe-4645-974b-0fca7cb366e0
# ╟─c3ba93bf-710b-4ccf-8800-c34af7b61a42
# ╟─12d39fca-5e5c-4b01-8080-7099c151e5ec
# ╟─427d7fd4-af60-4b3b-9d43-3cc6511e281d
# ╟─a7819b3e-6929-4d97-8860-b5eeb0c4d39a
# ╟─42094ddf-3b6e-496d-9624-30723db25590
# ╟─63e7170f-a3b4-4403-830c-7351ae309a3d
# ╟─14945142-2a86-43dc-ae4d-92a3270ed725
# ╟─fac12d85-045d-4e67-b3e8-d76f9285a297
# ╟─e2ce7fa8-83d6-4fa0-9c42-6148c7884b96
# ╟─6b4feee8-f8bb-4639-a423-97e7ab82cad0
# ╟─61897e7f-eac1-4eea-a679-4cb53757ee7f
# ╟─19b3047c-6b4d-4e54-a932-1030a31dd713
# ╟─6d79981a-47ac-4434-90e1-81b4c841108e
# ╟─2462b985-9c4a-446a-b8ea-3d5f6c7543c0
# ╟─2a5599e2-77ff-4951-8873-a3bd145b614f
# ╟─ca777958-84f4-42ef-95f7-1b0778620e0c
# ╟─0dd7fd47-6575-4b9d-938f-012cff42692d
# ╟─2c4171e0-8fc6-49d2-ba39-f987b634abda
# ╟─90673d7c-9ebf-4d31-8f89-7a3e1325c373
# ╟─a2fe2c48-bbb1-4601-96b2-470e1768c102
# ╟─91a92730-965a-44a6-87a9-ba350f6614ca
# ╟─b7213dcc-a2de-4507-a869-7f109d5a52ca
# ╟─f21ad23e-dcdd-46fa-b10e-fd115c17eb98
# ╟─7fb8d441-3685-4673-a959-75901d5ad06d
# ╟─89e74250-9d4b-49cc-9f12-2a4e6d921b90
# ╟─8c37e496-4f0b-4151-991a-4bccf66e35f8
# ╟─7df920cf-b634-40c9-913a-bc26732f486e
# ╟─89b55225-e4df-4be3-a34e-e0fe31c1ba0a
# ╟─aa1fb294-a0d2-41b0-8237-3590d16d0573
# ╟─f440930e-c68f-40ee-8d1b-cc510400e872
# ╟─5fa09f27-7cea-44db-80f9-0eda7f483860
# ╟─5300382d-e093-4e13-ba61-ab3dd3337f3f
# ╠═6cd0ec91-dc46-48e1-ab69-425780b03a16
# ╟─925feb4c-6f29-4dff-8e9e-f5032b47ac22
# ╠═66de57a4-18db-41fc-ba0f-8b889c4c4e66
# ╠═72977094-d304-4c01-86e2-d9ef5742dea3
# ╠═1c31fe3f-2b18-4c4d-a1b1-3304c3d779d7
# ╠═ceb98ac3-7a3d-4dbe-a5df-8183878afb1f
# ╟─24c846f3-3c61-4f9b-b243-d303451bcfdf
# ╟─411354b2-f9b7-46cc-9fe2-358f2d691dfe
# ╟─53b2a3e8-c8a9-4dae-92df-f3b9af112fda
# ╟─af04b82f-fb35-4eda-a941-34d9f798b035
# ╟─6f38c085-ffaf-4df5-9d83-217dc045d615
# ╟─4da94e9b-f009-48e5-b9ac-cae6e4d7495e
# ╟─491f715e-048f-4bc4-b62b-9d9f622d835b
# ╟─230a4e8a-6eb7-4b0a-84a7-c86019060062
# ╟─daf4dd3e-9427-4baa-836e-e1d524c0a170
# ╟─88b3d429-4acd-4115-82da-972db1c5b501
# ╟─ad0b76a6-46ce-42e0-82a5-e2230efc5d3b
# ╟─ac29d04e-1c97-4062-85c9-522d094a8749
# ╟─5d7d7822-61c9-47a1-830b-6b0294531d5c
# ╟─813fc6b1-460a-49cb-9ae5-909e38e18e71
# ╠═00edd691-2b60-4d1d-b5e2-2fd4675469da
# ╠═7a937f2c-5808-4756-9bfc-6f84b0f03cc9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
