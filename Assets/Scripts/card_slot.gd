extends MarginContainer

var is_player: bool = true
var is_empty: bool = true

func _on_gui_input(event: InputEvent) -> void:
	handle_mouse_release(event)
	
func handle_mouse_release(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
