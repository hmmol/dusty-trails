extends CharacterBody2D

# Player scene ref
@onready var player = get_tree().root.get_node("Main/Player")

# Enemy stats
@export var speed = 50
var direction : Vector2 # current direction
var new_direction = Vector2(0, 1) # next direction

# RNG to generate timer countdown value
var rng = RandomNumberGenerator.new()

# Timer reference to redirect the enemy if collision events occur & timer countdown reaches 0
var timer = 0

func _ready():
	rng.randomize()

# Enemy movement
func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)
	
	# If the enemy collides with other objects, turn them around re-randomize the timer countdown
	if collision != null and collision.get_collider().name != "Player":
		# Direction rotation
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		# Timer countdown random range
		timer = rng.randf_range(2, 5)
	# If they collide with the player
	# trigger the timer's timeout() so that they can chase/move toward
	else:
		timer = 0

func _on_timer_timeout():
	# Calculate the distance of the player relative position to the enemy's
	var player_distance = player.position - position
	# Turn towards player so that it can attack within radius
	if player_distance.length() <= 20:
		new_direction = player_distance.normalize()
	# Chase/move toward player to attack
	elif player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
	# Otherwise, roam randomly
	elif timer == 0:
		# Generate a random direction value
		var random_direction = rng.randf()
		# This direction is obtained by rotating Vector2.DOWN by a random angle
		if random_direction < 0.05:
			# Enemy stops
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			# Enemy moves
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
