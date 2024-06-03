extends CharacterBody3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 0.12

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position.x += speed
	if position.x >= 15:
		speed -= 0.05
	elif position.x <= 0:
		speed += 0.05
	$"saw (3)/AnimationPlayer".play("roll")

func saw():
	pass
