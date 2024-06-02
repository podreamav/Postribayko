extends CharacterBody3D

@onready var player = get_parent().get_parent().get_node("player")

var speed = 25
var health = 1
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var dead = false
var player_in_area = false
var mush_is_attacking = false

func play_attack():
	$detection_area/CollisionShape3D.disabled = true
	mush_is_attacking = true
	# Play the attack animation and wait for it to finish
	$mush_giant/AnimationPlayer.play("Attack")
	await $mush_giant/AnimationPlayer.animation_finished
	mush_is_attacking = false
	$detection_area/CollisionShape3D.disabled = false

func _ready():
	dead = false

func _physics_process(delta):
	if !dead:
		if mush_is_attacking:
			return  # Skip the rest of the logic if attacking
		
		$detection_area/CollisionShape3D.disabled = false
		move_and_slide()
		
		if not is_on_floor():
			velocity.y -= gravity * delta

		if player_in_area:
			var direction = (player.position - position).normalized()
			direction.y = 0 # Ignore the Y-axis for horizontal movement
			position += direction / speed
			$mush_giant/AnimationPlayer.play("Run")
			look_at(Vector3(player.position.x, position.y, player.position.z))
		else:
			$mush_giant/AnimationPlayer.play("Idle")
	else:
		$detection_area/CollisionShape3D.disabled = true

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

func _on_hitbox_area_entered(area):
	var damage
	#if area.has_method("legs"):
		#damage = 1
		#take_damage(damage)

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

func mush():
	pass
