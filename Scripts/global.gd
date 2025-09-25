extends Node

# Scene resources
@onready var pickups_scene = preload("res://Scenes/pickup.tscn")
@onready var enemy_scene = preload("res://Scenes/enemy.tscn")

# 
enum Pickups { AMMO, STAMINA, HEALTH }
