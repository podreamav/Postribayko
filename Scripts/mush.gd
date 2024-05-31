extends CharacterBody3D

@onready var player = get_parent().get_parent().get_node("player")

var speed = 17
var health = 1


var dead = false
var player_in_area = false



func _ready():
	dead = false
	
func _physics_process(delta):
	#if player_in_area and !dead:
		#var direction = (player.global_transform.origin - global_transform.origin).normalized()
		#direction.y += push_height
		#player.velocity += direction * push_strength
	if !dead:
		$detection_area/CollisionShape3D.disabled = false
		if player_in_area:
			var direction = (player.position - position).normalized()
			direction.y = 0 # Ignore the Y-axis for horizontal movement
			position += direction / speed
			$mush_giant/AnimationPlayer.play("Run")
			look_at(Vector3(player.position.x, position.y, player.position.z)) # Look at the player on the same Y level
		else:
			stop_movement()
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
	if area.has_method("legs"):
		damage = 1
		take_damage(damage)

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
	
func stop_movement():
	# Implement logic to stop the mush (e.g., setting velocity to zero)
	velocity = Vector3.ZERO


func mush():
	pass
