### A Pluto.jl notebook ###
# v0.19.36

#> [frontmatter]
#> license_url = "https://opensource.org/license/unlicense/"
#> image = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Travelling_salesman_problem_solved_with_simulated_annealing.gif/640px-Travelling_salesman_problem_solved_with_simulated_annealing.gif"
#> title = "Traveling Salesman Game"
#> tags = ["optimization", "game", "traveling-salesman"]
#> license = "Unlicense"
#> description = "A fun game to learn about the traveling salesman problem and the simulated annealing algorithm."
#> date = "2024-02-16"
#> 
#>     [[frontmatter.author]]
#>     name = "Matt Helm"
#>     url = "https://avatars.githubusercontent.com/u/30706758?v=4"

using Markdown
using InteractiveUtils

# ╔═╡ 5bf31410-c914-11ee-33f0-c5c134d6b4d8
begin
	using Distances
	using HypertextLiteral
	using Random
	using Statistics
end

# ╔═╡ 2ee01ff1-a85f-4ff9-8d25-6af053b2d8aa
md"""
## The Traveling Salesman Game

The Traveling Salesman Problem (TSP) is a classic optimization problem in the fields of computer science and operations research. It involves finding the shortest possible route that visits a set of given cities once, and then returns to the original city. The challenge is to determine the optimal ordering of the cities to minimize the total distance traveled by the salesman.

In this notebook, you get a chance to try to solve the problem while competing against the computer, which solves it using an algorithm known as *Simulated Annealing*, an optimization algorithm inspired by the annealing process in metallurgy. It is used to solve combinatorial optimization problems like the TSP.

#### How to Play

In the cell below, set `N` to the number of cities (or houses in our case) that you would like to start with. These will be generated randomly. Then, in the following cell, set `your_solution` to the path that you believe is the shortest. There is no need to add the starting point to the end of the vector; there is code below that handles that for you. Once you have entered your solution, push the `Go!` button and see if you beat the computer!

To play another round, or to generate new points, re-run the cell that defines `N`.
"""

# ╔═╡ 243063ab-0556-4fcb-950a-f7533a2f88fa
N = 5

# ╔═╡ 2989e7f5-3656-4383-861b-53a1eae26d70
your_solution = [1,2,5,3,4]

# ╔═╡ d25e7bed-3aae-43a1-aa5c-ef44cca55242
begin
	truck_url = "https://raw.githubusercontent.com/mthelm85/travelling-salesman-game/main/assets/truck.png"
	truck2_url = "https://raw.githubusercontent.com/mthelm85/travelling-salesman-game/main/assets/truck2.png"
	house_url = "https://raw.githubusercontent.com/mthelm85/travelling-salesman-game/main/assets/house.png"
	map_url = "https://raw.githubusercontent.com/mthelm85/travelling-salesman-game/dcf8e46f4cc01c7ba27418097eca1bdc7577d3a0/assets/map.png"
end;

# ╔═╡ d9ca9f51-d5dd-4321-bae8-fec16a53d250
begin
	struct Bounds
		x::Int
		y::Int
		width::Int
		height::Int
	end

	struct Point
		x::Int
		y::Int
	end
end

# ╔═╡ c5a0d444-770d-4dc8-8267-963d9f2be545
function random_point(bounds, points)
    x = rand(bounds.x:bounds.x + bounds.width - 1)
    y = rand(bounds.y:bounds.y + bounds.height - 1)
    
    threshold = 20
    for point in points
        if abs(point.x - x) < threshold || abs(point.y - y) < threshold
            return random_point(bounds, points)
        end
    end
    
    return Point(x, y)
end;

# ╔═╡ 739b8137-f6b6-4516-b28d-acdb79828be6
function create_points(b, N)
	points = []
	for i in 1:N
		push!(points, random_point(b, points))
	end
	return points
end;

# ╔═╡ fdfdbb5c-2204-434c-8249-bc9ad3e72531
begin
	get_points_xs(points) = [point.x for point in points]
	get_points_ys(points) = [point.y for point in points]
end;

# ╔═╡ 7c0f26a0-a478-4887-91c8-e5a747b97c19
begin
	function total_distance(points)
	    total_distance = 0.0
	    n = length(points)
	
	    for i in 1:n-1
	        x1, y1 = points[i]
	        x2, y2 = points[i+1]
	        total_distance += evaluate(Euclidean(), [x1,y1], [x2,y2])
	    end
	
	    # Return to starting point
	    x1, y1 = points[end]
	    x2, y2 = points[1]
	    total_distance += evaluate(Euclidean(), [x1,y1], [x2,y2])
	
	    return total_distance
	end

	
	function total_distance(points, tour)
	    total_distance = 0.0
	    n = length(points)
	    for i in 1:n-1
			p1 = points[tour[i]]
			p2 = points[tour[i+1]]
	        total_distance += evaluate(Euclidean(), [p1.x, p1.y], [p2.x, p2.y])
	    end
		p_last = points[tour[end]]
		p_first = points[tour[1]]
	    total_distance += evaluate(Euclidean(), [p_last.x, p_last.y], [p_first.x, p_first.y])  # Return to the starting point
	    return total_distance
	end
end;

# ╔═╡ 39556336-9d1c-417a-b3d7-4e424710902d
function simulated_annealing_tsp(points, max_iter, initial_temperature, cooling_rate)
	n = length(points)
	current_tour = randperm(n)
	best_tour = copy(current_tour)
	current_distance = total_distance(points, current_tour)
	best_distance = current_distance
	temperature = initial_temperature

	for iter in 1:max_iter
		next_tour = copy(current_tour)
		i, j = rand(1:n, 2)
		next_tour[i], next_tour[j] = next_tour[j], next_tour[i]  # Swap two cities
		next_distance = total_distance(points, next_tour)
		delta = next_distance - current_distance

		if delta < 0 || exp(-delta / temperature) > rand()
			current_tour = copy(next_tour)
			current_distance = next_distance
			if current_distance < best_distance
				best_tour = copy(current_tour)
				best_distance = current_distance
			end
		end

		temperature *= cooling_rate
	end

	return best_tour
end;

# ╔═╡ 624c3dc0-2186-4185-9fba-87e522d4a163
begin
	b = Bounds(100, 100, 450, 280)
	points = create_points(b, N)
	points_xs = get_points_xs(points)
	points_ys = get_points_ys(points)
	distances = pairwise(Euclidean(), [points_xs points_ys], dims=1)
	max_iter = 1000
	initial_temperature = mean(distances) + 3 * std(distances)
	cooling_rate = 0.99
	solution_player = vcat(your_solution, your_solution[1])
	player_xs = get_points_xs(points[solution_player])
	player_ys = get_points_ys(points[solution_player])
	solution_computer = simulated_annealing_tsp(points, max_iter, initial_temperature, cooling_rate)
	push!(solution_computer, solution_computer[1])
	computer_xs = get_points_xs(points[solution_computer])
	computer_ys = get_points_ys(points[solution_computer])
	player_distance = total_distance([(z[1], z[2]) for z in zip(player_xs, player_ys)])
	computer_distance = total_distance([(z[1], z[2]) for z in zip(computer_xs, computer_ys)])
end;

# ╔═╡ f3bf1b25-cb37-4594-b92b-fcd3f44429e9
if length(your_solution) == N
	@htl("""
		<script src="https://cdn.jsdelivr.net/npm/phaser@3.55.2/dist/phaser.js"></script>
		<div id="gameContainer"></div>
	
		<script>
			const gameContainer = document.getElementById('gameContainer');
	
			const config = {
				type: Phaser.CANVAS,
				width: 675,
				height: 400,
				parent: gameContainer,
				physics: {
					default: 'arcade',
					arcade: {
						gravity: { x: 0, y: 0 },
						debug: false
					}
				},
				scene: {
					preload: preload,
					create: create,
	        		update: update
				},
				scale: {
					mode: Phaser.Scale.FIT
				}
			};
	
			let bounds;
			let children;
			let computer;
			let defaultScene;
			let finished = false;
			let game;
			let graphics;
			let N = $N;
			let pathComputer;
			let pathPlayer;
			let player;
			let playerFinished = false;
			let points = [];
			let pointsGroup;
			let psComputer;
			let psPlayer;
			let goButton;
			let text1;
			let text2;
			let textTween1;
			let textTween2;
	
			game = new Phaser.Game(config);
		
			function preload () {
				this.load.image('player', $(truck_url));
				this.load.image('computer', $(truck2_url));
				this.load.image('dropoff', $(house_url));
				this.load.image('background', $(map_url));
				defaultScene = this;
			};
		
			function create() {
				this.add.image(config.width / 2, config.height / 2, 'background');
				bounds = new Phaser.Geom.Rectangle($(b.x), $(b.y), $(b.width), $(b.height));
				text1 = defaultScene.add.text(30, 20, 'Player: 0', { font: '16px Courier', fill: '#00ff00' });
				text2 = defaultScene.add.text(30, 40, 'Computer: 0', { font: '16px Courier', fill: '#00ff00' });
			
				textTween1 = defaultScene.tweens.addCounter({
					from: 0,
					to: 0,
					paused: true,
					duration: 10000,
					onComplete: () => {
						playerFinished = true;
					}
				});
	
				textTween2 = defaultScene.tweens.addCounter({
					from: 0,
					to: 0,
					paused: true,
					duration: 10000,
					onComplete: () => {
						finished = false;
					}
				});
			
				pointsGroup = this.physics.add.staticGroup({
					key: 'dropoff',
					frameQuantity: N,
					immovable: true
				});
			
				children = pointsGroup.getChildren();
		
				for (let i = 0; i < N; i++) {
					points.push(new Point($(points_xs)[i], $(points_ys)[i]));
					children[i].setPosition($(points_xs)[i], $(points_ys)[i]);
					let numberText = defaultScene.add.text($(points_xs)[i], $(points_ys)[i] - 20, (i + 1).toString(), { font: '16px Courier', fill: '#ffffff' });
				}
			
				pointsGroup.refresh();
				graphics = this.add.graphics();
				
				let buttonStyle = {
					backgroundColor: '#0f0',
					color: 'black',
					padding: 3,
					fontSize: 18,
				};
	
				goButton = this.add.text(620, 20, 'Go!', buttonStyle)
					.setVisible(true)
					.setInteractive({ useHandCursor: true })
					.on('pointerdown', gameOver);
			};
	
			function Point(x, y) {
				this.x = x;
				this.y = y;
			};
	
			function update() {
				if (finished) {
					textTween1.data[0].end = $(player_distance);
					textTween2.data[0].end = $(computer_distance)
					!playerFinished && textTween1.resume();
					playerFinished && textTween2.resume();
					text1.setText('Player: ' + Math.round(textTween1.getValue()));
					text2.setText('Computer: ' + Math.round(textTween2.getValue()));
				}
			
				N > 17 && location.reload()
			};
	
			function gameOver() {
				if ($player_xs.length > 0) {
					psPlayer = $(player_xs).map((x, i) => new Phaser.Math.Vector2(x, $(player_ys)[i]));
					pathPlayer = new Phaser.Curves.Spline(psPlayer); 
	
					if (player) {
						player.destroy();
					}
	
					player = defaultScene.add.follower(pathPlayer, psPlayer[0].x, psPlayer[0].y, 'player');
	
					psComputer = $(computer_xs).map((x, i) => new Phaser.Math.Vector2(x, $(computer_ys)[i]));
					pathComputer = new Phaser.Curves.Spline(psComputer); 
	
					computer = defaultScene.add.follower(pathComputer, psComputer[0].x, psComputer[0].y, 'computer');
					finished = true;
					player.startFollow({ duration: 10000, rotateToPath: true, ease: false });
					
					setTimeout(() => {
						computer.startFollow({ duration: 10000, rotateToPath: true, ease: false });
					}, 10000);
	
					setTimeout(() => {
						game.destroy(true);
						const messageElement = document.createElement('div');
						let messageText = "Your Distance: $(Int(round(player_distance))) <br> Computer Distance: $(Int(round(computer_distance)))";
						messageElement.style.minWidth = '675px';
						messageElement.style.minHeight = '400px';
						messageElement.innerHTML = messageText;
						gameContainer.innerHTML = '';
						gameContainer.appendChild(messageElement);
						messageElement.style.display = 'flex';
						messageElement.style.justifyContent = 'center';
						messageElement.style.alignItems = 'center';
						messageElement.style.fontSize = '24px';
						messageElement.style.border = '2px solid #333';
						messageElement.style.borderRadius = '5px';
					}, 21000)
				}
			}
	
		</script>
	""")
else
	@htl("""
		<div style="height: 400px; width: 675px; display: flex; justify-content: center; align-items: center; font-size: 24px;">Make sure &nbsp;<pre>length(your_solution) == length(N)</pre></div>
	""")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
Distances = "~0.10.11"
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "1adaeaec1fd57885bb7f86606f24f3c905de5e8d"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

    [deps.Distances.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"
"""

# ╔═╡ Cell order:
# ╟─2ee01ff1-a85f-4ff9-8d25-6af053b2d8aa
# ╠═243063ab-0556-4fcb-950a-f7533a2f88fa
# ╠═2989e7f5-3656-4383-861b-53a1eae26d70
# ╟─f3bf1b25-cb37-4594-b92b-fcd3f44429e9
# ╠═5bf31410-c914-11ee-33f0-c5c134d6b4d8
# ╠═d25e7bed-3aae-43a1-aa5c-ef44cca55242
# ╠═d9ca9f51-d5dd-4321-bae8-fec16a53d250
# ╠═c5a0d444-770d-4dc8-8267-963d9f2be545
# ╠═739b8137-f6b6-4516-b28d-acdb79828be6
# ╠═fdfdbb5c-2204-434c-8249-bc9ad3e72531
# ╠═7c0f26a0-a478-4887-91c8-e5a747b97c19
# ╠═39556336-9d1c-417a-b3d7-4e424710902d
# ╠═624c3dc0-2186-4185-9fba-87e522d4a163
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
