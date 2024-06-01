extends CharacterBody3D

var is_being_pushed = false
var push_velocity = Vector3.ZERO
var push_strength = 2.0  
var friction = 0.1  
var initial_position = Vector3.ZERO
var max_distance = 2.0  

func _ready():

	is_being_pushed = false
	push_velocity = Vector3.ZERO
	initial_position = global_transform.origin

func _physics_process(delta):
	if is_being_pushed:
		var collision = move_and_collide(push_velocity * delta)
		if collision:
			is_being_pushed = false
		else:
			push_velocity = push_velocity.move_toward(Vector3.ZERO, friction * delta)
			if push_velocity.length() < 0.1:  
				is_being_pushed = false
		
		if (global_transform.origin - initial_position).length() > max_distance:
			global_transform.origin = initial_position + (global_transform.origin - initial_position).normalized() * max_distance
			push_velocity = Vector3.ZERO
			is_being_pushed = false

func apply_push(direction):
	push_velocity = direction * push_strength
	is_being_pushed = true
