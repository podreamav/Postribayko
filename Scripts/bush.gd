extends Area3D



func _on_body_entered(body):
	#pass
	if Global.score < 9:
		get_tree().change_scene_to_file("res://Scenes/world_2bad.tscn")
	elif Global.score >= 9:
		get_tree().change_scene_to_file("res://Scenes/world_2good.tscn")
	
