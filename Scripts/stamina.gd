extends ColorRect

# Node refs
@onready var value = $Value

# Update UI
func update_stamina_ui(stamina, max_stamina):
	value.size.x = 98 * stamina / max_stamina
