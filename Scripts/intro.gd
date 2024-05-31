extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("FadeIn")
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("FadeOut")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://world.tscn")
	pass
