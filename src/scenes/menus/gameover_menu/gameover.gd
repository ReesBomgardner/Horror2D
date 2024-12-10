extends Control


func _on_animation_player_animation_finished(_anim_name):
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scenes/menus/main_menu/main_menu.tscn")
	pass # Replace with function body.
