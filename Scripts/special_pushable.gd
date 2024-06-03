extends CharacterBody3D

var is_being_pushed = false
var push_velocity = Vector3.ZERO
var push_strength = 2.0  
var friction = 0.1  
var initial_position = Vector3.ZERO
var max_distance = 5  
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	is_being_pushed = false
	push_velocity = Vector3.ZERO
	initial_position = global_transform.origin

func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta
	
	if is_being_pushed:
		push_velocity = push_velocity.move_toward(Vector3.ZERO, friction * delta)
		if push_velocity.length() < 0.1:  
			is_being_pushed = false

		velocity += push_velocity * delta

		if (global_transform.origin - initial_position).length() > max_distance:
			stop_pushing()

	move_and_slide()

func apply_push(direction):
	push_velocity = direction * push_strength
	is_being_pushed = true
	initial_position = global_transform.origin

func stop_pushing():
	push_velocity = Vector3.ZERO
	is_being_pushed = false
	velocity.x = 0
	velocity.z = 0

#123
