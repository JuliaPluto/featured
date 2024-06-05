### A Pluto.jl notebook ###
# v0.19.42

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
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
md"""
# Solving ciphers (part 1)

This notebook is about _substitution ciphers_. A substitution cipher is a kind of code where we replace each letter in a message with another. For example, replace every _A_ with an _F_, every _B_ with a _Q_, etc.

Here is an example. Try it out!
"""

# ╔═╡ 1bf7875f-9a22-4ddb-8493-e6415d7ff0b0
@bind test_message TextField((40, 4), default="Let's do some encryption! Yayyy")

# ╔═╡ 17c4d571-768e-451c-8596-34d791b83846
example_encrypted = encrypt(test_message, example_key)

# ╔═╡ ab028285-df3c-43d8-a4b2-9b063650ba66


# ╔═╡ e54cbe8a-fffd-41e6-9045-d8ecb0994ce6
md"""
Ciphers are used to **communicate in secret**. 

Without knowing the cipher, the encrypted text is impossible to read. But if you know the cipher used to encrypt a message, you can **decrypt** a message from someone else.
"""

# ╔═╡ 81421e82-2679-417c-ba97-15e6ffa8c4d4
decrypt(example_encrypted, example_key)

# ╔═╡ 7cee42ae-fa54-451f-a254-5871f22e5e11


# ╔═╡ 12f13216-0809-4da6-ad81-36e21e491cd1
md"""
## The challenge

Imagine that you intercepted a message that was encrypted using a cipher. The only thing you see is:


"""

# ╔═╡ 8abce95f-7163-4043-8a20-340ead77f462
example_encrypted

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

# ╔═╡ 1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╠═╡ show_logs = false
using Random, PlutoUI, Plots

# ╔═╡ 19ac84ba-367f-4aca-99bc-83a1f6ff122a
using PlutoTeachingTools: hint, almost, keep_working, correct

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Plots = "~1.40.4"
PlutoTeachingTools = "~0.2.15"
PlutoUI = "~0.7.59"
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

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"

[[ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "4b270d6465eb21ae89b732182c20dc165f8bf9f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.25.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

[[Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "ddda044ca260ee324c5fc07edb6d7cf3f0b9c350"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.5"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "278e5e0f820178e8a26df3184fcb2280717c79b1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.5+0"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Dates", "Test"]
git-tree-sha1 = "e7cbed5032c4c397a6ac23d1493f3289e01231c4"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.14"

[[IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

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
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e9648d90370e2d0317f9518c9c6e0841db54a90b"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.31"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "e0b5cd21dc1b44ec6e64f351976f961e6f31d6c4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.3"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "c6a36b22d2cca0e1a903f00f600991f97bf5f426"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.4.6"

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
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

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
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "442e1e7ac27dd5ff8825c3fa62fbd1e86397974b"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.4"

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
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "5d9ab1a4faf25a62bb9d07ef0003396ac258ef1c"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.15"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

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

[[Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

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

[[Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "12aa2d7593df490c407a3bbd8b86b8b515017f3e"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.14"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

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
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

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

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "5d54d076465da49d6746c647022f3b3674e64156"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.8"

[[Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "Random"]
git-tree-sha1 = "dd260903fdabea27d9b6021689b3cd5401a57748"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.20.0"

[[UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "52ff2af32e591541550bd753c0da8b9bc92bb9d9"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.7+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

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

[[Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

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
