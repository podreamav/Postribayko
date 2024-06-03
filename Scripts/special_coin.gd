extends Area3D

const ROTATE_SPEED = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(ROTATE_SPEED))
	#self.text = str(coin.score)


func _on_body_entered(body):
	if body.has_method("apply_push"):
		queue_free()
		Global.score += 1
		queue_free()
		print(Global.score)
