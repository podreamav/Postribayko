extends Node3D

@export var sensitivity = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseMotion:
		var xRot = clamp(rotation.x - event.relative.y / 1000 * sensitivity, -0.5, 0.5)
		var yRot = (rotation.y - event.relative.x / 1000 * sensitivity)
		rotation = Vector3(xRot, yRot, 0)
	
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if get_node("Camera_Target").spring_length < 5:
					get_node("Camera_Target").spring_length += 0.2
					

			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if get_node("Camera_Target").spring_length > 2:
					get_node("Camera_Target").spring_length -= 0.2
					

	
