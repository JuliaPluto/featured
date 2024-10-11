### A Pluto.jl notebook ###
# v0.19.47

#> [frontmatter]
#> license_url = "https://github.com/mitmath/computational-thinking/blob/Fall23/LICENSE.md"
#> image = "https://images.unsplash.com/photo-1457369804613-52c61a468e7d"
#> title = "Structure and language"
#> tags = ["language", "natural language processing", "language modelling", "natural language generation", "homework"]
#> license = "MIT / CC BY-SA 4.0"
#> description = "Automatically detect the language of a piece of text, and generate realistic-looking random text!"
#> 
#>     [[frontmatter.author]]
#>     name = "MIT Computational Thinking"
#>     url = "https://github.com/mitmath"
#>     [[frontmatter.author]]
#>     name = "Fons van der Plas"
#>     url = "https://github.com/fonsp"
#>     [[frontmatter.author]]
#>     name = "Luka van der Plas"
#>     url = "https://github.com/lukavdplas"

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

# ╔═╡ f0ebf845-3a6b-42f1-963d-7c6c5cf396c8
md"""

!!! info "Attribution"

	This notebook is adapted from [Homework 3](https://computationalthinking.mit.edu/Fall23/homework/hw3/) of the course ["Computational Thinking"](https://computationalthinking.mit.edu/) by Alan Edelman, David P. Sanders, and Fons van der Plas.

	The code is shared under an [MIT licence](https://opensource.org/license/mit/). The text of the course is shared under a [Creative Commons Attribution-ShareAlike 4.0 licence ](https://creativecommons.org/licenses/by-sa/4.0), and has been adapted for this notebook.

	---
	
	If you use or are inspired by any material, would you be so kind to prominently display:
		
	> Some material on this website is based on:
	> **Computational Thinking**, a live online Julia/Pluto textbook. ([computationalthinking.mit.edu](https://computationalthinking.mit.edu))

"""

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# Structure and Language

👉 This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"""
#### Initializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
end

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
bigbreak

# ╔═╡ c75856a8-1f36-4659-afb2-7edb14894ea1
md"""
## Introduction
"""

# ╔═╡ c9a8b35d-2183-4da1-ae35-d2552020e8a8
md"""
In this notebook, we will look at a particular type of data: **written text** in **natural language**. (The word "natural" here is to distinguish human (natural) languages from computer languages.)

In computational fields, dealing with data often means finding structure. Human speech or text is a big, complicated mess that we understand intuitively, but which is very difficult to explain to a computer.

One approach is to create a **grammar**: a formal system of rules that describes things like what order words can appear in, and how that translates to meaning. Those rules have to be written by humans, which turns out to be very difficult.

The other approach is to rely on **statistics**: we use a lot of real text as our starting point, and try to identify quantitative patterns in the text. Or preferably, we let our computer identify patterns for us 😉

Statistical approaches have made huge advances over the past few decades, and are a key component of state-of-the-art developments in artificial intelligence.

In this notebook, we'll use statistical patterns to analyse text, as well as generate some text of our own. To do this, we'll need to find some sort of structure in all those words...
"""

# ╔═╡ e8976562-d92b-4a58-adb8-3250486887b7
md"""
!!! info "A bit of theory: what is a language model?"

	What does it mean to make a model of a language?

	Formally, we usually define a [language model](https://en.wikipedia.org/wiki/Language_model) as something that gives you a _probability_ for a piece of text. That is to say, if we've built a model of the English language, we can give it a piece of text like `"I'm drinking tea"`, and it will tell us how likely it is that a random piece of English text is that exact sequence of characters.
	
	That may seem a bit limited: shouldn't a model be about other things, too? Shouldn't it describe grammar, or tell you what words mean?
	
	Well, a really advanced probabilistic model should do all of that. It should tell you that `"drinking tea I'm"` is less likely, because that is not a valid word order in English. And it should also know that `"I'm drinking pizza"` is less likely, because pizza isn't something you can drink.
	
	And importantly, such a model turns out to be quite useful. Technologies like language detection and spelling checkers essentially need to say: does this bit of text look like normal English text? When we want to generate text, we can use the model to ask: what is the most likely text here?
"""

# ╔═╡ 6f9df800-f92d-11ea-2d49-c1aaabd2d012
md"""
$bigbreak

## **Exercise 1:** _Language detection_

Let's start with some obvious structure in English text: the set of characters that we write the language in. If we generate random text by sampling (choosing) random characters (`Char` in Julia), it does not look like English:
"""

# ╔═╡ 3206c771-495a-43a9-b707-eaeb828a8545
rand(Char, 5)   # sample 5 random characters

# ╔═╡ b61722cc-f98f-11ea-22ae-d755f61f78c3
String(rand(Char, 40))   # join into a string

# ╔═╡ 59f2c600-2b64-4562-9426-2cfed9a864e4
md"""
[`Char` in Julia is the type for a [Unicode](https://en.wikipedia.org/wiki/Unicode) character, which includes characters like `日` and `⛄`.]
"""

# ╔═╡ f457ad44-f990-11ea-0e2d-2bb7627716a8
md"""
Instead, let's define an _alphabet_, and only use those letters to sample from. To keep things simple we will ignore punctuation, capitalization, etc., and use only the following 27 characters (English letters plus "space"):
"""

# ╔═╡ 4efc051e-f92e-11ea-080e-bde6b8f9295a
alphabet = ['a':'z' ; ' ']   # includes the space character

# ╔═╡ 38d1ace8-f991-11ea-0b5f-ed7bd08edde5
md"""
Let's sample random characters from our alphabet:
"""

# ╔═╡ ddf272c8-f990-11ea-2135-7bf1a6dca0b7
Text(String(rand(alphabet, 40)))

# ╔═╡ 3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
md"""
That already looks a lot better than our first attempt! But it still does not look like English text -- we can do better. 

### Frequency table

English words are not well modelled by this random-Latin-characters model. Our first observation is that **some letters are more common than others**. To put this observation into practice, we would like to have the **frequency table** of the Latin alphabet. We could search for it online, but it is actually very simple to calculate ourselves! The only thing we need is a _representative sample_ of English text.

The following samples are from Wikipedia, but feel free to type in your own sample! You can also enter a sample of a different language, if that language can be expressed in the Latin alphabet.

Remember that the $(html"<img src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/eye-outline.svg' style='width: 1em; height: 1em; margin-bottom: -.2em;'>") button on the left of a cell will show or hide the code.

We also include a sample of Spanish, which we'll use later!
"""

# ╔═╡ d67034d0-f92d-11ea-31c2-f7a38ebb412f
samples = (
	English = """
Although the word forest is commonly used, there is no universally recognised precise definition, with more than 800 definitions of forest used around the world.[4] Although a forest is usually defined by the presence of trees, under many definitions an area completely lacking trees may still be considered a forest if it grew trees in the past, will grow trees in the future,[9] or was legally designated as a forest regardless of vegetation type.[10][11]
	
The word forest derives from the Old French forest (also forès), denoting "forest, vast expanse covered by trees"; forest was first introduced into English as the word denoting wild land set aside for hunting[14] without the necessity in definition of having trees on the land.[15] Possibly a borrowing, probably via Frankish or Old High German, of the Medieval Latin foresta, denoting "open wood", Carolingian scribes first used foresta in the Capitularies of Charlemagne specifically to denote the royal hunting grounds of the King. The word was not endemic to Romance languages, e. g. native words for forest in the Romance languages derived from the Latin silva, which denoted "forest" and "wood(land)" (confer the English sylva and sylvan); confer the Italian, Spanish, and Portuguese selva; the Romanian silvă; and the Old French selve, and cognates in Romance languages, e. g. the Italian foresta, Spanish and Portuguese floresta, etc., are all ultimately derivations of the French word. 
""",
	Spanish =  """
Un bosque es un ecosistema donde la vegetación predominante la constituyen los árboles y matas.1​ Estas comunidades de plantas cubren grandes áreas del globo terráqueo y funcionan como hábitats para los animales, moduladores de flujos hidrológicos y conservadores del suelo, constituyendo uno de los aspectos más importantes de la biosfera de la Tierra. Aunque a menudo se han considerado como consumidores de dióxido de carbono atmosférico, los bosques maduros son prácticamente neutros en cuanto al carbono, y son solamente los alterados y los jóvenes los que actúan como dichos consumidores.2​3​ De cualquier manera, los bosques maduros juegan un importante papel en el ciclo global del carbono, como reservorios estables de carbono y su eliminación conlleva un incremento de los niveles de dióxido de carbono atmosférico.

Los bosques pueden hallarse en todas las regiones capaces de mantener el crecimiento de árboles, hasta la línea de árboles, excepto donde la frecuencia de fuego natural es demasiado alta, o donde el ambiente ha sido perjudicado por procesos naturales o por actividades humanas. Los bosques a veces contienen muchas especies de árboles dentro de una pequeña área (como la selva lluviosa tropical y el bosque templado caducifolio), o relativamente pocas especies en áreas grandes (por ejemplo, la taiga y bosques áridos montañosos de coníferas). Los bosques son a menudo hogar de muchos animales y especies de plantas, y la biomasa por área de unidad es alta comparada a otras comunidades de vegetación. La mayor parte de esta biomasa se halla en el subsuelo en los sistemas de raíces y como detritos de plantas parcialmente descompuestos. El componente leñoso de un bosque contiene lignina, cuya descomposición es relativamente lenta comparado con otros materiales orgánicos como la celulosa y otros carbohidratos. Los bosques son áreas naturales y silvestre 
""" |> unaccent,
)

# ╔═╡ 7e09011c-71b5-4f05-ae4a-025d48daca1d
samples.English |> Quote

# ╔═╡ a094e2ac-f92d-11ea-141a-3566552dd839
md"""
#### Exercise 1.1 - _Data cleaning_
Looking at the sample, we see that it is quite _messy_: it contains punctuation, accented letters and numbers. For our analysis, we are only interested in our 27-character alphabet (i.e. `'a'` through `'z'` plus `' '`). We are going to clean the data using the Julia function `filter`. 
"""

# ╔═╡ 27c9a7f4-f996-11ea-1e46-19e3fc840ad9
filter(isodd, [6, 7, 8, 9, -5])

# ╔═╡ f2a4edfa-f996-11ea-1a24-1ba78fd92233
md"""
`filter` takes two arguments: a **function** and a **collection**. The function is applied to each element of the collection, and it must return either `true` or `false` for each element. If the result is `true`, then that element is included in the final collection.

Did you notice something cool? Functions are also just _objects_ in Julia, and you can use them as arguments to other functions! _(Fons thinks this is super cool.)_

$(html"<br>")

We have written a function `isinalphabet`, which takes a character and returns a boolean:
"""

# ╔═╡ 5c74a052-f92e-11ea-2c5b-0f1a3a14e313
"""
Checks if a character is in our pre-defined alphabet.
"""
function isinalphabet(character)
	character ∈ alphabet
end

# ╔═╡ dcc4156c-f997-11ea-3e6f-057cd080d9db
isinalphabet('a'), isinalphabet('+')

# ╔═╡ 129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
md"👉 Use `filter` to extract just the characters from our alphabet out of `messy_sentence_1`:"

# ╔═╡ 3a5ee698-f998-11ea-0452-19b70ed11a1d
messy_sentence_1 = "#wow 2020 ¥500 (blingbling!)"

# ╔═╡ 75694166-f998-11ea-0428-c96e1113e2a0
cleaned_sentence_1 = missing

# ╔═╡ 6fe693c8-f9a1-11ea-1983-f159131880e9
if !@isdefined(messy_sentence_1)
	not_defined(:messy_sentence_1)
elseif !@isdefined(cleaned_sentence_1)
	not_defined(:cleaned_sentence_1)
else
	if cleaned_sentence_1 isa Missing
		still_missing()
	elseif cleaned_sentence_1 isa Vector{Char}
		keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
	elseif cleaned_sentence_1 == filter(isinalphabet, messy_sentence_1)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 05f0182c-f999-11ea-0a52-3d46c65a049e
md"""
$(html"<br>")

We are not interested in the capitalization of letters (i.e. `'A'` vs `'a'`), so we want to *map* these to lower case _before_ we apply our filter. If we don't, all upper case letters would get deleted.

Julia has a `map` function to do exactly this. Like `filter`, its first argument is the function we want to apply to each element of the second argument.

"""

# ╔═╡ 98266882-f998-11ea-3270-4339fb502bc7
md"👉 Use the function `lowercase` to convert `messy_sentence_2` into a lower case string, and then use `filter` to extract only the characters from our alphabet."

# ╔═╡ d3c98450-f998-11ea-3caf-895183af926b
messy_sentence_2 = "Awesome! 😍"

# ╔═╡ d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
cleaned_sentence_2 = missing

# ╔═╡ cee0f984-f9a0-11ea-2c3c-53fe26156ea4
if !@isdefined(messy_sentence_2)
	not_defined(:messy_sentence_2)
elseif !@isdefined(cleaned_sentence_2)
	not_defined(:cleaned_sentence_2)
else
	if cleaned_sentence_2 isa Missing
		still_missing()
	elseif cleaned_sentence_2 isa Vector{Char}
		keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
	elseif cleaned_sentence_2 == filter(isinalphabet, lowercase(messy_sentence_2))
		correct()
	else
		keep_working()
	end
end

# ╔═╡ aad659b8-f998-11ea-153e-3dae9514bfeb
md"""
$(html"<br>")

Finally, we need to deal with **accents**: simply deleting accented characters from the source text might deform it too much. We can add accented letters to our alphabet, but a simpler solution is to *replace* accented letters with the corresponding unaccented base character. We have written a function `unaccent` that does just that.
"""

# ╔═╡ d236b51e-f997-11ea-0c55-abb11eb35f4d
french_word = "Égalité!"

# ╔═╡ a56724b6-f9a0-11ea-18f2-991e0382eccf
unaccent(french_word)

# ╔═╡ 24860970-fc48-11ea-0009-cddee695772c
import Unicode

# ╔═╡ 734851c6-f92d-11ea-130d-bf2a69e89255
"""
Turn `"áéíóúüñ asdf"` into `"aeiouun asdf"`.
"""
unaccent(str) = Unicode.normalize(str, stripmark=true)

# ╔═╡ 8d3bc9ea-f9a1-11ea-1508-8da4b7674629
md"""
$(html"<br>")

👉 Let's put everything together. Write a function `clean` that takes a string, and returns a _cleaned_ version, where:
- accented letters are replaced by their base characters;
- upper-case letters are converted to lower case;
- it is filtered to only contain characters from `alphabet`
"""

# ╔═╡ 4affa858-f92e-11ea-3ece-258897c37e51
function clean(text)
	
	return missing
end

# ╔═╡ e00d521a-f992-11ea-11e0-e9da8255b23b
clean("Crème brûlée est mon plat préféré.")

# ╔═╡ ddfb1e1c-f9a1-11ea-3625-f1170272e96a
if !@isdefined(clean)
	not_defined(:clean)
else
	let
		input = "Aè !!!  x1"
		output = clean(input)
		
		
		if output isa Missing
			still_missing()
		elseif output isa Vector{Char}
			keep_working(md"Use `String(x)` to turn an array of characters `x` into a `String`.")
		elseif output == "ae   x"
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ eaa8c79e-f9a2-11ea-323f-8bb2bd36e11c
md"""
$(bigbreak)
#### Exercise 1.2 - _Letter frequencies_

We are going to count the _frequency_ of each letter in this sample, after applying your `clean` function. Can you guess which character is most frequent?
"""

# ╔═╡ 2680b506-f9a3-11ea-0849-3989de27dd9f
first_sample = clean(first(samples))

# ╔═╡ 571d28d6-f960-11ea-1b2e-d5977ecbbb11
"""
Returns the (relative) frequencies of all letters in a text
"""
function letter_frequencies(txt)
	if ismissing(txt)
		return missing
	end
	f = count.(string.(alphabet), txt)
	f ./ sum(f)
end

# ╔═╡ 11e9a0e2-bc3d-4130-9a73-7c2003595caa
alphabet

# ╔═╡ 6a64ab12-f960-11ea-0d92-5b88943cdb1a
sample_freqs = letter_frequencies(first_sample)

# ╔═╡ 603741c2-f9a4-11ea-37ce-1b36ecc83f45
md"""
The result is a 27-element array, with values between `0.0` and `1.0`. These values correspond to the _frequency_ of each letter. 

`sample_freqs[i] == 0.0` means that the $i$th letter did not occur in your sample, and 
`sample_freqs[i] == 0.1` means that 10% of the letters in the sample are the $i$th letter.

To make it easier to convert between a character from the alphabet and its index, we have the following function:
"""

# ╔═╡ b3de6260-f9a4-11ea-1bae-9153a92c3fe5
index_of_letter(letter) = findfirst(isequal(letter), alphabet)

# ╔═╡ a6c36bd6-f9a4-11ea-1aba-f75cecc90320
index_of_letter('a'), index_of_letter('b'), index_of_letter(' ')

# ╔═╡ 6d3f9dae-f9a5-11ea-3228-d147435e266d
md"""
$(html"<br>")

👉 Which letters from the alphabet did not occur in the sample?
"""

# ╔═╡ 92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
unused_letters = ['a', 'b', 'c'] # replace with your answer

# ╔═╡ 95b81778-f9a5-11ea-3f51-019430bc8fa8
if !@isdefined(unused_letters)
	not_defined(:unused_letters)
else
	if sample_freqs === missing
		md"""
		!!! warning "Oopsie!"
		    You need to complete the previous exercises first.
		"""
	elseif unused_letters isa Missing
		still_missing()
	elseif unused_letters isa String
		keep_working(md"Use `collect` to turn a string into an array of characters.")
	elseif Set(index_of_letter.(unused_letters)) == Set(findall(isequal(0.0), sample_freqs))
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 7df7ab82-f9ad-11ea-2243-21685d660d71
hint(md"You can answer this question without writing any code: have a look at the values of `sample_freqs`.")

# ╔═╡ dcffd7d2-f9a6-11ea-2230-b1afaecfdd54
md"""
$(bigbreak)
Now that we know the frequencies of letters in English, we can generate random text that already looks closer to English!

**Random letters from the alphabet:**
"""

# ╔═╡ b3dad856-f9a7-11ea-1552-f7435f1cb605
String(rand(alphabet, 400)) |> Quote

# ╔═╡ 01215e9a-f9a9-11ea-363b-67392741c8d4
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ be55507c-f9a7-11ea-189c-4ffe8377212e
if sample_freqs !== missing
	String([rand_sample_letter(sample_freqs) for _ in 1:400]) |> Quote
end

# ╔═╡ 8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
md"""
By considering the _frequencies_ of letters in English, we see that our model is already a lot better! 

Our next observation is that **some letter _combinations_ are more common than others**. Our current model thinks that `potato` is just as 'English' as `ooaptt`. In the next section, we will quantify these _transition frequencies_, and use it to improve our model.
"""

# ╔═╡ 343d63c2-fb58-11ea-0cce-efe1afe070c2


# ╔═╡ b5b8dd18-f938-11ea-157b-53b145357fd1
function rand_sample(frequencies)
	x = rand()
	findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))
end

# ╔═╡ 0e872a6c-f937-11ea-125e-37958713a495
function rand_sample_letter(frequencies)
	alphabet[rand_sample(frequencies)]
end

# ╔═╡ 77623f3e-f9a9-11ea-2f46-ff07bd27cd5f
md"""
$(bigbreak)
#### Exercise 1.3 - _Transition frequencies_
In the previous exercise we computed the frequency of each letter in the sample by _counting_ their occurences, and then dividing by the total number of counts.

In this exercise, we are going to count _letter transitions_, such as `aa`, `as`, `rt`, `yy`. Two letters might both be common, like `a` and `e`, but their combination, `ae`, is uncommon in English. 

To quantify this observation, we will do the same as in our last exercise: we count occurences in a _sample text_, to create the **transition frequency matrix**.
"""

# ╔═╡ fbb7c04e-f92d-11ea-0b81-0be20da242c8
function transition_counts(cleaned_sample)
	if ismissing(cleaned_sample)
		return missing
	end
	
	[
		count(string(a, b), cleaned_sample)
		for a in alphabet, b in alphabet
	]
end

# ╔═╡ 80118bf8-f931-11ea-34f3-b7828113ffd8
function normalize_array(x)
	if ismissing(x)
		return missing
	end

	x ./ sum(x)
end

# ╔═╡ 7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
transition_frequencies = normalize_array ∘ transition_counts;

# ╔═╡ d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
transition_frequencies(first_sample)

# ╔═╡ 689ed82a-f9ae-11ea-159c-331ff6660a75
md"What we get is a **27 by 27 matrix**. Each entry corresponds to a character pair. The _row_ corresponds to the first character, the _column_ is the second character. Let's visualize this:"

# ╔═╡ ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
show_pair_frequencies(transition_frequencies(first_sample))

# ╔═╡ aa2a73f6-0c1d-4be1-a414-05a6f8ce04bd
md"""
The brightness of each letter pair indicates how frequent that pair is; here space is indicated as `_`.
"""

# ╔═╡ 0b67789c-f931-11ea-113c-35e5edafcbbf
md"""
Answer the following questions with respect to the **cleaned English sample text**, which we called `first_sample`. Let's also give the transition matrix a name:
"""

# ╔═╡ 6896fef8-f9af-11ea-0065-816a70ba9670
sample_freq_matrix = transition_frequencies(first_sample);

# ╔═╡ e91c6fd8-f930-11ea-01ac-476bbde79079
md"""👉 What is the frequency of the combination `"th"`?"""

# ╔═╡ 1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
th_frequency = missing

# ╔═╡ 1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
md"""👉 What about `"ht"`?"""

# ╔═╡ 41b2df7c-f931-11ea-112e-ede3b16f357a
ht_frequency = missing

# ╔═╡ 489fe282-f931-11ea-3dcb-35d4f2ac8b40
if !@isdefined(th_frequency)
	not_defined(:th_frequency)
elseif !@isdefined(ht_frequency)
	not_defined(:ht_frequency)
else
	if th_frequency isa Missing  || ht_frequency isa Missing
		still_missing()
	elseif th_frequency < ht_frequency
		keep_working(md"Looks like your answers should be flipped. Which combination is more frequent in English?")
	elseif th_frequency == sample_freq_matrix[index_of_letter('t'), index_of_letter('h')] && ht_frequency == sample_freq_matrix[index_of_letter('h'), index_of_letter('t')] 
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
md"""
👉 Write code to find which le**tt**ers appeared doubled in our sample.
"""

# ╔═╡ 65c92cac-f930-11ea-20b1-6b8f45b3f262
double_letters = ['a', 'b', 'c'] # replace with your answer

# ╔═╡ 671525cc-f930-11ea-0e71-df9d4aae1c05
if !@isdefined(double_letters)
	not_defined(:double_letters)
else
	let
		result = double_letters
		if sample_freq_matrix isa Missing
			still_missing(md"Make sure you complete the earlier exercises first! `sample_freq_matrix` is still missing.")
		elseif result isa Missing
			still_missing()
		elseif result isa String
			keep_working(md"Use `collect` to turn a string into an array of characters.")
		elseif !(result isa AbstractVector{Char} || result isa AbstractSet{Char})
			keep_working(md"Make sure that `double_letters` is a `Vector`.")
		elseif Set(result) == Set(alphabet[diag(sample_freq_matrix) .!= 0])
			correct()
		elseif push!(Set(result), ' ') == Set(alphabet[diag(sample_freq_matrix) .!= 0])
			almost(md"We also consider the space (`' '`) as one of the letters in our `alphabet`.")
		else
			keep_working()
		end
	end
end

# ╔═╡ 7711ecc5-9132-4223-8ed4-4d0417b5d5c1
hint(md"First answer this question by looking at the pair frequency image.")

# ╔═╡ 4582ebf4-f930-11ea-03b2-bf4da1a8f8df
md"""
👉 Which letter is most likely to follow a **W**?

_You are free to do this partially by hand, partially using code, whatever is easiest!_
"""

# ╔═╡ 7898b76a-f930-11ea-2b7e-8126ec2b8ffd
most_likely_to_follow_w = 'x' # replace with your answer

# ╔═╡ a5fbba46-f931-11ea-33e1-054be53d986c
if !@isdefined(most_likely_to_follow_w)
	not_defined(:most_likely_to_follow_w)
else
	let
		result = most_likely_to_follow_w
		if sample_freq_matrix isa Missing
			still_missing(md"Make sure you complete the earlier exercises first! `sample_freq_matrix` is still missing.")
		elseif result isa Missing
			still_missing()
		elseif !(result isa Char)
			keep_working(md"Make sure that you return a `Char`. You might want to use the `alphabet` to index a character.")
		elseif let 
			transition_frequency(c) = sample_freq_matrix[
				index_of_letter('w'), index_of_letter(c)
			]
			most_frequent_index = argmax(transition_frequency, alphabet)
			result == alphabet[most_frequent_index]
		end
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 458cd100-f930-11ea-24b8-41a49f6596a0
md"""
👉 Which letter is most likely to precede a **W**?

_You are free to do this partially by hand, partially using code, whatever is easiest!_
"""

# ╔═╡ bc401bee-f931-11ea-09cc-c5efe2f11194
most_likely_to_precede_w = 'x' # replace with your answer

# ╔═╡ ba695f6a-f931-11ea-0fbb-c3ef1374270e
if !@isdefined(most_likely_to_precede_w)
	not_defined(:most_likely_to_precede_w)
else
	let
		result = most_likely_to_precede_w
		if sample_freq_matrix isa Missing
			still_missing(md"Make sure you complete the earlier exercises first! `sample_freq_matrix` is still missing.")
		elseif result isa Missing
			still_missing()
		elseif !(result isa Char)
			keep_working(md"Make sure that you return a `Char`. You might want to use the `alphabet` to index a character.")
		elseif let 
			transition_frequency(c) = sample_freq_matrix[
				index_of_letter(c), index_of_letter('w')
			]
			most_frequent_index = argmax(transition_frequency, alphabet)
			result == alphabet[most_frequent_index]
		end
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ 45c20988-f930-11ea-1d12-b782d2c01c11
md"""
👉 What is the sum of each row? What is the sum of each column? What is the sum of the matrix? How can we interpret these values?"
"""

# ╔═╡ 58428158-84ac-44e4-9b38-b991728cd98a
row_sums = missing

# ╔═╡ 4a0314a6-7dc0-4ee9-842b-3f9bd4d61fb1
col_sums = missing

# ╔═╡ d3d7bd9c-f9af-11ea-1570-75856615eb5d
bigbreak

# ╔═╡ 2f8dedfc-fb98-11ea-23d7-2159bdb6a299
md"""
We can use the measured transition frequencies to generate text in a way that it has **the same transition frequencies** as our original sample. Our generated text is starting to look like real language!
"""

# ╔═╡ b7446f34-f9b1-11ea-0f39-a3c17ba740e5
@bind ex23_sample Select([v => String(k) for (k, v) in zip(fieldnames(typeof(samples)), samples)])

# ╔═╡ 4f97b572-f9b0-11ea-0a99-87af0797bf28
md"""
**Random letters from the alphabet:**
"""

# ╔═╡ 46c905d8-f9b0-11ea-36ed-0515e8ed2621
String(rand(alphabet, 400)) |> Quote

# ╔═╡ 4e8d327e-f9b0-11ea-3f16-c178d96d07d9
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ 489b03d4-f9b0-11ea-1de0-11d4fe4e7c69
String([rand_sample_letter(letter_frequencies(ex23_sample)) for _ in 1:400]) |> Quote

# ╔═╡ d83f8bbc-f9af-11ea-2392-c90e28e96c65
md"""
**Random letters at the correct transition frequencies:**
"""

# ╔═╡ fd202410-f936-11ea-1ad6-b3629556b3e0
if ismissing(transition_frequencies(clean(ex23_sample)))
	still_missing(md"Complete the previous exercises to see the result!")
else
	sample_text(transition_frequencies(clean(ex23_sample)), 400) |> Quote
end

# ╔═╡ 0e465160-f937-11ea-0ebb-b7e02d71e8a8
function sample_text(A, n)
	
	first_index = rand_sample(vec(sum(A, dims=1)))
	
	indices = reduce(1:n; init=[first_index]) do word, _
		prev = last(word)
		freq = normalize_array(A[prev, :])
		next = rand_sample(freq)
		[word..., next]
	end
	
	String(alphabet[indices])
end

# ╔═╡ 6718d26c-f9b0-11ea-1f5a-0f22f7ddffe9
md"""
$(bigbreak)

#### Exercise 1.4 - _Language detection_
"""

# ╔═╡ 141af892-f933-11ea-1e5f-154167642809
md"""
It looks like we have a decent language model, in the sense that it understands _transition frequencies_ in the language. In the demo above, try switching the language between $(join(string.(fieldnames(typeof(samples))), " and ")) -- the generated text clearly looks more like one or the other, demonstrating that the model can capture differences between the two languages. What's remarkable is that our "training data" was just a single paragraph per language.

In this exercise, we will use our model to write a **classifier**: a program that automatically classifies a text as either $(join(string.(fieldnames(typeof(samples))), " or ")). 

This is not a difficult task -- you can download dictionaries for both languages, and count matches -- but we are doing something much more exciting: we only use a single paragraph of each language, and we use a _language model_ as classifier.
"""

# ╔═╡ 7eed9dde-f931-11ea-38b0-db6bfcc1b558
html"<h4 id='mystery-detect'>Mystery sample</h4>
<p>Enter some text here -- we will detect in which language it is written!</p>" # dont delete me

# ╔═╡ 7e3282e2-f931-11ea-272f-d90779264456
@bind mystery_sample TextField((70, 8), default="""
Small boats are typically found on inland waterways such as rivers and lakes, or in protected coastal areas. However, some boats, such as the whaleboat, were intended for use in an offshore environment. In modern naval terms, a boat is a vessel small enough to be carried aboard a ship. Anomalous definitions exist, as lake freighters 1,000 feet (300 m) long on the Great Lakes are called "boats". 
""")

# ╔═╡ 7d1439e6-f931-11ea-2dab-41c66a779262
try
	@assert !ismissing(distances.English)
	"""<h2>It looks like this text is *$(argmin(distances))*!</h2>""" |> HTML
catch
end

# ╔═╡ 7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
mystery_sample

# ╔═╡ 292e0384-fb57-11ea-0238-0fbe416fc976
md"""
Let's compute the transition frequencies of our mystery sample! Type some text in the box above, and check whether the frequency matrix updates.
"""

# ╔═╡ 7dabee08-f931-11ea-0cb2-c7d5afd21551
transition_frequencies(mystery_sample)

# ╔═╡ 3736a094-fb57-11ea-1d39-e551aae62b1d
md"""
Our model will **compare the transition frequencies of our mystery sample** to those of our two language samples. The closest match will be our detected language.

The only question left is: How do we compare two matrices? When two matrices are almost equal, but not exactly, we want to quantify the _distance_ between them.

👉 Write a function called `matrix_distance` which takes 2 matrices of the same size and finds the distance between them by:

1. Subtracting corresponding elements
2. Finding the absolute value of the difference
3. Summing the differences
"""

# ╔═╡ 13c89272-f934-11ea-07fe-91b5d56dedf8
function matrix_distance(A, B)

	return missing # do something with A .- B
end

# ╔═╡ 7d60f056-f931-11ea-39ae-5fa18a955a77
distances = map(samples) do sample
	matrix_distance(transition_frequencies(mystery_sample), transition_frequencies(sample))
end

# ╔═╡ b09f5512-fb58-11ea-2527-31bea4cee823
if !@isdefined(matrix_distance)
	not_defined(:matrix_distance)
else
	try
	let
		A = rand(Float64, (5, 4))
		B = rand(Float64, (5, 4))
		
		output = matrix_distance(A,B)
		
		if output isa Missing
			still_missing()
		elseif !(output isa Number)
			keep_working(md"Make sure that `matrix_distance` returns a number.")
		elseif output == 0.0
			keep_working(md"Two different matrices should have non-zero distance.")
		else
			if matrix_distance(A,B) < 0 || matrix_distance(B,A) < 0
				keep_working(md"The distance between two matrices should always be positive.")
			elseif matrix_distance(A,A) != 0
				almost(md"The distance between two identical matrices should be zero.")
			elseif matrix_distance([1 -1], [0 0]) == 0.0
				almost(md"`matrix_distance([1 -1], [0 0])` should not be zero.")
			else
				correct()
			end
		end
	end
	catch
		keep_working(md"The function errored.")
	end
end

# ╔═╡ 8c7606f0-fb93-11ea-0c9c-45364892cbb8
md"""
We have written a cell that selects the language with the _smallest distance_ to the mystery language. Make sure sure that `matrix_distance` is working correctly, and [scroll up](#mystery-detect) to the mystery text to see it in action!

$(bigbreak)
"""

# ╔═╡ 82e0df62-fb54-11ea-3fff-b16c87a7d45b
md"""
## **Exercise 2** - _Language generation_

Our model from Exercise 1 has the property that it can easily be 'reversed' to _generate_ text. While this is useful to demonstrate its structure, the produced text is mostly meaningless: it fails to generate real words, let alone sentences.

To take our model one step further, we are going to _generalize_ what we have done so far. Instead of looking at _letter combinations_, we will model _word combinations_.  And instead of analyzing the frequencies of bigrams (combinations of two letters), we are going to analyze _$n$-grams_.

#### Dataset
This also means that we are going to need a larger dataset to train our model on: the number of English words (and their combinations) is much higher than the number of letters.

We will train our model on the novel [_Emma_ (1815), by Jane Austen](https://en.wikipedia.org/wiki/Emma_(novel)). This work is in the public domain, which means that we can download the whole book as a text file from `archive.org`. We've done the process of downloading and cleaning already, and we have split the text into word and punctuation tokens.
"""

# ╔═╡ b7601048-fb57-11ea-0754-97dc4e0623a1
emma = let
	raw_text = read(download("https://ia800303.us.archive.org/24/items/EmmaJaneAusten_753/emma_pdf_djvu.txt"), String)

	# remove preamble / postamble
	first_words = "Emma Woodhouse"
	last_words = "THE END"
	start_index = findfirst(first_words, raw_text)[1]
	stop_index = findlast(last_words, raw_text)[end]
	
	raw_text[start_index:stop_index]
end;

# ╔═╡ cc42de82-fb5a-11ea-3614-25ef961729ab
"""
Split a text into a list of words.

Returns a vector of the words (strings) in the text, in order. Punctuation marks like `"."` and `","` are listed as separate words.
"""
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
emma_words = splitwords(emma)

# ╔═╡ 4ca8e04a-fb75-11ea-08cc-2fdef5b31944
forest_words = splitwords(samples.English)

# ╔═╡ 6f613cd2-fb5b-11ea-1669-cbd355677649
md"""
#### Exercise 2.1 - _bigrams revisited_

The goal of the upcoming exercises is to **generalize** what we have done in Exercise 1. To keep things simple, we _split up our problem_ into smaller problems. (The solution to any computational problem.)

First, here is a function that takes an array, and returns the array of all **neighbour pairs** from the original. For example,

```julia
bigrams([1, 2, 3, 42])
```
gives

```julia
[[1,2], [2,3], [3,42]]
```

(We used integers as "words" in this example, but our function works with any type of value.)
"""

# ╔═╡ 91e87974-fb78-11ea-3ce4-5f64e506b9d2
function bigrams(words)
	starting_positions = 1:length(words)-1
	
	map(starting_positions) do i
		words[i:i+1]
	end
end

# ╔═╡ 9f98e00e-fb78-11ea-0f6c-01206e7221d6
bigrams([1, 2, 3, 42])

# ╔═╡ d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
md"""
👉 Next, it's your turn to write a more general function `ngrams` that takes an array and a number $n$, and returns all **subsequences of length $n$**. For example:

```julia
ngrams([1, 2, 3, 42], 3)
```
should give

```julia
[[1,2,3], [2,3,42]]
```

and

```julia
ngrams([1, 2, 3, 42], 2) == bigrams([1, 2, 3, 42])
```
"""

# ╔═╡ 7be98e04-fb6b-11ea-111d-51c48f39a4e9
function ngrams(words, n)
	
	return missing
end

# ╔═╡ 052f822c-fb7b-11ea-382f-af4d6c2b4fdb
ngrams([1, 2, 3, 42], 3)

# ╔═╡ 067f33fc-fb7b-11ea-352e-956c8727c79f
ngrams(forest_words, 4)

# ╔═╡ 954fc466-fb7b-11ea-2724-1f938c6b93c6
let
	output = ngrams([1, 2, 3, 42], 2)

	if output isa Missing
		still_missing()
	elseif !(output isa Vector{<:Vector})
		keep_working(md"Make sure that `ngrams` returns an array of arrays.")
	elseif output == [[1,2], [2,3], [3,42]]
		if ngrams([1,2,3], 1) == [[1],[2],[3]]
			if ngrams([1,2,3], 3) == [[1,2,3]]
				if ngrams(["a"],1) == [["a"]]
					correct()
				else
					keep_working(md"`ngrams` should work with any type, not just integers!")
				end
			else
				keep_working(md"`ngrams(x, 3)` did not give a correct result.")
			end
		else
			keep_working(md"`ngrams(x, 1)` did not give a correct result.")			
		end
	else
		keep_working(md"`ngrams(x, 2)` did not give the correct bigrams. Start out with the same code as `bigrams`.")
	end
end

# ╔═╡ e467c1c6-fbf2-11ea-0d20-f5798237c0a6
hint(md"Start out with the same code as `bigrams`, and use the Julia documentation to learn how it works. How can we generalize the `bigram` function into the `ngram` function? It might help to do this on paper first.")

# ╔═╡ 7b10f074-fb7c-11ea-20f0-034ddff41bc3
md"""
If you are stuck, you can write `ngrams(words, n) = bigrams(words)` (ignoring the true value of $n$), and continue with the other exercises.

#### Exercise 2.2 - _frequency matrix revisisted_
In Exercise 1 we use a 2D array to store the bigram frequencies, where each column or row corresponds to a character from the alphabet. To use trigrams we could store the frequencies in a 3D array, and so on. 

However, when counting words instead of letters we run into a problem: A 3D array with one row, column and layer per word has too many elements to store on our computer!
"""

# ╔═╡ 24ae5da0-fb7e-11ea-3480-8bb7b649abd5
md"""
_Emma_ consists of $(
	length(Set(emma_words))
) unique words. This means that there are $(
	Int(floor(length(Set(emma_words))^3 / 10^9))
) billion possible trigrams - that's too many!
"""

# ╔═╡ 47836744-fb7e-11ea-2305-3fa5819dc154
md"""
$(html"<br>")

Although the frequency array would be very large, it is also **sparse**, meaning *most entries are zero*. For example, _"Emma"_ is a common word, but the sequence of words _"Emma Emma Emma"_ never occurs in the novel.

When a matrix is sparse in this way, we can **store the same information in a more efficient structure**. We don't need to store every combination of words that never occurred - just the ones that do!

To do this, we will use a **dictionary**, or `Dict` in Julia.

!!! info "SparseArrays?"

	Julia's [`SparseArrays.jl` package](https://docs.julialang.org/en/v1/stdlib/SparseArrays/index.html) might sound like a logical choice, but the arrays from that package support only 1D and 2D types.

	Dictionaries are also designed to make things easy when you want to look up values by, say, a word or a sequence of words, rather than a numeric index. This will be convenient for us!

Take a close look at the next example. Note that you can click on the output to expand the data viewer.
"""

# ╔═╡ df4fc31c-fb81-11ea-37b3-db282b36f5ef
healthy = Dict("fruits" => ["🍎", "🍊"], "vegetables" => ["🌽", "🎃", "🍕"])

# ╔═╡ c83b1770-fb82-11ea-20a6-3d3a09606c62
healthy["fruits"]

# ╔═╡ 52970ac4-fb82-11ea-3040-8bd0590348d2
md"""
(Did you notice something funny? The dictionary is _unordered_, this is why the entries were printed in reverse from the definition.)

You can dynamically add or change values of a `Dict` by assigning to `my_dict[key]`. You can check whether a key already exists using `haskey(my_dict, key)`.

👉 Use these two techniques to write a function `word_counts` that takes an array of words, and returns a `Dict` with entries `word => number_of_occurences`.

For example:
```julia
word_counts(["to", "be", "or", "not", "to", "be"])
```
should return
```julia
Dict(
	"to" => 2, 
	"be" => 2, 
	"or" => 1, 
	"not" => 1
)
```
"""

# ╔═╡ 8ce3b312-fb82-11ea-200c-8d5b12f03eea
function word_counts(words::Vector)
	counts = Dict()
	
	# your code here
	
	return counts
end

# ╔═╡ a2214e50-fb83-11ea-3580-210f12d44182
word_counts(["to", "be", "or", "not", "to", "be"])

# ╔═╡ a9ffff9a-fb83-11ea-1efd-2fc15538e52f
let
	output = word_counts(["to", "be", "or", "not", "to", "be"])

	if output === nothing
		keep_working(md"Did you forget to write `return`?")
	elseif output == Dict()
		still_missing(md"Write your function `word_counts` above.")
	elseif !(output isa Dict)
		keep_working(md"Make sure that `word_counts` returns a `Dict`.")
	elseif output == Dict("to" => 2, "be" => 2, "or" => 1, "not" => 1)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 808abf6e-fb84-11ea-0785-2fc3f1c4a09f
md"""
👉 Write code to find how many times `"Emma"` occurs in the book.
"""

# ╔═╡ 953363dc-fb84-11ea-1128-ebdfaf5160ee
emma_count = missing

# ╔═╡ b8af4d06-b38a-4675-9399-81fb5977f077
if emma_count isa Missing
	still_missing()
elseif emma_count == 865
	correct()
else
	keep_working()
end

# ╔═╡ 294b6f50-fb84-11ea-1382-03e9ab029a2d
md"""
Great! Let's get back to our n-grams. For the purpose of generating text, we are going to store a _completion cache_. This is a dictionary where each key is an $(n-1)$-gram, and the corresponding value is the vector of all those words which can complete it to an $n$-gram. Let's look at an example:

```julia
let
	words = splitwords("to be or not to be that is the question")
	trigrams = ngrams(words, 3)
	cache = completions_cache(trigrams)
	cache == Dict(
		["to", "be"] => ["or", "that"],
		["be", "or"] => ["not"],
		["or", "not"] => ["to"],
		["be", "that"] => ["is"],
		["that", "is"] => ["the"],
		["is", "the"] => ["question"]
	)
end
```

So for trigrams the keys are the first $2$ words of each trigram, and the values are arrays containing every third word of those trigrams.

If the same n-gram occurs multiple times (e.g. "said Emma laughing"), then the last word ("laughing") should also be stored multiple times. This will allow us to generate trigrams with the same frequencies as the original text.

👉 Write the function `completion_cache`, which takes an array of ngrams (i.e. an array of arrays of words, like the result of your `ngram` function), and returns a dictionary like described above.
"""

# ╔═╡ b726f824-fb5e-11ea-328e-03a30544037f
function completion_cache(grams)
	cache = Dict()
	
	# your code here
	
	cache
end

# ╔═╡ 18355314-fb86-11ea-0738-3544e2e3e816
let
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	completion_cache(trigrams)
end

# ╔═╡ 13be7476-d87c-46c6-ba04-f8da13ccb483
md"""
!!! hint

	Start by making a list of ngrams, and then go over them one by one, updating your completions cache as you go.
	
	What should happen if the first words are already in the cache? What should happen if they aren't?
"""

# ╔═╡ 472687be-995a-4cf9-b9f6-6b56ae159539
md"""
What is this cache telling us? In our sample text, the words "to be" were followed by "or" and by "that". So if we are generating text, and the last two words we wrote are "to be", we can look at the cache, and see that the next word can be either "or" or "that".
"""

# ╔═╡ abe2b862-fb69-11ea-08d9-ebd4ba3437d5
completion_cache(ngrams(forest_words, 3))

# ╔═╡ 3d105742-fb8d-11ea-09b0-cd2e77efd15c
md"""
#### Exercise 2.4 - _write a novel_

We have everything we need to generate our own novel! The final step is to sample random ngrams, in a way that each next ngram overlaps with the previous one. We've done this in the function `generate_from_ngrams` below - feel free to look through the code, or to implement your own version.
"""

# ╔═╡ a72fcf5a-fb62-11ea-1dcc-11451d23c085
"""
	generate_from_ngrams(grams, num_words)

Given an array of ngrams (i.e. an array of arrays of words), generate a sequence of `num_words` words by sampling random ngrams.
"""
function generate_from_ngrams(grams, num_words)
	if ismissing(grams)
		return missing
	end
	
	n = length(first(grams))
	cache = completion_cache(grams)
	
	# we need to start the sequence with at least n-1 words.
	# a simple way to do so is to pick a random ngram!
	sequence = rand(grams)
	
	# we iteratively add one more word at a time
	for i ∈ n+1:num_words
		# the previous n-1 words
		tail = sequence[end-(n-2):end]
		
		# possible next words ; as a fallback, pick a random word
		completions = get(cache, tail, rand(grams))
		
		choice = rand(completions)
		push!(sequence, choice)
	end
	sequence
end

# ╔═╡ 4b27a89a-fb8d-11ea-010b-671eba69364e
"""
	generate(source_text::AbstractString, num_token; n=3, use_words=true)

Given a source text, generate a `String` that "looks like" the original text by satisfying the same ngram frequency distribution as the original.
"""
function generate(source_text::AbstractString, s; n=3, use_words=true)
	preprocess = if use_words
		splitwords
	else
		collect
	end
	
	words = preprocess(source_text)
	if length(words) < n
		""
	else
		grams = ngrams(words, n)
		result = generate_from_ngrams(grams, s)

		if ismissing(result)
			missing
		elseif use_words
			join(result, " ")
		else
			String(result)
		end
	end
end

# ╔═╡ d7b7a14a-fb90-11ea-3e2b-2fd8f379b4d8
md"
#### Interactive demo

Enter your own text in the box below, and use that as training data to generate anything!
"

# ╔═╡ 1939dbea-fb63-11ea-0bc2-2d06b2d4b26c
@bind generate_demo_sample TextField((50, 5), default=samples.English)

# ╔═╡ 70169682-fb8c-11ea-27c0-2dad2ff3080f
md"""Using $(@bind generate_sample_n_letters NumberField(1:5))grams for characters"""

# ╔═╡ b5dff8b8-fb6c-11ea-10fc-37d2a9adae8c
let
	result = generate(
		generate_demo_sample, 400; 
		n=generate_sample_n_letters, 
		use_words=false
	)

	if ismissing(result)
		still_missing(md"Complete the previous exercises to see the result!")
	else
		Quote(result)
	end
end

# ╔═╡ 402562b0-fb63-11ea-0769-375572cc47a8
md"""Using $(@bind generate_sample_n_words NumberField(1:5))grams for words"""

# ╔═╡ ee8c5808-fb5f-11ea-19a1-3d58217f34dc
let
	result = generate(
		generate_demo_sample, 100; 
		n=generate_sample_n_words, 
		use_words=true
	)

	if ismissing(result)
		still_missing(md"Complete the previous exercises to see the result!")
	else
		Quote(result)
	end
end

# ╔═╡ 2521bac8-fb8f-11ea-04a4-0b077d77529e
md"""
### Automatic Jane Austen

Uncomment the cell below to generate some Jane Austen text:
"""

# ╔═╡ 49b69dc2-fb8f-11ea-39af-030b5c5053c3
# generate(emma, 100; n=4) |> Quote

# ╔═╡ 7f341c4e-fb54-11ea-1919-d5421d7a2c75
bigbreak

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 54b1e236-fb53-11ea-3769-b382ef8b25d6
function Quote(text::AbstractString)
	text |> Markdown.Paragraph |> Markdown.BlockQuote |> Markdown.MD
end

# ╔═╡ b7803a28-fb96-11ea-3e30-d98eb322d19a
function show_pair_frequencies(A)
	if ismissing(A)
		return missing
	end
	
	imshow = let
		to_rgb(x) = RGB(0.36x, 0.82x, 0.8x)
		to_rgb.(A ./ maximum(abs.(A)))
	end
	compimg(imshow)
end

# ╔═╡ ddef9c94-fb96-11ea-1f17-f173a4ff4d89
function compimg(img, labels=[c*d for c in replace(alphabet, ' ' => "_"), d in replace(alphabet, ' ' => "_")])
	xmax, ymax = size(img)
	xmin, ymin = 0, 0
	arr = [(j-1, i-1) for i=1:ymax, j=1:xmax]

	compose(context(units=UnitBox(xmin, ymin, xmax, ymax)),
		fill(vec(img)),
		compose(context(),
			fill("white"), font("monospace"), 
			text(first.(arr) .+ .1, last.(arr) .+ 0.6, labels)),
		rectangle(
			first.(arr),
			last.(arr),
			fill(1.0, length(arr)),
			fill(1.0, length(arr))))
end

# ╔═╡ 20c0bfc0-a6ce-4290-95e1-d01264114cb1
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ deba983b-5422-4033-9d61-09138abf59ac
import PlutoTeachingTools: still_missing, almost, hint, keep_working, correct, not_defined

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
Compose = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unicode = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[compat]
Colors = "~0.12.8"
Compose = "~0.9.4"
PlutoTeachingTools = "~0.3.1"
PlutoUI = "~0.7.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "bf6570a34c850f99407b494757f5d7ad233a7257"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.5"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

[[LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "96d2a4a668f5c098fb8a26ce7da53cde3e462a80"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.3"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [Pkg.extensions]
    REPLExt = "REPL"

[[PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoLinks", "PlutoUI"]
git-tree-sha1 = "8252b5de1f81dc103eb0293523ddf917695adea1"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.3.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "2d4e5de3ac1c348fd39ddf8adbef82aa56b65576"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.6.1"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─f0ebf845-3a6b-42f1-963d-7c6c5cf396c8
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─c75856a8-1f36-4659-afb2-7edb14894ea1
# ╟─c9a8b35d-2183-4da1-ae35-d2552020e8a8
# ╟─e8976562-d92b-4a58-adb8-3250486887b7
# ╟─6f9df800-f92d-11ea-2d49-c1aaabd2d012
# ╠═3206c771-495a-43a9-b707-eaeb828a8545
# ╠═b61722cc-f98f-11ea-22ae-d755f61f78c3
# ╟─59f2c600-2b64-4562-9426-2cfed9a864e4
# ╟─f457ad44-f990-11ea-0e2d-2bb7627716a8
# ╠═4efc051e-f92e-11ea-080e-bde6b8f9295a
# ╟─38d1ace8-f991-11ea-0b5f-ed7bd08edde5
# ╠═ddf272c8-f990-11ea-2135-7bf1a6dca0b7
# ╟─3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
# ╟─d67034d0-f92d-11ea-31c2-f7a38ebb412f
# ╟─7e09011c-71b5-4f05-ae4a-025d48daca1d
# ╟─a094e2ac-f92d-11ea-141a-3566552dd839
# ╠═27c9a7f4-f996-11ea-1e46-19e3fc840ad9
# ╟─f2a4edfa-f996-11ea-1a24-1ba78fd92233
# ╟─5c74a052-f92e-11ea-2c5b-0f1a3a14e313
# ╠═dcc4156c-f997-11ea-3e6f-057cd080d9db
# ╟─129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
# ╠═3a5ee698-f998-11ea-0452-19b70ed11a1d
# ╠═75694166-f998-11ea-0428-c96e1113e2a0
# ╟─6fe693c8-f9a1-11ea-1983-f159131880e9
# ╟─05f0182c-f999-11ea-0a52-3d46c65a049e
# ╟─98266882-f998-11ea-3270-4339fb502bc7
# ╠═d3c98450-f998-11ea-3caf-895183af926b
# ╠═d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
# ╟─cee0f984-f9a0-11ea-2c3c-53fe26156ea4
# ╟─aad659b8-f998-11ea-153e-3dae9514bfeb
# ╠═d236b51e-f997-11ea-0c55-abb11eb35f4d
# ╠═a56724b6-f9a0-11ea-18f2-991e0382eccf
# ╟─24860970-fc48-11ea-0009-cddee695772c
# ╟─734851c6-f92d-11ea-130d-bf2a69e89255
# ╟─8d3bc9ea-f9a1-11ea-1508-8da4b7674629
# ╠═4affa858-f92e-11ea-3ece-258897c37e51
# ╠═e00d521a-f992-11ea-11e0-e9da8255b23b
# ╟─ddfb1e1c-f9a1-11ea-3625-f1170272e96a
# ╟─eaa8c79e-f9a2-11ea-323f-8bb2bd36e11c
# ╠═2680b506-f9a3-11ea-0849-3989de27dd9f
# ╟─571d28d6-f960-11ea-1b2e-d5977ecbbb11
# ╠═11e9a0e2-bc3d-4130-9a73-7c2003595caa
# ╠═6a64ab12-f960-11ea-0d92-5b88943cdb1a
# ╟─603741c2-f9a4-11ea-37ce-1b36ecc83f45
# ╟─b3de6260-f9a4-11ea-1bae-9153a92c3fe5
# ╠═a6c36bd6-f9a4-11ea-1aba-f75cecc90320
# ╟─6d3f9dae-f9a5-11ea-3228-d147435e266d
# ╠═92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
# ╟─95b81778-f9a5-11ea-3f51-019430bc8fa8
# ╟─7df7ab82-f9ad-11ea-2243-21685d660d71
# ╟─dcffd7d2-f9a6-11ea-2230-b1afaecfdd54
# ╟─b3dad856-f9a7-11ea-1552-f7435f1cb605
# ╟─01215e9a-f9a9-11ea-363b-67392741c8d4
# ╟─be55507c-f9a7-11ea-189c-4ffe8377212e
# ╟─8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
# ╟─343d63c2-fb58-11ea-0cce-efe1afe070c2
# ╟─b5b8dd18-f938-11ea-157b-53b145357fd1
# ╟─0e872a6c-f937-11ea-125e-37958713a495
# ╟─77623f3e-f9a9-11ea-2f46-ff07bd27cd5f
# ╠═fbb7c04e-f92d-11ea-0b81-0be20da242c8
# ╠═80118bf8-f931-11ea-34f3-b7828113ffd8
# ╠═7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
# ╠═d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
# ╟─689ed82a-f9ae-11ea-159c-331ff6660a75
# ╠═ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
# ╟─aa2a73f6-0c1d-4be1-a414-05a6f8ce04bd
# ╟─0b67789c-f931-11ea-113c-35e5edafcbbf
# ╠═6896fef8-f9af-11ea-0065-816a70ba9670
# ╟─e91c6fd8-f930-11ea-01ac-476bbde79079
# ╠═1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
# ╟─1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
# ╠═41b2df7c-f931-11ea-112e-ede3b16f357a
# ╟─489fe282-f931-11ea-3dcb-35d4f2ac8b40
# ╟─1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
# ╠═65c92cac-f930-11ea-20b1-6b8f45b3f262
# ╟─671525cc-f930-11ea-0e71-df9d4aae1c05
# ╟─7711ecc5-9132-4223-8ed4-4d0417b5d5c1
# ╟─4582ebf4-f930-11ea-03b2-bf4da1a8f8df
# ╠═7898b76a-f930-11ea-2b7e-8126ec2b8ffd
# ╟─a5fbba46-f931-11ea-33e1-054be53d986c
# ╟─458cd100-f930-11ea-24b8-41a49f6596a0
# ╠═bc401bee-f931-11ea-09cc-c5efe2f11194
# ╟─ba695f6a-f931-11ea-0fbb-c3ef1374270e
# ╟─45c20988-f930-11ea-1d12-b782d2c01c11
# ╠═58428158-84ac-44e4-9b38-b991728cd98a
# ╠═4a0314a6-7dc0-4ee9-842b-3f9bd4d61fb1
# ╟─d3d7bd9c-f9af-11ea-1570-75856615eb5d
# ╟─2f8dedfc-fb98-11ea-23d7-2159bdb6a299
# ╟─b7446f34-f9b1-11ea-0f39-a3c17ba740e5
# ╟─4f97b572-f9b0-11ea-0a99-87af0797bf28
# ╟─46c905d8-f9b0-11ea-36ed-0515e8ed2621
# ╟─4e8d327e-f9b0-11ea-3f16-c178d96d07d9
# ╟─489b03d4-f9b0-11ea-1de0-11d4fe4e7c69
# ╟─d83f8bbc-f9af-11ea-2392-c90e28e96c65
# ╟─fd202410-f936-11ea-1ad6-b3629556b3e0
# ╟─0e465160-f937-11ea-0ebb-b7e02d71e8a8
# ╟─6718d26c-f9b0-11ea-1f5a-0f22f7ddffe9
# ╟─141af892-f933-11ea-1e5f-154167642809
# ╟─7eed9dde-f931-11ea-38b0-db6bfcc1b558
# ╟─7e3282e2-f931-11ea-272f-d90779264456
# ╟─7d1439e6-f931-11ea-2dab-41c66a779262
# ╠═7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
# ╟─292e0384-fb57-11ea-0238-0fbe416fc976
# ╠═7dabee08-f931-11ea-0cb2-c7d5afd21551
# ╟─3736a094-fb57-11ea-1d39-e551aae62b1d
# ╠═13c89272-f934-11ea-07fe-91b5d56dedf8
# ╟─7d60f056-f931-11ea-39ae-5fa18a955a77
# ╟─b09f5512-fb58-11ea-2527-31bea4cee823
# ╟─8c7606f0-fb93-11ea-0c9c-45364892cbb8
# ╟─82e0df62-fb54-11ea-3fff-b16c87a7d45b
# ╠═b7601048-fb57-11ea-0754-97dc4e0623a1
# ╟─cc42de82-fb5a-11ea-3614-25ef961729ab
# ╠═d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
# ╠═4ca8e04a-fb75-11ea-08cc-2fdef5b31944
# ╟─6f613cd2-fb5b-11ea-1669-cbd355677649
# ╠═91e87974-fb78-11ea-3ce4-5f64e506b9d2
# ╠═9f98e00e-fb78-11ea-0f6c-01206e7221d6
# ╟─d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
# ╠═7be98e04-fb6b-11ea-111d-51c48f39a4e9
# ╠═052f822c-fb7b-11ea-382f-af4d6c2b4fdb
# ╠═067f33fc-fb7b-11ea-352e-956c8727c79f
# ╟─954fc466-fb7b-11ea-2724-1f938c6b93c6
# ╟─e467c1c6-fbf2-11ea-0d20-f5798237c0a6
# ╟─7b10f074-fb7c-11ea-20f0-034ddff41bc3
# ╟─24ae5da0-fb7e-11ea-3480-8bb7b649abd5
# ╟─47836744-fb7e-11ea-2305-3fa5819dc154
# ╠═df4fc31c-fb81-11ea-37b3-db282b36f5ef
# ╠═c83b1770-fb82-11ea-20a6-3d3a09606c62
# ╟─52970ac4-fb82-11ea-3040-8bd0590348d2
# ╠═8ce3b312-fb82-11ea-200c-8d5b12f03eea
# ╠═a2214e50-fb83-11ea-3580-210f12d44182
# ╟─a9ffff9a-fb83-11ea-1efd-2fc15538e52f
# ╟─808abf6e-fb84-11ea-0785-2fc3f1c4a09f
# ╠═953363dc-fb84-11ea-1128-ebdfaf5160ee
# ╟─b8af4d06-b38a-4675-9399-81fb5977f077
# ╟─294b6f50-fb84-11ea-1382-03e9ab029a2d
# ╠═b726f824-fb5e-11ea-328e-03a30544037f
# ╠═18355314-fb86-11ea-0738-3544e2e3e816
# ╟─13be7476-d87c-46c6-ba04-f8da13ccb483
# ╟─472687be-995a-4cf9-b9f6-6b56ae159539
# ╠═abe2b862-fb69-11ea-08d9-ebd4ba3437d5
# ╟─3d105742-fb8d-11ea-09b0-cd2e77efd15c
# ╟─a72fcf5a-fb62-11ea-1dcc-11451d23c085
# ╟─4b27a89a-fb8d-11ea-010b-671eba69364e
# ╟─d7b7a14a-fb90-11ea-3e2b-2fd8f379b4d8
# ╟─1939dbea-fb63-11ea-0bc2-2d06b2d4b26c
# ╟─70169682-fb8c-11ea-27c0-2dad2ff3080f
# ╟─b5dff8b8-fb6c-11ea-10fc-37d2a9adae8c
# ╟─402562b0-fb63-11ea-0769-375572cc47a8
# ╟─ee8c5808-fb5f-11ea-19a1-3d58217f34dc
# ╟─2521bac8-fb8f-11ea-04a4-0b077d77529e
# ╠═49b69dc2-fb8f-11ea-39af-030b5c5053c3
# ╟─7f341c4e-fb54-11ea-1919-d5421d7a2c75
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─54b1e236-fb53-11ea-3769-b382ef8b25d6
# ╟─b7803a28-fb96-11ea-3e30-d98eb322d19a
# ╟─ddef9c94-fb96-11ea-1f17-f173a4ff4d89
# ╟─20c0bfc0-a6ce-4290-95e1-d01264114cb1
# ╠═deba983b-5422-4033-9d61-09138abf59ac
# ╠═00115b6e-f381-11ea-0bc6-61ca119cb628
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
