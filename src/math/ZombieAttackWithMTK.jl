### A Pluto.jl notebook ###
# v0.20.17

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
HypertextLiteral = "~0.9.5"
ModelingToolkit = "~10.21.0"
OrdinaryDiffEq = "~6.102.0"
Parameters = "~0.12.3"
PlotlyBase = "~0.8.21"
Plots = "~1.40.19"
PlutoUI = "~0.7.71"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.6"
manifest_format = "2.0"
project_hash = "f9137265d82761af98335c81eb82dd2b554e8ed5"

[[deps.ADTypes]]
git-tree-sha1 = "60665b326b75db6517939d0e1875850bc4a54368"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.17.0"
weakdeps = ["ChainRulesCore", "ConstructionBase", "EnzymeCore"]

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesConstructionBaseExt = "ConstructionBase"
    ADTypesEnzymeCoreExt = "EnzymeCore"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "MacroTools"]
git-tree-sha1 = "3b86719127f50670efe356bc11073d84b4ed7a5d"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.42"

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
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "f7817e2e585aa6d924fd714df1e2a84be7896c60"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.3.0"
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
git-tree-sha1 = "9606d7832795cbef89e06a550475be300364a8aa"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.19.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesCoreExt = "ChainRulesCore"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "120e392af69350960b1d3b89d41dcc1d66543858"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.11.2"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Bijections]]
git-tree-sha1 = "a2d308fcd4c2fb90e943cf9cd2fbfa9c32b69733"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.2.2"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.BlockArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra"]
git-tree-sha1 = "84a4360c718e7473fec971ae27f409a2f24befc8"
uuid = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
version = "1.7.1"

    [deps.BlockArrays.extensions]
    BlockArraysAdaptExt = "Adapt"
    BlockArraysBandedMatricesExt = "BandedMatrices"

    [deps.BlockArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"

[[deps.BracketingNonlinearSolve]]
deps = ["CommonSolve", "ConcreteStructs", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "a9014924595b7a2c1dd14aac516e38fa10ada656"
uuid = "70df07ce-3d50-431d-a3e7-ca6ddb60ac1e"
version = "1.3.0"
weakdeps = ["ChainRulesCore", "ForwardDiff"]

    [deps.BracketingNonlinearSolve.extensions]
    BracketingNonlinearSolveChainRulesCoreExt = ["ChainRulesCore", "ForwardDiff"]
    BracketingNonlinearSolveForwardDiffExt = "ForwardDiff"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Preferences", "Static"]
git-tree-sha1 = "f3a21d7fc84ba618a779d1ed2fcca2e682865bab"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.7"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fde3bf89aead2e723284a8ff9cdf5b551ed700e8"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.5+0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e4c6a16e77171a5f5e25e9646617ab1c276c5607"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.26.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "a656525c8b46aa6a1c76891552ed5381bb32ae7b"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.30.0"

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
git-tree-sha1 = "8010b6bb3388abe68d95743dcbea77650bb2eddf"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.3"

[[deps.CommonMark]]
deps = ["PrecompileTools"]
git-tree-sha1 = "351d6f4eaf273b753001b2de4dffb8279b100769"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.9.1"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

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
git-tree-sha1 = "0037835448781bb46feb39866934e243886d756a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

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
git-tree-sha1 = "f749037478283d372048690eb3b5f92a79432b34"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.3"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

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

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

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

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ConcreteStructs", "DocStringExtensions", "EnzymeCore", "FastBroadcast", "FastClosures", "FastPower", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "Setfield", "Static", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "TruncatedStacktraces"]
git-tree-sha1 = "50fe8e2c583a899506d2b8d777a0bd5beed9a33f"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.185.0"

    [deps.DiffEqBase.extensions]
    DiffEqBaseCUDAExt = "CUDA"
    DiffEqBaseChainRulesCoreExt = "ChainRulesCore"
    DiffEqBaseEnzymeExt = ["ChainRulesCore", "Enzyme"]
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
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
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
deps = ["ConcreteStructs", "DataStructures", "DiffEqBase", "DifferentiationInterface", "Functors", "LinearAlgebra", "Markdown", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "397ef6fffcf418ba55264ba785b032b8a136903b"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "4.9.0"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "ResettableStacks", "SciMLBase", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "516d553f5deee7c55b2945b5edf05b6542837887"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.24.1"

    [deps.DiffEqNoiseProcess.extensions]
    DiffEqNoiseProcessReverseDiffExt = "ReverseDiff"

    [deps.DiffEqNoiseProcess.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

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
git-tree-sha1 = "16946a4d305607c3a4af54ff35d56f0e9444ed0e"
uuid = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
version = "0.7.7"

    [deps.DifferentiationInterface.extensions]
    DifferentiationInterfaceChainRulesCoreExt = "ChainRulesCore"
    DifferentiationInterfaceDiffractorExt = "Diffractor"
    DifferentiationInterfaceEnzymeExt = ["EnzymeCore", "Enzyme"]
    DifferentiationInterfaceFastDifferentiationExt = "FastDifferentiation"
    DifferentiationInterfaceFiniteDiffExt = "FiniteDiff"
    DifferentiationInterfaceFiniteDifferencesExt = "FiniteDifferences"
    DifferentiationInterfaceForwardDiffExt = ["ForwardDiff", "DiffResults"]
    DifferentiationInterfaceGPUArraysCoreExt = "GPUArraysCore"
    DifferentiationInterfaceGTPSAExt = "GTPSA"
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

[[deps.DispatchDoctor]]
deps = ["MacroTools", "Preferences"]
git-tree-sha1 = "fc34127e78323c49984e1a146d577d0f890dd2b4"
uuid = "8d63f2c5-f18a-4cf2-ba9d-b3f60fc568c8"
version = "0.4.26"
weakdeps = ["ChainRulesCore", "EnzymeCore"]

    [deps.DispatchDoctor.extensions]
    DispatchDoctorChainRulesCoreExt = "ChainRulesCore"
    DispatchDoctorEnzymeCoreExt = "EnzymeCore"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "3e6d038b77f22791b8e3472b7c633acea1ecac06"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.120"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "c249d86e97a7e8398ce2068dce4c078a1c3464de"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.7.16"

    [deps.DomainSets.extensions]
    DomainSetsMakieExt = "Makie"
    DomainSetsRandomExt = "Random"

    [deps.DomainSets.weakdeps]
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DynamicPolynomials]]
deps = ["Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Reexport", "Test"]
git-tree-sha1 = "ca693f8707a77a0e365d49fe4622203b72b6cf1d"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.6.3"

[[deps.DynamicQuantities]]
deps = ["DispatchDoctor", "PrecompileTools", "TestItems", "Tricks"]
git-tree-sha1 = "44ec2bcde862031866a9f43ee477eaa1ddb0cccc"
uuid = "06fc5a27-2a28-4c7c-a15d-362465fb6821"
version = "1.8.0"

    [deps.DynamicQuantities.extensions]
    DynamicQuantitiesLinearAlgebraExt = "LinearAlgebra"
    DynamicQuantitiesMeasurementsExt = "Measurements"
    DynamicQuantitiesScientificTypesExt = "ScientificTypes"
    DynamicQuantitiesUnitfulExt = "Unitful"

    [deps.DynamicQuantities.weakdeps]
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.EnumX]]
git-tree-sha1 = "bddad79635af6aec424f53ed8aad5d7555dc6f00"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.5"

[[deps.EnzymeCore]]
git-tree-sha1 = "8272a687bca7b5c601c0c24fc0c71bff10aafdfd"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.8.12"
weakdeps = ["Adapt"]

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"

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
git-tree-sha1 = "7bb1361afdb33c7f2b085aa49ea8fe1b0fb14e58"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.7.1+0"

[[deps.ExplicitImports]]
deps = ["Markdown", "Pkg", "PrecompileTools", "TOML"]
git-tree-sha1 = "fde76669757deacce495be6018d17ffe9d70f214"
uuid = "7d51a73a-1435-4ff3-83d9-f097790105c7"
version = "1.13.2"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "cae251c76f353e32d32d76fae2fea655eab652af"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.27.0"
weakdeps = ["StaticArrays"]

    [deps.ExponentialUtilities.extensions]
    ExponentialUtilitiesStaticArraysExt = "StaticArrays"

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
git-tree-sha1 = "83dc665d0312b41367b7263e8a4d172eac1897f4"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.4"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3a948313e7a41eb1db7a1e733e6335f17b4ab3c4"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "7.1.1+0"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "ab1b34570bcdf272899062e1a56285a53ecaae08"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.3.5"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "fd923962364b645f3719855c88f7074413a6ad92"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "1.0.2"

[[deps.FastPower]]
git-tree-sha1 = "5f7afd4b1a3969dc34d692da2ed856047325b06e"
uuid = "a4df4552-cc26-4903-aec0-212e50a0e84b"
version = "1.1.3"

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
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FindFirstFunctions]]
git-tree-sha1 = "670e1d9ceaa4a3161d32fe2d2fb2177f8d78b330"
uuid = "64ca27bc-2ba2-4a57-88aa-44e436879224"
version = "1.4.1"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Setfield"]
git-tree-sha1 = "31fd32af86234b6b71add76229d53129aa1b87a9"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.28.1"

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
git-tree-sha1 = "ce15956960057e9ff7f1f535400ffa14c92429a4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "1.1.0"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Functors]]
deps = ["Compat", "ConstructionBase", "LinearAlgebra", "Random"]
git-tree-sha1 = "60a0339f28a233601cb74468032b5c302d5067de"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.5.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "83cf05ab16a73219e5f6bd1bdfa9848fa24ac627"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.2.0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "1828eb7275491981fa5f1752a5e126e8f26f8741"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.17"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "27299071cc29e409488ada41ec7643e0ab19091f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.17+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "f88e0ba1f6b42121a7c1dfe93a9687d8e164c91b"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.5"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "35fbd0cefb04a516104b8e183ce0df11b70a3f1a"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.84.3+0"

[[deps.Glob]]
git-tree-sha1 = "97285bbd5230dd766e9ef6749b80fc617126d496"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "7a98c6502f4632dbe9fb1973a4244eaa3324e84d"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.13.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "ed5e9c58612c4e081aecdb6e1a479e18462e041e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "68c173f4f449de5b438ee67ed0c9c748dc31a2ec"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.28"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImplicitDiscreteSolve]]
deps = ["DiffEqBase", "OrdinaryDiffEqCore", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SymbolicIndexingInterface", "UnPack"]
git-tree-sha1 = "3e9ef0da0cabc23fc74e24cb233e184023f3b3ce"
uuid = "3263718b-31ed-49cf-8a0f-35a466e8af96"
version = "1.2.0"

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
git-tree-sha1 = "5fbb102dcb8b1a858111ae81d56682376130517d"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.11"
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
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

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
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Jieko]]
deps = ["ExproniconLite"]
git-tree-sha1 = "2f05ed29618da60c06a87e9c033982d4f71d0b6c"
uuid = "ae98c720-c025-4a4a-838c-29b094483192"
version = "0.2.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e95866623950267c1e4878846f848d94810de475"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.2+0"

[[deps.JuliaFormatter]]
deps = ["CommonMark", "Glob", "JuliaSyntax", "PrecompileTools", "TOML"]
git-tree-sha1 = "f512fefd5fdc7dd1ca05778f08f91e9e4c9fdc37"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "2.1.6"

[[deps.JuliaSyntax]]
git-tree-sha1 = "937da4713526b96ac9a178e2035019d3b78ead4a"
uuid = "70703baa-626e-46a2-a12c-08ffd08c73b4"
version = "0.4.10"

[[deps.JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "SymbolicIndexingInterface", "UnPack"]
git-tree-sha1 = "f5b57507a36f05509e72120aa84d5c3747dbd70e"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.17.0"

    [deps.JumpProcesses.extensions]
    JumpProcessesKernelAbstractionsExt = ["Adapt", "KernelAbstractions"]

    [deps.JumpProcesses.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "b94257a1a8737099ca40bc7271a8b374033473ed"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.10.1"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "52e1296ebbde0db845b356abbbe67fb82a0a116c"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.9"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "SparseArrays"]
git-tree-sha1 = "76627adb8c542c6b73f68d4bfd0aa71c9893a079"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "2.6.2"

    [deps.LazyArrays.extensions]
    LazyArraysBandedMatricesExt = "BandedMatrices"
    LazyArraysBlockArraysExt = "BlockArrays"
    LazyArraysBlockBandedMatricesExt = "BlockBandedMatrices"
    LazyArraysStaticArraysExt = "StaticArrays"

    [deps.LazyArrays.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

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
git-tree-sha1 = "706dfd3c0dd56ca090e86884db6eda70fa7dd4af"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.1+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d3c8af829abaeba27181db4acb485b18d15d89c6"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.1+0"

[[deps.LineSearch]]
deps = ["ADTypes", "CommonSolve", "ConcreteStructs", "FastClosures", "LinearAlgebra", "MaybeInplace", "SciMLBase", "SciMLJacobianOperators", "StaticArraysCore"]
git-tree-sha1 = "97d502765cc5cf3a722120f50da03c2474efce04"
uuid = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
version = "0.1.4"
weakdeps = ["LineSearches"]

    [deps.LineSearch.extensions]
    LineSearchLineSearchesExt = "LineSearches"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "4adee99b7262ad2a1a4bbbc59d993d24e55ea96f"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.4.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "ChainRulesCore", "ConcreteStructs", "DocStringExtensions", "EnumX", "GPUArraysCore", "InteractiveUtils", "Krylov", "LazyArrays", "Libdl", "LinearAlgebra", "MKL_jll", "Markdown", "OpenBLAS_jll", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "Setfield", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "0f1a02cea457a2e26b67e105aa7ee549419c2550"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "3.37.0"

    [deps.LinearSolve.extensions]
    LinearSolveAMDGPUExt = "AMDGPU"
    LinearSolveBLISExt = ["blis_jll", "LAPACK_jll"]
    LinearSolveBandedMatricesExt = "BandedMatrices"
    LinearSolveBlockDiagonalsExt = "BlockDiagonals"
    LinearSolveCUDAExt = "CUDA"
    LinearSolveCUDSSExt = "CUDSS"
    LinearSolveCUSOLVERRFExt = ["CUSOLVERRF", "SparseArrays"]
    LinearSolveCliqueTreesExt = ["CliqueTrees", "SparseArrays"]
    LinearSolveEnzymeExt = "EnzymeCore"
    LinearSolveFastAlmostBandedMatricesExt = "FastAlmostBandedMatrices"
    LinearSolveFastLapackInterfaceExt = "FastLapackInterface"
    LinearSolveForwardDiffExt = "ForwardDiff"
    LinearSolveHYPREExt = "HYPRE"
    LinearSolveIterativeSolversExt = "IterativeSolvers"
    LinearSolveKernelAbstractionsExt = "KernelAbstractions"
    LinearSolveKrylovKitExt = "KrylovKit"
    LinearSolveMetalExt = "Metal"
    LinearSolvePardisoExt = ["Pardiso", "SparseArrays"]
    LinearSolveRecursiveFactorizationExt = "RecursiveFactorization"
    LinearSolveSparseArraysExt = "SparseArrays"
    LinearSolveSparspakExt = ["SparseArrays", "Sparspak"]

    [deps.LinearSolve.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockDiagonals = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    CUSOLVERRF = "a8cc9031-bad2-4722-94f5-40deabb4245c"
    CliqueTrees = "60701a23-6482-424a-84db-faee86b9b1f8"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastAlmostBandedMatrices = "9d29842c-ecb8-4973-b1e9-a27b1157504e"
    FastLapackInterface = "29a986be-02c6-4525-aec4-84b980013641"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    HYPRE = "b5ffcf37-a2bd-41ab-a3da-4bd9bc8ad771"
    IterativeSolvers = "42fd0dbc-a981-5370-80f2-aaf504508153"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
    LAPACK_jll = "51474c39-65e3-53ba-86ba-03b1b862ec14"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    Pardiso = "46dd5b70-b6fb-5a00-ae2d-e8fea33afaf2"
    RecursiveFactorization = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Sparspak = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
    blis_jll = "6136c539-28a5-5bf0-87cc-b183200dce32"

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
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "282cadc186e7b2ae0eeadbd7a4dffed4196ae2aa"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2025.2.0+0"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
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
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.ModelingToolkit]]
deps = ["ADTypes", "AbstractTrees", "ArrayInterface", "BlockArrays", "ChainRulesCore", "Combinatorics", "CommonSolve", "Compat", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "DiffRules", "DifferentiationInterface", "Distributed", "Distributions", "DocStringExtensions", "DomainSets", "DynamicQuantities", "EnumX", "ExprTools", "FindFirstFunctions", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "Graphs", "ImplicitDiscreteSolve", "InteractiveUtils", "JuliaFormatter", "JumpProcesses", "Latexify", "Libdl", "LinearAlgebra", "MLStyle", "Moshi", "NaNMath", "OffsetArrays", "OrderedCollections", "OrdinaryDiffEqCore", "PrecompileTools", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SCCNonlinearSolve", "SciMLBase", "SciMLPublic", "SciMLStructures", "Serialization", "Setfield", "SimpleNonlinearSolve", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "SymbolicUtils", "Symbolics", "URIs", "UnPack", "Unitful"]
git-tree-sha1 = "b72f2a60bec4a52ddbb4eb796acaf57d81c97b1b"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "10.21.0"

    [deps.ModelingToolkit.extensions]
    MTKBifurcationKitExt = "BifurcationKit"
    MTKCasADiDynamicOptExt = "CasADi"
    MTKDeepDiffsExt = "DeepDiffs"
    MTKFMIExt = "FMI"
    MTKInfiniteOptExt = "InfiniteOpt"
    MTKLabelledArraysExt = "LabelledArrays"
    MTKPyomoDynamicOptExt = "Pyomo"

    [deps.ModelingToolkit.weakdeps]
    BifurcationKit = "0f109fa4-8a5d-4b75-95aa-f515264e7665"
    CasADi = "c49709b8-5c63-11e9-2fb2-69db5844192f"
    DeepDiffs = "ab62b9b5-e342-54a8-a765-a90f495de1a6"
    FMI = "14a09403-18e3-468f-ad8a-74f8dda2d9ac"
    InfiniteOpt = "20393b10-9daf-11e9-18c9-8db751c92c57"
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    Pyomo = "0e8e1daf-01b5-4eba-a626-3897743a3816"

[[deps.Moshi]]
deps = ["ExproniconLite", "Jieko"]
git-tree-sha1 = "53f817d3e84537d84545e0ad749e483412dd6b2a"
uuid = "2e0e35c7-a2e4-4343-998d-7ef72827ed2d"
version = "0.3.7"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "fade91fe9bee7b142d332fc6ab3f0deea29f637b"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.5.9"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "491bdcdc943fcbc4c005900d7463c9f216aabf4c"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.6.4"

[[deps.NLSolversBase]]
deps = ["ADTypes", "DifferentiationInterface", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "25a6638571a902ecfb1ae2a18fc1575f86b1d4df"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.10.0"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "BracketingNonlinearSolve", "CommonSolve", "ConcreteStructs", "DiffEqBase", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "NonlinearSolveBase", "NonlinearSolveFirstOrder", "NonlinearSolveQuasiNewton", "NonlinearSolveSpectralMethods", "PrecompileTools", "Preferences", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SparseArrays", "SparseMatrixColorings", "StaticArraysCore", "SymbolicIndexingInterface"]
git-tree-sha1 = "d2ec18c1e4eccbb70b64be2435fc3b06fbcdc0a1"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "4.10.0"

    [deps.NonlinearSolve.extensions]
    NonlinearSolveFastLevenbergMarquardtExt = "FastLevenbergMarquardt"
    NonlinearSolveFixedPointAccelerationExt = "FixedPointAcceleration"
    NonlinearSolveLeastSquaresOptimExt = "LeastSquaresOptim"
    NonlinearSolveMINPACKExt = "MINPACK"
    NonlinearSolveNLSolversExt = "NLSolvers"
    NonlinearSolveNLsolveExt = ["NLsolve", "LineSearches"]
    NonlinearSolvePETScExt = ["PETSc", "MPI"]
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
    SpeedMapping = "f1835b91-879b-4a3f-a438-e4baacf14412"
    Sundials = "c3572dad-4567-51f8-b174-8c6c989267f4"

[[deps.NonlinearSolveBase]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "CommonSolve", "Compat", "ConcreteStructs", "DifferentiationInterface", "EnzymeCore", "FastClosures", "LinearAlgebra", "Markdown", "MaybeInplace", "Preferences", "Printf", "RecursiveArrayTools", "SciMLBase", "SciMLJacobianOperators", "SciMLOperators", "StaticArraysCore", "SymbolicIndexingInterface", "TimerOutputs"]
git-tree-sha1 = "1d42a315ba627ca0027d49d0efb44e3d88db24aa"
uuid = "be0214bd-f91f-a760-ac4e-3421ce2b2da0"
version = "1.14.0"

    [deps.NonlinearSolveBase.extensions]
    NonlinearSolveBaseBandedMatricesExt = "BandedMatrices"
    NonlinearSolveBaseDiffEqBaseExt = "DiffEqBase"
    NonlinearSolveBaseForwardDiffExt = "ForwardDiff"
    NonlinearSolveBaseLineSearchExt = "LineSearch"
    NonlinearSolveBaseLinearSolveExt = "LinearSolve"
    NonlinearSolveBaseSparseArraysExt = "SparseArrays"
    NonlinearSolveBaseSparseMatrixColoringsExt = "SparseMatrixColorings"

    [deps.NonlinearSolveBase.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    LineSearch = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
    LinearSolve = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"

[[deps.NonlinearSolveFirstOrder]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConcreteStructs", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLJacobianOperators", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "3f1198ae5cbf21e84b8251a9e62fa1f888f3e4cb"
uuid = "5959db7a-ea39-4486-b5fe-2dd0bf03d60d"
version = "1.7.0"

[[deps.NonlinearSolveQuasiNewton]]
deps = ["ArrayInterface", "CommonSolve", "ConcreteStructs", "DiffEqBase", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLOperators", "StaticArraysCore"]
git-tree-sha1 = "40dfaf1bf74f1f700f81d0002d4dd90999598eb2"
uuid = "9a2c21bd-3a47-402d-9113-8faf9a0ee114"
version = "1.8.0"
weakdeps = ["ForwardDiff"]

    [deps.NonlinearSolveQuasiNewton.extensions]
    NonlinearSolveQuasiNewtonForwardDiffExt = "ForwardDiff"

[[deps.NonlinearSolveSpectralMethods]]
deps = ["CommonSolve", "ConcreteStructs", "DiffEqBase", "LineSearch", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "84de5a469e119eb2c22ae07c543dc4e7f7001ee7"
uuid = "26075421-4e9a-44e1-8bd1-420ed7ad02b2"
version = "1.3.0"
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
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.5+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "f1a7e086c677df53e064e0fdd2c9d0b0833e3f6e"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.5.0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "2ae7d4ddec2e13ad3bddf5c0796f7547cf682391"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.2+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Optim]]
deps = ["Compat", "EnumX", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "61942645c38dd2b5b78e2082c9b51ab315315d10"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.13.2"

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

    [deps.Optim.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c392fc5dd032381919e3b22dd32d6443760ce7ea"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.5.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "CommonSolve", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "ExplicitImports", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FillArrays", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "MacroTools", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqAdamsBashforthMoulton", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqDefault", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqExplicitRK", "OrdinaryDiffEqExponentialRK", "OrdinaryDiffEqExtrapolation", "OrdinaryDiffEqFIRK", "OrdinaryDiffEqFeagin", "OrdinaryDiffEqFunctionMap", "OrdinaryDiffEqHighOrderRK", "OrdinaryDiffEqIMEXMultistep", "OrdinaryDiffEqLinear", "OrdinaryDiffEqLowOrderRK", "OrdinaryDiffEqLowStorageRK", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqNordsieck", "OrdinaryDiffEqPDIRK", "OrdinaryDiffEqPRK", "OrdinaryDiffEqQPRK", "OrdinaryDiffEqRKN", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqSDIRK", "OrdinaryDiffEqSSPRK", "OrdinaryDiffEqStabilizedIRK", "OrdinaryDiffEqStabilizedRK", "OrdinaryDiffEqSymplecticRK", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "Static", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "92cbff9044dc0a035b859de3778a9d0bfe73bdea"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.102.0"

[[deps.OrdinaryDiffEqAdamsBashforthMoulton]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqLowOrderRK", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "09aae1486c767caa6bce9de892455cbdf5a6fbc8"
uuid = "89bda076-bce5-4f1c-845f-551c83cdda9a"
version = "1.5.0"

[[deps.OrdinaryDiffEqBDF]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqSDIRK", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "ce8db53fd1e4e41c020fd53961e7314f75e4c21c"
uuid = "6ad6398a-0878-4a85-9266-38940aa047c8"
version = "1.10.1"

[[deps.OrdinaryDiffEqCore]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "FastBroadcast", "FastClosures", "FastPower", "FillArrays", "FunctionWrappersWrappers", "InteractiveUtils", "LinearAlgebra", "Logging", "MacroTools", "MuladdMacro", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleUnPack", "Static", "StaticArrayInterface", "StaticArraysCore", "SymbolicIndexingInterface", "TruncatedStacktraces"]
git-tree-sha1 = "e579c9a4f9102e82da3d97c349a74d6bc11cf8dc"
uuid = "bbf590c4-e513-4bbe-9b18-05decba2e5d8"
version = "1.30.0"

    [deps.OrdinaryDiffEqCore.extensions]
    OrdinaryDiffEqCoreEnzymeCoreExt = "EnzymeCore"
    OrdinaryDiffEqCoreMooncakeExt = "Mooncake"

    [deps.OrdinaryDiffEqCore.weakdeps]
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"

[[deps.OrdinaryDiffEqDefault]]
deps = ["ADTypes", "DiffEqBase", "EnumX", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "PrecompileTools", "Preferences", "Reexport", "SciMLBase"]
git-tree-sha1 = "7d5ddeee97e1bdcc848f1397cbc3d03bd57f33e7"
uuid = "50262376-6c5a-4cf5-baba-aaf4f84d72d7"
version = "1.8.0"

[[deps.OrdinaryDiffEqDifferentiation]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "ConstructionBase", "DiffEqBase", "DifferentiationInterface", "FastBroadcast", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqCore", "SciMLBase", "SciMLOperators", "SparseArrays", "SparseMatrixColorings", "StaticArrayInterface", "StaticArrays"]
git-tree-sha1 = "4c270747152db513dd80bfd5f2f9df48befff28a"
uuid = "4302a76b-040a-498a-8c04-15b101fed76b"
version = "1.14.0"

[[deps.OrdinaryDiffEqExplicitRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "4c0633f587395d7aaec0679dc649eb03fcc74e73"
uuid = "9286f039-9fbf-40e8-bf65-aa933bdc4db0"
version = "1.4.0"

[[deps.OrdinaryDiffEqExponentialRK]]
deps = ["ADTypes", "DiffEqBase", "ExponentialUtilities", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "3b81416ff11e55ea0ae7b449efc818256d9d450b"
uuid = "e0540318-69ee-4070-8777-9e2de6de23de"
version = "1.8.0"

[[deps.OrdinaryDiffEqExtrapolation]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FastPower", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "ee2cba2533e9faf71b09a319a910d4886931e7a6"
uuid = "becaefa8-8ca2-5cf9-886d-c06f3d2bd2c4"
version = "1.8.0"

[[deps.OrdinaryDiffEqFIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FastGaussQuadrature", "FastPower", "LinearAlgebra", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "b968d66de3de5ffcf18544bc202ca792bad20710"
uuid = "5960d6e9-dd7a-4743-88e7-cf307b64f125"
version = "1.16.0"

[[deps.OrdinaryDiffEqFeagin]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "815b54211201ec42b8829e0275ab3c9632d16cbe"
uuid = "101fe9f7-ebb6-4678-b671-3a81e7194747"
version = "1.4.0"

[[deps.OrdinaryDiffEqFunctionMap]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "fe750e4b8c1b1b9e1c1319ff2e052e83ad57b3ac"
uuid = "d3585ca7-f5d3-4ba6-8057-292ed1abd90f"
version = "1.5.0"

[[deps.OrdinaryDiffEqHighOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "42096f72136078fa02804515f1748ddeb1f0d47d"
uuid = "d28bc4f8-55e1-4f49-af69-84c1a99f0f58"
version = "1.5.0"

[[deps.OrdinaryDiffEqIMEXMultistep]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "a5dcd75959dada0005b1707a5ca9359faa1734ba"
uuid = "9f002381-b378-40b7-97a6-27a27c83f129"
version = "1.7.0"

[[deps.OrdinaryDiffEqLinear]]
deps = ["DiffEqBase", "ExponentialUtilities", "LinearAlgebra", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "925fc0136e8128fd19abf126e9358ec1f997390f"
uuid = "521117fe-8c41-49f8-b3b6-30780b3f0fb5"
version = "1.6.0"

[[deps.OrdinaryDiffEqLowOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "3cc4987c8e4725276b55a52e08b56ded4862917e"
uuid = "1344f307-1e59-4825-a18e-ace9aa3fa4c6"
version = "1.6.0"

[[deps.OrdinaryDiffEqLowStorageRK]]
deps = ["Adapt", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static", "StaticArrays"]
git-tree-sha1 = "9291cdfd2e8c91e900c48d71d76618de47daeede"
uuid = "b0944070-b475-4768-8dec-fb6eb410534d"
version = "1.6.0"

[[deps.OrdinaryDiffEqNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FastClosures", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "PreallocationTools", "RecursiveArrayTools", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "StaticArrays"]
git-tree-sha1 = "b05226afc8fa6b8fc6f2258a89987b4f5bd0db4e"
uuid = "127b3ac7-2247-4354-8eb6-78cf4e7c58e8"
version = "1.14.1"

[[deps.OrdinaryDiffEqNordsieck]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqTsit5", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "c90aa7fa0d725472c4098096adf6a08266c2f682"
uuid = "c9986a66-5c92-4813-8696-a7ec84c806c8"
version = "1.4.0"

[[deps.OrdinaryDiffEqPDIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Polyester", "Reexport", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "9d599d2eafdf74ab26ea6bf3feb28183a2ade143"
uuid = "5dd0a6cf-3d4b-4314-aa06-06d4e299bc89"
version = "1.6.0"

[[deps.OrdinaryDiffEqPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "Reexport", "SciMLBase"]
git-tree-sha1 = "8e35132689133255be6d63df4190b5fc97b6cf2b"
uuid = "5b33eab2-c0f1-4480-b2c3-94bc1e80bda1"
version = "1.4.0"

[[deps.OrdinaryDiffEqQPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "63fb643a956b27cd0e33a3c6d910c3c118082e0f"
uuid = "04162be5-8125-4266-98ed-640baecc6514"
version = "1.4.0"

[[deps.OrdinaryDiffEqRKN]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "a31c41f9dbea7c7179c6e544c25c7e144d63868c"
uuid = "af6ede74-add8-4cfd-b1df-9a4dbb109d7a"
version = "1.5.0"

[[deps.OrdinaryDiffEqRosenbrock]]
deps = ["ADTypes", "DiffEqBase", "DifferentiationInterface", "FastBroadcast", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "d0b4e34792fb64c3815fc79ad3adc300b1e35588"
uuid = "43230ef6-c299-4910-a778-202eb28ce4ce"
version = "1.17.0"

[[deps.OrdinaryDiffEqSDIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "20caa72c004414435fb5769fadb711e96ed5bcd4"
uuid = "2d112036-d095-4a1e-ab9a-08536f3ecdbf"
version = "1.7.0"

[[deps.OrdinaryDiffEqSSPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static", "StaticArrays"]
git-tree-sha1 = "af955c61407631d281dd4c2e8331cdfea1af49be"
uuid = "669c94d9-1f4b-4b64-b377-1aa079aa2388"
version = "1.6.0"

[[deps.OrdinaryDiffEqStabilizedIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqStabilizedRK", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "75abe7462f4b0b2a2463bb512c8a5458bbd39185"
uuid = "e3e12d00-db14-5390-b879-ac3dd2ef6296"
version = "1.6.0"

[[deps.OrdinaryDiffEqStabilizedRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "7e94d3d1b3528b4bcf9e0248198ee0a2fd65a697"
uuid = "358294b1-0aab-51c3-aafe-ad5ab194a2ad"
version = "1.4.0"

[[deps.OrdinaryDiffEqSymplecticRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "e8dd5ab225287947016dc144a5ded1fb83885638"
uuid = "fa646aed-7ef9-47eb-84c4-9443fc8cbfa8"
version = "1.7.0"

[[deps.OrdinaryDiffEqTsit5]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "778c7d379265f17f40dbe9aaa6f6a2a08bc7fa3e"
uuid = "b1df2697-797e-41e3-8120-5422d3b24e4a"
version = "1.5.0"

[[deps.OrdinaryDiffEqVerner]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "185578fa7c38119d4318326f9375f1cba0f0ce53"
uuid = "79d7bb75-1356-48c1-b8c0-6832512096c2"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f07c06228a1c670ae4c87d1276b92c7c597fdda0"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.35"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "275a9a6d85dc86c24d03d1837a0010226a96f540"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.3+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
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
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Colors", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "28278bb0053da0fd73537be94afd1682cc5a0a83"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.21"

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
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "0c5a5b7e440c008fe31416a3ac9e0d2057c81106"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.19"

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
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "8329a3a4f75e178c11c1ce2342778bcbbbfa7e3c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.71"

[[deps.PoissonRandom]]
deps = ["LogExpFunctions", "Random"]
git-tree-sha1 = "c1ea45aa9f209fe97192afa233907bc4e551c8aa"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.6"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "6f7cd22a802094d239824c57d94c8e2d0f7cfc7d"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.18"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "PrecompileTools"]
git-tree-sha1 = "9b4ee15d1fc68654031964a7af0c914c898e35a7"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.33"

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
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "0f27480397253da18fe2c12a4ba4eb9eb208bf3d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.0"

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
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "eb38d376097f47316fe089fc62cb7c6d85383a52"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.8.2+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "da7adf145cce0d44e892626e647f9dcbe9cb3e10"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.8.2+1"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "9eca9fc3fe515d619ce004c83c31ffd3f85c7ccf"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.8.2+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "e1d5e16d0f65762396f9ca4644a5f4ddab8d452b"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.8.2+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9da16da70037ba9d701192e27befedefb91ec284"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.2"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "dbe5fd0b334694e905cb9fda73cd8554333c46e2"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.7.1"

[[deps.RandomNumbers]]
deps = ["Random"]
git-tree-sha1 = "c6ec94d2aaba1ab2ff983052cf6a606ca5985902"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.6.0"

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
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "96bef5b9ac123fff1b379acf0303cf914aaabdfd"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.37.1"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsKernelAbstractionsExt = "KernelAbstractions"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsSparseArraysExt = ["SparseArrays"]
    RecursiveArrayToolsStructArraysExt = "StructArrays"
    RecursiveArrayToolsTablesExt = ["Tables"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
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

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "86a8a8b783481e1ea6b9c91dd949cb32191f8ab4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.15"

[[deps.SCCNonlinearSolve]]
deps = ["CommonSolve", "PrecompileTools", "Reexport", "SciMLBase", "SymbolicIndexingInterface"]
git-tree-sha1 = "5595105cef621942aceb1aa546b883c79ccbfa8f"
uuid = "9dfe8606-65a1-4bb3-9748-cb89d1561431"
version = "1.4.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SciMLBase]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "Moshi", "PreallocationTools", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "33786c33502a6652fba239d3062ccc5e4cdd30c4"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.114.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseDistributionsExt = "Distributions"
    SciMLBaseForwardDiffExt = "ForwardDiff"
    SciMLBaseMLStyleExt = "MLStyle"
    SciMLBaseMakieExt = "Makie"
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
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    MLStyle = "d8e11817-5142-5d16-987a-aa16d5891078"
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
git-tree-sha1 = "3414071e3458f3065de7fa5aed55283b236b4907"
uuid = "19f34311-ddf3-4b8b-af20-060888a46c0e"
version = "0.1.8"

[[deps.SciMLOperators]]
deps = ["Accessors", "ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "78ac1b947205b07973321f67f17df8fbe6154ac9"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "1.6.0"
weakdeps = ["SparseArrays", "StaticArraysCore"]

    [deps.SciMLOperators.extensions]
    SciMLOperatorsSparseArraysExt = "SparseArrays"
    SciMLOperatorsStaticArraysCoreExt = "StaticArraysCore"

[[deps.SciMLPublic]]
git-tree-sha1 = "ed647f161e8b3f2973f24979ec074e8d084f1bee"
uuid = "431bcebd-1456-4ced-9d72-93c2757fff0b"
version = "1.0.0"

[[deps.SciMLStructures]]
deps = ["ArrayInterface"]
git-tree-sha1 = "566c4ed301ccb2a44cbd5a27da5f885e0ed1d5df"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.7.0"

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

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

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
git-tree-sha1 = "09d986e27a606f172c5b6cffbd8b8b2f10bf1c75"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "2.7.0"

    [deps.SimpleNonlinearSolve.extensions]
    SimpleNonlinearSolveChainRulesCoreExt = "ChainRulesCore"
    SimpleNonlinearSolveDiffEqBaseExt = "DiffEqBase"
    SimpleNonlinearSolveReverseDiffExt = "ReverseDiff"
    SimpleNonlinearSolveTrackerExt = "Tracker"

    [deps.SimpleNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "be8eeac05ec97d379347584fa9fe2f5f76795bcb"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.5"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

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
version = "1.11.0"

[[deps.SparseMatrixColorings]]
deps = ["ADTypes", "DocStringExtensions", "LinearAlgebra", "PrecompileTools", "Random", "SparseArrays"]
git-tree-sha1 = "9de43e0b9b976f1019bf7a879a686c4514520078"
uuid = "0a514795-09f3-496d-8182-132a7b665d35"
version = "0.4.21"

    [deps.SparseMatrixColorings.extensions]
    SparseMatrixColoringsCUDAExt = "CUDA"
    SparseMatrixColoringsCliqueTreesExt = "CliqueTrees"
    SparseMatrixColoringsColorsExt = "Colors"

    [deps.SparseMatrixColorings.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CliqueTrees = "60701a23-6482-424a-84db-faee86b9b1f8"
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "41852b8679f78c8d8961eeadc8f62cef861a52e3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "95af145932c2ed859b63329952ce8d633719f091"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.3"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "f737d444cb0ad07e61b3c1bef8eb91203c321eff"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.2.0"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Static"]
git-tree-sha1 = "96381d50f1ce85f2663584c8e886a6ca97e60554"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.8.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "b8693004b385c842357406e3af647701fe783f98"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.15"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

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
git-tree-sha1 = "9d72a13a3f4dd3795a195ac5a44d7d6ff5f552ff"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.1"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2c962245732371acd51700dbb268af311bddd719"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.6"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "8e45cecc66f3b42633b8ce14d431e8e57a3e242e"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "83151ba8065a73f53ca2ae98bc7274d817aa30f2"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.5.8"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.SymbolicIndexingInterface]]
deps = ["Accessors", "ArrayInterface", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "93104ca226670c0cb92ba8bc6998852ad55a2d4c"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.43"

    [deps.SymbolicIndexingInterface.extensions]
    SymbolicIndexingInterfacePrettyTablesExt = "PrettyTables"

    [deps.SymbolicIndexingInterface.weakdeps]
    PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[[deps.SymbolicLimits]]
deps = ["SymbolicUtils"]
git-tree-sha1 = "fabf4650afe966a2ba646cabd924c3fd43577fc3"
uuid = "19f23fe9-fdab-4a78-91af-e7b7767979c3"
version = "0.2.2"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "ArrayInterface", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "ExproniconLite", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "TaskLocalValues", "TermInterface", "TimerOutputs", "Unityper"]
git-tree-sha1 = "8c103c491ccf3e2b4284635c24b5de768adc6be8"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "3.31.0"

    [deps.SymbolicUtils.extensions]
    SymbolicUtilsLabelledArraysExt = "LabelledArrays"
    SymbolicUtilsReverseDiffExt = "ReverseDiff"

    [deps.SymbolicUtils.weakdeps]
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.Symbolics]]
deps = ["ADTypes", "ArrayInterface", "Bijections", "CommonWorldInvalidations", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "DynamicPolynomials", "LaTeXStrings", "Latexify", "Libdl", "LinearAlgebra", "LogExpFunctions", "MacroTools", "Markdown", "NaNMath", "OffsetArrays", "PrecompileTools", "Primes", "RecipesBase", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "SciMLPublic", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArraysCore", "SymbolicIndexingInterface", "SymbolicLimits", "SymbolicUtils", "TermInterface"]
git-tree-sha1 = "5f2f0188931997573d2a8e24f43bac699da95d8f"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "6.52.0"

    [deps.Symbolics.extensions]
    SymbolicsD3TreesExt = "D3Trees"
    SymbolicsForwardDiffExt = "ForwardDiff"
    SymbolicsGroebnerExt = "Groebner"
    SymbolicsLuxExt = "Lux"
    SymbolicsNemoExt = "Nemo"
    SymbolicsPreallocationToolsExt = ["PreallocationTools", "ForwardDiff"]
    SymbolicsSymPyExt = "SymPy"
    SymbolicsSymPyPythonCallExt = "SymPyPythonCall"

    [deps.Symbolics.weakdeps]
    D3Trees = "e3df1716-f71e-5df9-9e2d-98e193103c45"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Groebner = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
    Lux = "b2108857-7c20-44ae-9111-449ecde12c47"
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

[[deps.TestItems]]
git-tree-sha1 = "42fd9023fef18b9b78c8343a4e2f3813ffbcefcb"
uuid = "1c621080-faea-4a02-84b6-bbd5e436b8fe"
version = "1.0.0"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "d969183d3d244b6c33796b5ed01ab97328f2db85"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.5"

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
git-tree-sha1 = "372b90fe551c019541fafc6ff034199dc19c8436"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.12"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "6258d453843c466d84c17a58732dda5deeb8d3af"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.24.0"
weakdeps = ["ConstructionBase", "ForwardDiff", "InverseFunctions", "Printf"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    PrintfExt = "Printf"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "af305cc62419f9bd61b6644d19170a4d258c7967"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.7.0"

[[deps.Unityper]]
deps = ["ConstructionBase"]
git-tree-sha1 = "25008b734a03736c41e2a7dc314ecb95bd6bbdb0"
uuid = "a7c27f48-0311-42f6-a7f8-2c11e75eb415"
version = "0.1.6"

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

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

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
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

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
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "9caba99d38404b285db8801d5c45ef4f4f425a6d"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.1+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a5bc75478d323358a90dc36766f3c99ba7feb024"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.6+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "aff463c82a773cb86061bce8d53a0d976854923e"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.5+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "e3150c7400c41e207012b41659591f083f3ef795"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.3+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "c5bf2dad6a03dfef57ea0a170a1fe493601603f2"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.5+0"

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
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

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
git-tree-sha1 = "4bba74fa59ab0755167ad24f98800fe5d727175b"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.12.1+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

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
git-tree-sha1 = "07b6a107d926093898e82b3b1db657ebe33134ec"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.50+0"

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
version = "1.59.0+0"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d5a767a3bb77135a99e433afe0eb14cd7f6914c3"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2022.0.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
git-tree-sha1 = "fbf139bce07a534df0e699dbb5f5cc9346f95cc1"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.9.2+0"
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
