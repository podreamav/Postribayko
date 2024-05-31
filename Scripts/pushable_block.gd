extends CharacterBody3D

var is_being_pushed = false
var push_velocity = Vector3.ZERO
var push_strength = 2.0  # Зменшено силу поштовху
var friction = 0.1  # Сила тертя для зменшення швидкості з часом
var initial_position = Vector3.ZERO
var max_distance = 2.0  # Максимальна відстань переміщення

func _ready():
	# Установка початкових значень
	is_being_pushed = false
	push_velocity = Vector3.ZERO
	initial_position = global_transform.origin

func _physics_process(delta):
	if is_being_pushed:
		# Переміщення блоку
		var collision = move_and_collide(push_velocity * delta)
		# Якщо є зіткнення, зупинити рух
		if collision:
			is_being_pushed = false
		else:
			# Зменшення сили поштовху з часом
			push_velocity = push_velocity.move_toward(Vector3.ZERO, friction * delta)
			# Якщо швидкість майже нульова, зупинити рух
			if push_velocity.length() < 0.1:  # Коригування порогу швидкості
				is_being_pushed = false
		
		# Перевірка, чи перевищує переміщення допустиму відстань
		if (global_transform.origin - initial_position).length() > max_distance:
			global_transform.origin = initial_position + (global_transform.origin - initial_position).normalized() * max_distance
			push_velocity = Vector3.ZERO
			is_being_pushed = false

func apply_push(direction):
	push_velocity = direction * push_strength
	is_being_pushed = true
