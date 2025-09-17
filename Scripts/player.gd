extends CharacterBody2D

@export_category("Nodes")
# Component for listening to input
@export var input_component: InputComponent

@export_category("Settings")
# Player movement speed
@export var speed = 50

# Node references
@onready var animation_sprite = $AnimatedSprite2D
@onready var health_bar = $UI/HealthBar
@onready var stamina_bar = $UI/StaminaBar

# Direction and animation to be updated throughout the game state
var new_direction = Vector2(0,1) # only move one space
var animation
var is_attacking = false

# UI variables
var health = 100
var max_health = 100
var regen_health = 1
var stamina = 100
var max_stamina = 100
var regen_stamina = 5

# Custom signals
signal health_updated
signal stamina_updated

# ---------------------------------- Movement & Animations ---------------------------------------
func _physics_process(delta):
	# Get player input
	var direction = Vector2(input_component.input_horizontal, input_component.input_vertical)
	
	# Sprinting
	if Input.is_action_pressed("ui_sprint"):
		if stamina >= 25:
			speed = 100
			stamina = stamina - 20 * delta
			stamina_updated.emit(stamina, max_stamina)
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
	
	# Apply movement
	var movement = speed * direction * delta
	if is_attacking == false:
		# Moves the player around, whilst enforcing collisions so that they come to a stop when colliding
		# with other objects
		move_and_collide(movement)
		# Plays animations
		player_animations(direction)
	# If no input is pressed, idle
	if !Input.is_anything_pressed():
		if is_attacking == false:
			animation = "idle_" + returned_direction(new_direction)

func _input(event):
	# Input event for attacking/shooting
	if event.is_action_pressed("ui_attack"):
		# attacking/shooting animation
		is_attacking = true
		var animation = "attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)

# Animations
func player_animations(direction: Vector2):
	# Vector2.ZERO is shorthand for writing Vector2(0,0)
	if direction != Vector2.ZERO:
		# Update direction with new_direction
		new_direction = direction
		# Play walk animation because we are moving
		animation = "walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		# Play idle animation because we are still
		animation = "idle_" + returned_direction(new_direction)
		animation_sprite.play(animation)
		
# Animation direction
func returned_direction(direction: Vector2):
	# Normalize the direction vector
	var normalized_drection = direction.normalized()
	var default_return = "side"
	
	if normalized_drection.y > 0:
		return "down"
	elif normalized_drection.y < 0:
		return "up"
	elif normalized_drection.x > 0:
		# (right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_drection.x < 0:
		# (left)
		$AnimatedSprite2D.flip_h = true
		return "side"
	
	# Default value is empty
	return default_return


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

# ------------------------------------ UI -----------------------------------
func _process(delta):
	# Calculate health
	var updated_health = min(health + regen_health * delta, max_health)
	if updated_health != health:
		health = updated_health
		health_updated.emit(health, max_health)
	# Calcualte stamina
	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina)
	if updated_stamina != stamina:
		stamina = updated_stamina
		stamina_updated.emit(stamina, max_stamina)

func _ready():
	# Connect the signals to the UI components' funcions
	health_updated.connect(health_bar.update_health_ui)
	stamina_updated.connect(stamina_bar.update_stamina_ui)
