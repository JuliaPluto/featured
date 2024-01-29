### A Pluto.jl notebook ###
# v0.19.36

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
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 00edd691-2b60-4d1d-b5e2-2fd4675469da
begin
	using ModelingToolkit
	using DifferentialEquations
	md"""
	!!! info "Modeling"
		[ModelingToolkit](https://juliapackages.com/p/ModelingToolkit): Use for modeling to setup ODESystem for each of the models.
	
		[DifferentialEquations](https://www.juliapackages.com/p/DifferentialEquations): Holds the differential equation solvers.
	"""
end

# ╔═╡ 7a937f2c-5808-4756-9bfc-6f84b0f03cc9
begin
	using Plots
	plotly()
	using PlutoUI
	import PlutoUI: combine
	using HypertextLiteral: @htl
	using Parameters
	using DocStringExtensions
	md"""
	!!! info "Display Packages"
		[Plots](https://juliapackages.com/p/Plots): Plotting library for the several plots in the notebook.

		[PlutoUI](https://www.juliapackages.com/p/PlutoUI):  Extension for Pluto to handle interactivity, provides the Sliders.
	
		[HypertextLiteral](https://www.juliapackages.com/p/HypertextLiteral): Julia package for generating HTML, SVG, and other SGML tagged content.
	
		[Parameters](https://www.juliapackages.com/p/Parameters): Types with default field values with keyword constructors.
	
		[DocStringExtensions](https://www.juliapackages.com/p/DocStringExtensions): Package that provide `Abbreviations` to use in DocStrings.
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
md"""Our model is now looks like this:"""

# ╔═╡ 77d94a92-f058-4b9f-9df8-9de58603c293
md"## Setting up the system"

# ╔═╡ e0581cf3-f942-45a6-bcf2-9e72ba2379a4
md"""

!!! info "Acausal Modeling"
	To set up this model, we will be using the *acausal modeling library* [ModelingToolkit](https://github.com/SciML/ModelingToolkit.jl) from [SciML](https://sciml.ai/). The idea is that we can define equations and systems using the equations that we have defined directly. (You can actually check that the system that is mentioned earlier is actually a ModelingToolkit system.)

"""

# ╔═╡ 28def719-c8e2-43d6-b20e-6141e423add2
md"The first step is to define the variables that will be needed for the model. That is, our dependent time variable ``t``, the differential operator ``D``, the independent variables ``😟(t)``, ``🧟(t)``, ``😵(t)`` and the model parameters ``⚔``,``🦠``, and ``💀``." 

# ╔═╡ d3acb594-ce66-4049-b674-ef641ee1207e
@variables t

# ╔═╡ 961c955f-cc9b-4cb3-abed-dc19a95ca1eb
D = Differential(t)

# ╔═╡ 01ce7903-0ba3-45bc-816a-f8288583b4d4
@variables 😟(t) 🧟(t) 😵(t)  

# ╔═╡ 6bfa46a7-f50d-49b6-bebc-b7821f89100f
@parameters ⚔️ 🦠 💀  

# ╔═╡ ddcea9d8-abc0-40a3-8740-fa0cd29b0b0e
begin
	displaySystem = ODESystem(
		[
			D(😟) ~ -🦠*😟*🧟,
		 	D(🧟) ~  🦠*😟*🧟]
	, name = :base) # only used for equations display
	
	# @info typeof(displaySystem)  # uncomment to check the type of displaySystem
end

# ╔═╡ 52d9452b-5c1e-42ea-8976-0ec2f30eaaf8
md"Once we have defined everything, we can put them together to define the system via the ODE System constructor:"

# ╔═╡ 43593199-0107-4b69-a239-f9f68c14b8eb
@named simple_attack_sys = ODESystem(
	[
		D(😟) ~ -🦠*😟*🧟,
		D(🧟) ~  🦠*😟*🧟  -	⚔️*😟*🧟 + 💀*😵,
		D(😵) ~ 		  	 	⚔️*😟*🧟 - 💀*😵
	]
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
	@named lattent_infection_sys = ODESystem(lattent_infection_eqs)
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
	@named simple_quarantine_sys = ODESystem(simple_quarantine_eqs)
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
	@named treatment_model_sys = ODESystem(treatment_model_eqs)
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
impulsive_eradication_impulse = [
		turret_reload_time => [🧟 ~ 🧟 - (💣*🧟)]
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
	@named impulsive_eradication_sys = ODESystem(
		impulsive_eradication_eqs,
		t,
		[😟,🧟,🤮,😵],
		[⚔️, 🦠, 💀, 💣, 🌡️, 💊];
		
		# Note here that we explicity give the variables and parameters to the ODESystem constructors. This is due to the fact that the automatic variables/parameters detection from the ODESystem constructor does not work on the discrete events (as of now), so we have to pass k as a parameter, and hence all of them.
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
	@named vaccine_model_sys = ODESystem(
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
"""
$(TYPEDEF)

Structure to hold me/tadata for a parameter controlled via a Slider.

$(TYPEDFIELDS)

## Examples 

```julia
αSlider = SliderParameter(
			lb = 0.0,
			ub = 0.8,
			step  = 0.01,
			default = 0.5,
			label 	= "α",
			description = "Zombie Defeating Rate" 
		)
```
"""
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

# ╔═╡ 925feb4c-6f29-4dff-8e9e-f5032b47ac22
"""
    isSymbolicInArray(sym, arr)

Check if a given symbolic object `sym` is in the array `arr`.

# Arguments
- `sym`: A symbolic variable as defined in ModelingTooolkit( or Symbolics) to check.
- `arr`: The array of symbolic variables to to check in.

# Returns
- `Bool`: Returns `true` if `sym` is not in `arr`, and `false` otherwise.

# Examples
```julia

> @variables a, b, c

> @variables d, e

> arr = [a, b, e]
> isSymbolicInArray(a, arr) 
true
> isSymbolicInArray(c, arr) 
false
```
"""
function isSymbolicInArray(sym, arr)
	isequal(setdiff(arr, [sym]), arr)
end

# ╔═╡ 24c846f3-3c61-4f9b-b243-d303451bcfdf
"""
	loadSliderCSS()

Helper function to generate the CSS needed for styling the sliders.
Generates the following classes:
 - slider-container
 - slider-container-title
 - slider-container-content-wrapper
 - slider-container-content 
 - slider-container-content-inner
 - label-chip
"""
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


# ╔═╡ 2c33a46c-6024-4a55-a7a5-5b7838cd4c9d
"""
    format_sliderParameter(sliderParams::Vector{SliderParameter}; title::String = "")

Create a formatted HTML slider with labels and descriptions from a vector of `SliderParameter` objects.

# Arguments
- `sliderParams::Vector{SliderParameter}`: A vector of `SliderParameter` objects. 
- `title::String=""`: An optional title for the slider container. If not provided, no title will be displayed.

# Returns
- A Pluto Bond containing the slider container, with each slider, its label, and description. To access the value generated by the slider, use the @bind macro from PlutoUI.

# Example

```julia
> sliderParams = [SliderParameter(label="Slider1", alias=:s1, lb=0, ub=10, step=1, ? 
> default=5, description="This is Slider 1"),
                SliderParameter(label="Slider2", alias=:s2, lb=0, ub=100, step=10, default=50, description="This is Slider 2")]
> @bind params format_sliderParameter(sliderParams, title="My Sliders")
> params
(s1 = 5.0, s2 = 50.0)
```
"""
function format_sliderParameter(sliderParams::Vector{SliderParameter};title::String = "")

	return combine() do Child
		mds = [
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
			
			""")
			
			for sliderParam in sliderParams
		]
		
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
	simple_attack_prob = ODEProblem(
		simple_attack_sys, 
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
		lattent_infection_sys, 
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
		simple_quarantine_sys, 
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
		treatment_model_sys, 
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
		impulsive_eradication_sys, 
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
		vaccine_model_sys, 
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

# ╔═╡ 53b2a3e8-c8a9-4dae-92df-f3b9af112fda
"""
	loadCollapsibleCSS()

Helper function to generate the CSS needed for styling the sliders.

Generates the following classes:
- collpasible-content
- toggle:checked
- toggle-label:hover
- toggle-label::before

Also controls how big the collapsible panel should be via "max-height". To change this, change the value of "max-height" in `extendedPanelHeightCSS`.

"""
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
"""
    collapsiblePanel(child; title::String=nothing)

Create a collapsible panel with a unique id.

# Arguments
- `child`: The content to be displayed when the panel is expanded.
- `title::String=nothing`: The title of the collapsible panel. If not provided, no title will be displayed.

# Returns
- A HTML node that represents a collapsible panel.

"""
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
"""
	loadSideBarCSS()

Helper function to generate the CSS needed for styling the sliders.
Generate the following classes:
- side-bar

"""
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
"""
    sideBarWrapper(child; location=:right)

Create a sidebar wrapper for a given HTML child.

# Arguments
- `child`: The HTML node to be wrapped.
- `location` (optional): The location of the sidebar. Default is `:right`. 
  
# Returns
- A HTML node that wraps the provided div in a sidebar.

"""
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
"""
    systemDiffTable(systems::Vector{ODESystem}; headers::Union{Vector{String},Nothing}=nothing)

Generate an HTML table that shows the differences between multiple ODE systems.

# Arguments
- `systems::Vector{ODESystem}`: A vector of ODE systems to compare.
- `headers::Union{Vector{String},Nothing}= nothing`: An optional vector of strings to use as headers for the table. If not provided, the names of the systems will be used. The number of headers must match the number of systems.

# Returns
- An HTML string wrapped in a sidebar, which represents a table. The table has a row for each parameter and state in the systems. Each column represents a system. A checkmark ("✓") in a cell indicates that the corresponding parameter or state is present in the corresponding system.

# Throws
- `DimensionMismatch`: If the number of headers provided does not match the number of systems.

# Example
```julia
> system1 = ODESystem(...)
> system2 = ODESystem(...)
> systemDiffTable([system1, system2], headers=["System 1", "System 2"])
```
"""
function systemDiffTable(
	systems::Vector{ODESystem}; 
	headers::Union{Vector{String},Nothing}= nothing
)

	if(!isnothing(headers) && length(systems) !== length(headers)) 		
		throw(DimensionMismatch("Number of headers must match the number of systems.")) 
	end

	
    paramsList = parameters.(systems)
    statesList = states.(systems)

    all_params = union(paramsList...)
    all_states = union(statesList...)

	headers = isnothing(headers) ? getproperty.(systems, :name) : headers
	
	headersHTML =  [
					@htl "
					<th>
						$(header)
					</th> "
				 for header in headers
	]
	
	paramsRowsHTML = map(all_params) do p 
				@htl """
					<tr>
						<td>
							$p
						</td>
						$([
							@htl "
								<td>
									$(isSymbolicInArray(p, paramsList[index]) ? "" : "✓" )
								</td> 
							"
							 
							for (index) in 1:length(systems)
						])
					</tr>
				"""
			end

	statesRowsHTML = map(all_states) do s 
				@htl """
					<tr>
						<td>
							$s
						</td>
						$([
							@htl "
								<td>
									$(isSymbolicInArray(s, statesList[index]) ? "" : "✓" )
								</td> 
							"
							
							for (index) in 1:length(systems)
						])
						
					</tr>
				"""
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
					Parameter
				</th>
	
			</tr>
	
			$(paramsRowsHTML)
	
			<tr>
				<th>
					States
				</th>
			</tr>
	
			$(statesRowsHTML)
	
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
systemDiffTable([simple_quarantine_sys, impulsive_eradication_sys, vaccine_model_sys], headers=["Quarantine","Impulse Eradication", "Vaccine"])

# ╔═╡ 411354b2-f9b7-46cc-9fe2-358f2d691dfe
"""
    sideBarPanelsWithCollapsible(main, extra; location=:right, collapsibleTitle="Extra Parameters")

Create a sidebar with two panels. The second panel is collapsible.

# Arguments
- `main`: The main content to be displayed in the sidebar.
- `extra`: The extra content to be displayed in the collapsible panel.
- `location` (optional, default=:right): The location of the sidebar. It can be either `:right` or `:left`.
- `collapsibleTitle` (optional, default="Extra Parameters"): The title of the collapsible panel.

# Returns
- A sidebar with the main content and an extra collapsible panel.

# Examples 

```julia
> main = html"<p>Main content"
> extra = html"<p>Extra content"
> sideBarPanelsWithCollapsible(main, extra)
```
"""
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
"""
    solutionAnalytics(sol::ODESolution)

This function generates an analytics card for a ODE solution of a Zombie Model. The analytics card displays the number of days survived and the day when everyone becomes a zombie.

# Arguments
- `sol::ODESolution`: An object of type ODESolution. This object should contain the solution to an ODE system with variables 
- Survivor variable: Default `😟(t)` 
- Zombie varaible: Default `🧟(t)`.

# Returns
- A HTML node that represents an analytics card. The card contains the number of days survived and the day when everyone becomes a zombie.

"""
function solutionAnalytics(sol::ODESolution; survivor=😟, zombie=🧟)

	
	totalPop =  sum(sol.prob.u0) 
	daysAllZombiesIndex = findfirst( x-> x >= totalPop-0.01*totalPop, sol[zombie]) 
	

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
"""
	$(TYPEDSIGNATURES)

Ploting shortcut for plotting model evolution of a zombie model. 

# Arguments

- `title`: Title of the plot Default: "Time Evolution of the system"
- `xlim:` X axis limits Default: `(0.0,100.0)`
- `label`: Labels for plot Default: `["Susceptible 😟" "Zombies 🧟" "Removed 😵" ]`
- `kwargs`: any other plot parameter, passed to `plot()`

"""
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => simple_attack_u0s.😟, 
				 🧟 => simple_attack_u0s.🧟,
				 😵 => 0,
			],
			states(simple_attack_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => simple_attack_ps.⚔️, 
				 🦠 => simple_attack_ps.🦠,
				 💀 => simple_attack_ps.💀,
			],
			parameters(simple_attack_sys)
		),
		tspan = (0.0, simple_attack_tspan.duration)
	)

	
	simple_attack_sol = solve(simple_attack_prob_remake)
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => lattent_infection_u0s.😟, 
				 🧟 => lattent_infection_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
			],
			states(lattent_infection_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => lattent_infection_ps.⚔️, 
				 🦠 => lattent_infection_ps.🦠,
				 💀 => lattent_infection_ps.💀,
				 🌡️ => lattent_infection_ps.🌡️
			],
			parameters(lattent_infection_sys)
		),
		tspan = (0, lattent_infection_tspan.duration)
	)
	
	lattent_infection_sol = solve(lattent_infection_prob_remake)
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => simple_quarantine_u0s.😟, 
				 🧟 => simple_quarantine_u0s.🧟,
				 😷 => 0,
				 🤮 => 0,
				 😵 => 0,
			],
			states(simple_quarantine_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => simple_quarantine_ps.⚔️, 
				 🦠 => simple_quarantine_ps.🦠,
				 💀 => simple_quarantine_ps.💀,
				 🌡️ => simple_quarantine_ps.🌡️,
				 🗡️ => simple_quarantine_ps.🗡️,
				 🚑 => simple_quarantine_ps.🚑
			],
			parameters(simple_quarantine_sys)
		),
		tspan = (0, simple_quarantine_tspan.duration)
	)
	
	simple_quarantine_sol = solve(simple_quarantine_prob_remake)
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => treatment_model_u0s.😟, 
				 🧟 => treatment_model_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
			],
			states(treatment_model_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => treatment_model_ps.⚔️, 
				 🦠 => treatment_model_ps.🦠,
				 💀 => treatment_model_ps.💀,
				 💊 => treatment_model_ps.💊,
				 🌡️ => treatment_model_ps.🌡️,
			],
			parameters(treatment_model_sys)
		),
		tspan = (0.0, treatment_model_tspan.duration)
	)
	
	treatment_model_sol = solve(treatment_model_prob_remake)
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => impulsive_eradication_u0s.😟, 
				 🧟 => impulsive_eradication_u0s.🧟,
				 🤮 => 0,
				 😵 => 0,
			],
			states(impulsive_eradication_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => impulsive_eradication_ps.⚔️, 
				 🦠 => impulsive_eradication_ps.🦠,
				 💀 => impulsive_eradication_ps.💀,
				 🌡️ => impulsive_eradication_ps.🌡️,
				 💣 => impulsive_eradication_ps.💣,
				 💊 => impulsive_eradication_ps.💊,
			],
			parameters(impulsive_eradication_sys)
		),
		tspan = (0.0, impulsive_eradication_tspan.duration)
	)
	
	
	impulsive_eradication_sol = solve(impulsive_eradication_prob_remake)
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
		u0 = ModelingToolkit.varmap_to_vars(
			[
				 😟 => vaccine_model_u0s.😟, 
				 🧟 => vaccine_model_u0s.🧟,
				 😊 => 0,
			     😷=> 0,
				 🤮 => 0,
				 😵 => 0,
			],
			states(vaccine_model_sys)
		),
		p =  ModelingToolkit.varmap_to_vars(
			[
				 ⚔️ => vaccine_model_ps.⚔️, 
				 🦠 => vaccine_model_ps.🦠,
				 💀 => vaccine_model_ps.💀,
				 🌡️ => vaccine_model_ps.🌡️,
				 💣 => vaccine_model_ps.💣,
				 💊 => vaccine_model_ps.💊,
				 🚑 => vaccine_model_ps.🚑,
				 💉 => vaccine_model_ps.💉,
				🗡️ => vaccine_model_ps.🗡️
			],
			parameters(vaccine_model_sys)
		),
		tspan = (0.0, vaccine_model_tspan.duration)
	)
	
	
	vaccine_model_sol = solve(vaccine_model_prob_remake)
	# plot(vaccine_model_sol)
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
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
DocStringExtensions = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DifferentialEquations = "~7.10.0"
DocStringExtensions = "~0.9.3"
HypertextLiteral = "~0.9.5"
ModelingToolkit = "~8.70.0"
Parameters = "~0.12.3"
Plots = "~1.39.0"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ADTypes]]
git-tree-sha1 = "332e5d7baeff8497b923b730b994fa480601efc7"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.2.5"

[[AbstractAlgebra]]
deps = ["GroupsCore", "InteractiveUtils", "LinearAlgebra", "MacroTools", "Preferences", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "c3c29bf6363b3ac3e421dc8b2ba8e33bdacbd245"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.32.5"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "16267cf279190ca7c1b30d020758ced95db89cd0"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.5.1"

[[ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "a45ec4acc9d905f94b47243cff666820bb107789"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.5.2"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "PrecompileTools", "SparseArrays"]
git-tree-sha1 = "0b816941273b5b162be122a6c94d706e3b3125ca"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.38"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bijections]]
git-tree-sha1 = "c9b163bd832e023571e86d0b90d9de92a9879088"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.6"

[[BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[BoundaryValueDiffEq]]
deps = ["ArrayInterface", "BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NonlinearSolve", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "TruncatedStacktraces", "UnPack"]
git-tree-sha1 = "f7392ce20e6dafa8fee406142b1764de7d7cd911"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "4.0.1"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "601f7e7b3d36f18790e2caf83a882d88e9b71ff1"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.4"

[[CSTParser]]
deps = ["Tokenize"]
git-tree-sha1 = "3ddd48d200eb8ddf9cb3e0189fc059fd49b97c1f"
uuid = "00ebfdb7-1f24-5e51-bd34-a7502290713f"
version = "3.3.6"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"

[[ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonMark]]
deps = ["Crayons", "JSON", "PrecompileTools", "URIs"]
git-tree-sha1 = "532c4185d3c9037c0237546d817858b23cf9e071"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.12"

[[CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[CompositeTypes]]
git-tree-sha1 = "02d2316b7ffceff992f3096ae48c7829a8aa0638"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.3"

[[ConcreteStructs]]
git-tree-sha1 = "f749037478283d372048690eb3b5f92a79432b34"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.3"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "32d125af0fb8ec3f8935896122c5e345709909e5"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.0"

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SimpleUnPack"]
git-tree-sha1 = "e40378efd2af7658d0a0579aa9e15b17137368f4"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.44.0"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DataStructures", "Distributions", "DocStringExtensions", "EnumX", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "Parameters", "PreallocationTools", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Static", "StaticArraysCore", "Statistics", "Tricks", "TruncatedStacktraces", "ZygoteRules"]
git-tree-sha1 = "0d9982e8dee851d519145857e79a17ee33ede154"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.130.0"

[[DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "Functors", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "d0b94b3694d55e7eedeee918e7daee9e3b873399"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.35.0"

[[DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "57ed4597a309c5b2a10cab5f9813adcb78f92117"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.19.0"

[[DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "NonlinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "96a19f498504e4a3b39524196b73eb60ccef30e9"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.10.0"

[[Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "9242eec9b7e2e14f9952e8ea1c7e31a50501d587"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.104"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "51b4b84d33ec5e0955b55ff4b748b99ce2c3faa9"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.6.7"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "8b84876e31fa39479050e2d3395c4b3b210db8b0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.6"

[[EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[EnzymeCore]]
deps = ["Adapt"]
git-tree-sha1 = "2efe862de93cd87f620ad6ac9c9e3f83f1b2841b"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.6.4"

[[EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "602e4585bcbd5a25bc06f514724593d13ff9e862"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.25.0"

[[ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "a6e756a880fc419c8b41592010aebe6a5ce09136"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.8"

[[FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "b12f05108e405dadcc2aff0008db7f831374e051"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "2.0.0"

[[FillArrays]]
deps = ["LinearAlgebra", "PDMats", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9a68d75d466ccc1218d0552a8e1631151c569545"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.5"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[Glob]]
git-tree-sha1 = "97285bbd5230dd766e9ef6749b80fc617126d496"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[Groebner]]
deps = ["AbstractAlgebra", "Combinatorics", "ExprTools", "Logging", "MultivariatePolynomials", "Primes", "Random", "SIMD", "SnoopPrecompile"]
git-tree-sha1 = "44f595de4f6485ab5ba71fe257b5eadaa3cf161e"
uuid = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
version = "0.4.4"

[[GroupsCore]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "6df9cd6ee79fc59feab33f63a1b3c9e95e2461d5"
uuid = "d5909c97-4eac-4ecc-a3dc-fdd0858a4120"
version = "0.4.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

[[HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "199288db29b37c0d3fbd30c66c9b66fa4aea5ceb"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.0.0+1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

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

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60b1194df0a3298f460063de985eae7b01bc011a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.1+0"

[[JuliaFormatter]]
deps = ["CSTParser", "CommonMark", "DataStructures", "Glob", "Pkg", "PrecompileTools", "Tokenize"]
git-tree-sha1 = "8f5295e46f594ad2d8652f1098488a77460080cd"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "1.0.45"

[[JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "UnPack"]
git-tree-sha1 = "c451feb97251965a9fe40bacd62551a72cc5902c"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.10.1"

[[KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "884c2968c2e8e7e6bf5956af88cb46aa745c854b"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.4.1"

[[Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "8a6837ec02fe5fb3def1abc907bb802ef11a0729"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.9.5"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "f12f2225c999886b69273f84713d1b9cb66faace"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.15.0"

[[LambertW]]
git-tree-sha1 = "c5ffc834de5d61d00d2b0e18c96267cffc21f648"
uuid = "984bce1d-4616-540c-a9ee-88d1112d94c9"
version = "0.4.6"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

[[LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

[[Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LinearSolve]]
deps = ["ArrayInterface", "ConcreteStructs", "DocStringExtensions", "EnumX", "EnzymeCore", "FastLapackInterface", "GPUArraysCore", "InteractiveUtils", "KLU", "Krylov", "Libdl", "LinearAlgebra", "MKL_jll", "PrecompileTools", "Preferences", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Sparspak", "SuiteSparse", "UnPack"]
git-tree-sha1 = "9f807ca41005f9a8f092716e48022ee5b36cf5b1"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "2.14.1"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "SpecialFunctions", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "0f5648fbae0d015e3abe5867bca2b362f67a5894"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.166"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "72dc3cf284559eb8f53aa593fe62cb33f83ed0c0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.0.0+0"

[[MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

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

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[ModelingToolkit]]
deps = ["AbstractTrees", "ArrayInterface", "Combinatorics", "Compat", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffRules", "Distributed", "Distributions", "DocStringExtensions", "DomainSets", "ForwardDiff", "FunctionWrappersWrappers", "Graphs", "IfElse", "InteractiveUtils", "JuliaFormatter", "JumpProcesses", "LabelledArrays", "Latexify", "Libdl", "LinearAlgebra", "MLStyle", "MacroTools", "NaNMath", "OrdinaryDiffEq", "PrecompileTools", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "Serialization", "Setfield", "SimpleNonlinearSolve", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "SymbolicUtils", "Symbolics", "URIs", "UnPack", "Unitful"]
git-tree-sha1 = "87a45c453295c1640a1fd011a85e42fda7a78d15"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "8.70.0"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "eaa98afe2033ffc0629f9d0d83961d66a021dfcc"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.7"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "806eea990fb41f9b36f1253e5697aa645bf6a9f8"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.4.0"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[NonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "EnumX", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "PrecompileTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SparseArrays", "SparseDiffTools", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "e10debcea868cd6e51249e8eeaf191c25f68a640"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "1.10.1"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "01f85d9269b13fedc61e63cc72ee2213565f7a72"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.8"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "IfElse", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLNLSolve", "SciMLOperators", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "SparseDiffTools", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "f0f43037c0ba045e96f32d65858eb825a211b817"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.58.2"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[PackageExtensionCompat]]
deps = ["Requires", "TOML"]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "a0f1159c33f846aa77c3f30ebbc69795e5327152"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.4"

[[Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "fca25670784a1ae44546bcb17288218310af2778"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.9"

[[PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "Requires"]
git-tree-sha1 = "f739b1b3cc7b9949af3b35089931f2b58c289163"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.12"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "1d05623b5952aed1307bf8b43bec8b8d1ef94b6e"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.5"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "c860e84651f58ce240dd79e5d9e055d55234c35a"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.2"

[[RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "b8a399e95663485820000f26b6a43c794e166a49"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.4"

[[RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "d7087c013e8a496ff396bae843b1e16d9a30ede8"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.38.10"

[[RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "PrecompileTools", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "8bc86c78c7d8e2a5fe559e3721c0f9c9e303b2ed"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.21"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "6aacc5eefe8415f47b3e34214c1d79d2674a0ba2"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.12"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "d8911cc125da009051fb35322415641d02d9e37f"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.4.6"

[[SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

[[SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "ChainRulesCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FillArrays", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables", "TruncatedStacktraces", "ZygoteRules"]
git-tree-sha1 = "916b8a94c0d61fa5f7c5295649d3746afb866aff"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.98.1"

[[SciMLNLSolve]]
deps = ["DiffEqBase", "LineSearches", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "765b788339abd7d983618c09cfc0192e2b6b15fd"
uuid = "e9a6253c-8580-4d32-9898-8661bb511710"
version = "0.1.9"

[[SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "Lazy", "LinearAlgebra", "Setfield", "SparseArrays", "StaticArraysCore", "Tricks"]
git-tree-sha1 = "51ae235ff058a64815e0a2c34b1db7578a06813d"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.7"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[SimpleNonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "PackageExtensionCompat", "PrecompileTools", "Reexport", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "15ff97fa4881133caa324dacafe28b5ac47ad8a2"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "0.1.23"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SparseDiffTools]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "PackageExtensionCompat", "Random", "Reexport", "SciMLOperators", "Setfield", "SparseArrays", "StaticArrayInterface", "StaticArrays", "Tricks", "UnPack", "VertexSafeGraphs"]
git-tree-sha1 = "ddea63e5de5405878d990a2cea4fc1daf2d52d41"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "2.14.0"

[[Sparspak]]
deps = ["Libdl", "LinearAlgebra", "Logging", "OffsetArrays", "Printf", "SparseArrays", "Test"]
git-tree-sha1 = "342cf4b449c299d8d1ceaf00b7a49f4fbc7940e7"
uuid = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
version = "0.3.9"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "f295e0a1da4ca425659c57441bcb59abb035a4bc"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.8"

[[StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "5d66818a39bb04bf328e92bc933ec5b4ee88e436"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "2aded4182a14b19e9b62b063c0ab561809b5af2c"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.8.0"

[[StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

[[SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "2ca69f4be3294e4cd987d83d6019037d420d9fc1"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.16.1"

[[StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "b341540a647b39728b6d64eaeda82178e848f76e"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.62.0"

[[StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "d6415f66f3d89c615929af907fdc6a3e17af0d8c"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.5.2"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "PrecompileTools", "Reexport", "SciMLBase", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "71dc65a2d7decdde5500299c9b04309e0138d1b4"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.20.1"

[[Sundials_jll]]
deps = ["CompilerSupportLibraries_jll", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "013ff4504fc1d475aa80c63b455b6b3a58767db2"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.0+1"

[[SymbolicIndexingInterface]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "f8ab052bfcbdb9b48fad2c80c873aa0d0344dfe5"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.2.2"

[[SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TimerOutputs", "Unityper"]
git-tree-sha1 = "e7bf8868bd1acad8e0bb59f6fd964410b82f3eef"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "1.1.0"

[[Symbolics]]
deps = ["ArrayInterface", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "Groebner", "IfElse", "LaTeXStrings", "LambertW", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Markdown", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TreeViews"]
git-tree-sha1 = "f1d43a0dbb553890195e49fb599ea51d0e97a5ef"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "5.5.1"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f548a9e9c490030e545f72074a41edfd0e5bcdd7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.23"

[[Tokenize]]
git-tree-sha1 = "0454d9a9bad2400c7ccad19ca832a2ef5a8bc3a1"
uuid = "0796e94c-ce3b-5d07-9a54-7f471281c624"
version = "0.5.26"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "fadebab77bf3ae041f77346dd1c290173da5a443"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.20"

[[Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

[[UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[Unityper]]
deps = ["ConstructionBase"]
git-tree-sha1 = "21c8fc7cd598ef49f11bc9e94871f5d7740e34b9"
uuid = "a7c27f48-0311-42f6-a7f8-2c11e75eb415"
version = "0.1.5"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "7209df901e6ed7489fe9b7aa3e46fb788e15db85"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.65"

[[VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "9d749cd449fb448aeca4feee9a2f4186dbb5d184"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.4"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "576c27f2c23add3ce8f10717d72fbaee6fe120e9"
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "3.1.0+2"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
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
# ╟─ddcea9d8-abc0-40a3-8740-fa0cd29b0b0e
# ╟─4c3f3770-ef33-41a5-89a6-274101b06c87
# ╟─71baff78-d298-4c6a-99d5-6b65c1c27e6f
# ╟─70547a7e-c357-4787-9c34-d2789bb60860
# ╟─77d94a92-f058-4b9f-9df8-9de58603c293
# ╟─e0581cf3-f942-45a6-bcf2-9e72ba2379a4
# ╟─28def719-c8e2-43d6-b20e-6141e423add2
# ╠═d3acb594-ce66-4049-b674-ef641ee1207e
# ╠═961c955f-cc9b-4cb3-abed-dc19a95ca1eb
# ╠═01ce7903-0ba3-45bc-816a-f8288583b4d4
# ╠═6bfa46a7-f50d-49b6-bebc-b7821f89100f
# ╟─52d9452b-5c1e-42ea-8976-0ec2f30eaaf8
# ╠═43593199-0107-4b69-a239-f9f68c14b8eb
# ╟─4b731a5f-3fe2-4691-8f89-c37f05d623ab
# ╟─416dc725-d1c1-4b14-9315-aa57d9e1127d
# ╠═671ad109-4bea-426f-b5c2-2dcabb53a7be
# ╟─56714c4c-daed-47e2-bda7-ab5518e16faa
# ╠═3bd175bd-0019-40bc-a1f7-9f94e94ddb87
# ╟─63181343-9e48-4cdc-8888-c5476b4d75cd
# ╟─122b4bc2-24df-423c-904b-158cc0790abe
# ╟─dd6bea4d-35fc-4cea-956c-00db08a1f511
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
# ╟─d1b89ad6-9116-48b4-805f-f1ba6b15b3dc
# ╟─e5a804cc-0cbe-4645-974b-0fca7cb366e0
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
# ╟─925feb4c-6f29-4dff-8e9e-f5032b47ac22
# ╟─66de57a4-18db-41fc-ba0f-8b889c4c4e66
# ╟─24c846f3-3c61-4f9b-b243-d303451bcfdf
# ╟─2c33a46c-6024-4a55-a7a5-5b7838cd4c9d
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
# ╟─00edd691-2b60-4d1d-b5e2-2fd4675469da
# ╟─7a937f2c-5808-4756-9bfc-6f84b0f03cc9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
