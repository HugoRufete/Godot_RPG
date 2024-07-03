extends Area2D




func _on_body_entered(body):# Asegúrate de que solo el jugador cambie la escena
		get_tree().change_scene_to_file("res://win_scene.tscn")
