extends CharacterBody3D

@onready var camera = $Camera
@onready var armature = $FlowerKnight/Armature
@onready var anim_tree = $AnimationTree


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var health = 6
var dead = false
var push_strength : float = 7
var push_height : float = 0.4
var push_length : float = 5




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _ready():
	dead = false

	$Health/DeadHeart.visible = false
	$Health/DeadHeart2.visible = false
	$Health/DeadHeart3.visible = false
	$Health/HalfHeart.visible = false
	$Health/HalfHeart2.visible = false
	$Health/HalfHeart3.visible = false
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera.rotation.y)
	if direction:
		velocity.x = lerp (velocity.x, direction.x * SPEED, 0.1)
		velocity.z = lerp (velocity.z, direction.z * SPEED, 0.1)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), 0.15)
		
	else:
		velocity.x = lerp (velocity.x, 0.0, 0.25)
		velocity.z = lerp (velocity.z, 0.0, 0.25)

	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

	move_and_slide()
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Vector2(
	#Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	#Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#)
#
## If there is any input
	#if input_dir != Vector2.ZERO:
	## Transform the 2D input direction into 3D
		#var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		#$FlowerKnight/AnimationPlayer.play("Run")
	## Adjust direction based on the camera's orientation
		#if $Camera:
			#direction = ($Camera.transform.basis * direction).normalized()
	#
	## Apply the calculated direction to the velocity
			#velocity.x = direction.x * SPEED
			#velocity.z = direction.z * SPEED
		#else:
	## Smoothly move velocity towards zero when no input
			#velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			#velocity.z = move_toward(velocity.z, 0, SPEED * delta)
	#else: 
		#velocity.x = 0
		#velocity.z = 0
		##$FlowerKnight/AnimationPlayer.stop()
		#$FlowerKnight/AnimationPlayer.play("Idle(Left)")


	#move_and_slide()
	
	# Camera is smoothly moving along player
	$Camera.position = lerp($Camera.position, position, 0.15)

	
func player():
	pass

func _on_hitbox_body_entered(body):
	if body.has_method("mush"):
		var mush = body
		# Calculate direction vector from mush to player
		var direction = (global_transform.origin - mush.global_transform.origin).normalized()

		# Add push in both height and length
		direction.y += push_height
		direction.x += push_length * sign(direction.x)
		direction.z += push_length * sign(direction.z)

		# Apply push to player's velocity
		velocity += direction * push_strength

		var damage = 1
		take_damage(damage)
	
	if body.has_method("apply_push"):
		# Calculate direction vector from player to block
		var direction = (body.global_transform.origin - global_transform.origin).normalized()

		# Add push in both height and length
		direction.y += push_height
		if abs(direction.x) > abs(direction.z):
			direction.x += push_length * sign(direction.x)
		else:
			direction.z += push_length * sign(direction.z)

		# Apply push to block
		body.apply_push(direction)

		
func take_damage(damage):
	health = health - damage
	print (health)

	
	if health == 5:
		$Health/HalfHeart3.visible = true
	elif health == 4:
		$Health/DeadHeart3.visible = true
	elif health == 3:
		$Health/HalfHeart2.visible = true
	elif health == 2:
		$Health/DeadHeart2.visible = true
	elif health == 1:
		$Health/HalfHeart.visible = true
	elif health == 0:
		$Health/DeadHeart.visible = true
	
	if health <= 0 and !dead:
		death()


func death():
	dead = true
	get_tree().change_scene_to_file("res://intro.tscn")
	


		
