extends Node2D

# Node refs
@onready var spawned_enemies = $SpawnedEnemies
@onready var tilemap = get_tree().root.get_node("Main/Map")

# Enemy stats
@export var max_enemies = 20
var enemy_count = 0
var rng = RandomNumberGenerator.new()

# ---------------------------------- Spawning --------------------------------
func spawn_enemy():
	var enemy = Global.enemy_scene.instantiate()
	spawned_enemies.add_child(enemy)
