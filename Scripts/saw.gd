extends CharacterBody3D

func _physics_process(delta):
	$saw/AnimationPlayer.play("roll")
