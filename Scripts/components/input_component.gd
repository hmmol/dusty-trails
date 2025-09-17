class_name InputComponent
extends Node

# Stores current Horizontal input. -1 for Left, 1 for Right, 0 for no press
var input_horizontal: float = 0
# Stores current Vertical input. -1 for Up, 1 for Down, 0 for no press
var input_vertical: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("ui_left", "ui_right")
	input_vertical = Input.get_axis("ui_up", "ui_down")
