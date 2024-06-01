extends CharacterBody3D

@onready var player = get_parent().get_parent().get_node("player")

var speed = 25
var health = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var dead = false
var player_in_area = false
var mush_is_attacking = false

func play_attack():
	mush_is_attacking = true
	await get_tree().create_timer(1.4583).timeout
	
	mush_is_attacking = false
	#print("hello from attack func")
	#$mush_giant/AnimationPlayer.play("Attack")

func _ready():
	dead = false
	
func _physics_process(delta):
	#if player_in_area and !dead:
		#var direction = (player.global_transform.origin - global_transform.origin).normalized()
		#direction.y += push_height
		#player.velocity += direction * push_strength
	if !dead:
		$detection_area/CollisionShape3D.disabled = false
		move_and_slide()
		velocity.y -= gravity * delta
		
		if not is_on_floor():
			velocity.y -= gravity * delta
			
		#else:
			#velocity.y = 0
		if player_in_area:
			var direction = (player.position - position).normalized()
			direction.y = 0 # Ignore the Y-axis for horizontal movement
			position += direction / speed
			#$mush_giant/AnimationPlayer.play("Run")
			look_at(Vector3(player.position.x, position.y, player.position.z))
		elif mush_is_attacking:
			$mush_giant/AnimationPlayer.play("Attack")
		else:
			#stop_movement()
			$mush_giant/AnimationPlayer.play("Idle")
	else:
		$detection_area.disabled = true

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body
		
		

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_hitbox_area_entered(area):
	var damage
	#if area.has_method("mush1"):
		#damage = 1
		#take_damage(damage)
		

#func attack_anim(body):
	#if body.has_method("mush"):
		#attacking = true
		#if attacking == true:
			#$mush_giant/AnimationPlayer.play("Attack")

func take_damage(damage):
	health = health - damage
	if health <= 0 and !dead:
		death()
	
func death():
	dead = true
	$hitbox/CollisionShape3D.disabled = true
	$CollisionShape3D.call_deferred("set", "disabled", true)
	$mush_giant/AnimationPlayer.play("death")
	await $mush_giant/AnimationPlayer.animation_finished
	queue_free()
	
#func stop_movement():
	## Implement logic to stop the mush
	#velocity = Vector3.ZERO
	#move_and_slide()


func mush():
	pass
