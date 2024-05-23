### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> license_url = "https://github.com/JuliaPluto/featured/blob/main/LICENSES/Unlicense"
#> image = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Verschiedenfarbige_Schwertlilie_%28Iris_versicolor%29-20200603-RM-100257.jpg/1024px-Verschiedenfarbige_Schwertlilie_%28Iris_versicolor%29-20200603-RM-100257.jpg"
#> order = "1"
#> title = "Classifying Irises"
#> tags = ["machine learning", "knn"]
#> date = "2024-04-30"
#> description = "Write a machine learning algorithm!"
#> license = "Unlicense"
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

# ╔═╡ db795bce-a590-4f1c-b1d1-d7056b617268
using DataFrames # allows us to work with tables

# ╔═╡ 37521375-31c9-4e90-be2d-cb9c8421d2c5
using Colors

# ╔═╡ 1f2d1ed2-58aa-4131-9331-3a3e870d06a6
md"""
# Classifying irises

How can a computer learn and adapt?

This notebook will discuss some basic concepts in **machine learning**. We'll be looking at the *iris* dataset, a collection of measurements on different species of iris (a kind of flower).
"""

# ╔═╡ 7def21a0-7d83-4b4f-863b-90b9e61c7e13
html"""
<figure>
	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Verschiedenfarbige_Schwertlilie_%28Iris_versicolor%29-20200603-RM-100257.jpg/1024px-Verschiedenfarbige_Schwertlilie_%28Iris_versicolor%29-20200603-RM-100257.jpg">
	<figcaption><i>
		Photograph by <a href="https://commons.wikimedia.org/wiki/User:Ermell">Reinhold Möller</a>, licensed under <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0 International</a>
	</i></figcaption
</figure>
"""

# ╔═╡ 9ea7eab3-f90e-498c-9105-b3d152e0e014
md"""
The task for our program will be to categorise flowers based on their measurements. This kind of task (putting things in categories) is called **classification**.

To do that, we'll use an algorithm called **k nearest neighbours** (or **KNN**).

!!! info "Is this for me?"
	
	This notebook contains exercises that will takke you through basic concepts in machine learning.

	The exercises are designed to be suitable for beginning programmers. If you've never worked with [DataFrames](https://dataframes.juliadata.org/stable/), I recommend keeping the documentation open.
"""

# ╔═╡ 4f011391-d962-431b-9d05-8c83c5561cfb
md"""
Let's get started!

We'll import some useful libraries:
"""

# ╔═╡ 6dc49a6e-d96b-4a37-bad9-6d702961b972
import Plots # visualisations!

# ╔═╡ d2722a2c-9555-412f-8e39-17f28357149b
import PlutoUI # interactive widgets!

# ╔═╡ a0dd088a-e6c2-4b4a-8696-1181a0fc91c1
import Random # for taking random samples

# ╔═╡ 811c6d67-c0bc-41b9-a8d0-fb1a63aef616
md"""
## Data preparation

The *iris* dataset is a classic dataset that is often used to illustrate data visualisation, statistics, and machine learning. It contains measurements for 150 irises, as well as their species.

This dataset is included in the `RDatasets` package, so we'll import it from there.
"""

# ╔═╡ b56c60e5-83ad-4806-a88a-e6051f0e7a77
import RDatasets: dataset # package containing common datasets

# ╔═╡ 6c9ae100-8b67-4633-939a-1cf8df118fd6
data = dataset("datasets", "iris")

# ╔═╡ 9e0d088f-1e31-4ddb-9346-577ecaaa28a2
md"""
There are three species of flowers in the dataset:
"""

# ╔═╡ 5c788dc0-f0fe-43cf-bf8b-b5c4d9c08e33
species = unique(data.Species)

# ╔═╡ 9bcf05fc-3244-4d71-9ed0-84529ecb0428
md"""
Our model should learn to recognise the species of flower based on the measurements. The dataset has four columns containing measurements:
"""

# ╔═╡ 22a4b918-c4f7-4ffc-9f08-67e330fc1ee2
feature_columns = names(data, Not(:Species))

# ╔═╡ 825521a1-b398-4d5c-8a0f-75e356ce271a
md"""
These are the _features_ of the flowers that our model will be looking at.
"""

# ╔═╡ d0cfa2dd-31ee-4431-b268-5256b97557be
md"""
### Train and test data

Before we can start with some machine learning, we have to ask ourselves: how will we evaluate our model? How can we see if it works?

Ultimately, we want to be able to make predictions for new input. We have identified the species of 150 flowers; now we build a model, so when we have more flowers in the future, the model can identify their species.

So, what we want to know is how well our model performs on flowers that it hasn't seen yet. To do that, we'll split our data into two parts:

- _training data_ which the model will be based on
- _test data_ which we use to evaluate the model

Here is some code that divides the data.
"""

# ╔═╡ 36c3077f-b10d-4e9d-aeb4-40902627e0d5
train_set_assignments = let
	# 4 parts train data, 1 part test data
	chunk = ["train", "train", "train", "train", "test"]
	# repeat to get 150 items
	assignments = repeat(chunk, 30)
	# shuffle
	Random.shuffle(assignments)
end

# ╔═╡ 03266573-f7c7-4d0e-b6be-1c36f993e8b5
split_data = let
	# add the assignments as a column
	data_with_set = insertcols(data, :set => train_set_assignments)
	# group the data by assigned set
	grouped = collect(groupby(data_with_set, :set, sort=true))
	# select everything except the assignment column from each group
	map(grouped) do group
		select(group, Not(:set))
	end
end;

# ╔═╡ ef271385-b5ba-4f89-9375-7bc9c2444f6c
md"""
The dataset `train_data` has 120 items:
"""

# ╔═╡ c62f4d47-9fa2-46ce-9a74-0b570243cb7d
train_data = last(split_data)

# ╔═╡ 1f8eef1c-b6d4-4af3-b52c-9657092fb7a8
md"""
`test_data` contains the remaining 30 items:
"""

# ╔═╡ 3c133b18-45da-40d0-9af5-14166e68d9ca
test_data = first(split_data)

# ╔═╡ 3f48af69-32a1-4387-bda3-aab232938456
md"""
### Feature selection

There are four data columns with _features_ of flowers that our model can use: sepal length, sepal width, petal length and petal width.

Our model in this notebook will only look at _two_ features, as that's easier to visualise. You can pick which ones here!
"""

# ╔═╡ eef4fb63-ff68-4657-8b70-4b3cac878fc4
@bind feature_1 PlutoUI.Select(feature_columns)

# ╔═╡ 9e2ac902-1a95-4bc2-a0e7-6098e3af31d1
let
	not_picked = filter(feature_columns) do feature
		feature != feature_1
	end
	@bind feature_2 PlutoUI.Select(not_picked)
end

# ╔═╡ 618e9666-82a2-4727-91fd-30e096e7e9e0
feature_1, feature_2

# ╔═╡ 73dd13d7-61b2-4337-9ebd-15c98c8f368f
md"""
We'll be looking at *$(feature_1)* and *$(feature_2)*. Here they are in a graph:
"""

# ╔═╡ 966dbb91-e16d-4ba2-a6d0-7155ec6ef619
md"""
The white points (labelled "?" in the legend) are the test data.
"""

# ╔═╡ b59a4174-90fe-4e87-9da1-2624301e18cb
md"""
## A baseline model

Our goal is to make an algorithm where we can input some measurements of a flower, and the species as output.

Before we'll get to machine learning, we'll start with a **baseline**. This is a "model" that will do the same thing (take some data as input and give a species as output), but it hasn't learned anything. It will just give random results.
"""

# ╔═╡ 008af75a-67af-4d56-977a-3fdcb2292954
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `classify_random` that takes a row of data as input and returns a _random_ species.
"""

# ╔═╡ 7d4385d7-ad71-4eae-8613-bf83a42b0c82
md"""
!!! hint "Hint"

	The `Random` package contains some functions for getting random values. You can use the "live docs" panel to explore it!

	If you have trouble figuring this out, you can also just return the same flower name each time.
"""

# ╔═╡ f2546819-8f44-44b0-b10a-a140075100aa
function classify_random(f1::Float64, f2::Float64)
	missing # replace this with your code!
end

# ╔═╡ 9dd7878e-9206-4ce7-9934-3a8e33b8ea57
md"""
Let's try it!
"""

# ╔═╡ 1a92dbbe-de0f-4646-935a-9b9385e84a81
example_row = first(test_data)

# ╔═╡ ca9c6cca-f2a8-4d8b-94a3-174fe17f6bfe
classify_random(example_row[feature_1], example_row[feature_2])

# ╔═╡ b42035ee-2721-40d3-a4e7-76fea44581f9
md"""
Let's see how accurate our baseline model is. This will be a good sanity check when we build a real model: it tells us what we should expect at minimum.
"""

# ╔═╡ 3db840b1-64b5-42c2-8b0f-0bc016d6077e
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `percentage_correct` that takes two vectors: the correct answers, and the predictions from a model. It should return what percentage of items was predicted correctly.
"""

# ╔═╡ f4ed242d-fe2d-41c9-b670-0e59513bcbf5
md"""
!!! hint

	Start by comparing each pair of a prediction and an answer. How often do they match?
"""

# ╔═╡ c0263a27-de58-423c-96a1-b27c182eb6db
function percentage_correct(answers::AbstractVector, predictions::AbstractVector)
	missing # replace this with your code!
end

# ╔═╡ afb924f7-452a-4f6f-84b5-d39cda44f2b4
try
	result_100 = percentage_correct(["a", "b"], ["a", "b"])
	result_50 = percentage_correct(["a", "b"], ["a", "c"])
	result_0 = percentage_correct(["a", "b"], ["b", "a"])
	if any(ismissing, [result_100, result_50, result_0])
		md"""
		!!! info "No answer yet"

			Fill in your answer in the `percentage_correct` function!
		"""
	elseif result_100 == 100 && result_50 == 50 && result_0 == 0
		md"""
		!!! success "Well done!"
	
			Great!
		"""
	elseif result_100 == 1 && result_50 == 0.5 && result_0 == 0
		md"""
		!!! warning "Almost there!"
	
			It looks like your function is working correctly, but it's giving ratios instead of percentages. If everything matches, the output should be 100, not 1!		
		"""
	elseif result_100 == 2 && result_50 == 1 && result_0 == 0
		md"""
		!!! warning "Almost there!"
	
			It looks like your function is counting the correct answers, but it's not yet turning them into percentages.
		"""
	else
		md"""
		!!! danger "Keep working on it!"

			Your function isn't giving the expected results yet.
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ b9895dfa-1ded-4794-875f-79bd4ece8e28
md"""
We can use this function to evaluate a classifier. Here is a function that does that: it takes a classifier function as input (like `classify_random`) and returns the percentage of correct answers that the function outputs on the test data.
"""

# ╔═╡ 08baa655-fe08-4d83-b015-a36b63faf076
function evaluate(classifier::Function)
	values_feature_1 = test_data[!,feature_1]
	values_feature_2 = test_data[!,feature_2]

	test_predictions = classifier.(values_feature_1, values_feature_2)
	
	# check for when the classifier hasn't been implemented yet
	if any(ismissing, test_predictions)
		return missing
	end
	percentage_correct(test_predictions, test_data.Species)
end

# ╔═╡ 5e21ecff-70b8-4010-afb1-aa46a8513a02
md"""
Let's evalute the `classify_random` function!
"""

# ╔═╡ 2bf19860-cf72-43eb-805b-3d220617610a
evaluate(classify_random)

# ╔═╡ 684f55cb-740f-4cd6-8aa1-4c24055f9396
md"""
There are three species of flowers and they're all equally common in the dataset. So when we we assign randomly, we should get a percentage somewhere around 33%.

!!! exercise "⭐ Bonus"

	If `classify_random` involves a random component, the accuracy is going to be a little different each time we run it. Try running the cell above a few times! You should get different results, but see that they're around 33%.

	Perhaps we can build that repetition into `percentage_correct` to get a more reliable score. Can you update it?
"""

# ╔═╡ a95504e7-e5aa-48cd-ab52-802c57da8cb1
md"""
We can see how our model behaves in a visualisation. Here we've plotted the training data again, but the background in the graph shows the prediction of the model for that datapoint.

If `classify_random` is giving random predictions, this should just look like random noise.

(If the background is empty, it's because the classifier hasn't been implemented yet, or it's not giving valid results.)
"""

# ╔═╡ 398acb44-1fbc-4b6f-bfa4-3e1ecfaf73a9
md"""
Here we can see the same comparison with the test data.
"""

# ╔═╡ 562dad75-8a94-4d31-acac-bb771f75b154
md"""
In machine learning, we often use baseline models to set our own expectations. The random model helps us to see what we can expect at minimum. Now, let's see if we can improve it!
"""

# ╔═╡ 92643819-477e-4c41-a63b-686b3a8e25f2
md"""
## Remembering observations

To improve from random assignments, our model has 120 observations at its disposal (the training data). How can we use those observations when we classify a new flower?

We'll start with a very simple form of learning: rote memory.

Our improved model will classify flowers by looking at the training data, and checking if there is a flower with the same measurements. If so, the model can return the species of that flower.
"""

# ╔═╡ 76e4ca8f-02b9-4bcd-a60b-bfcb7cc26cd3
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `find_match`. It will get two measurements as input (for the two features we selected).

	If there is a row in `train_data` that matches those measurements, the function should return that row. Otherwise, it should return nothing.
"""

# ╔═╡ fdf7e78a-fcc8-4818-a6e7-4bfcec8fd53d
md"""
!!! hint

	Use `eachrow` to get a list of all rows in a dataframe!
"""

# ╔═╡ 0a1c4c26-f838-4b9e-8ee0-16d71f9d238b
function find_match(f1::Float64, f2::Float64)
	missing # replace this with your code!
end

# ╔═╡ e7bbe043-b1fe-495f-9252-6613bde68a20
md"""
Let's try it:
"""

# ╔═╡ 8ea763c7-5385-4dfb-89ff-1d95061391b2
let
	test_row = test_data[1,:]
	find_match(test_row[feature_1], test_row[feature_2])
end

# ╔═╡ 54e8c76c-6541-4b74-878c-93785e9afd06
try
	train_rows = eachrow(train_data)
	train_matches = map(train_rows) do row
		find_match(row[feature_1], row[feature_2])
	end

	all_match = all(zip(train_rows, train_matches)) do (train_row, matched_row)
		if ismissing(matched_row)
			missing
		else
			train_row[feature_1] == matched_row[feature_1] && train_row[feature_2] == matched_row[feature_2]
		end
	end

	no_match = find_match(100.0, 300.4)

	if any(ismissing, train_matches) || ismissing(no_match)
		md"""
		!!! info "No answer yet"
			
			Fill in your answer above!
		"""
	elseif all_match && isnothing(no_match)
		md"""
		!!! success "Yay!"

			Well done! Let's try using this function.
		"""
	elseif all(isnothing, train_matches) && isnothing(no_match)
		md"""
		!!! warning "No matches"

			`find_match` isn't finding anything!
		"""
	else
		md"""
		!!! danger "Keep working on it!"

			That's not quite right!
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 410f9241-7bd9-4579-9bc2-ba121e68fc47
md"""
Now we can match observations to an item in the training data. Let's use that to build a classifier function.
"""

# ╔═╡ eacb9a6b-b1e4-4d77-b8ea-f49d4e8675c9
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `classify_by_memory`. It takes two measurements as input, and should return a species.
	
	If the measurements have a match in the training data, it should return the species of that flower. If not, it should return a random result.
"""

# ╔═╡ 37527109-c527-4dcb-8261-3f555cf2e394
md"""
!!! hint

	Use your `find_match` function to identify the species, and `classify_random` as a backup.
"""

# ╔═╡ d38875ad-8d47-47bc-8e44-af27552f7dba
function classify_by_memory(f1::Float64, f2::Float64)
	missing # replace this with your code!
end

# ╔═╡ fc871c1d-2d7c-434b-b52f-2d79b782a5e1
md"""
Let's try it!
"""

# ╔═╡ ecf201c2-d895-48ec-91be-a4ae7bbe3cd5
classify_by_memory(test_data[1,feature_1], test_data[1,feature_2])

# ╔═╡ 18af3602-b843-424b-9386-dd3faf1ffa76
md"""
Let's see the accuracy of this function.
"""

# ╔═╡ d01eaba7-7e55-4e5c-b345-6d4ee11cd2bf
evaluate(classify_by_memory)

# ╔═╡ 1dbe3c99-fe1e-4b2f-84a4-0a3d866ade23
md"""
It's not performing much better than the random classifier!

Let's visualise this function too. Here it is with the training data:
"""

# ╔═╡ 551077e9-9120-41a3-9d6f-d4f365108444
md"""
If everything went well, you should see that for each training point (the dots), the underlying square shows the same color: the classifier is using these datapoints as a reference, so it would be assigning them correctly if it saw them again.

However, most of the graph is just random noise. When we plot the assignments with the test data, it's hard to distinguish from the random classifier.
"""

# ╔═╡ dc506ec6-de15-4704-a7c5-2b35d636a299
md"""
## Handling new observations

We wrote a model that can remember observations from the training data, but each flower is just a bit different, so that doesn't work very well.

We need a way of handling new observations: compare them to the training data, but without requiring an exact match.

To do this, we'll need some way of checking if two flowers are _similar_.
"""

# ╔═╡ e5c9e9f4-33aa-4594-944d-60f6fffcafe2
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `distance` that takes the measurements for two flowers, and tell you how far apart they are.

	It's up to you how exactly you want to define distance. But distance should always be a positive number, and the distance from a flower to itself should always be 0.
"""

# ╔═╡ 964cfedf-38c0-4a01-8e47-d63726b449dc
md"""
!!! hint

	The easiest way to quantify distance is to add the difference in both features together.
"""

# ╔═╡ 0fbb7294-1e9f-4f39-9805-a0205de37bc3
function distance(
	flower1_f1::Number,
	flower1_f2::Number,
	flower2_f1::Number,
	flower2_f2::Number,
)
	missing # replace this with your code!
end

# ╔═╡ 821d0997-2806-455d-8f9d-f1d8ae7bdeb1
md"""
Let's try it out!
"""

# ╔═╡ 159669e0-25f8-4013-9448-d74dc1a17ff0
let
	flower1 = train_data[1,:]
	flower2 = train_data[2,:]
	distance(
		flower1[feature_1], flower1[feature_1],
		flower2[feature_1], flower2[feature_1]
	)
end

# ╔═╡ 2d388e16-c993-4f01-a532-735148e65966
try
	distance_very_high = distance(100.0, 100.0, 2.3, 2.4)
	distance_high = distance(4.4, 4.5, 2.3, 2.4)
	distance_low = distance(4.4, 2.3, 4.5, 2.4)
	distance_none = distance(4.4, 4.5, 4.4, 4.5)
	distances = [distance_very_high, distance_high, distance_low, distance_none]

	if any(ismissing, distances)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif any(d -> !(d isa Number), distances)
		md"""
		!!! danger "Keep working on it!"

			The distance function should always return an number.
		"""
	elseif any(d -> d < 0, distances)
		md"""
		!!! danger "Keep working on it!"

			Distance should always be a positive number!
		"""
	elseif distance_none > 0
		md"""
		!!! warning "Almost there!"

			The distance between two identical measurements should always be 0.
		"""
	elseif distance_very_high > distance_low > distance_high > distance_none > 0
		md"""
		!!! danger "Almost there!"

			Did you confuse the four input parameters? The first two are from the first flower, and the second two are form the second flower.
		"""
	elseif distance_low == distance(4.4, 2.3, 4.5, 100.0) || distance_low == distance(4.4, 2.3, 100.0, 2.4)
		md"""
		!!! warning "Almost there!"

			It looks like you're ignoring one of the two features. You should use both!
		"""
	elseif distance_very_high > distance_high > distance_low > distance_none == 0
		md"""
		!!! success "Nice!"

			It looks like the distance function is working!
		"""
	else
		md"""
		!!! danger "Keep at it!"

			It looks like the distance function isn't working well. The distance should be higher when measurements are far apart!
		"""
	end
catch
		md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 4f45ead9-74ed-48fe-8470-7989e790b66c
md"""
Now we have a way of quantifying whether two flowers are similar. We can use that function to compare new observations to the training data: instead of looking for an exact match, we can  find the _closest match_.
"""

# ╔═╡ 4ec487d0-ae21-400c-a47b-c1194ed5daa1
md"""
!!! exercise "👉 Your turn!"
	
	Use your function `distance` to fill in the function `nearest_neighbor`.

	The function takes two measurements as input, and should return a row of the training data, that is the closest match to those measurements.
"""

# ╔═╡ 786c6b59-a1d1-414f-8004-ba2bfa8b066d
md"""
!!! hint

	If you're not sure what to do, use the Live Docs panel to check out the documentation for `minimum`, `findmin` and `argmin`. Can you think of a way to use those functions?

	If you find it more intuitive, you can also use a `for` loop to go through the data and keep track of the closest match as you go.
"""

# ╔═╡ 5c25ae31-b182-467d-8361-a9d03031ab79
function nearest_neighbor(f1::Number, f2::Number)
	missing # replace this with your code!
end

# ╔═╡ fd1770bb-fce1-479a-9e9e-bbd6388d5f27
md"""
Let's try it!
"""

# ╔═╡ 097fbc6c-d085-4652-bb93-930aab57beb1
first(test_data)

# ╔═╡ fd7f2edc-c885-4905-ad35-bff780366bac
nearest_neighbor(first(test_data)[feature_1], first(test_data)[feature_2])

# ╔═╡ 357e3b2f-1b77-458b-a0ba-0dbbb6ce97ee
md"""
!!! exercise "⭐ Bonus"

	What does your function do if multiple rows are tied? Is that what you think should happen?

	Can you update `nearest_neighbor` to pick one of the tied rows at random?

!!! hint

	Try using `Random.shuffle()` on a dataframe to get a copy with the rows randomly rearranged.
"""

# ╔═╡ e7531f74-65ba-427c-bb35-5c3b17e20a64
md"""
Now that we have the best matching row, we can use it to predict the species of a flower.
"""

# ╔═╡ 6e0936a2-d3c2-42b8-8510-6f9cb6ca8a95
md"""
!!! exercise "👉 Your turn!"
	
	Use your `nearest_neighbor` function to fill in the function `classify_by_nearest_neigbor` that will take a pair of measurements and return a _species_ for it, based on the closest match in the training data.
"""

# ╔═╡ 16c1f0c9-2d22-4d4f-866a-b119a5b002fd
function classify_by_nearest_neighbor(f1::Number, f2::Number)
	missing # replace this with your code!
end

# ╔═╡ ff228129-8098-4721-bccc-9b2b812ccc35
md"""
Let's try it!
"""

# ╔═╡ 10d027f5-920e-4951-af4f-6ad047fb9ec5
classify_by_nearest_neighbor(first(test_data)[feature_1], first(test_data)[feature_2])

# ╔═╡ d6ef42f6-931a-4019-b594-fd4fbde07967
md"""
We can see the accuracy of this function:
"""

# ╔═╡ f1c9fefb-47d6-4038-8cc0-a1fc3f90cd68
evaluate(classify_by_nearest_neighbor)

# ╔═╡ d00b3fc2-6441-4233-94ef-70c380c324c7
md"""
This should be a noticable improvement on the baseline model!

Let's visualise the results.
"""

# ╔═╡ c19a27e0-caff-4e5c-abd7-67da7ba13841
md"""
## Improving our classifier

The nearest neighbour classifier works, but can we improve it?

One issue with this way of classifying things is that our model is basing its answer on a single flower. That makes it very sensitive to outliers: one weirdly shaped flower can throw off your predictions.

We can improve this by looking at a few flowers, instead of just one.
"""

# ╔═╡ 6d016e4c-07e2-47ac-a421-69f5d59fc94a
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `nearest_neighbors` which will return the ``k`` nearest matches in the training data.
"""

# ╔═╡ f9e87ee2-1b1d-4175-ab25-35f310abf336
md"""
!!! hint

	You can use the function `first` to get the first ``k`` rows in a dataframe. But you'll need to sort the data first, so the best matches appear on top.
"""

# ╔═╡ c9b20e9b-cfad-4391-ac42-1c30061a6f19
function nearest_neighbors(f1::Number, f2::Number; k::Int=5)
	missing # replace this with your code!
end

# ╔═╡ 7cd84b83-5981-4bf6-b01a-f97a1016de3b
md"""
Let's try it!
"""

# ╔═╡ 6a830cc8-2a67-4996-a359-c1adb62d0999
nearest_neighbors(4.8, 3.4, k=5)

# ╔═╡ c71d1f21-8d90-4340-a269-3a018757dd95
md"""
When we have a few matches, we'll need to pick the correct species. Let's write a function to help us with that.
"""

# ╔═╡ bc3c6b39-e88a-4f3c-96bf-327c89071ccc
md"""
!!! exercise "👉 Your turn!"
	
	Fill in the function `most_common` which takes a list of species names, and returns the most common one.
	
	In case of a tie, you can pick any of the tied values.
"""

# ╔═╡ 4283d5bf-deac-42f0-9389-7768be5200f7
md"""
!!! hint

	Start by counting how often each species name occurs in the list.
"""

# ╔═╡ b0fb79f0-97ad-4d14-a522-78d5d8843e73
function most_common(names::AbstractVector)
	missing # replace this with your code!
end

# ╔═╡ 04ca45fc-8d9c-4687-bc3d-bc140f8910f4
md"""
Let's try it!
"""

# ╔═╡ ce354381-57ad-40c0-b4ee-b9e4ec78685e
most_common(["setosa", "versicolor"])

# ╔═╡ b63c4912-d454-4f4a-bd69-e4312e777b0e
try
	checks = [
		most_common(["setosa", "versicolor", "setosa"]) == "setosa",
		most_common(["versicolor", "setosa", "setosa"]) == "setosa",
		most_common(["setosa", "versicolor", "versicolor", "virginica"]) == "versicolor",
		most_common(["setosa", "virginica", "setosa", "virginica"]) ∈ ["setosa", "virginica"],
		most_common(["virginica", "setosa", "versicolor", "setosa", "virginica"]) ∈ ["setosa", "virginica"],
		most_common(["virginica", "setosa", "versicolor", "setosa", "versicolor"]) ∈ ["setosa", "versicolor"],
	]

	if any(ismissing, checks)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(checks)
		md"""
		!!! success "Well done!"

			That looks good!
		"""
	elseif all(checks[1:3])
		md"""
		!!! danger "Almost there!"

			It looks like your function isn't handling ties correctly. It should be returning one of the tied species.
		"""
	else
		md"""
		!!! danger "Keep working on it!"

			That's not quite right. You function should be returning the most common species name in a list.
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 884c13fe-9a8c-4dfc-bc2b-92dc25aa7c2e
md"""
Now, we can combine these functions to make a new classifier.
"""

# ╔═╡ bbb8a251-4fd9-48ff-a8ff-90d8e3aabca4
md"""
!!! exercise "👉 Your turn!"
	
	Use your `nearest_neighbors` and `most_common` functions to write a function `classify_by_nearest_neighbors` which takes a datapoint and returns a species, based on the 5 closest matches in the training data.
"""

# ╔═╡ 79d727b1-054a-424d-8004-a5a70ad94707
function classify_by_nearest_neighbors(f1::Number, f2::Number)
	missing # replace this with your code!
end

# ╔═╡ 1eb5b386-1b72-4a76-842a-413a47ddff0e
md"""
Let's try it!
"""

# ╔═╡ 483d1a3e-5ea9-421c-b60c-741cd2715d6c
classify_by_nearest_neighbors(test_data[1,feature_1], test_data[1,feature_2])

# ╔═╡ 11920f81-1af7-4e16-b263-edee26ecc5b3
md"""
Let's see the accuracy of this new function. Is it any better?
"""

# ╔═╡ 8f492983-6f92-4432-9a03-0f5f67986b2b
evaluate(classify_by_nearest_neighbors)

# ╔═╡ d7d67d0a-d2d2-45ff-ae99-f99ed96884c4
md"""
!!! exercise "⭐ Bonus"

	Here is a slider to adjust ``k`` (the number of nearest neighbours we consider). Use the variable `k` in your `classify_by_nearest_neighbors` function and play with the slider.

	Can you find a value of `k` with higher accuracy?
"""

# ╔═╡ f5c31b93-2277-4aa7-b3e3-a8fe99a9e3f4
@bind k PlutoUI.Slider(1:15, default=5, show_value=true)

# ╔═╡ 7507ccf5-7a52-425c-ad3f-e86cbbeb7cb1
md"""
Let's visualise the results!
"""

# ╔═╡ 31bbd32a-8499-4bf4-a52d-b5fa5ab025ae
md"""
## Wrapping up

We've built several models of flower species, each one a little more complex than the last. (You may have noticed that each "improved" model also took longer to run.)

We saw that a model that simply remembers the training data isn't very useful at all: it needs to **generalise** from the training data to handle new cases.

We used a *nearest neighbour* algorithm to make the model more generic, and handle new data that wasn't an exact match for anything in the training data.

A *k nearest neighbour* algorithm is a bit better at making generalisations, because draws a conclusing from several training items instead of just one, but you may have found that it barely improved performance.

In machine learning, we need to strike a balance between precisely remembering the training data, and making generalisations for new data. It can be difficult to know where that balance should be, until we try it out on our data. That is where it's useful to compare different models on a test dataset: that way, we can predict how well each model will perform.

That's it! I hope this notebook has been fun! 🎈
"""

# ╔═╡ 69a85aa1-f5a0-4bd6-8c50-a184c32aa0f9
md"""
### Helper functions

This section contains various functions that are used to make plots and check the answers the exercises.

These helper functions are used in some the answer checks:
"""

# ╔═╡ 7ff8b684-ee36-45f8-953c-a9bdecf83afd
"""
A filtered version of the training data, with all "ambiguous cases" removed.

This removes all rows where there is another row in the training data that has the same measurements on the two selected features, but is of a different species.
"""
train_data_without_ambiguity = filter(train_data) do row
	!any(eachrow(train_data)) do row2
		f1_match = row[feature_1] == row2[feature_1]
		f2_match = row[feature_2] == row2[feature_2]
		species_mismatch = row.Species !== row2.Species
		f1_match && f2_match && species_mismatch
	end
end;

# ╔═╡ 15427a26-9846-4a8f-b925-d52992d4816d
"""
Checks whether the output of a classifier is valid.

Valid output should be an element of the `species` array.
"""
function isvalid(classifier_result::Any)
	if ismissing(classifier_result)
		false
	else
		classifier_result ∈ species
	end
end;

# ╔═╡ a9f11922-ffde-4d10-b0e1-b123ee540133
try
	result = classify_random(example_row[feature_1], example_row[feature_2])

	if ismissing(result)
		md"""
		!!! info "No answer yet"

			Fill in your answer in the `classify_random` function!
		"""
	elseif isvalid(result)
		md"""
		!!! succes "Great!"

			That looks like a valid result! If you're satisfied that the results are random, let's move on.
		"""
	else
		md"""
		!!! danger "Keep at it!"

			Something's not right: your function isn't returning flower names!
		"""
	end
catch e
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 65f2912a-99e1-4b95-be66-2f58bb8fdcce
try
	valid_training_results = map(eachrow(train_data)) do row
		classify_by_memory(row[feature_1], row[feature_2]) |> isvalid
	end
	training_matches = map(eachrow(train_data_without_ambiguity)) do row
		classify_by_memory(row[feature_1], row[feature_2]) == row.Species
	end
	no_match_result = classify_by_memory(100.4, 300.0)

	if any(ismissing, training_matches) || ismissing(no_match_result)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(training_matches) && isvalid(no_match_result)
		md"""
		!!! success "Great!"

			That looks good!
		"""
	elseif all(valid_training_results) && isvalid(no_match_result)
		md"""
		!!! warning "Almost there!"

			The classifier is returning flower names, but it's not matching training data correctly.
		"""
	else
		md"""
		!!! danger "Keep working on it!"

			Those are some unexpected results. The classifier function should return flower names!
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 8c756047-c405-4930-9d6a-16bb436f94ab
try
	new_data = map(1:10) do i
		Random.rand(Float64), Random.rand(Float64)
	end
	results = map(new_data) do (f1, f2)
		nearest_neighbor(f1, f2)
	end
	valid_row(result) = result isa DataFrameRow && result ∈ eachrow(train_data)
	results_valid = map(valid_row, results)
	results_match = map(zip(new_data, results)) do (features, result)
		if ismissing(result)
			return missing
		end
		if !valid_row(result)
			return false
		end
		result_distance = distance(result[feature_1], result[feature_2], features...)
		all(eachrow(train_data)) do row
			distance(row[feature_1], row[feature_2], features...) >= result_distance
		end
	end

	if any(ismissing, results)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(results_valid) && all(results_match)
		md"""
		!!! success "Neat!"

			It looks like your function is working well!
		"""
	elseif all(results_valid)
		md"""
		!!! warning "Keep working on it!"

			It looks like your function is returning valid results, but it's not finding the best possible match!
		"""
	elseif all(r -> r isa DataFrameRow, results)
		md"""
		!!! warning "What's this?"

			It looks like your function is returning DataFrame rows (as it should), but they're not coming from the training data. Did you use the test data by accident?
		"""
	elseif all(isvalid, results)
		md"""
		!!! danger "Unexpected output type"

			It looks like your function is returning flower names. We'll do that in the next step - for now, you should return the closest matching row!
		"""
	else
		md"""
		!!! danger "Unexpected output type"

			Your function returned an output type we did not expect. It should return dataframe rows from the training data!
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ fbe3d721-5c2b-4227-8c55-cda06bf042e7
try
	results = map(eachrow(test_data)) do row
		classify_by_nearest_neighbor(row[feature_1], row[feature_2])
	end
	results_valid = map(isvalid, results)

	if any(ismissing, results)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(results_valid)
		md"""
		!!! success "Great!"

			It looks like your function is working!
		"""
	else
		md"""
		!!! danger "Unexpected output type"

			Your classifier is returning some unexpected results. It should return flower names!
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 03dab6a4-2429-40e1-8fe6-c1509dcf7631
try
	results = map(eachrow(test_data)) do row
		classify_by_nearest_neighbors(row[feature_1], row[feature_2])
	end
	results_valid = map(isvalid, results)

	if any(ismissing, results)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(results_valid)
		md"""
		!!! success "Great!"

			It looks like your function is working!
		"""
	else
		md"""
		!!! danger "Unexpected output type"

			Your classifier is returning some unexpected results. It should return flower names!
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 0e19d6c8-c502-42f7-8bc2-ecc22b43d1b8
"""
Check for functions that should select a row or a set of rows: whether they contain all the columns of the original data.

The result is allowed to contain extra columns.
"""
function has_required_names(df::AbstractDataFrame)
	all(name -> name ∈ names(df), names(data))
end;

# ╔═╡ 3715f7c4-ced0-4452-9fd2-96d47e757b6e
md"""
These functions are used to create plots:
"""

# ╔═╡ 3d0abcb7-a1fb-45ab-b590-8a9d47983589
"""
Create an empty plot with lablled axes.
"""
function base_plot(; kwargs...)::Plots.Plot
	Plots.plot(
		xlabel=feature_1,
		ylabel=feature_2;
		kwargs...
	)
end;

# ╔═╡ 17f6ba0b-bea2-4e1a-a78a-15242a76a8cb
md"""
Here are some more helper functions to get the grid data for predictions:
"""

# ╔═╡ 6ad42e44-fa96-4763-bb80-d80428b6d1fb
grid_pixel_size = 0.1

# ╔═╡ a5427207-380d-4c4c-9ef8-a9b299c82928
"""
Returns a range for a feature.

This is the range in which values may fall, with a small margin. Used to create a grid with predictions for visualisations.
"""
function feature_range(feature::String)::Vector{Float64}
	minimum(data[!,feature]) - 0.1 : grid_pixel_size : maximum(data[!,feature]) + 0.1
end;

# ╔═╡ e2bdcd71-d38d-47c1-9f79-2fe03e632d3b
try
	new_data = map(1:10) do i
		Random.rand(feature_range(feature_1)), Random.rand(feature_range(feature_2))
	end
	results = map(new_data) do (f1, f2)
		nearest_neighbors(f1, f2)
	end
	is_df(result) = result isa DataFrame
	in_train_data(result) = let
		if has_required_names(result)
			all(eachrow(select(result, names(train_data)))) do row
				row ∈ eachrow(train_data)
			end
		else
			false
		end
	end
	valid_subset(result) = is_df(result) && in_train_data(result)
	results_valid = map(valid_subset, results)
	results_match = map(zip(new_data, results)) do (features, result)
		if ismissing(result)
			return missing
		end
		if !is_df(result) || !has_required_names(result)
			return false
		end
		result_distance = maximum(eachrow(result)) do row
			distance(row[feature_1], row[feature_2], features...)
		end
		not_included = antijoin(train_data, result, on=names(train_data))
		all(eachrow(not_included)) do row
			distance(row[feature_1], row[feature_2], features...) >= result_distance
		end
	end

	correct_k = all(1:10) do k
		result = nearest_neighbors(
			Random.rand(feature_range(feature_1)),
			Random.rand(feature_range(feature_2)),
			k=k
		)
		is_df(result) && nrow(result) == k
	end

	if any(ismissing, results)
		md"""
		!!! info "No answer yet"

			Fill in your answer above!
		"""
	elseif all(results_valid) && all(results_match) && correct_k
		md"""
		!!! success "Neat!"

			It looks like your function is working well!
		"""
	elseif all(results_valid) && !correct_k
		md"""
		!!! warning "Incorrect number of results"

			Your function is not using the value of `k` correctly: it should always return ``k`` rows.
		"""
	elseif all(results_valid)
		md"""
		!!! warning "Almost there!"

			It looks like your function is returning valid results, but it's not always finding the best possible matches!
		"""
	elseif any(!is_df, results)
		md"""
		!!! danger "Unexpected output type"

			Your function returned an output type we did not expect. It should return dataframes containing the closest matches.
		"""
	elseif any(!has_required_names, results)
		md"""
		!!! danger "Missing columns"

			It looks like your function is returning DataFrames (as it should), but they don't contain all the columns we expect. The DataFrame should contain the same columns as the training data.
		"""
	else
		md"""
		!!! danger "Unexpected results"

			It looks like your function is returning DataFrames (as it should), but they're not coming from the training data. Did you use the test data by accident?
		"""
	end
catch
	md"""
	!!! danger "Oh no!"

		This block tried to run your function but ran into an error!
	"""
end

# ╔═╡ 3dbe3cd9-3423-4a5b-a1a7-1b331adc9408
"""
Convert the output of a classifier to an integer.

If the output is in `species`, this returns 1, 2, or 3, which coresponds to the index. Any other value is returned as `0`.
"""
function species_index(value)::Int
	# values taken from the data have type CategoricalValue
	# convert to String if possible
	as_string = try
		String(value)
	catch
		""
	end
	
	index = findfirst(isequal(as_string), species)

	if isnothing(index)
		0
	else
		index
	end
end;

# ╔═╡ 26014dd7-ffbb-4b88-b490-346de3d7a83a
"""
Dataframe with all points for the heatmap grid.
"""
grid_points = crossjoin(
	DataFrame(feature_1 => feature_range(feature_1)),
	DataFrame(feature_2 => feature_range(feature_2))
);

# ╔═╡ 584ffe77-acab-4157-88f3-142fa36bc73b
"""
Generate the data for the heatmap layer in visualisations.

Uses a classifier function to return a dataframe containing predictions for every point in the grid.

Includes the column :Prediction with the classifier output, and :PredictionIndex which contains predictions as integers.
"""
function grid_data(classifier::Function)
	predictions(f1_values, f2_values) = classifier.(f1_values, f2_values)
	with_predictions = transform(grid_points,
		[feature_1, feature_2] => predictions => :Prediction
	)
	with_prediction_index = transform(with_predictions,
		:Prediction => (values -> species_index.(values)) => :PredictionIndex
	)
end;

# ╔═╡ 92a2fbb5-6f28-45fd-85e4-c7a74fb24512
md"""
Some definitions for colours:
"""

# ╔═╡ b499c6e8-5710-4de7-be36-9cf7097147c8
"""
Palette used in visualisations.
"""
palette = [
	RGB(0.902, 0.624, 0.0),
    RGB(0.337, 0.706, 0.914),
    RGB(0.0, 0.620, 0.451),
];

# ╔═╡ c177e996-7e1d-467b-905f-ec015ffd9105
"""
Plot observations.

`set` can be `:all`, `:train`, or `:test`, to indicate which subset of the data should be plotted.

When plotting all data or the test data, `hide_test_answer=true` will obscure the species of the test data.
"""
function plot_data!(p::Plots.Plot; set::Symbol=:all, hide_test_answer=false)
	X(dataset) = dataset[!,feature_1]
	Y(dataset) = dataset[!,feature_2]

	labelled_data = if set == :test
		hide_test_answer ? nothing : test_data
	elseif set == :train
		train_data
	else
		hide_test_answer ? train_data : data
	end

	if !isnothing(labelled_data)
		for group in groupby(labelled_data, :Species)
			species = first(group.Species)
			index = (species_index ∘ String)(species)
			color = palette[index]
			Plots.scatter!(p, X(group), Y(group), label=species, color=color)
		end
	end
	
	if set ∈ [:test, :all]  && hide_test_answer
		Plots.scatter!(
			p,
			X(test_data), Y(test_data),
			label="?",
			color=:white,
		)
	end
end;

# ╔═╡ ec2b0a71-184b-41a4-bdaf-2966ead4bb45
let
	p = base_plot(title="Train and test data")
	plot_data!(p, hide_test_answer=true)
	p

	# Plot functions like base_plot and plot_data! are defined at the bottom of the notebook.  This isn't a notebook about how to make plots so we won't go into them, but feel free to check out the code!
end

# ╔═╡ 3eebffc3-2df4-4de6-a66f-9350070623cb
"""
Transparent colour used when no (valid) prediction is made.
"""
transparent = RGBA(1,1,1,0);

# ╔═╡ eafa5557-b895-4271-8b86-18541da98fc1
"""
Returns a colour with alpha set to 0.5
"""
function semitransparent(color)
	RGBA(color.r, color.g, color.b, 0.5)
end;

# ╔═╡ e526d0ad-f146-4fb1-a2fe-22a221a875aa
"""
Returns the gradient for an array of classifications.

Because heatmaps are designed to work with continuous values, the values should be integers.

Returns a gradient of three colours, or four if the data includes 0 values (no valid prediction).
"""
function gradient(values::AbstractArray{Int})
	colors = if any(isequal(0), values)
		[transparent, palette...]
	else
		palette
	end
	Plots.cgrad(semitransparent.(colors), categorical=true)
end;

# ╔═╡ 0dedab2d-dfb2-4253-8ad7-bd51ea0d5eea
"""
Plot the predictions of a classifier.

Uses `Plots.heatmap!` to plot a grid of predictions.
"""
function plot_predictions!(p::Plots.Plot, classifier::Function)
	xs = feature_range(feature_1)
	ys = feature_range(feature_2)
	
	grid = grid_data(classifier)
	z = reshape(grid.PredictionIndex, length(ys), length(xs))

	Plots.heatmap!(p, xs, ys, z,
		color=gradient(z), colorbar=false,
	)
end;

# ╔═╡ c4221b29-c214-4825-983b-6d32430578aa
let
	p = base_plot(title="Baseline classifier with training data")
	plot_predictions!(p, classify_random)
	plot_data!(p, set=:train)
	p
end

# ╔═╡ 3488c3b0-dea1-43de-b035-dc4062eef649
let
	p = base_plot(title="Baseline classifier with test data")
	plot_predictions!(p, classify_random)
	plot_data!(p, set=:test)
	p
end

# ╔═╡ 85ed5063-78f5-4a39-a6ae-6c1af7cc1451
let
	p = base_plot(title="Memory classifier with training data")
	plot_predictions!(p, classify_by_memory)
	plot_data!(p, set=:train)
	p
end

# ╔═╡ b2b4aa84-926a-47de-96aa-d2eff3b76ea1
let
	p = base_plot(title="Memory classifier with test data")
	plot_predictions!(p, classify_by_memory)
	plot_data!(p, set=:test)
	p
end

# ╔═╡ 0a3d197c-637a-4352-ba8b-973103c8e413
let
	p = base_plot(title="Nearest neighbour classifier with training data")
	plot_predictions!(p, classify_by_nearest_neighbor)
	plot_data!(p, set=:train)
	p
end

# ╔═╡ 99de1bf6-c8ce-4a1c-9d30-64e2f19160a7
let
	p = base_plot(title="Nearest neighbour classifier with test data")
	plot_predictions!(p, classify_by_nearest_neighbor)
	plot_data!(p, set=:test)
	p
end

# ╔═╡ 8c3de3ac-c79d-4424-8941-5b26490d9d69
let
	p = base_plot(title="k nearest neighbours classifier with training data")
	plot_predictions!(p, classify_by_nearest_neighbors)
	plot_data!(p, set=:train)
	p
end

# ╔═╡ cbfdf0ba-1fc0-413d-b551-3a11896801d4
let
	p = base_plot(title="k nearest neighbours classifier with test data")
	plot_predictions!(p, classify_by_nearest_neighbors)
	plot_data!(p, set=:test)
	p
end

# ╔═╡ 6367e2d0-5a75-404c-b5d8-124ceaec62da
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
RDatasets = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
Colors = "~0.12.10"
DataFrames = "~1.6.1"
Plots = "~1.40.4"
PlutoUI = "~0.7.59"
RDatasets = "~0.7.7"
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

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"

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

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

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

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Dates", "Test"]
git-tree-sha1 = "e7cbed5032c4c397a6ac23d1493f3289e01231c4"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.14"

[[InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

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
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

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

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "bf17d9cb4f0d2882351dfad030598f64286e5936"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.8"

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

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[RData]]
deps = ["CategoricalArrays", "CodecZlib", "DataFrames", "Dates", "FileIO", "Requires", "TimeZones", "Unicode"]
git-tree-sha1 = "19e47a495dfb7240eb44dc6971d660f7e4244a72"
uuid = "df47a6cb-8c03-5eed-afd8-b6050d6c41da"
version = "0.8.3"

[[RDatasets]]
deps = ["CSV", "CodecZlib", "DataFrames", "FileIO", "Printf", "RData", "Reexport"]
git-tree-sha1 = "2720e6f6afb3e562ccb70a6b62f8f308ff810333"
uuid = "ce6b1742-4840-55fa-b093-852dadbb1d8b"
version = "0.7.7"

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

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "90b4f68892337554d31cdcdbe19e48989f26c7e6"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.3"

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

[[StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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

[[TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Printf", "RecipesBase", "Scratch", "Unicode"]
git-tree-sha1 = "5b347464bdac31eccfdbe1504d9484c31645cafc"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.11.0"

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

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

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
# ╟─1f2d1ed2-58aa-4131-9331-3a3e870d06a6
# ╟─7def21a0-7d83-4b4f-863b-90b9e61c7e13
# ╟─9ea7eab3-f90e-498c-9105-b3d152e0e014
# ╟─4f011391-d962-431b-9d05-8c83c5561cfb
# ╠═db795bce-a590-4f1c-b1d1-d7056b617268
# ╠═6dc49a6e-d96b-4a37-bad9-6d702961b972
# ╠═d2722a2c-9555-412f-8e39-17f28357149b
# ╠═a0dd088a-e6c2-4b4a-8696-1181a0fc91c1
# ╟─811c6d67-c0bc-41b9-a8d0-fb1a63aef616
# ╠═b56c60e5-83ad-4806-a88a-e6051f0e7a77
# ╠═6c9ae100-8b67-4633-939a-1cf8df118fd6
# ╟─9e0d088f-1e31-4ddb-9346-577ecaaa28a2
# ╠═5c788dc0-f0fe-43cf-bf8b-b5c4d9c08e33
# ╟─9bcf05fc-3244-4d71-9ed0-84529ecb0428
# ╠═22a4b918-c4f7-4ffc-9f08-67e330fc1ee2
# ╟─825521a1-b398-4d5c-8a0f-75e356ce271a
# ╟─d0cfa2dd-31ee-4431-b268-5256b97557be
# ╠═36c3077f-b10d-4e9d-aeb4-40902627e0d5
# ╠═03266573-f7c7-4d0e-b6be-1c36f993e8b5
# ╟─ef271385-b5ba-4f89-9375-7bc9c2444f6c
# ╠═c62f4d47-9fa2-46ce-9a74-0b570243cb7d
# ╟─1f8eef1c-b6d4-4af3-b52c-9657092fb7a8
# ╠═3c133b18-45da-40d0-9af5-14166e68d9ca
# ╟─3f48af69-32a1-4387-bda3-aab232938456
# ╟─eef4fb63-ff68-4657-8b70-4b3cac878fc4
# ╟─9e2ac902-1a95-4bc2-a0e7-6098e3af31d1
# ╠═618e9666-82a2-4727-91fd-30e096e7e9e0
# ╟─73dd13d7-61b2-4337-9ebd-15c98c8f368f
# ╠═ec2b0a71-184b-41a4-bdaf-2966ead4bb45
# ╟─966dbb91-e16d-4ba2-a6d0-7155ec6ef619
# ╟─b59a4174-90fe-4e87-9da1-2624301e18cb
# ╟─008af75a-67af-4d56-977a-3fdcb2292954
# ╟─7d4385d7-ad71-4eae-8613-bf83a42b0c82
# ╠═f2546819-8f44-44b0-b10a-a140075100aa
# ╟─9dd7878e-9206-4ce7-9934-3a8e33b8ea57
# ╠═1a92dbbe-de0f-4646-935a-9b9385e84a81
# ╠═ca9c6cca-f2a8-4d8b-94a3-174fe17f6bfe
# ╟─a9f11922-ffde-4d10-b0e1-b123ee540133
# ╟─b42035ee-2721-40d3-a4e7-76fea44581f9
# ╟─3db840b1-64b5-42c2-8b0f-0bc016d6077e
# ╟─f4ed242d-fe2d-41c9-b670-0e59513bcbf5
# ╠═c0263a27-de58-423c-96a1-b27c182eb6db
# ╟─afb924f7-452a-4f6f-84b5-d39cda44f2b4
# ╟─b9895dfa-1ded-4794-875f-79bd4ece8e28
# ╠═08baa655-fe08-4d83-b015-a36b63faf076
# ╟─5e21ecff-70b8-4010-afb1-aa46a8513a02
# ╠═2bf19860-cf72-43eb-805b-3d220617610a
# ╟─684f55cb-740f-4cd6-8aa1-4c24055f9396
# ╟─a95504e7-e5aa-48cd-ab52-802c57da8cb1
# ╠═c4221b29-c214-4825-983b-6d32430578aa
# ╟─398acb44-1fbc-4b6f-bfa4-3e1ecfaf73a9
# ╠═3488c3b0-dea1-43de-b035-dc4062eef649
# ╟─562dad75-8a94-4d31-acac-bb771f75b154
# ╟─92643819-477e-4c41-a63b-686b3a8e25f2
# ╟─76e4ca8f-02b9-4bcd-a60b-bfcb7cc26cd3
# ╟─fdf7e78a-fcc8-4818-a6e7-4bfcec8fd53d
# ╠═0a1c4c26-f838-4b9e-8ee0-16d71f9d238b
# ╟─e7bbe043-b1fe-495f-9252-6613bde68a20
# ╠═8ea763c7-5385-4dfb-89ff-1d95061391b2
# ╟─54e8c76c-6541-4b74-878c-93785e9afd06
# ╟─410f9241-7bd9-4579-9bc2-ba121e68fc47
# ╟─eacb9a6b-b1e4-4d77-b8ea-f49d4e8675c9
# ╟─37527109-c527-4dcb-8261-3f555cf2e394
# ╠═d38875ad-8d47-47bc-8e44-af27552f7dba
# ╟─fc871c1d-2d7c-434b-b52f-2d79b782a5e1
# ╠═ecf201c2-d895-48ec-91be-a4ae7bbe3cd5
# ╟─65f2912a-99e1-4b95-be66-2f58bb8fdcce
# ╟─18af3602-b843-424b-9386-dd3faf1ffa76
# ╠═d01eaba7-7e55-4e5c-b345-6d4ee11cd2bf
# ╟─1dbe3c99-fe1e-4b2f-84a4-0a3d866ade23
# ╠═85ed5063-78f5-4a39-a6ae-6c1af7cc1451
# ╟─551077e9-9120-41a3-9d6f-d4f365108444
# ╠═b2b4aa84-926a-47de-96aa-d2eff3b76ea1
# ╟─dc506ec6-de15-4704-a7c5-2b35d636a299
# ╟─e5c9e9f4-33aa-4594-944d-60f6fffcafe2
# ╟─964cfedf-38c0-4a01-8e47-d63726b449dc
# ╠═0fbb7294-1e9f-4f39-9805-a0205de37bc3
# ╟─821d0997-2806-455d-8f9d-f1d8ae7bdeb1
# ╠═159669e0-25f8-4013-9448-d74dc1a17ff0
# ╟─2d388e16-c993-4f01-a532-735148e65966
# ╟─4f45ead9-74ed-48fe-8470-7989e790b66c
# ╟─4ec487d0-ae21-400c-a47b-c1194ed5daa1
# ╟─786c6b59-a1d1-414f-8004-ba2bfa8b066d
# ╠═5c25ae31-b182-467d-8361-a9d03031ab79
# ╟─fd1770bb-fce1-479a-9e9e-bbd6388d5f27
# ╠═097fbc6c-d085-4652-bb93-930aab57beb1
# ╠═fd7f2edc-c885-4905-ad35-bff780366bac
# ╟─8c756047-c405-4930-9d6a-16bb436f94ab
# ╟─357e3b2f-1b77-458b-a0ba-0dbbb6ce97ee
# ╟─e7531f74-65ba-427c-bb35-5c3b17e20a64
# ╟─6e0936a2-d3c2-42b8-8510-6f9cb6ca8a95
# ╠═16c1f0c9-2d22-4d4f-866a-b119a5b002fd
# ╟─ff228129-8098-4721-bccc-9b2b812ccc35
# ╠═10d027f5-920e-4951-af4f-6ad047fb9ec5
# ╟─fbe3d721-5c2b-4227-8c55-cda06bf042e7
# ╟─d6ef42f6-931a-4019-b594-fd4fbde07967
# ╠═f1c9fefb-47d6-4038-8cc0-a1fc3f90cd68
# ╟─d00b3fc2-6441-4233-94ef-70c380c324c7
# ╠═0a3d197c-637a-4352-ba8b-973103c8e413
# ╠═99de1bf6-c8ce-4a1c-9d30-64e2f19160a7
# ╟─c19a27e0-caff-4e5c-abd7-67da7ba13841
# ╟─6d016e4c-07e2-47ac-a421-69f5d59fc94a
# ╟─f9e87ee2-1b1d-4175-ab25-35f310abf336
# ╠═c9b20e9b-cfad-4391-ac42-1c30061a6f19
# ╟─7cd84b83-5981-4bf6-b01a-f97a1016de3b
# ╠═6a830cc8-2a67-4996-a359-c1adb62d0999
# ╟─e2bdcd71-d38d-47c1-9f79-2fe03e632d3b
# ╟─c71d1f21-8d90-4340-a269-3a018757dd95
# ╟─bc3c6b39-e88a-4f3c-96bf-327c89071ccc
# ╟─4283d5bf-deac-42f0-9389-7768be5200f7
# ╠═b0fb79f0-97ad-4d14-a522-78d5d8843e73
# ╟─04ca45fc-8d9c-4687-bc3d-bc140f8910f4
# ╠═ce354381-57ad-40c0-b4ee-b9e4ec78685e
# ╟─b63c4912-d454-4f4a-bd69-e4312e777b0e
# ╟─884c13fe-9a8c-4dfc-bc2b-92dc25aa7c2e
# ╟─bbb8a251-4fd9-48ff-a8ff-90d8e3aabca4
# ╠═79d727b1-054a-424d-8004-a5a70ad94707
# ╟─1eb5b386-1b72-4a76-842a-413a47ddff0e
# ╠═483d1a3e-5ea9-421c-b60c-741cd2715d6c
# ╟─03dab6a4-2429-40e1-8fe6-c1509dcf7631
# ╟─11920f81-1af7-4e16-b263-edee26ecc5b3
# ╠═8f492983-6f92-4432-9a03-0f5f67986b2b
# ╟─d7d67d0a-d2d2-45ff-ae99-f99ed96884c4
# ╠═f5c31b93-2277-4aa7-b3e3-a8fe99a9e3f4
# ╟─7507ccf5-7a52-425c-ad3f-e86cbbeb7cb1
# ╠═8c3de3ac-c79d-4424-8941-5b26490d9d69
# ╠═cbfdf0ba-1fc0-413d-b551-3a11896801d4
# ╟─31bbd32a-8499-4bf4-a52d-b5fa5ab025ae
# ╟─69a85aa1-f5a0-4bd6-8c50-a184c32aa0f9
# ╠═7ff8b684-ee36-45f8-953c-a9bdecf83afd
# ╠═15427a26-9846-4a8f-b925-d52992d4816d
# ╠═0e19d6c8-c502-42f7-8bc2-ecc22b43d1b8
# ╟─3715f7c4-ced0-4452-9fd2-96d47e757b6e
# ╠═3d0abcb7-a1fb-45ab-b590-8a9d47983589
# ╠═c177e996-7e1d-467b-905f-ec015ffd9105
# ╠═0dedab2d-dfb2-4253-8ad7-bd51ea0d5eea
# ╟─17f6ba0b-bea2-4e1a-a78a-15242a76a8cb
# ╠═a5427207-380d-4c4c-9ef8-a9b299c82928
# ╠═6ad42e44-fa96-4763-bb80-d80428b6d1fb
# ╠═3dbe3cd9-3423-4a5b-a1a7-1b331adc9408
# ╠═26014dd7-ffbb-4b88-b490-346de3d7a83a
# ╠═584ffe77-acab-4157-88f3-142fa36bc73b
# ╟─92a2fbb5-6f28-45fd-85e4-c7a74fb24512
# ╠═37521375-31c9-4e90-be2d-cb9c8421d2c5
# ╠═b499c6e8-5710-4de7-be36-9cf7097147c8
# ╠═3eebffc3-2df4-4de6-a66f-9350070623cb
# ╠═eafa5557-b895-4271-8b86-18541da98fc1
# ╠═e526d0ad-f146-4fb1-a2fe-22a221a875aa
# ╠═6367e2d0-5a75-404c-b5d8-124ceaec62da
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
