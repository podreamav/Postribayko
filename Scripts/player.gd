extends CharacterBody3D
@onready var camera = $Camera
@onready var armature = $FlowerKnight/Armature
#@onready var anim_tree = $AnimationTree
@onready var anim_tree = $FlowerKnight/AnimationTree
@onready var jump_sound = $Sounds/Jump
@onready var run_sound = $Sounds/Run
@onready var idle_sound = $Idle
@onready var death_sound = $Death
@onready var leaves_sound = $Leaves




@export var blend_speed = 15

enum { IDLE, RUN, JUMP, DEATH, FALL }
var curAnim = IDLE


var run_val = 0
var jump_val = 0
var death_val = 0
#var att_val = 0
var fall_val = 0


const SPEED = 4.5
const JUMP_VELOCITY = 4.6
var health = 6
var dead = false
var push_strength : float = 2
var push_height : float = 0.4
var push_length : float = 4
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func handle_animations(delta):
	match curAnim:
		IDLE:
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
			#att_val = lerpf(att_val, 0, blend_speed * delta)
			death_val = lerpf(death_val, 0, blend_speed * delta)
			fall_val = lerpf(fall_val, 0, blend_speed * delta)
		RUN:
			run_val = lerpf(run_val, 1, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
			#att_val = lerpf(att_val, 0, blend_speed * delta)
			death_val = lerpf(death_val, 0, blend_speed * delta)
			fall_val = lerpf(fall_val, 0, blend_speed * delta)
		JUMP:
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 1, blend_speed * delta)
			#att_val = lerpf(att_val, 0, blend_speed * delta)
			death_val = lerpf(death_val, 0, blend_speed * delta)
			fall_val = lerpf(fall_val, 0, blend_speed * delta)
		DEATH:
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
			#att_val = lerpf(att_val, 0, blend_speed * delta)
			death_val = lerpf(death_val, 1, blend_speed * delta)
			fall_val = lerpf(fall_val, 0, blend_speed * delta)
		
		
		#ATTACK:
			#run_val = lerpf(run_val, 0, blend_speed * delta)
			#jump_val = lerpf(jump_val, 0, blend_speed * delta)
			#att_val = lerpf(att_val, 1, blend_speed * delta)
			#death_val = lerpf(death_val, 0, blend_speed * delta)
			fall_val = lerpf(fall_val, 0, blend_speed * delta)
		FALL:
			run_val = lerpf(run_val, 0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0, blend_speed * delta)
			#att_val = lerpf(att_val, 0, blend_speed * delta)
			death_val = lerpf(death_val, 0, blend_speed * delta)
			fall_val = lerpf(fall_val, 1, blend_speed * delta)
	update_tree()

func update_tree():
	anim_tree["parameters/Run/blend_amount"] = run_val
	anim_tree["parameters/Jump/blend_amount"] = jump_val
	#anim_tree["parameters/jump-fall/blend_amount"] = jump_val
	anim_tree["parameters/Death/blend_amount"] = death_val
	#anim_tree["parameters/Attack/blend_amount"] = att_val
	anim_tree["parameters/Fall/blend_amount"] = fall_val

func _ready():
	dead = false
	$Health/DeadHeart.visible = false
	$Health/DeadHeart2.visible = false
	$Health/DeadHeart3.visible = false
	$Health/HalfHeart.visible = false
	$Health/HalfHeart2.visible = false
	$Health/HalfHeart3.visible = false
	leaves_sound.play()
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_focus_next"):
		health += 1
		print(health)

func _physics_process(delta):
	handle_animations(delta)
	if !dead:
		$Camera.position = lerp($Camera.position, position, 0.15)

		# Handle movement
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, camera.rotation.y)
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, 0.1)
			velocity.z = lerp(velocity.z, direction.z * SPEED, 0.1)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), 0.15)
			curAnim = RUN
			idle_sound.play()
			#run_sound.play()
			
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.25)
			velocity.z = lerp(velocity.z, 0.0, 0.25)
			curAnim = IDLE
			run_sound.play()
			

		if is_on_floor():
			
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				curAnim = JUMP
				jump_sound.play()
				run_sound.stop()

		else:
			# Apply gravity
			velocity.y -= gravity * delta
			curAnim = FALL

	# Move and slide
	move_and_slide()


	# Camera is smoothly moving along player
func player():
	pass
func _on_hitbox_body_entered(body):
	if body.has_method("mush"):
		var mush = body
		mush.play_attack()


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
		
	if body.has_method("saw"):
		var saw = body


		# Calculate direction vector from mush to player
		var direction = (global_transform.origin - body.global_transform.origin).normalized()

		# Add push in both height and length
		direction.y += push_height * 2
		direction.x += (push_length * sign(direction.x)) * 2
		direction.z += (push_length * sign(direction.z)) * 2
		# Apply push to player's velocity
		velocity += direction * push_strength * 0.5
		var damage = 1
		take_damage(damage)
	
func take_damage(damage):
	health = health - damage
	print (health)
	
	if health == 6:
		$Health/FullHeart3.visible = true
	elif health == 5:
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
		#$FlowerKnight/AnimationPlayer.play("Death")
		#await $FlowerKnight/AnimationPlayer.animation_finished
		death()
func death():
	dead = true
	velocity.x = 0
	velocity.y = 0
	velocity.z = 0
	jump_sound.stop()
	run_sound.stop()
	idle_sound.stop()
	death_sound.play()
	$hitbox/CollisionShape3D.disabled = true
	curAnim=DEATH
	#queue_free()
	#get_tree().change_scene_to_file("res://Scenes/intro.tscn")


func _on_legs_area_entered(area):
		if area.has_method("mush_giant"):
			var mush_giant = area
		# Calculate direction vector from mush to player
			var direction = (global_transform.origin - mush_giant.global_transform.origin).normalized()

		# Add push in both height and length
			direction.y += push_height
			direction.x += (push_length * sign(direction.x) ) /2
			direction.z += (push_length * sign(direction.z) ) /2
			# Apply push to player's velocity
			velocity += (direction * (push_strength * 2) ) * 2
		elif area.has_method("mush"):
			var mush = area
		# Calculate direction vector from mush to player
			var direction = (global_transform.origin - mush.global_transform.origin).normalized()

		# Add push in both height and length
			direction.y += push_height
			direction.x += push_length * sign(direction.x)
			direction.z += push_length * sign(direction.z)
			# Apply push to player's velocity
			velocity += (direction * 0.7) * push_strength 
