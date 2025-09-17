extends ColorRect

# Node refs
@onready var value = $Value

# Update UI
func update_health_ui(health, max_health):
	value.size.x = 98 * health / max_health
