extends Node2D

var door_name : String = "door_1"


func _ready():
	position = Global.size_block * Vector2(Global.key_x, Global.key_y)
	$AnimatedSprite2D.play("default")
	print(self.position)

func spawn():
	position = Global.size_block * Vector2(Global.key_x, Global.key_y)
	Global.random_spwan_key = false
	print(position)

func _on_area_key_body_entered(_body):
	if _body.is_in_group("jugador"):
		Global.keys_founded.append(door_name)
		hide()


func _physics_process(delta):
	if Global.reset_game:
		show()
	if Global.random_spwan_key:
		spawn()
		show()

#func _on_area_2d_2_area_entered(area):
	






