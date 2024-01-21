### A Pluto.jl notebook ###
# v0.19.36

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> title = "Modeling a Zombie Attack "
#> date = "2023-12-16"
#> license = "Unlicense"
#> description = "An introduction to modeling dynamical systems with Modeling Toolkit through a Zombie Attack.  "
#> tags = ["dynamical systems", "biology", "modelingtoolkit", "zombie outbreak", "modeling"]
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
	!!! info "ModelingToolkit"
		[ModelingToolkit](https://juliapackages.com/p/ModelingToolkit):
	
		[DifferentialEquations](https://www.juliapackages.com/p/DifferentialEquations): 
	"""
end

# ╔═╡ 7a937f2c-5808-4756-9bfc-6f84b0f03cc9
begin
	using Plots
	gr()
	using PlutoUI
	import PlutoUI: combine
	using PlutoHooks
	using HypertextLiteral: @htl
	using Parameters
	md"""
	!!! info "ModelingToolkit"
		[Plots](https://juliapackages.com/p/Plots):
	
		[PlutoUI](https://www.juliapackages.com/p/PlutoUI): 
	
		[PlutoHooks](https://www.juliapackages.com/p/PlutoHooks): 
	
		[HypertextLiteral](https://www.juliapackages.com/p/HypertextLiteral): 
	
		[Parameters](https://www.juliapackages.com/p/Parameters): 
	"""
end

# ╔═╡ 5d7d7822-61c9-47a1-830b-6b0294531d5c
TableOfContents()

# ╔═╡ fc95aba1-5f63-44ee-815c-e9f181219253
md"""The world is facing a impending disaster. A virus broke out from a laboratory and is turning humans into zombies! 
There are only 2 outcomes, either the zombies take over the world or a solution is found to fight them and survive this terrible apocalpyse.

Countries are closing down borders, flights are no longer running, chaos is spreading quickly accross the world... 
"""

# ╔═╡ 19ea7ddf-f62b-4dd9-95bb-d71ac9c375a0
md"# Introduction"

# ╔═╡ 7f21a7c5-08aa-4810-9752-671516918119
md"""There is hope! The zombies are still in low numbers and there is time to prepare. What could we possibly do to address this? Before nailing planks of wood to the windows of the lab, let's try to understand what *could* happen. 

Let's try to use a model of an outbreak to try and predict what could happen. 
"""

# ╔═╡ bf5da9c2-bb7b-46d2-8b39-a362eaf9e6f9
md"# Simple Zombie Outbreak Model"

# ╔═╡ cc1a1a9a-7a45-4231-8471-0fb90b994357
md"""To model the situation, lets start with the simplest model. In this model, there are healthy humans and zombies. So what happens when a zombie meets a human? Well we can say that there is a rate β that describes the chance of a zombie converting a human into another human. We can then define the following system of equation: 
"""

# ╔═╡ 4c3f3770-ef33-41a5-89a6-274101b06c87
md"""However since β is define to be positive this model is quite pessimistic, every scenario will eventually end up with zombies taking over the world. 

Lets give the humans some chance of fighting back. We can introduce a new class of individuals in our model, that we'll call 'Removed'. This class represent the zombies that were abled to be killed by humans. We now have: 

- S: Human suceptible to be converted (Healthy)
- Z: Zombies 
- R: Removed 

We define the rate at which the suceptible kill the zombies with the rate α. Addionally, these zombies will be hard to get rid of since there is a small chance ζ that a removed "comes back from the dead" and is reintroduced as a zombie. 
"""

# ╔═╡ e0581cf3-f942-45a6-bcf2-9e72ba2379a4
md"""

!!! info "Acausal Modeling"
	To define this model, we will be using the acausal modeling library [ModelingToolkit](https://github.com/SciML/ModelingToolkit.jl) from [SciML](https://sciml.ai/). The idea is that we can define equations and systems using the equations that we have defined directly. (You can actually check that the system that is mentioned earlier is actually a ModelingToolkit system.)

"""

# ╔═╡ 28def719-c8e2-43d6-b20e-6141e423add2
md"The first step is to define the variables that we'll be needed for the model. Tht is, our depedent time variable ``t``, the differential operator ``D``, the independent variables ``S``, ``Z``, ``R`` and the model parameters ``α``, ``β``, ``ζ`` " 

# ╔═╡ d3acb594-ce66-4049-b674-ef641ee1207e
@variables t

# ╔═╡ 961c955f-cc9b-4cb3-abed-dc19a95ca1eb
D = Differential(t)

# ╔═╡ 01ce7903-0ba3-45bc-816a-f8288583b4d4
@variables S(t) Z(t) R(t)  # Our 3 dependent variables 

# ╔═╡ 6bfa46a7-f50d-49b6-bebc-b7821f89100f
@parameters α β ζ  

# ╔═╡ ddcea9d8-abc0-40a3-8740-fa0cd29b0b0e
ODESystem(
	[
		D(S) ~ -β*S*Z,
	 	D(Z) ~  β*S*Z]
, name = :base) # only used for equations display

# ╔═╡ 43593199-0107-4b69-a239-f9f68c14b8eb
@named simple_attack_sys = ODESystem(
	[
		D(S) ~ -β*S*Z,
		D(Z) ~  β*S*Z - α*S*Z + ζ*R,
		D(R) ~ 			α*S*Z - ζ*R
	]
)

# ╔═╡ 4b731a5f-3fe2-4691-8f89-c37f05d623ab
md"Now in order to simulate what would happen to our model we need to set some values for each of the variables and parameter of the system"

# ╔═╡ 416dc725-d1c1-4b14-9315-aa57d9e1127d
md"""

!!! info "Sliders"
	Throughout this notebook I use sliders to add interactivity to the system. When defining parameters and initial values it will always be in the form:

	`[PARAM] => [SYSTEM](u0s/ps).[PARAM]`
	
	where `[SYSTEM](u0s/ps)` is an variable that contains the current values selected by the sliders and `[SYSTEM]` is the system of the current section. More information is available in the [appendix](#6b4feee8-f8bb-4639-a423-97e7ab82cad0). 
"""

# ╔═╡ c0be7469-6c7b-46e8-b4b5-2c3c1d003433
md"# Extending the Model"

# ╔═╡ 5047fe97-df0e-4611-9b6c-733af6e0ad32
md"This is good, however, this basic model is quite pessimistic. As you can see, the only scenario where the zombies never take over, is when they never get the chance to bite one human. There seems to be no chance for the camp to survive the attack. But it must be possible, right? "

# ╔═╡ ec47f63d-36eb-4331-aec9-9f1af15a3eab
md"""
!!! tip "Update from the front line"
	As you hear the roars from outside the camp, you realise that their might some hope after all. Some new promising information has come through! A team on the front line has reported that the virus does not transform the human directly into zombies! There might be some hope for a cure... 

	The days are rough and more zombies are trying to get in but after securing the walls of the camp you decide to return to your model to try to add this new bit of information.
"""

# ╔═╡ 0f22c808-a413-415e-95d1-98317ca6ed25
md"## Latent Infection"

# ╔═╡ c1918d6a-3b5a-4046-b084-e6f98eaabee6
md"""	
Let's introduce this as the concept of latent infection. In this scenario, when a zombie bites a human, that human first becomes infected, and after some time, turns into a zombie. 
	
We can introduce a new class `I(t)` and the parameter ρ to capture the rate at which the infected turn into zombies.
"""

# ╔═╡ dc366710-6f43-434c-8787-d6d1a7dd3920
begin
	@variables I(t)
	@parameters ρ 
end;

# ╔═╡ 6aa3249f-4751-45d9-b13d-f748cc950d47
md"We can define the new equations and follow the same workflow as before to solve this system."

# ╔═╡ d4446f64-8d69-4ded-90b3-59544800d6fa
begin
	lattent_infection_eqs = [
		D(S) ~ 			-β*S*Z ,
		D(I) ~ 		  	 β*S*Z 	- ρ*I, 
		D(Z) ~ -α*S*Z 			+ ρ*I  	+ ζ*R,
		D(R) ~  α*S*Z 		 			- ζ*R
	]
end

# ╔═╡ 9358905f-8d2f-40f6-a9d9-38e39ae3ee85
begin
	@named lattent_infection_sys = ODESystem(lattent_infection_eqs)
end

# ╔═╡ 8c51a878-6466-4832-ad74-c90683614ebc
md"""
In this model, we are able to survie a bit longer, but there still does not seem to be a way to overcome all the zombies. 

"""

# ╔═╡ b2e6544a-2e87-439c-9b25-de60518f1970
md"""
!!! tip "New development!"
	As the days go by, there are more and more zombies but few survivors are now coming to the camp. The last group arrived 4 days ago, and there has not been another sighting since. 

	At least it seems that the radio is working again. You switch to the information channel, and you managed to catch some exiting information.

	The cure has been developed!
	It was tested this morning on the first patient. You might be able to stop infected patient turning them into zombies afterall. 
	The report indicates that the cure only works on infected patient and does not seem to work on fully transformed zombies.

	The letter mentioned that the cure will be delivered to all survivor camps in the next few weeks, so as you wait patiently you decide to set up a section of our camp to isolate the infected so that you are ready when we get the cure... 

	So far the virus has not been seen to transmit by any other mean than bitting, and the infected don't seem to have a urge of bitting anyone. 
	However, there don't seem to be a clear warning to when that seems to happen and reports indicates that it takes between 1 day to a couple week after the bite. 
	
	To be safe, we can make a quarantine, where every new infected person can be isolated from anyone else, reducing the chance that they infect other people once they suddendly get a taste of human blood. After setting up the tent and securing everything, we now have a dedicated section of the camp where any new infected patient can stay. 
"""

# ╔═╡ e831d3ab-8122-4cb6-9dfc-ebbfb241f0c9
md"## Setting up a quarantine"

# ╔═╡ a0cfe29e-bc1e-451c-b456-9060137e17d1
md"""Let's add a quarantine into our model. We will represent the number of people in the quarantine section with the state Q(t) and introduce 2 new parameters.

- κ: Infected to Quarantine rate
- γ: Quarantine to Removed rate 

!!! tip "Did you get bitten?"
	We have a big camp and getting bitten has now become taboo, hence a few people have not directly said openly that they have be bitten... 

The κ parameter will take into account and represent how much of the infected are placed in quarantine. 

!!! tip "A unfornutate futur" 
	Unfornutalely the quarantine is not a very solid area and the first infected patient that was admitted turned into zombie, wreaking havoc inside the camp. You take the hard decision to remove the zombies from the quarantine. 

The γ parameter represents all the infected that have turned into zombies and who are then removed.
"""

# ╔═╡ 2cb27c2f-edae-4386-a68d-77b2050924a0
begin
	@variables Q(t)
	@parameters κ γ
end;

# ╔═╡ 6467d83d-0e9c-4025-aecf-ab19807e6ba7
begin
	simple_quarantine_eqs = [
		D(S) ~ -β*S*Z,
		D(I) ~  β*S*Z  - ρ*I 		- κ*I, 		   # New: - κ*I term
		D(Z) ~ -α*S*Z  + ρ*I + ζ*R ,
		D(R) ~  α*S*Z  		 - ζ*R 			+ γ*Q, # New: + γ*Q term
		D(Q) ~          		 	+ κ*I 	- γ*Q  
	]
end;

# ╔═╡ 26050146-bacf-42c2-b56b-4e2ddf27b19d
begin
	@named simple_quarantine_sys = ODESystem(simple_quarantine_eqs)
end

# ╔═╡ 7eb18218-a9aa-4b3e-9448-8b724e9c9093
md"---"

# ╔═╡ 874323d9-2910-4c77-8aa1-902df4990105
md"""
!!! tip "The white van at the gate"
	As you wake up to another day of fighting of zombies, you receive a call from the main gate. A white van is trying to get in. As soon as you hear this, you rush to the gate. 

	"We have the cure!!" you hear, and suddendly the whole camp erupts in joy. You finaly have a chance to fight off this pandedemic. 
"""

# ╔═╡ 79489f1f-b8a7-4800-b9ec-feaf6fa134b1
md"## Treating the infected!"

# ╔═╡ f804a947-4e16-4871-84e3-8654d4fb0a46
md"To incorporate the cure into to the model, we can define a new parameter `c` that will determine how effective the cure is in treating the infected. This parameter abstract the time it takes for the cure to work, the amount of infected patient the camp can treat, the supply etc..."

# ╔═╡ 3d9aacb9-1307-4a80-a277-60fe3a66e7ed
begin
	@parameters c
end;

# ╔═╡ 06efabb8-15dc-4952-9f5b-fabadd13a87a
begin
	treatment_model_eqs = [
		D(S) ~ -β*S*Z 				+ c*I,
		D(I) ~  β*S*Z - ρ*I 		- c*I, 
		D(Z) ~ -α*S*Z + ρ*I + ζ*R     ,
		D(R) ~  α*S*Z  		- ζ*R,
	]
end;

# ╔═╡ 8a8733d1-89ae-4a0b-a218-72127fd14e0b
begin
	@named treatment_model_sys = ODESystem(treatment_model_eqs)
end

# ╔═╡ c81b1580-55e5-4034-934a-b682a029ee9c
md"---"

# ╔═╡ bc1471e4-925f-4583-b9b1-193ca59748be
md"""

!!! tip "A misterious delivery"
	A big crate just got delivered at the camp, with a note that simply state: "A gift from your friends!". 

	After some debate, you anxiously open the crate to find a large number of steel components. You also find a manual at the top: it's a turret! 

	The turret is a next-generation plasma beam turret that send orbs of energy. You are now equipped to handle large vagues of zombies. 
"""

# ╔═╡ aee9374d-fefc-409b-99f0-67de38071f52
md"## Let's fight back..."

# ╔═╡ f7e79c80-1da8-4b95-9447-6107a9e8f2df
md"""
To model the behaviour of our new turret, we can introduce the concept of events into our model. 
ModelingToolkit enables the possibility to define discrete events which affect the values of a state or parameter at a given t. 

In our case, we can define the parameter `k` to define the efficacy of the turret. The manual indicates that the turret reload time is 10s. H

"""

# ╔═╡ edd1f38c-60a9-4dee-afe1-c674907a652c
turret_reload_time = 10.0

# ╔═╡ 806d844d-a02e-4b50-bb51-132513003cbf
begin
	@parameters k
end;

# ╔═╡ 59a77cd5-35de-4e27-9539-43f0d6c791ac
impulsive_eradication_impulse = [
		turret_reload_time => [Z ~ Z - (k*Z)]
]

# ╔═╡ c841be91-502b-4b30-9af0-ba10e5d71558
begin
	impulsive_eradication_eqs = [
		D(S) ~ -β*S*Z 			  		   + c*I,
		D(I) ~  β*S*Z - ρ*I 	  		   - c*I, 
		D(Z) ~ 		  + ρ*I	+ ζ*R - α*S*Z     ,
		D(R) ~  	  		- ζ*R + α*S*Z,
	]
end;

# ╔═╡ 89a66b68-dfaf-454f-b787-96fabb978e7a
begin
	@named impulsive_eradication_sys = ODESystem(
		impulsive_eradication_eqs,
		t,
		[S,Z,I,R],
		[β, α, ζ, k, ρ, c];
		
		# Note here that we explicity give the variables and parameters to the ODESystem constructors. This is due to the fact that the automatic variables/parameters detection from the ODESystem constructor does not work on the discrete events (as of now), so we have to pass k as a parameter, and hence all of them.
		discrete_events = impulsive_eradication_impulse
	)
end

# ╔═╡ 5169aab6-e356-41eb-ba77-1d57d4e1b8ab
md"---"

# ╔═╡ a7819b3e-6929-4d97-8860-b5eeb0c4d39a
md"# Other extensions"

# ╔═╡ 92010b6c-f024-44d2-8d19-2f39b35f26f4
md"""
Can you think of other way to extend the model?
Here's a few ideas:

- The quarantine might not be perfect and zombies might escape, how would the equations change? 
- Maybe there is another cure that can also cure transformed zombies, how could you model that?
- What if the turret requires someone to operate, adding another check might make the last model more realistic? 

Now you can create your own model to make your own zombie attack model. 
 **(Share you model in the Julia slack!)**
"""

# ╔═╡ 6b4feee8-f8bb-4639-a423-97e7ab82cad0
md"# Appendix"

# ╔═╡ 61897e7f-eac1-4eea-a679-4cb53757ee7f
md"# Sliders Setup"

# ╔═╡ 2462b985-9c4a-446a-b8ea-3d5f6c7543c0
md"## Initial Values"

# ╔═╡ 1a50274c-f283-4248-9764-973076e0f1a3
md"### Suceptible"

# ╔═╡ c8d9d400-d8fc-4c29-b7c8-f54670eb8317
md"### Zombie"

# ╔═╡ 0dd7fd47-6575-4b9d-938f-012cff42692d
md"## Parameters"

# ╔═╡ 49d5fe00-d25d-40e8-b8e6-e8a475a23e9c
md"### tSpan"

# ╔═╡ f1d9d916-def2-45f3-94a3-1621d5cd8913
md"### α"

# ╔═╡ 81ef11bb-c4ca-45c9-bd4f-9bef33c1672e
md"### β"

# ╔═╡ 665a9877-1b0e-4175-9d01-aad723209b57
md"### ζ"

# ╔═╡ 826e1888-664f-4a70-89b4-a593c3b3ec47
md"### ρ"

# ╔═╡ a98bc585-2648-4283-a742-e503c469b90b
md"### k"

# ╔═╡ da0d2229-c62c-4a81-8253-c95bf8bf503d
md"### κ"

# ╔═╡ 432b4a0a-d8ff-4765-9397-f54b7e5df0e5
md"### σ"

# ╔═╡ 7cb92640-c3f7-4d15-99bb-7fc159c8856c
md"### γ"

# ╔═╡ 2555bbc3-8b71-4fdd-9daa-9c263502eddf
md"### c"

# ╔═╡ f440930e-c68f-40ee-8d1b-cc510400e872
md"### Interactivity extensions"

# ╔═╡ 19b3047c-6b4d-4e54-a932-1030a31dd713
@with_kw struct SliderParameter{T} 
	lb::T = 0.0
	ub::T = 100.0
	step::T = 1.0
	default::T = lb
	description::String = "" 
	label::String 
	alias::Symbol = Symbol(label)
	function SliderParameter{T}(lb::T,ub::T,step::T,default::T, description::String ,label::String, alias::Symbol) where T
		 if ub < lb error("Invalid Bounds") end 
		 return new{typeof(default)}(lb,ub,step,default,description,label,alias)
	end
end

# ╔═╡ 2a5599e2-77ff-4951-8873-a3bd145b614f
suceptibleInitSlider = SliderParameter(
			lb 		= 1,
			ub 	 	= 1000,
			step 	= 1,
			default = 50,
			alias 	= :S,
			label 	= "👩"
		)

# ╔═╡ ca777958-84f4-42ef-95f7-1b0778620e0c
zombieInitSlider = SliderParameter(
			lb 		= 1,
			ub 	 	= 1000,
			step 	= 1,
			default = 10,
			alias 	= :Z,
			label = "🧟"
		)

# ╔═╡ 90673d7c-9ebf-4d31-8f89-7a3e1325c373
tspanSlider = SliderParameter(
			lb 		= 0.0,
			ub 	 	= 1000.0,
			step 	= 10.0,
			default = 100.0,
			alias 	= :duration,
			label = "Duration"
		)

# ╔═╡ a2fe2c48-bbb1-4601-96b2-470e1768c102
αSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 0.8,
			step  	= 0.01,
			default = 0.5,
			label 	= "α",
			description = "Zombie Defeating Rate" 
		)

# ╔═╡ 91a92730-965a-44a6-87a9-ba350f6614ca
βSlider = SliderParameter(
			lb  	= 0.2, 
			ub 		= 1.0, 
			step   	= 0.01, 
			default = 0.25,
			label  	= "β",
			description = "Infection Rate"
		)

# ╔═╡ b7213dcc-a2de-4507-a869-7f109d5a52ca
ζSlider = SliderParameter(
			lb 		= 0.1,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.05, 
			label 	= "ζ",
			description = "Back from the dead Rate"
		)

# ╔═╡ 671ad109-4bea-426f-b5c2-2dcabb53a7be
simple_attack_params =  [
	S 	=> 50.0,  
	Z 	=> 10.0,  
	R 	=> 0, 				    # we will always start with 0 removed 	 
	α 	=> αSlider.default, 	 
	β 	=> βSlider.default, 	 
	ζ   => ζSlider.default, 	 
]

# ╔═╡ f21ad23e-dcdd-46fa-b10e-fd115c17eb98
ρSlider = SliderParameter(
			lb 		= 0.05,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.4,
			label 	= "ρ",
			description = "Zombie Transformation Rate"
		)

# ╔═╡ 68c6f9c8-2e76-4b08-8b9b-f18b13a4a50b
begin	
	lattent_infection_params =  [
		S => 50.0, 
	 	Z => 10.0, 
	 	I => 0, 					  
		R => 0, 					  
		α => αSlider.default,   # Zombie defeating rate
		β => βSlider.default,   # Zombie infection rate
		ζ => ζSlider.default,   # "Back from the dead" rate
		ρ => ρSlider.default,   # "Back from the dead" rate
	]
end

# ╔═╡ 7fb8d441-3685-4673-a959-75901d5ad06d
kSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.05,
			label 	= "k",
			description = "Turret Effectiveness"
		)

# ╔═╡ 89e74250-9d4b-49cc-9f12-2a4e6d921b90
κSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.05,
			label 	= "κ",
			description = "Infected into Quarantine rate"
		)

# ╔═╡ e5f00f03-348b-4153-bf2b-efffba4254cb
σSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.5,
			label 	= "σ",
	 		description = ""
		)

# ╔═╡ 8c37e496-4f0b-4151-991a-4bccf66e35f8
γSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.04,
			label 	= "γ",
			description = "Quarantine tried to escape but failed rate"
		)

# ╔═╡ 2847c8b9-0ac8-4b90-a23b-6323414b3d1b
begin	
	simple_quarantine_params =  [
		S => 50.0,  
	 	Z => 10.0,  
	 	I => 0, 					   
		R => 0, 					   
		Q => 0, 					   
		α 	=> αSlider.default, # Zombie defeating rate
		β 	=> βSlider.default, # Susceptible to Infection rate
		ζ   => ζSlider.default, # "Back from the dead" rate
		ρ   => ρSlider.default, # Zombie transformation rate
		κ 	=> κSlider.default, # Infected to Quarantined  rate
		γ   => γSlider.default, # Failed Quarantined rate
	]
end

# ╔═╡ 89b55225-e4df-4be3-a34e-e0fe31c1ba0a
cSlider = SliderParameter(
			lb 		= 0.0,
			ub 		= 1.0,
			step 	= 0.01,
			default = 0.5,
			label 	= "c",
			description = "Cure Effectiveness" 
		)

# ╔═╡ e5fc55c6-c292-494d-9a56-9506eb95c80d
begin	
	treatment_model_params =  [
		S => 50.0, 
	 	Z => 10.0, 
	 	I => 0, 				
		R => 0, 				
		α => αSlider.default, 
		β => βSlider.default, 
		ζ => ζSlider.default, 
		ρ => ρSlider.default, 
		c => cSlider.default, 
		
	]
end

# ╔═╡ 1e457fe1-6cc5-4d2e-812e-13f666747d81
begin	
	impulsive_eradication_params =  [
		S => 50.0, 
	 	Z => 10.0, 
		I => 0,
		R => 0, 			
		α => αSlider.default, 
		β => βSlider.default, 
		ρ => βSlider.default,  
		ζ => ζSlider.default, 
		k => kSlider.default, 
		c => cSlider.default, 
		
	]
end;

# ╔═╡ c56afbfc-7536-41cb-9ada-ceba128820c6
@with_kw struct NumberFieldParameter{T}
	lb::T = 0
	ub::T = 100
	step::T = 1
	default::T = lb
	description::String = "" 
	label::String
	alias::Symbol = Symbol(label)
	function NumberFieldParameter(lb,ub,step,default,description, label, alias) 
		 if ub < lb error("Invalid Bounds") end 
		 return new{typeof(default)}(lb,ub,step,default,description,label,alias)
	end
end

# ╔═╡ d5c4e4fd-c674-4d81-a60c-1c0bd13235a4
@with_kw struct CheckBoxParameter
	label::String 
	default::Bool = false
	description::String = "" 
	alias::Symbol = Symbol(label)
end

# ╔═╡ 308bfa9d-58fd-4411-88ab-ba0675898cac
@with_kw struct ColorParameter
	label::String 
	default::RGB = RGB(0,0,0)
	description::String = "" 
	alias::Symbol = Symbol(label)
end

# ╔═╡ 2c33a46c-6024-4a55-a7a5-5b7838cd4c9d
function format_sliderParameter(params;title::String,) 
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div class="slider-container-content">
			<div class="slider-container-content-inner"> 
				$(param.description)
			</div>
			<div class="slider-container-content-inner"> 
			<p>$(param.label)
			</div>
			<div class="slider-container-content-inner"> 
				$(Child(param.alias, PlutoUI.Slider(param.lb:param.step:param.ub, default = param.default, show_value = true))) 
			</div>
			</div>
			
			""")
			
			for param in params
		]
		@htl("""
		<div class="slider-container">
			<div class="slider-container-title">
				<h4>$title</h4>
			</div>
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
			suceptibleInitSlider,
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
		title = "Time Span",
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
		title = "Plotting Parameters",
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

# ╔═╡ 5ddf1f68-2dd6-4780-a5f9-90a2c0370967
begin
	
	let 
		state, setState = @use_state(nothing)
		@use_effect([
			simple_attack_u0s,
			simple_attack_ps, 
			simple_attack_tspan, 
			simple_attack_plots_params
		]) do

			# ModelingToolkit provide a handy feature that is the remake() function. It is used to redefine a model's parameters more effiently when the equations remain identical. This allows for near instant feedback for interaction with the sliders. 
			
			prob = remake(
				simple_attack_prob;
				u0 = ModelingToolkit.varmap_to_vars(
					[
						 S => simple_attack_u0s.S, 
						 Z => simple_attack_u0s.Z,
					     R => 0,
					],
					states(simple_attack_sys)
				),
				p =  ModelingToolkit.varmap_to_vars(
					[
						 α => simple_attack_ps.α, 
						 β => simple_attack_ps.β,
					     ζ => simple_attack_ps.ζ,
					],
					parameters(simple_attack_sys)
				),
				tspan = (0.0, simple_attack_tspan.duration)
			)

			
			sol = solve(prob)
			p = plot(sol, label=["Susceptible 👩" "Zombies 🧟" "Removed 👵" ])
			xlims!(simple_attack_plots_params.ts,simple_attack_plots_params.te)
			setState(p)
		end

		state
	
	end
end

# ╔═╡ e5deaa27-54cb-4f48-8f56-b55c3a797dcf
begin
	lattent_infection_u0s_sliders = @bind lattent_infection_u0s format_sliderParameter([
		suceptibleInitSlider,
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
		],
		title = "Time Span",
	);
end;

# ╔═╡ d04d419b-2fc0-4b3a-bb78-ea3b6b76bc64
begin
	lattent_infection_prob = ODEProblem(
		lattent_infection_sys, 
		lattent_infection_params, 
		(0.0, lattent_infection_tspan.duration)
	)			
	lattent_infection_prob
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
	],
	title = "Plotting Parameters",
);

# ╔═╡ 603aea40-5cb1-4ef0-9bee-f7476c815833
begin
	let 
		state, setState = @use_state(nothing)
		@use_effect([
			lattent_infection_u0s,
			lattent_infection_ps, 
			lattent_infection_tspan, 
			lattent_infection_plots_params]) do
			prob = remake(lattent_infection_prob;
				u0 = ModelingToolkit.varmap_to_vars(
					[
						 S => lattent_infection_u0s.S, 
						 Z => lattent_infection_u0s.Z,
						 I => 0,
					     R => 0,
					],
					states(lattent_infection_sys)
				),
				p =  ModelingToolkit.varmap_to_vars(
					[
						 α => lattent_infection_ps.α, 
						 β => lattent_infection_ps.β,
					     ζ => lattent_infection_ps.ζ,
						 ρ => lattent_infection_ps.ρ
					],
					parameters(lattent_infection_sys)
				),
				tspan = (0, lattent_infection_tspan.duration)
			)
			
			sol = solve(prob)

			p = plot(sol, labels=["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Removed 👵" ])
			xlims!(lattent_infection_plots_params.ts,lattent_infection_plots_params.te)
			setState(p)
		end
		state
	
	end
end

# ╔═╡ 7d8c6ed0-f70c-42ae-9f89-1eb5a4a1447b
simple_quarantine_u0s_sliders = @bind simple_quarantine_u0s format_sliderParameter(
		title = "Initial Values",
		[
			suceptibleInitSlider,
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
		title = "Time Span",
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
		],
		title = "Plotting Parameters",
	);
end;

# ╔═╡ f2bfba1b-6be2-4e30-a886-617c30f8b027
begin
	let 
		state, setState = @use_state(nothing)
		@use_effect([
			simple_quarantine_u0s,
			simple_quarantine_ps,
			simple_quarantine_tspan, 
			simple_quarantine_plots_params
			]) do
			prob = remake(simple_quarantine_prob;
				u0 = ModelingToolkit.varmap_to_vars(
					[
						 S => simple_quarantine_u0s.S, 
						 Z => simple_quarantine_u0s.Z,
						 Q => 0,
						 I => 0,
					     R => 0,
					],
					states(simple_quarantine_sys)
				),
				p =  ModelingToolkit.varmap_to_vars(
					[
						 α => simple_quarantine_ps.α, 
						 β => simple_quarantine_ps.β,
					     ζ => simple_quarantine_ps.ζ,
						 γ => simple_quarantine_ps.γ,
						 ρ => simple_quarantine_ps.ρ,
						 κ => simple_quarantine_ps.κ
					],
					parameters(simple_quarantine_sys)
				),
				tspan = (0, simple_quarantine_tspan.duration)
			)
			
			sol = solve(prob)
			p = plot(sol,  labels=["Susceptible 👩" "Infected 😱" "Zombies 🧟" "Removed 👵" "Quarantine 😷" ])
			xlims!(simple_quarantine_plots_params.ts,simple_quarantine_plots_params.te)
			setState(p)
		end
		state
	
	end
end

# ╔═╡ 00b880d1-3db4-40a6-aff4-03a4900df99d
treatment_model_u0s_sliders = @bind treatment_model_u0s format_sliderParameter([
		suceptibleInitSlider,
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
		title = "Time Span",
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
	],
	title = "Plotting Parameters",
);

# ╔═╡ 2a3e5049-9ded-427b-b719-f9ef48164bb6
begin
	let 
		state, setState = @use_state(nothing)
		@use_effect([treatment_model_u0s,treatment_model_ps, treatment_model_tspan, treatment_model_plots_params]) do
			prob = remake(treatment_model_prob; 
				u0 = ModelingToolkit.varmap_to_vars(
					[
						 S => treatment_model_u0s.S, 
						 Z => treatment_model_u0s.Z,
						 I => 0,
					     R => 0,
					],
					states(treatment_model_sys)
				),
				p =  ModelingToolkit.varmap_to_vars(
					[
						 α => treatment_model_ps.α, 
						 β => treatment_model_ps.β,
					     ζ => treatment_model_ps.ζ,
						 c => treatment_model_ps.c,
						 ρ => treatment_model_ps.ρ,
					],
					parameters(treatment_model_sys)
				),
				tspan = (0.0, treatment_model_tspan.duration)
			)
			
			sol = solve(prob)
			p = plot(sol)
			xlims!(treatment_model_plots_params.ts,treatment_model_plots_params.te)
			setState(p)
		end
		state
	
	end
end

# ╔═╡ 028b2237-e62a-403b-8d6c-786accb8c782
impulsive_eradication_u0s_sliders = @bind impulsive_eradication_u0s format_sliderParameter(
	title = "Initial Values",
	[
		suceptibleInitSlider,
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
		title = "Time Span",
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
			label = "Starting time (Plot)"
		),
		SliderParameter(
			lb 		= 0.0,
			ub 	 	= impulsive_eradication_tspan.duration,
			step 	= 10.0,
			default = 1000.0,
			alias 	= :te,
			label = "End time (Plot)"
		),
	],
	title = "Plotting Parameters",
);

# ╔═╡ 1d6f6649-ddee-42d7-a0b8-29e03f3ac0f8
begin
	let 
		state, setState = @use_state(nothing)
		@use_effect([
			impulsive_eradication_u0s,
			impulsive_eradication_ps,
			impulsive_eradication_tspan,
			impulsive_eradication_plots_params]) do
			prob = remake(impulsive_eradication_prob;
				u0 = ModelingToolkit.varmap_to_vars(
					[
						 S => impulsive_eradication_u0s.S, 
						 Z => impulsive_eradication_u0s.Z,
						 I => 0,
					     R => 0,
					],
					states(impulsive_eradication_sys)
				),
				p =  ModelingToolkit.varmap_to_vars(
					[
						 α => impulsive_eradication_ps.α, 
						 β => impulsive_eradication_ps.β,
					     ζ => impulsive_eradication_ps.ζ,
					     ρ => impulsive_eradication_ps.ρ,
						 k => impulsive_eradication_ps.k,
						 c => impulsive_eradication_ps.c,
					],
					parameters(impulsive_eradication_sys)
				),
				tspan = (0.0, impulsive_eradication_tspan.duration)
			)
			
			
			sol = solve(prob)
			p = plot(sol)
			xlims!(impulsive_eradication_plots_params.ts,impulsive_eradication_plots_params.te)
			setState(p)
		end
		state
	
	end
end

# ╔═╡ 1b4f97eb-69bb-4cfb-a3b5-8413cee7d2cc
function format_numberFieldParameter( params::Vector{NumberFieldParameter{T}};title::String,) where T
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.NumberField(param.lb:param.step:param.ub, default = param.default)) ) 
			</div>
			
			""")
			for param in params
		]
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ 31873c6e-2c78-4bb8-8069-ca491f25b077
function format_checkBoxParameter( params::Vector{CheckBoxParameter};title::String)
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.CheckBox(default=param.default)) ) 
			</div>
			
			""")
			
			for param in params
		]
		
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ e8f30ca6-0d03-4a8b-a835-c5c1dce56575
function format_colorPicker( params::Vector{ColorParameter};title::String)
	
	return combine() do Child
		
		mds = [
			@htl("""
			<div>
			<p>$(param.label)
			</div>
			<div>
				$(Child(param.alias, PlutoUI.ColorPicker(default=param.default))) 
			</div>
			
			""")
			
			for param in params
		]
		
		md"""
		#### $title
		$(mds)
		"""
	end
end

# ╔═╡ 411354b2-f9b7-46cc-9fe2-358f2d691dfe
function createSliderGroup(sliders, extraSliders)

	slider_group_wrap =  x -> @htl("""
					<div class="slider-group-inner ">
						$x
					</div>
	""")
	sliders_group = map(slider_group_wrap, sliders)
	extraSliders_group = map(slider_group_wrap, extraSliders)
	toggleId = join(rand(["a","b","c","d"],20))
	return @htl("""
	<div class="on-small-show">
		<div class="slider-group sidebar-right">
			<div class="interact-group">
				<div class="slider-group-outer">
					$sliders_group
				</div>
				<div class="slider-container">
					<div class="wrap-collabsible">
						<input id="$(toggleId)" class="toggle" type="checkbox" checked="" />
						<label for="$(toggleId)" class="lbl-toggle">Extra Parameters</label>
						<div class="collapsible-content">
							<div class="content-inner">
								$extraSliders_group
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="on-tiny-show">
		<div class="sidebar-bottom ">
			<div class="interact-group">
				<div>
					$sliders_group
				</div>
				<div class="slider-container">
					<div class="wrap-collabsible">
						<input id="collapsible_simple_attack2" class="toggle" type="checkbox" checked="" />
						<label for="collapsible_simple_attack2" class="lbl-toggle">Extra Parameters</label>
						<div class="collapsible-content">
							<div class="content-inner">
								$extraSliders_group
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
""")
end

# ╔═╡ 122b4bc2-24df-423c-904b-158cc0790abe
createSliderGroup(
		[
			simple_attack_ps_sliders,
			simple_attack_u0s_sliders],
		[
			simple_attack_tspan_sliders,
			simple_attack_plots_params_sliders
		]
	)

# ╔═╡ 572dff66-18d8-4b0f-be6e-75767ac33be0
createSliderGroup(
	[
		lattent_infection_ps_sliders,
		lattent_infection_u0s_sliders
	],
	[
		lattent_infection_tspan_sliders,
		lattent_infection_plots_params_sliders
	])

# ╔═╡ 33ba58f3-9959-48ec-a7f0-098b864ba02f
createSliderGroup(
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
createSliderGroup(
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
createSliderGroup(
	[
		impulsive_eradication_ps_sliders,
		impulsive_eradication_u0s_sliders
	],
	[
		impulsive_eradication_tspan_sliders, impulsive_eradication_plots_params_sliders
	]
)

# ╔═╡ 813fc6b1-460a-49cb-9ae5-909e38e18e71
md"# Packages"

# ╔═╡ 88f8f2b8-6ea5-4bcc-8026-70a760873033
md"### CSS"

# ╔═╡ 929793eb-4409-46d9-85be-98f1b98d8839
@htl("""
<style>

bond {
	width: 100%
	
}


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


.slider-container{
	min-width: 27rem;
    gap: 0.5rem;
	border-radius: 1rem;
	width: 100%;
	background: rgba(0, 105, 255, 0.2);
}
.slider-container-content-wrapper{
	display: flex;
	flex-direction: column;
}
.slider-container-content{
	min-width: 30rem;
	display: flex;
	padding: 0.5rem;
	margin: 0.5rem;
    gap: 0.5rem;
}

.slider-container-content-inner{
 	display: flex;
	align-items: center;
}

.slider-container-title{
	display: block;
	text-align: center;
	padding: 1rem;
	color: #ddd;
	background: #0069ff;
	cursor: pointer;
	border-radius: 7px;
	transition: all 0.25s ease-out;
}

.sidebar-left {
	position: absolute;
    top: 100%;
	right: 110%;
	width: 17rem;
	z-index: 99;
}
.sidebar-right {
    top: 100%;
	position: absolute;
	left: 100%;
	width: 17rem;
}
.sidebar-bottom {
    display: flex;
}

.slider-group{
	display:flex; 
	flex-direction: column;
	padding: .5rem;  
}
.slider-group-inner{
	border-radius: 7px;
	display:flex; 
	align-items:center; 
}
.slider-group-outer{
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.interact-group {
	display: flex;
    flex-direction: column;
	gap: 0.5rem;
}

input[type="checkbox"] {
  display: none;
}
.wrap-collabsible {
  
}

.lbl-toggle {
  display: block;
  font-weight: bold;
  font-family: monospace;
  font-size: 1.2rem;
  text-align: center;
  padding: 1rem;
  color: #ddd;
  background: #0069ff;
  cursor: pointer;
  border-radius: 7px;
  transition: all 0.25s ease-out;
}

.lbl-toggle:hover {
  color: #fff;
}
.lbl-toggle::before {
  content: " ";
  display: inline-block;
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
  border-left: 5px solid currentColor;
  vertical-align: middle;
  margin-right: 0.7rem;
  transform: translateY(-2px);
  transition: transform 0.2s ease-out;
}
.toggle:checked + .lbl-toggle::before {
  transform: rotate(90deg) translateX(-3px);
}
.collapsible-content {
  max-height: 0px;
  overflow: hidden;
  transition: max-height 0.25s ease-in-out;
}
.toggle:checked + .lbl-toggle + .collapsible-content {
  max-height: 100rem;
}
.toggle:checked + .lbl-toggle {
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.collapsible-content .content-inner {
  background: rgba(0, 105, 255, 0.2);
  border-bottom: 1px solid rgba(0, 105, 255, 0.45);
  border-bottom-left-radius: 7px;
  border-bottom-right-radius: 7px;
  padding: 0.25rem .25rem;
}
.content-inner{
  padding: 0.5rem
}
.collapsible-content p {
  margin-bottom: 0;
}


</style>
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoHooks = "0ff47ea0-7a50-410d-8455-4348d5de0774"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DifferentialEquations = "~7.10.0"
HypertextLiteral = "~0.9.5"
ModelingToolkit = "~8.70.0"
Parameters = "~0.12.3"
Plots = "~1.39.0"
PlutoHooks = "~0.0.5"
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
git-tree-sha1 = "b08a4043e1c14096ef8efe4dd97e07de5cacf240"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.4.5"

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

[[PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

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
git-tree-sha1 = "552f30e847641591ba3f39fd1bed559b9deb0ef3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.1"

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
# ╟─5d7d7822-61c9-47a1-830b-6b0294531d5c
# ╟─fc95aba1-5f63-44ee-815c-e9f181219253
# ╟─19ea7ddf-f62b-4dd9-95bb-d71ac9c375a0
# ╟─7f21a7c5-08aa-4810-9752-671516918119
# ╟─bf5da9c2-bb7b-46d2-8b39-a362eaf9e6f9
# ╟─cc1a1a9a-7a45-4231-8471-0fb90b994357
# ╟─ddcea9d8-abc0-40a3-8740-fa0cd29b0b0e
# ╟─4c3f3770-ef33-41a5-89a6-274101b06c87
# ╟─e0581cf3-f942-45a6-bcf2-9e72ba2379a4
# ╟─28def719-c8e2-43d6-b20e-6141e423add2
# ╠═d3acb594-ce66-4049-b674-ef641ee1207e
# ╠═961c955f-cc9b-4cb3-abed-dc19a95ca1eb
# ╠═01ce7903-0ba3-45bc-816a-f8288583b4d4
# ╠═6bfa46a7-f50d-49b6-bebc-b7821f89100f
# ╠═43593199-0107-4b69-a239-f9f68c14b8eb
# ╠═4b731a5f-3fe2-4691-8f89-c37f05d623ab
# ╟─416dc725-d1c1-4b14-9315-aa57d9e1127d
# ╠═671ad109-4bea-426f-b5c2-2dcabb53a7be
# ╠═3bd175bd-0019-40bc-a1f7-9f94e94ddb87
# ╟─122b4bc2-24df-423c-904b-158cc0790abe
# ╟─5ddf1f68-2dd6-4780-a5f9-90a2c0370967
# ╟─49f7ca3c-4b9d-4145-9faa-70d082a5c8d9
# ╟─7551684a-04cd-4d6d-bb9e-b7f4aa46aceb
# ╟─c0be7469-6c7b-46e8-b4b5-2c3c1d003433
# ╠═5047fe97-df0e-4611-9b6c-733af6e0ad32
# ╟─ec47f63d-36eb-4331-aec9-9f1af15a3eab
# ╟─0f22c808-a413-415e-95d1-98317ca6ed25
# ╟─c1918d6a-3b5a-4046-b084-e6f98eaabee6
# ╠═dc366710-6f43-434c-8787-d6d1a7dd3920
# ╟─6aa3249f-4751-45d9-b13d-f748cc950d47
# ╠═d4446f64-8d69-4ded-90b3-59544800d6fa
# ╠═9358905f-8d2f-40f6-a9d9-38e39ae3ee85
# ╠═68c6f9c8-2e76-4b08-8b9b-f18b13a4a50b
# ╠═d04d419b-2fc0-4b3a-bb78-ea3b6b76bc64
# ╠═572dff66-18d8-4b0f-be6e-75767ac33be0
# ╟─603aea40-5cb1-4ef0-9bee-f7476c815833
# ╟─e5deaa27-54cb-4f48-8f56-b55c3a797dcf
# ╟─d59c9761-382e-4450-b654-dc4b8b203f15
# ╟─8c51a878-6466-4832-ad74-c90683614ebc
# ╟─b2e6544a-2e87-439c-9b25-de60518f1970
# ╟─e831d3ab-8122-4cb6-9dfc-ebbfb241f0c9
# ╟─a0cfe29e-bc1e-451c-b456-9060137e17d1
# ╠═2cb27c2f-edae-4386-a68d-77b2050924a0
# ╠═6467d83d-0e9c-4025-aecf-ab19807e6ba7
# ╠═26050146-bacf-42c2-b56b-4e2ddf27b19d
# ╠═2847c8b9-0ac8-4b90-a23b-6323414b3d1b
# ╠═d60f5b1d-132d-4d76-8060-d6365b95e923
# ╠═33ba58f3-9959-48ec-a7f0-098b864ba02f
# ╟─f2bfba1b-6be2-4e30-a886-617c30f8b027
# ╟─7d8c6ed0-f70c-42ae-9f89-1eb5a4a1447b
# ╟─94b4f52b-ae28-4e26-93d2-7e7d32c739d5
# ╟─f13c3c52-7c73-4aa3-a233-3d64f4623b89
# ╟─97564904-a6ce-497b-9bbc-e978c6877f0c
# ╟─7eb18218-a9aa-4b3e-9448-8b724e9c9093
# ╟─874323d9-2910-4c77-8aa1-902df4990105
# ╠═79489f1f-b8a7-4800-b9ec-feaf6fa134b1
# ╟─f804a947-4e16-4871-84e3-8654d4fb0a46
# ╠═3d9aacb9-1307-4a80-a277-60fe3a66e7ed
# ╠═06efabb8-15dc-4952-9f5b-fabadd13a87a
# ╠═8a8733d1-89ae-4a0b-a218-72127fd14e0b
# ╠═e5fc55c6-c292-494d-9a56-9506eb95c80d
# ╠═7b660a3d-3fe3-4d48-be37-49754fa70b16
# ╟─ab916a56-52ff-4f35-b8ba-72f2d3d7ba9a
# ╟─2a3e5049-9ded-427b-b719-f9ef48164bb6
# ╟─00b880d1-3db4-40a6-aff4-03a4900df99d
# ╟─d5c896f3-1aa8-4334-8c7c-7b01b122aa1b
# ╟─53c4ef85-6f0c-46d8-a08a-28f8ab368309
# ╟─22d85cbc-0e8f-49c9-9045-3b56d2a3c2f0
# ╟─c81b1580-55e5-4034-934a-b682a029ee9c
# ╟─bc1471e4-925f-4583-b9b1-193ca59748be
# ╟─aee9374d-fefc-409b-99f0-67de38071f52
# ╟─f7e79c80-1da8-4b95-9447-6107a9e8f2df
# ╠═edd1f38c-60a9-4dee-afe1-c674907a652c
# ╠═59a77cd5-35de-4e27-9539-43f0d6c791ac
# ╠═806d844d-a02e-4b50-bb51-132513003cbf
# ╠═c841be91-502b-4b30-9af0-ba10e5d71558
# ╠═89a66b68-dfaf-454f-b787-96fabb978e7a
# ╠═1e457fe1-6cc5-4d2e-812e-13f666747d81
# ╠═2cfac784-ec48-4963-a12d-d8bac6ae41cc
# ╟─63c5fab1-fb11-4d9a-b2fc-8a23598602ba
# ╟─1d6f6649-ddee-42d7-a0b8-29e03f3ac0f8
# ╟─028b2237-e62a-403b-8d6c-786accb8c782
# ╟─4e947fbc-84f4-460d-9079-0e7397f5d05f
# ╟─5efa346c-4d46-4c5c-9e14-08015a96bd85
# ╟─5169aab6-e356-41eb-ba77-1d57d4e1b8ab
# ╟─a7819b3e-6929-4d97-8860-b5eeb0c4d39a
# ╟─92010b6c-f024-44d2-8d19-2f39b35f26f4
# ╟─6b4feee8-f8bb-4639-a423-97e7ab82cad0
# ╟─61897e7f-eac1-4eea-a679-4cb53757ee7f
# ╠═2462b985-9c4a-446a-b8ea-3d5f6c7543c0
# ╟─1a50274c-f283-4248-9764-973076e0f1a3
# ╟─2a5599e2-77ff-4951-8873-a3bd145b614f
# ╟─c8d9d400-d8fc-4c29-b7c8-f54670eb8317
# ╟─ca777958-84f4-42ef-95f7-1b0778620e0c
# ╟─0dd7fd47-6575-4b9d-938f-012cff42692d
# ╟─49d5fe00-d25d-40e8-b8e6-e8a475a23e9c
# ╟─90673d7c-9ebf-4d31-8f89-7a3e1325c373
# ╟─f1d9d916-def2-45f3-94a3-1621d5cd8913
# ╟─a2fe2c48-bbb1-4601-96b2-470e1768c102
# ╟─81ef11bb-c4ca-45c9-bd4f-9bef33c1672e
# ╟─91a92730-965a-44a6-87a9-ba350f6614ca
# ╟─665a9877-1b0e-4175-9d01-aad723209b57
# ╟─b7213dcc-a2de-4507-a869-7f109d5a52ca
# ╟─826e1888-664f-4a70-89b4-a593c3b3ec47
# ╟─f21ad23e-dcdd-46fa-b10e-fd115c17eb98
# ╟─a98bc585-2648-4283-a742-e503c469b90b
# ╟─7fb8d441-3685-4673-a959-75901d5ad06d
# ╟─da0d2229-c62c-4a81-8253-c95bf8bf503d
# ╟─89e74250-9d4b-49cc-9f12-2a4e6d921b90
# ╟─432b4a0a-d8ff-4765-9397-f54b7e5df0e5
# ╟─e5f00f03-348b-4153-bf2b-efffba4254cb
# ╟─7cb92640-c3f7-4d15-99bb-7fc159c8856c
# ╟─8c37e496-4f0b-4151-991a-4bccf66e35f8
# ╟─2555bbc3-8b71-4fdd-9daa-9c263502eddf
# ╟─89b55225-e4df-4be3-a34e-e0fe31c1ba0a
# ╟─f440930e-c68f-40ee-8d1b-cc510400e872
# ╟─19b3047c-6b4d-4e54-a932-1030a31dd713
# ╟─c56afbfc-7536-41cb-9ada-ceba128820c6
# ╟─d5c4e4fd-c674-4d81-a60c-1c0bd13235a4
# ╟─308bfa9d-58fd-4411-88ab-ba0675898cac
# ╟─2c33a46c-6024-4a55-a7a5-5b7838cd4c9d
# ╟─1b4f97eb-69bb-4cfb-a3b5-8413cee7d2cc
# ╟─31873c6e-2c78-4bb8-8069-ca491f25b077
# ╟─e8f30ca6-0d03-4a8b-a835-c5c1dce56575
# ╟─411354b2-f9b7-46cc-9fe2-358f2d691dfe
# ╠═813fc6b1-460a-49cb-9ae5-909e38e18e71
# ╠═00edd691-2b60-4d1d-b5e2-2fd4675469da
# ╠═7a937f2c-5808-4756-9bfc-6f84b0f03cc9
# ╟─88f8f2b8-6ea5-4bcc-8026-70a760873033
# ╟─929793eb-4409-46d9-85be-98f1b98d8839
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
