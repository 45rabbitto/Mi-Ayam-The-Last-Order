extends Node3D
class_name InteractableDoor

var is_open := false
@export var open_angle := 90.0
@export var speed := 5.0

func interact(player):
	is_open = !is_open

	if is_open:
		PhoneNotif.push("Pintu terbuka... berderit pelan 🚪")
	else:
		PhoneNotif.push("Pintu tertutup kembali")

func _process(delta):
	var target = Vector3(0, open_angle if is_open else 0, 0)
	rotation_degrees = rotation_degrees.lerp(target, speed * delta)

func get_prompt():
	return "Open Door" if !is_open else "Close Door"
