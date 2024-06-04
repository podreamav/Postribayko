extends Node3D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var camera = $world2main/Path3D/PathFollow3D/Camera3D

var is_pathfollowing = true
@onready var pathfollower = $world2main/Path3D/PathFollow3D


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if is_pathfollowing:
		pathfollower.progress_ratio += 0.001
