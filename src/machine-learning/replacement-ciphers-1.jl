### A Pluto.jl notebook ###
# v0.19.26

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

# ╔═╡ 1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╠═╡ show_logs = false
using Random, PlutoUI, Plots;

# ╔═╡ 0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
md"""
# Replacement ciphers (part 1)

This notebook is about _replacement ciphers_. A replacement cipher is a kind of code where we replace each letter in a message with another. For example, replace every _A_ with an _F_, every _B_ with a _Q_, etc.

Here is an example. Try it out!
"""

# ╔═╡ 9f8955ea-d994-48c2-9547-55d443885243


# ╔═╡ 1bf7875f-9a22-4ddb-8493-e6415d7ff0b0
@bind test_message TextField((40, 4), default="Let's do some encryption!")

# ╔═╡ 1754093a-a7e5-4aff-b4d7-816a21937855


# ╔═╡ fbbaac1b-53b1-4eb2-82b2-a0ec481f58e7
md"""
(More specifically, we will look at one-to-one replacement ciphers. This means that every letter in the original message has only one target, and every target has only one original.)

In this notebook, we will define such ciphers, and make a start with solving them. Since solving ciphers is pretty hard, we will look at a simpler case: ceasar ciphers. We will see what it takes to write a program that solves these simpler ciphers.

Part 2 of this notebook is about solving replacement ciphers. The two notebooks are intended to provide a gradual introduction into the topic, but you can skip ahead if you're feeling very confident.

The exercises in this notebook will not require any knowledge about ciphers, but some understanding of strings in Julia is recommended.
"""

# ╔═╡ edfa02ac-22ba-4252-8608-0e2ef8adc4f7


# ╔═╡ 6917f83f-a6aa-4cbc-89da-ba0f448acaa0
md"""
## Defining ciphers

To solve ciphers, we first need some basic code to encrypt a piece of text, and to decrypt it once we know the key.

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
	# shuffle alphabet to get replacements for each character
	replacements = shuffle(alphabet)

	# combine alphabet and replacements
	(collect ∘ zip)(alphabet, replacements)
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
	
	If you know the key, encrypting and decrypting messages is pretty straightforward. Trying to decrypt a message without the key is a puzzle.
	"""
end

# ╔═╡ 28378ac9-fd4a-4fe4-9a5f-1d9444427a60
md"""
### Encryption

Let's try using that key. But before we can start replacing, there is one thing we need to do. You may have noticed that our alphabet only uses uppercase characters. If we want to use the key on a message, we need to use _uppercase_ characters only.
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
For real secret communication, you might consider doing more in this preparation, such as obscuring the interpunction a bit, or stripping diacritics (`é`, `ö` and so on). But we'll leave it at this for now.

Now, let's encrypt that message. Here is a function that will apply a replacement cipher for a message and a key.
"""

# ╔═╡ a868d8db-fdab-4941-b733-ef5435ba5659
function encrypt(message, key)
	# make a dictionary from the key for easy retrieval
	replacement_dict = Dict(key)

	# prepare the message and make an array of characters
	characters = (collect ∘ prepare)(message)

	# replace each character
	newcharacters = map(characters) do character
		if character in alphabet
			# replace using the key
			replacement_dict[character]
		else
			# for characters not in the alphabet, return them unchanged
			character
		end
	end

	# convert the replaced characters into a string
	String(newcharacters)
end

# ╔═╡ 17c4d571-768e-451c-8596-34d791b83846
encrypt(test_message, example_key)

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
	
	For one-to-one replacement ciphers, decryption is just like encryption. We just need to apply our encryption function, but inverse the key. The original key said to replace _$firstchar_ with _$secondchar_, so now we want to replace _$secondchar_ with _$firstchar_.
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

We'll start with a simpler version of the puzzle, using the _ceasar cipher_. Ceasar ciphers (also known as shift ciphers) are a kind of replacement cipher where the replacement for each character always has the same distance in the alphabet. For example, if _A_ is replaced by _D_, then _B_ is replaced by _E_, _C_ by _F_, and so forth.

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

# ╔═╡ 51c7849b-05f1-4169-bb1d-45dba94ccf5e
md"Let's do a sanity check: if we encrypt and then decrypt a message using the same key, we should get the same message back."

# ╔═╡ c746e0c8-7246-4d48-bcc0-53d75f4fcaaa
let
	shift = 3
	encrypted = ceasar_encrypt(hamlet, shift)
	decrypted = ceasar_decrypt(encrypted, shift)
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

# ╔═╡ 81aba30e-4c6e-4d6a-a165-3d9313f108df
md"""
What is the shift key that was used to encrypt the message?
"""

# ╔═╡ c428660d-3ab9-4624-8a14-7044581e6b98
secret_key = missing # fill in your solution here

# ╔═╡ a8871358-7e16-41e1-a8a9-99bf46a3aab7
md"""
This list of solutions only had 26 options. But with a "normal" replacement cipher, there are way too many options to go over them by hand like this.

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

(Another problem with recognising words is that you need to know a _lot_ of words before it works reliably.)

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
	differences = map(zip(percentages_1, percentages_2)) do (p1, p2)
		abs(p1 - p2)
	end

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

To wrap everything up: we introduced _replacement ciphers_. Decrypting a message is straightforward if you don't know the _key_, but difficult if you don't. We solved an easier version of the problem by focusing on a more resctricted kind of replacement ciphers, namely _ceasar ciphers_.

Ceasar ciphers are easier to solve because they don't have many keys, which is why you can check every single solution.

We then evaluated solutions based on character frequencies, and selected the one that looked the most like "normal" English text. This method is a bit crude, but it helps that caesar ciphers have very limited options.

The _part 2_ to this notebook will get into the more complex case of solving any replacement cipher.
"""

# ╔═╡ 416802ea-9e46-4e4a-8091-9c26da687614
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));

# ╔═╡ bef18c5f-7a9c-475e-bd2c-9d3338257ac1
hint(md"Each way to shift the alphabet is characterised by a shift key. You need to generate the decrypted message for every single one.")

# ╔═╡ 1beb64fe-5554-4a6e-8c59-998c4a34369c
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

# ╔═╡ 5fe264ca-c102-4f12-af55-bb29e7d8b1d9
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

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

# ╔═╡ b1acbd5d-be00-4638-882b-d4022874dd75
correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

# ╔═╡ f7ab9713-f36f-4c9c-9165-1bdd785c0926
let
	encrypted = ceasar_encrypt(hamlet, 3)

	if encrypted == "WR EH RU QRW WR EH, WKDW LV WKH TXHVWLRQ."
		correct()
	else
		hint(md"The function `shift_cipher` converts a shift number to a list of replacements. We have another function that applies a list of replacements.")
	end
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

# ╔═╡ 71311a17-112d-40b2-b291-61e990c2b4a3
if hamlet_ceasar_encrypted_most_frequent == 'W'
	correct()
else
	hint(md"""You can calculate the most frequent letter in the encrypted quote by counting the characters again, but if you solved the last question, maybe you don't need to. What happens to every $(hamlet_most_frequent == 'T' ? "_T_" : "character") in the encrypted quote? And how does that affect their frequency?""")
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Plots = "~1.30.1"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "e08915633fcb3ea83bf9d6126292e5bc5c739922"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.13.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "fb28b5dc239d0174d7297310ef7b84a11804dfab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.0.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "fe9aea4ed3ec6afdfbeb5a4f39a2208909b162a6"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.5"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "d0a61518267b44a70427c0b690b5e993a4f5fe01"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.30.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "18c35ed630d7229c5584b945641a73ca83fb5213"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.2"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "ffc098086f35909741f71ce21d03dadf0d2bfa76"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.11"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArraysCore", "Tables"]
git-tree-sha1 = "13237798b407150a6d2e2bce5d793d7d9576e99e"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.13"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─0fa3c6d0-ee3d-11ec-0bb4-a944807ba0ed
# ╟─9f8955ea-d994-48c2-9547-55d443885243
# ╟─1bf7875f-9a22-4ddb-8493-e6415d7ff0b0
# ╟─17c4d571-768e-451c-8596-34d791b83846
# ╟─1754093a-a7e5-4aff-b4d7-816a21937855
# ╠═fbbaac1b-53b1-4eb2-82b2-a0ec481f58e7
# ╠═edfa02ac-22ba-4252-8608-0e2ef8adc4f7
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
# ╟─ce51b0bd-f3f4-4aba-b750-32277ad85cb3
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
# ╟─1f522768-ff6f-4f27-8f16-75bf5b5e6f9e
# ╟─416802ea-9e46-4e4a-8091-9c26da687614
# ╟─1beb64fe-5554-4a6e-8c59-998c4a34369c
# ╟─5fe264ca-c102-4f12-af55-bb29e7d8b1d9
# ╟─b1acbd5d-be00-4638-882b-d4022874dd75
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
