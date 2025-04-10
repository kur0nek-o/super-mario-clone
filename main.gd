extends Node


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/levels/Level1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/levels/Level2.tscn")
