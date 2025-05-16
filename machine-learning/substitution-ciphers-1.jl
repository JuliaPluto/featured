### A Pluto.jl notebook ###
# v0.20.8

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/2a6a9664e5428b37abe4957c1dca0994f4a8b7fd/LICENSES/Unlicense"
#> image = "https://upload.wikimedia.org/wikipedia/commons/7/75/Caesar_substition_cipher.png?20160930042235"
#> order = "2.1"
#> title = "Solving ciphers (part 1)"
#> tags = ["optimization", "machine learning", "encryption", "ceasar cipher", "natural-language-processing"]
#> license = "Unlicense"
#> description = "Learn about optimisation by solving ceasar ciphers!"
#> 
#>     [[frontmatter.author]]
#>     name = "Luka van der Plas"
#>     url = "https://github.com/lukavdplas"

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

# ╔═╡ 1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╠═╡ show_logs = false
using Random, PlutoUI, Plots

# ╔═╡ 19ac84ba-367f-4aca-99bc-83a1f6ff122a
using PlutoTeachingTools: hint, almost, keep_working, correct

# ╔═╡ 0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
md"""
# Solving ciphers (part 1)

This notebook is about _substitution ciphers_. A substitution cipher is a kind of code where we replace each letter in a message with another. For example, replace every _A_ with an _F_, every _B_ with a _Q_, etc.

Here is an example. Try it out!
"""

# ╔═╡ 1bf7875f-9a22-4ddb-8493-e6415d7ff0b0
@bind test_message TextField((40, 4), default="Let's do some encryption! Yayyy")

# ╔═╡ ab028285-df3c-43d8-a4b2-9b063650ba66


# ╔═╡ e54cbe8a-fffd-41e6-9045-d8ecb0994ce6
md"""
Ciphers are used to **communicate in secret**. 

Without knowing the cipher, the encrypted text is impossible to read. But if you know the cipher used to encrypt a message, you can **decrypt** a message from someone else.
"""

# ╔═╡ 7cee42ae-fa54-451f-a254-5871f22e5e11


# ╔═╡ 12f13216-0809-4da6-ad81-36e21e491cd1
md"""
## The challenge

Imagine that you intercepted a message that was encrypted using a cipher. The only thing you see is:


"""

# ╔═╡ 45242ec9-b815-483c-8ef9-6c6cfdd52e7d
md"""
but you don't have the original cipher. Is it possible to **crack the code** and figure out the cipher that was used, and read the secret message?
"""

# ╔═╡ fbbaac1b-53b1-4eb2-82b2-a0ec481f58e7
md"""
> ## Part 1 and 2
> 
> In Part 1, we will define substitution ciphers, and make a start with solving them. Since solving ciphers is pretty hard, we will look at a simpler case: _ceasar ciphers_. We will see what it takes to write a program that solves these simpler ciphers.
> 
> Part 2 of this notebook is about solving substitution ciphers. The two notebooks are intended to provide a gradual introduction into the topic, but you can skip ahead if you're feeling very confident.
> 
> The exercises in this notebook will not require any knowledge about ciphers, but some understanding of handling strings in Julia is recommended.
"""

# ╔═╡ 92ca8a1e-4c20-419e-8d72-b9721f32699b


# ╔═╡ 6917f83f-a6aa-4cbc-89da-ba0f448acaa0
md"""
## Defining ciphers

To solve ciphers, we first need some basic functions to encrypt a piece of text, and to decrypt it once we know the key.

### The alphabet

First, we need to define our alphabet. This is the collection of characters that we we are going to be replacing.

The characters A-Z will be sufficient:
"""

# ╔═╡ ee221dd4-d072-4679-992f-0d3657e90cd4
alphabet = collect('A':'Z')

# ╔═╡ ed619597-5d98-49a0-b015-7d832366ef9c
md"""
Note that we are not including whitespace (space, newlines) or interpunction characters (`.`, `,`, and so on). Our encryption will leave those characters as they are.
"""

# ╔═╡ c427fa89-4e71-4afa-8358-64df1f2c737f
md"""
### Encryption keys

A one-to-one replacement cipher will replace each character in the alphabet with another. We need a _key_ to tell us which character to replace with which.

Here is a function that will make a random key.
"""

# ╔═╡ cb1e5f06-39a5-4b60-9e69-53772de4e8ce
function randomkey()
	# shuffle alphabet to get substitutions for each character
	substitutions = shuffle(alphabet)

	# combine alphabet and substitutions
	(collect ∘ zip)(alphabet, substitutions)
end

# ╔═╡ c16adf04-a392-4f41-851b-3204e96c1c46
md"""
Here is what our key will look like:
"""

# ╔═╡ 7ef58fdd-6853-4486-9d1d-cc8c590c2ed7
example_key = randomkey()

# ╔═╡ 669bb484-a594-4412-a96d-8a3414c0c204
let
	firstpair = first(example_key)
	firstchar = string(firstpair[1])
	secondchar = string(firstpair[2])
	
	md"""
	This gives our a list of replacements. For example, every _$firstchar_ should be replaced with a _$secondchar_.
	
	If you know the key, encrypting and decrypting messages is pretty straightforward. Trying to decrypt a message _without_ the key is a puzzle.
	"""
end

# ╔═╡ 28378ac9-fd4a-4fe4-9a5f-1d9444427a60
md"""
### Encryption

Let's try using that key. But before we can make substitutions, there is one thing we need to do. You may have noticed that our alphabet only uses uppercase characters. If we want to use the key on a message, we need to use _uppercase_ characters only.
"""

# ╔═╡ 806509f4-9bab-4bf0-a8c5-40900f337f11
function prepare(message)
	uppercase(message)
end

# ╔═╡ 5b2fef01-5a47-4f8a-bcd0-6cd75c1d0c82
md"""
For example:
"""

# ╔═╡ ccb8ccbd-37a4-4bde-8d3f-38ef76ea61a3
hamlet = "To be or not to be, that is the question."

# ╔═╡ af8bf867-09c2-4ac5-910f-9de5ae5a616a
prepare(hamlet)

# ╔═╡ 47851e6c-ed25-4ad4-bd5c-c1f622a8ac51
md"""
You could do more in this preparation, such as obscuring the interpunction a bit, or stripping diacritics (`é`, `ö` and so on). But we'll leave it at this for now.

Now, let's encrypt that message. Here is a function that will apply a substitution cipher for a message and a key.
"""

# ╔═╡ a868d8db-fdab-4941-b733-ef5435ba5659
function encrypt(message, key)
	# make a dictionary from the key for easy retrieval
	substitution_dict = Dict(key)

	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)

	# replace each character
	newcharacters = map(characters) do character
		if character in alphabet
			# replace using the key
			substitution_dict[character]
		else
			# for characters not in the alphabet, return them unchanged
			character
		end
	end

	# convert the replaced characters into a string
	String(newcharacters)
end

# ╔═╡ 17c4d571-768e-451c-8596-34d791b83846
example_encrypted = encrypt(test_message, example_key)

# ╔═╡ 8abce95f-7163-4043-8a20-340ead77f462
example_encrypted

# ╔═╡ c2a77d46-2d79-4993-96e4-a7d4a8ee5e6e
md"""
Let's try it out!
"""

# ╔═╡ 64bef739-2aca-4423-92d9-93f0cc6bef59
hamlet_encrypted = encrypt(hamlet, example_key)

# ╔═╡ 12842e4f-420c-4531-8ab5-9353149d1c18
let
	firstpair = first(example_key)
	firstchar = string(firstpair[1])
	secondchar = string(firstpair[2])

	md"""
	### Decryption
	
	Now that we have encrypted our message, we can safely send it to all our friends. If they know the key, they can *decrypt* the message.
	
	For one-to-one substitution ciphers, decryption is just like encryption. We just need to apply our encryption function, but inverse the key. The original key said to replace _$firstchar_ with _$secondchar_, so now we want to replace _$secondchar_ with _$firstchar_.
	"""
end

# ╔═╡ 9f91b4e9-df13-4bbc-b2ee-3faf0a5e012c
function decrypt(message, key)
	inverse_key = map(key) do (character, replacement)
		(replacement, character)
	end

	encrypt(message, inverse_key)
end

# ╔═╡ 81421e82-2679-417c-ba97-15e6ffa8c4d4
decrypt(example_encrypted, example_key)

# ╔═╡ a3a4d43f-3b53-4d85-9721-923f2a62e9a1
md"""
Let's see it:
"""

# ╔═╡ 46dab0d5-f6dc-44b2-b30c-be534e1d04c3
decrypt(hamlet_encrypted, example_key)

# ╔═╡ 0d91bb9a-edbc-4076-960d-3f197d43c485
md"""
And there we have our intended message!
"""

# ╔═╡ b5023561-26bc-486e-99d8-cdce6cb76a2a
md"""
## Ceasar ciphers

It's straightforward enough to decrypt a message when you know the key, but the real fun is in decrypting a message where you _don't_ know the key. And by fun, I mean that it's difficult.

We'll start with a simpler version of the puzzle, using the _ceasar cipher_. Ceasar ciphers (also known as shift ciphers) are a kind of substitution cipher where the replacement for each character always has the same distance in the alphabet. For example, if _A_ is replaced by _D_, then _B_ is replaced by _E_, _C_ by _F_, and so forth.

Ceasar ciphers are easier to crack because they only have 26 possible keys (in a 26-character alphabet). 
"""

# ╔═╡ 7bbc4b4d-fbff-4897-b657-befe2268adbd
md""" 
### Defining the ceasar cipher

We are going to write some functions to apply ceasar ciphers. These are essentially more specialised versions of our replacement cipers functions.

For a ceasar cipher, the _key_ is just the shift number: that is all we need to know to encrypt or decrypt a message.

To use our replacement cipher functions, we need to convert the shift key to a list of replacements:
"""

# ╔═╡ e7c4ffc0-e494-4cf0-895d-110cb7b50357
function shift_cipher(shift)
	replacements = map(eachindex(alphabet)) do index
		# shift the position
		shifted_index = index + shift

		# the new value may not be in [1:26], use `mod` to get the equivalent
		# index, e.g. mod(27, 1:26) = 1
		newindex = mod(shifted_index, eachindex(alphabet))
		alphabet[newindex]
	end
	
	(collect ∘ zip)(alphabet, replacements)
end

# ╔═╡ 767996b1-40bf-49ba-9523-3d3111c33566
shift_cipher(3)

# ╔═╡ 892f4ce7-ac98-4e66-a6c6-aef74ba275ff
md"""
**👉 your turn!** Fill in the function `ceasar_encrypt` below. It takes a message and a shift number, and applies ceasar encryption.
"""

# ╔═╡ 4e44f92f-0de9-495d-9165-376717a1df2a
function ceasar_encrypt(message, shift)
	# your code here...
end

# ╔═╡ f7ab9713-f36f-4c9c-9165-1bdd785c0926
let
	encrypted = ceasar_encrypt(hamlet, 3)

	if encrypted == "WR EH RU QRW WR EH, WKDW LV WKH TXHVWLRQ."
		correct()
	else
		hint(md"The function `shift_cipher` converts a shift number to a list of replacements. We have another function that applies a list of replacements.")
	end
end

# ╔═╡ 4814d886-b988-4423-ad03-378f0d4768fb
md"Let's see it in action:"

# ╔═╡ 108ad7d2-8a5b-462f-9a0d-6f3302c73a9a
ceasar_encrypt(hamlet, 3)

# ╔═╡ c27d16d1-70b2-481b-8374-4b4c7841807c
md"""
Now that we can encrypt message, we still need code to decrypt them:

**👉 your turn!** Fill in the function `ceasar_decrypt` below, which should reverse the ceasar encryption. The `shift` argument gives the shift number of the original encryption.
"""

# ╔═╡ a2c829c8-17a9-4489-96da-14975f3560b2
function ceasar_decrypt(message, shift)
	# your code here...
end

# ╔═╡ 125b86e9-6e9d-4770-a246-5a235b346609
let
	encrypted = "WR EH RU QRW WR EH, WKDW LV WKH TXHVWLRQ."
	decrypted =  ceasar_decrypt(encrypted, 3)

	if decrypted == "TO BE OR NOT TO BE, THAT IS THE QUESTION."
		correct()
	else
		hint(md"Let's say we shifted the alphabet by 1 to encrypt the message. By what should we shift the encrypted message to get back the original?")
	end
end

# ╔═╡ 51c7849b-05f1-4169-bb1d-45dba94ccf5e
md"Let's do a sanity check: if we encrypt and then decrypt a message using the same key, we should get the same message back."

# ╔═╡ c746e0c8-7246-4d48-bcc0-53d75f4fcaaa
let
	shift = 3
	encrypted = ceasar_encrypt(hamlet, shift)
	decrypted = ceasar_decrypt(encrypted, shift)
end

# ╔═╡ cccb5e00-7293-4be6-9d70-13449bdb08fe
let
	shift = 3
	encrypted = ceasar_encrypt(hamlet, shift)
	decrypted = ceasar_decrypt(encrypted, shift)

	if decrypted != prepare(hamlet)
		keep_working(md"""That's not quite right! We expected to see our Hamlet quote back.
		
		For the following sections, it is **essential** that we have working encryption/decryption functions, so make sure to get these right before you continue.""")
	else
		correct()
	end
end

# ╔═╡ e75bed2d-6b28-4f07-955c-e9d52d2d0884
md"""
## A first attempt at cracking the cipher

Now that we can apply a ceasar cipher, how can we crack it? Well, since there are only 26 possibilities, you could just check every single one. Let's try that. Here is a secret message:
"""

# ╔═╡ 15960689-5dd0-44e6-98ea-82612866d1e7
secret = "U LIMY VS UHS INBYL HUGY QIOFX MGYFF UM MQYYN"

# ╔═╡ 361d9b88-e693-4654-9582-ab227dd21025
md"""
This was encrypted using a ceasar cipher, but we don't know the key! We can try all possible keys, and see if one of them makes sense.

**👉 your turn!** Write some code that will generate all possible solutions for the `secret` message and display them in your notebook.
"""

# ╔═╡ 25372462-b52a-4ba5-b59d-df591ea35f98
# your code here...

# ╔═╡ bef18c5f-7a9c-475e-bd2c-9d3338257ac1
hint(md"Each way to shift the alphabet is characterised by a shift key. For each of those keys, you need to show what the decrypted message would look like.")

# ╔═╡ 81aba30e-4c6e-4d6a-a165-3d9313f108df
md"""
What is the shift key that was used to encrypt the message?
"""

# ╔═╡ c428660d-3ab9-4624-8a14-7044581e6b98
secret_key = missing # fill in your solution here

# ╔═╡ b1557342-b352-4ed0-8b3b-15d466cbef24
if ismissing(secret_key)
	keep_working()
elseif secret_key == 20
	correct()
elseif secret_key == 6
	almost(md"You may have confused _encrypt_ and _decrypt_ in your solution. Remember, the key used to _encrypt_ a message can be given to the _decrypt_ function to get the original message back.")
elseif !( secret_key isa Number )
	keep_working(md"Your answer should give the shift value, which is a number.")
else
	keep_working()
end

# ╔═╡ a8871358-7e16-41e1-a8a9-99bf46a3aab7
md"""
This list of solutions only had 26 options But with a "normal" replacement cipher, there are way too many options to go over them by hand like this.

Instead of letting the computer generate solutions and picking the right one by hand, we should let the computer pick out the best solution as well.
"""

# ╔═╡ 7cc9612a-bbac-4cad-bc5f-3c2bdc71ee90
md"""
## Finding the best solution

To select the best solution from a range of options, our program will need some way of knowing what English text looks like. That is how you were able to pick out the right message in the excercise above: you didn't know what it was going to say, but you can recognise English text when you see it.

### What does English text look like?

There are lots of properties that distinguish real English text from random gibberish. Some of them are more useful than others.

Let's start by thinking about how you are able to recognise a solution as real text. A big part of that is that you will recognise the words.

Sadly, recognising words is a good strategy for _verifying_ a solution, but not for _finding_ one. If we are even a little bit off from the real solution, we won't end up with real English words. With this method, it is very difficult to tell if we are getting close at all. Often, the only way to tell which solution is the right one is to consider every single one.

Instead, we will start by using a very different kind of knowledge: the frequency of different characters. Some characters, like 'E', are very frequent in English text, while others, like 'X', are not frequent at all. So the most frequent character in your encrypted message is more likely to have been an 'E' than 'X'.

Let's start by counting the characters in a message.
"""

# ╔═╡ b1575bb2-95ee-442b-b594-a7d21827b64d
function countcharacters(message)
	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)
	
	# for each character in the alphabet, see how often it occurred
	counts = map(alphabet) do character
		occurrences = count(characters) do character_in_message
			character_in_message == character
		end
		character, occurrences
	end

	# return the character/counts list as dictionary
	Dict(counts)
end

# ╔═╡ c6c848cb-af80-40ab-a8b6-9b52b4141a23
md"""
Here are the counts for our example message:
"""

# ╔═╡ 47a88fe3-4d80-4e26-9cfb-70b4b45f2cee
hamlet_counts = countcharacters(hamlet)

# ╔═╡ b9a0b03a-7564-44ad-a65a-64c1355d614f
md"""
If you are not familiar with dictionaries, we can get frequencies of a specific character like so:
"""

# ╔═╡ 3f103c93-5435-42b3-8101-aec32a18654f
hamlet_counts['A']

# ╔═╡ 75a7e5a3-d966-4057-ba18-5ef3820afe44
md"""
**👉 your turn!** What is the most frequent character in the `hamlet` quote?
"""

# ╔═╡ 457404ba-d87a-472e-87ef-b107bef05787
hamlet_most_frequent = let
	# your code here...
end

# ╔═╡ f0fc8d5c-eb29-4263-afad-9678b76ff5d6
if hamlet_most_frequent == 'T'
	correct()
elseif hamlet_most_frequent == 'Z'
	keep_working(md"""
	Oh no, `Z` is not really the most frequent character! Your code may have selected this one because it comes last in alphabetic order, which is not what we're after.

	If you were using `maximum` to find the most frequent character, you could try `findmax` or `argmax`.
	""")
elseif isnothing(hamlet_most_frequent)
	hint(md"""
	Julia has a few functions that are related to the maximum. Try the functions `maximum`, `findmax` and `argmax` on the counts dictionary. Can you see what they do?
	""")
else
	keep_working()
end

# ╔═╡ aa7017b6-acfa-4323-9fbc-fa39ec3c48bf
md"""
**👉 your turn!** What is the most frequent character if we encrypt the quote with shift key `3`?
"""

# ╔═╡ 99b4a36a-d537-4cb7-b5e0-7ceb0d2fd58c
hamlet_ceasar_encrypted = ceasar_encrypt(hamlet, 3)

# ╔═╡ c2bac47d-a7eb-4447-802f-58354bb2625c
hamlet_ceasar_encrypted_most_frequent = let
	# your code here...
end

# ╔═╡ 71311a17-112d-40b2-b291-61e990c2b4a3
if hamlet_ceasar_encrypted_most_frequent == 'W'
	correct()
else
	hint(md"""You can calculate the most frequent letter in the encrypted quote by counting the characters again, but if you solved the last question, maybe you don't need to. What happens to every $(hamlet_most_frequent == 'T' ? "_T_" : "character") in the encrypted quote? And how does that affect their frequency?""")
end

# ╔═╡ 68fe1c65-1a59-40ef-8ef5-b7c40ba7511e
md"""
### Comparing character frequencies

Okay, so now we know how to count characters in a text. Those character counts give us a kind of 'profile' of a text. But in order to see if those frequencies look like normal English, we need some kind of reference of what normal English looks like.

We need some larger text to work from. Let's get the full soliloquy for that Hamlet quote we've been using.
"""

# ╔═╡ e8c0fdb4-79d0-4818-b4c0-a55b36b1de5c
hamlet_full = """
To be, or not to be, that is the question: Whether ’tis nobler
in the mind to suffer The slings and arrows of outrageous fortune, Or
to take arms against a sea of troubles, And by opposing end them? To
die—to sleep, No more; and by a sleep to say we end The heart-ache, and
the thousand natural shocks That flesh is heir to: ’tis a consummation
Devoutly to be wish’d. To die, to sleep. To sleep, perchance to
dream—ay, there’s the rub, For in that sleep of death what dreams may
come, When we have shuffled off this mortal coil, Must give us pause.
There’s the respect That makes calamity of so long life. For who would
bear the whips and scorns of time, The oppressor’s wrong, the proud
man’s contumely, The pangs of dispriz’d love, the law’s delay, The
insolence of office, and the spurns That patient merit of the unworthy
takes, When he himself might his quietus make With a bare bodkin? Who
would these fardels bear, To grunt and sweat under a weary life, But
that the dread of something after death, The undiscover’d country, from
whose bourn No traveller returns, puzzles the will, And makes us rather
bear those ills we have Than fly to others that we know not of? Thus
conscience does make cowards of us all, And thus the native hue of
resolution Is sicklied o’er with the pale cast of thought, And
enterprises of great pith and moment, With this regard their currents
turn awry And lose the name of action. Soft you now, The fair Ophelia!
Nymph, in thy orisons Be all my sins remember’d.
"""

# ╔═╡ 30e55ee5-4a25-4347-8693-9380e2d3de5f
md"""
This text is not very long so it won't be a perfect representation of English, but it's good enough for our purposes here.

Let's visualise what the character frequencies in this text are. To get a result that we can easily compare between texts, we will count the characters and turn them into a list of percentages.
"""

# ╔═╡ 075365b0-e2d0-433d-a370-7cfe7863206a
function character_percentages(message)
	counts = countcharacters(message)
	total_count = (sum ∘ values)(counts)

	map(alphabet) do character
		100 * counts[character] / total_count
	end
end

# ╔═╡ 7cd72e08-350f-47f6-a232-5462faad778a
md"Now we define a function that takes a message, calculates the percentages and turns them into a barchart:"

# ╔═╡ f0dbf680-f59e-46f8-a238-16eb30617957
function plotcharacters(message)
	percentages = character_percentages(message)

	# locations of the ticks on the x-axis - should be in the middle of each bar
	xticklocations = (1:length(alphabet)) .- 0.5

	p = bar(
		alphabet, percentages,
		legend = nothing,
		xticks = (xticklocations, alphabet),
		xlabel = "character",
		ylabel = "frequency",
		yformatter = value -> "$value%"
	)
end

# ╔═╡ 32877712-1ab7-4807-a2f7-48b0f0182461
md"Let's see it!"

# ╔═╡ 7efff273-2e95-4242-ac01-8b6e148d8d8e
plotcharacters(hamlet_full)

# ╔═╡ e44d3c04-86ad-4e7f-a89d-221cf624fc30
md"Okay, now we want to compare these frequencies to another piece of text. Here is an adapted version of the function that will show the frequencies of _two_ messages:"

# ╔═╡ 0663fecc-f446-4cdb-907b-ce98e36a0713
function plot_character_comparison(message_1, message_2,
	label_1 = "message 1", label_2 = "message 2")
	percentages_1 = character_percentages(message_1)
	percentages_2 = character_percentages(message_2)

	xticklocations = (1:length(alphabet)) .- 0.5

	p = plot(
		legendposition = :outertop,
		xticks = (xticklocations, alphabet),
		ylabel = "frequency",
		xlabel = "character",
		yformatter = value -> "$value%"
	)

	bar!(p,
		alphabet, percentages_1,
		label = label_1,
		line = nothing,
		fillopacity = 0.5
	)

	bar!(p,
		alphabet, percentages_2,
		label = label_2,
		line = nothing,
		fillopacity = 0.5
	)
end

# ╔═╡ eb30efa9-6c35-4d93-88f4-88ffc046086c
md"""
For instance, we can compare the full soliloquy to the short quote:
"""

# ╔═╡ be7ddd86-27ee-40be-bb8d-fd7be6e2ae52
plot_character_comparison(hamlet_full, hamlet, "full soliloquy", "short quote")

# ╔═╡ bbc6d33b-1989-4124-8b8d-7e67495be1d6
md"""
You can see that they don't line up super well. For example, the short quote has a lot more `B`'s and `T`'s, relatively speaking.

For very short pieces of text, character frequencies are not very predictable. But you don't need a lot of texts for the frequencies to stabilise somewhat.

Let's see how we can use this graph to crack a ceasar cipher. Here is another encrypted message. To make the character frequencies more useful, it is a bit longer than some of our earlier examples:
"""

# ╔═╡ 9b43d8b1-96da-456f-a4d2-807551eb59a4
secret2 = """
TML KGXL! OZSL DAYZL LZJGMYZ QGFVWJ OAFVGO TJWSCK?
AL AK LZW WSKL, SFV BMDAWL AK LZW KMF!
SJAKW, XSAJ KMF, SFV CADD LZW WFNAGMK EGGF,
OZG AK SDJWSVQ KAUC SFV HSDW OALZ YJAWX
LZSL LZGM ZWJ ESAV SJL XSJ EGJW XSAJ LZSF KZW.
"""

# ╔═╡ 7acac33f-0fc4-4ade-8a1b-03c6f133e15b
md"""
Now, we use a slider to set our guess for the _shift key_, and then plot how the frequency of the _decrypted_ message compares to our reference text (the hamlet soliloquy).
"""

# ╔═╡ 1ccbc14e-74a7-4875-8a5d-8eeaa5fd2d68
@bind secret2_key_guess html"""
<input type="range" min="0" max="26" value="0" style="width: 100%;">
"""

# ╔═╡ 7031b1ba-1da8-478c-9aba-53ec5c89e305
md"Key: $secret2_key_guess"

# ╔═╡ 9e1ffcf6-de14-463b-b6a9-fc9a393a3d8c
let
	decrypted = ceasar_decrypt(secret2, secret2_key_guess)
	if isa(decrypted, String)
		plot_character_comparison(hamlet_full, decrypted, "reference text", "decrypted message")
	else
		keep_working(md"""
		It looks like your `ceasar_decrypt` function is not working yet! It should
		be returning a string.

		Try to complete the encryption and decryption functions above before doing this exercise.
		""")
	end
end

# ╔═╡ c2977b4c-3750-4390-889b-3928770f6494
md"""
**👉 your turn!** Try to align the bars by moving the slider value. Move the slider slowly, until you find a value that looks alright, and fill in your best fit for the shift key below:
"""

# ╔═╡ 95c0b0d9-5d45-4254-88f5-2765b6c99810
secret2_key = missing # fill in your answer here

# ╔═╡ 82077381-611b-4084-ac9b-b51b684681dd
md"Let's try using that key! Did you get the right answer?"

# ╔═╡ 0643922e-6fd7-40b3-8469-3076e1b7b9aa
if !ismissing(secret2_key)
	Text(ceasar_decrypt(secret2, secret2_key))
else
	Text("Fill in the key to see the result..")
end

# ╔═╡ ce51b0bd-f3f4-4aba-b750-32277ad85cb3
if !ismissing(secret2_key)
	decrypted = ceasar_decrypt(secret2, secret2_key)

	if startswith(decrypted, "BUT SOFT")
		correct()
	else
		almost(md"That doesn't look right! No worries, just go back and play with a the slider a bit more. You should be able to find a value that fits even better.")
	end
else
	keep_working(md"Fill in your best guess for the key in `secret2_key` to see if it works!")
end

# ╔═╡ d7c37c08-0aae-4a59-9a42-541fe459325e
md"""
If all went well, you were able to find the right key _just_ by looking at the frequencies.

(Even if you filled in the wrong key at first, that's still very good! If the number of manual inspections was not 26, the frequencies are helping us to narrow down results!)

This solution may have felt a bit awkward: perhaps you found it easier to just look at the text. But while comparing numbers is relatively difficult for humans, it is easy for computers. This is how we can let our program find the encryption key for us.
"""

# ╔═╡ 40e44098-2ffa-4cf2-bb38-cf61285b06f7
md"""
## Cracking a ceasar cipher automatically

We are almost ready to crack ceasar ciphers automatically. We have the code to count the frequencies of characters, which we can compare to see how much a possible solution looks like English text. In the last section, we did that comparison by hand using a visualisation, but now we want to let the computer do that for us.

We will use a simple calculation to compare two frequency profiles: we use the percentage vectors we calculated before, and sum the absolute difference for each character:
"""

# ╔═╡ 3874cac0-2eaf-41c5-9ed9-d11e219ede1e
function compare_frequencies(message_1, message_2)
	# calculate relative frequencies
	percentages_1 = character_percentages(message_1)
	percentages_2 = character_percentages(message_2)

	# calculate the difference for each character
	differences = abs.(percentages_1 .- percentages_2)

	# take the sum
	sum(differences)
end

# ╔═╡ 97dfce7d-175d-4d77-bbac-6a832c6dd221
md"Here is how we use the function:"

# ╔═╡ e750ecd9-21ec-46dc-ae49-1ce01487c83f
compare_frequencies(hamlet_full, hamlet)

# ╔═╡ 98bb511c-4957-428e-98b1-0c7b5a9254ea
md"""
As a sanity check, the difference between a message and itself should be 0:
"""

# ╔═╡ 6a997f41-b89e-439f-a1f1-b2e7cab67a45
compare_frequencies(hamlet, hamlet)

# ╔═╡ 7fec90d5-4d0f-46ee-ba34-2fa37d62558d
md"""
**👉 your turn!** Fill in the function `evaluate_key` below. For a message and a key, it should try to decrypt the message using the key, and compare the result to `hamlet_full`.
"""

# ╔═╡ ffa9fc10-0d4e-4e29-9015-2b0ea9370d51
function evaluate_key(message, key)
	# your code here
	missing
end

# ╔═╡ 0828ed8e-67ba-46ac-974a-f673d93d8e19
let
	score1 = evaluate_key(hamlet, 3)
	score2 = evaluate_key(hamlet_full, 0)

	if ismissing(score1) || isnothing(score1)
		hint(md"You will need two earlier functions for this: `ceasar_decrypt` and `compare_frequencies`")
	elseif score1 == 140.74391988555078 && score2 == 0.0
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 073b2c94-8582-4f85-9f2f-45ea9ca27a8e
md"""
Since there are only 26 possible solutions, we can just calculate the score for all of them and pick the best one.
"""

# ╔═╡ ededfbcf-a514-44cb-9512-70c700647666
function best_solution(message)
	possible_keys = 1:length(alphabet)

	scores = map(possible_keys) do key
		score = evaluate_key(message, key)
		key, score
	end

	(argmin ∘ Dict)(scores)
end

# ╔═╡ da19664c-bb33-45bb-9d4d-a7667fe6aca7
md"Let's try it out!"

# ╔═╡ 9568383b-b14c-451c-8c1b-57604e8c13ba
secret3 = "WZGP LWW, ECFDE L QPH, OZ HCZYR EZ YZYP."

# ╔═╡ c75c8817-23ca-4495-bcc6-f68102ed9c88
best_solution(secret3)

# ╔═╡ 2e09cbe9-f24c-470a-ba3d-d46d8092d47f
let
	key = best_solution(secret3)
	ceasar_decrypt(secret3, key)
end

# ╔═╡ be369d7a-b3da-442b-aaf5-0d71caf0b69a
md"""
If you filled in a correct evaluation function above, you should be getting a sensible result here... hopefully! 😉
"""

# ╔═╡ 7654a2e4-daf0-4e21-918f-4931c22045cf
md"""
## Wrapping up

That's it for this notebook!

To wrap everything up: we introduced _substitution ciphers_. Decrypting a message is straightforward if you don't know the _key_, but difficult if you don't. We solved an easier version of the problem by focusing on a more resctricted kind of substitution ciphers, namely _ceasar ciphers_.

Ceasar ciphers are easier to solve because they don't have many keys, which is why you can check every single solution.

We then evaluated solutions based on character frequencies, and selected the one that looked the most like "normal" English text. This method is a bit crude, but it helps that caesar ciphers have very limited options.

The _part 2_ to this notebook will get into the more complex case of solving any replacement cipher.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Plots = "~1.40.13"
PlutoTeachingTools = "~0.4.1"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "8c5ca40141f3731bc5317657bb628a737a171944"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2ac646d71d0d24b44f3f8c84da8c9f4d70fb67df"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.4+0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

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

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

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
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "301b5d5d731a0654825f1f2e906990f7141a106b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.16.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "7ffa4049937aeba2e5e1242274dc052b0362157a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.14"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "98fc192b4e4b938775ecd276ce88f539bcec358e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.14+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

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

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

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
git-tree-sha1 = "cd10d2cc78d34c0e2a3a36420ab607b611debfbb"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.7"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

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
git-tree-sha1 = "a31572773ac1b745e0343fe5e2c8ddda7a37e997"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "321ccef73a96ba828cd51f2ab5b9f917fa73945a"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

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

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

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

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

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

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "809ba625a00c605f8d00cd2a9ae19ce34fc24d68"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.13"

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

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoUI"]
git-tree-sha1 = "537c439831c0f8d37265efe850ee5c0d9c7efbe4"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.4.1"

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

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "95af145932c2ed859b63329952ce8d633719f091"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.3"

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
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "b81c5035922cc89c2d9523afc6c54be512411466"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.5"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d62610ec45e4efeabf7032d67de2ffdea8344bed"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.1"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

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
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

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
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3cad2cf2c8d80f1d17320652b3ea7778b30f473f"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.3.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "002748401f7b520273e2b506f61cab95d4701ccf"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.48+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "c950ae0a3577aec97bfccf3381f66666bc416729"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.8.1+0"
"""

# ╔═╡ Cell order:
# ╟─0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
# ╟─1bf7875f-9a22-4ddb-8493-e6415d7ff0b0
# ╟─17c4d571-768e-451c-8596-34d791b83846
# ╟─ab028285-df3c-43d8-a4b2-9b063650ba66
# ╟─e54cbe8a-fffd-41e6-9045-d8ecb0994ce6
# ╠═81421e82-2679-417c-ba97-15e6ffa8c4d4
# ╟─7cee42ae-fa54-451f-a254-5871f22e5e11
# ╟─12f13216-0809-4da6-ad81-36e21e491cd1
# ╟─8abce95f-7163-4043-8a20-340ead77f462
# ╟─45242ec9-b815-483c-8ef9-6c6cfdd52e7d
# ╟─fbbaac1b-53b1-4eb2-82b2-a0ec481f58e7
# ╟─92ca8a1e-4c20-419e-8d72-b9721f32699b
# ╟─6917f83f-a6aa-4cbc-89da-ba0f448acaa0
# ╠═ee221dd4-d072-4679-992f-0d3657e90cd4
# ╟─ed619597-5d98-49a0-b015-7d832366ef9c
# ╟─c427fa89-4e71-4afa-8358-64df1f2c737f
# ╠═cb1e5f06-39a5-4b60-9e69-53772de4e8ce
# ╟─c16adf04-a392-4f41-851b-3204e96c1c46
# ╟─7ef58fdd-6853-4486-9d1d-cc8c590c2ed7
# ╟─669bb484-a594-4412-a96d-8a3414c0c204
# ╟─28378ac9-fd4a-4fe4-9a5f-1d9444427a60
# ╠═806509f4-9bab-4bf0-a8c5-40900f337f11
# ╟─5b2fef01-5a47-4f8a-bcd0-6cd75c1d0c82
# ╠═ccb8ccbd-37a4-4bde-8d3f-38ef76ea61a3
# ╠═af8bf867-09c2-4ac5-910f-9de5ae5a616a
# ╟─47851e6c-ed25-4ad4-bd5c-c1f622a8ac51
# ╠═a868d8db-fdab-4941-b733-ef5435ba5659
# ╟─c2a77d46-2d79-4993-96e4-a7d4a8ee5e6e
# ╠═64bef739-2aca-4423-92d9-93f0cc6bef59
# ╟─12842e4f-420c-4531-8ab5-9353149d1c18
# ╠═9f91b4e9-df13-4bbc-b2ee-3faf0a5e012c
# ╟─a3a4d43f-3b53-4d85-9721-923f2a62e9a1
# ╠═46dab0d5-f6dc-44b2-b30c-be534e1d04c3
# ╟─0d91bb9a-edbc-4076-960d-3f197d43c485
# ╟─b5023561-26bc-486e-99d8-cdce6cb76a2a
# ╟─7bbc4b4d-fbff-4897-b657-befe2268adbd
# ╠═e7c4ffc0-e494-4cf0-895d-110cb7b50357
# ╠═767996b1-40bf-49ba-9523-3d3111c33566
# ╟─892f4ce7-ac98-4e66-a6c6-aef74ba275ff
# ╠═4e44f92f-0de9-495d-9165-376717a1df2a
# ╟─f7ab9713-f36f-4c9c-9165-1bdd785c0926
# ╟─4814d886-b988-4423-ad03-378f0d4768fb
# ╠═108ad7d2-8a5b-462f-9a0d-6f3302c73a9a
# ╟─c27d16d1-70b2-481b-8374-4b4c7841807c
# ╠═a2c829c8-17a9-4489-96da-14975f3560b2
# ╟─125b86e9-6e9d-4770-a246-5a235b346609
# ╟─51c7849b-05f1-4169-bb1d-45dba94ccf5e
# ╠═c746e0c8-7246-4d48-bcc0-53d75f4fcaaa
# ╟─cccb5e00-7293-4be6-9d70-13449bdb08fe
# ╟─e75bed2d-6b28-4f07-955c-e9d52d2d0884
# ╠═15960689-5dd0-44e6-98ea-82612866d1e7
# ╟─361d9b88-e693-4654-9582-ab227dd21025
# ╠═25372462-b52a-4ba5-b59d-df591ea35f98
# ╟─bef18c5f-7a9c-475e-bd2c-9d3338257ac1
# ╟─81aba30e-4c6e-4d6a-a165-3d9313f108df
# ╠═c428660d-3ab9-4624-8a14-7044581e6b98
# ╟─b1557342-b352-4ed0-8b3b-15d466cbef24
# ╟─a8871358-7e16-41e1-a8a9-99bf46a3aab7
# ╟─7cc9612a-bbac-4cad-bc5f-3c2bdc71ee90
# ╠═b1575bb2-95ee-442b-b594-a7d21827b64d
# ╟─c6c848cb-af80-40ab-a8b6-9b52b4141a23
# ╠═47a88fe3-4d80-4e26-9cfb-70b4b45f2cee
# ╟─b9a0b03a-7564-44ad-a65a-64c1355d614f
# ╠═3f103c93-5435-42b3-8101-aec32a18654f
# ╟─75a7e5a3-d966-4057-ba18-5ef3820afe44
# ╠═457404ba-d87a-472e-87ef-b107bef05787
# ╟─f0fc8d5c-eb29-4263-afad-9678b76ff5d6
# ╟─aa7017b6-acfa-4323-9fbc-fa39ec3c48bf
# ╠═99b4a36a-d537-4cb7-b5e0-7ceb0d2fd58c
# ╠═c2bac47d-a7eb-4447-802f-58354bb2625c
# ╟─71311a17-112d-40b2-b291-61e990c2b4a3
# ╟─68fe1c65-1a59-40ef-8ef5-b7c40ba7511e
# ╠═e8c0fdb4-79d0-4818-b4c0-a55b36b1de5c
# ╟─30e55ee5-4a25-4347-8693-9380e2d3de5f
# ╠═075365b0-e2d0-433d-a370-7cfe7863206a
# ╟─7cd72e08-350f-47f6-a232-5462faad778a
# ╠═f0dbf680-f59e-46f8-a238-16eb30617957
# ╟─32877712-1ab7-4807-a2f7-48b0f0182461
# ╠═7efff273-2e95-4242-ac01-8b6e148d8d8e
# ╟─e44d3c04-86ad-4e7f-a89d-221cf624fc30
# ╠═0663fecc-f446-4cdb-907b-ce98e36a0713
# ╟─eb30efa9-6c35-4d93-88f4-88ffc046086c
# ╠═be7ddd86-27ee-40be-bb8d-fd7be6e2ae52
# ╟─bbc6d33b-1989-4124-8b8d-7e67495be1d6
# ╠═9b43d8b1-96da-456f-a4d2-807551eb59a4
# ╟─7acac33f-0fc4-4ade-8a1b-03c6f133e15b
# ╟─1ccbc14e-74a7-4875-8a5d-8eeaa5fd2d68
# ╟─7031b1ba-1da8-478c-9aba-53ec5c89e305
# ╟─9e1ffcf6-de14-463b-b6a9-fc9a393a3d8c
# ╟─c2977b4c-3750-4390-889b-3928770f6494
# ╠═95c0b0d9-5d45-4254-88f5-2765b6c99810
# ╟─82077381-611b-4084-ac9b-b51b684681dd
# ╟─0643922e-6fd7-40b3-8469-3076e1b7b9aa
# ╠═ce51b0bd-f3f4-4aba-b750-32277ad85cb3
# ╟─d7c37c08-0aae-4a59-9a42-541fe459325e
# ╟─40e44098-2ffa-4cf2-bb38-cf61285b06f7
# ╠═3874cac0-2eaf-41c5-9ed9-d11e219ede1e
# ╟─97dfce7d-175d-4d77-bbac-6a832c6dd221
# ╠═e750ecd9-21ec-46dc-ae49-1ce01487c83f
# ╟─98bb511c-4957-428e-98b1-0c7b5a9254ea
# ╠═6a997f41-b89e-439f-a1f1-b2e7cab67a45
# ╟─7fec90d5-4d0f-46ee-ba34-2fa37d62558d
# ╠═ffa9fc10-0d4e-4e29-9015-2b0ea9370d51
# ╟─0828ed8e-67ba-46ac-974a-f673d93d8e19
# ╟─073b2c94-8582-4f85-9f2f-45ea9ca27a8e
# ╠═ededfbcf-a514-44cb-9512-70c700647666
# ╟─da19664c-bb33-45bb-9d4d-a7667fe6aca7
# ╠═9568383b-b14c-451c-8c1b-57604e8c13ba
# ╠═c75c8817-23ca-4495-bcc6-f68102ed9c88
# ╠═2e09cbe9-f24c-470a-ba3d-d46d8092d47f
# ╟─be369d7a-b3da-442b-aaf5-0d71caf0b69a
# ╟─7654a2e4-daf0-4e21-918f-4931c22045cf
# ╠═1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╠═19ac84ba-367f-4aca-99bc-83a1f6ff122a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
