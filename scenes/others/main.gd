extends Node2D

#var key_to_spawn = preload("res://scenes/key/key_1.tscn")
#var spawn_key = key_to_spawn.instantiate()


		#spawn_key.door_name = "door_1"

func _ready():
	#spawn()
	$jugador/ColorRect/Label/countdown.start()
	#
#func spawn():
		##$key_1.show()
		##$key_1.position += Global.size_block * Vector2(Global.key_x, Global.key_y)
		##var spawn_key = key_to_spawn.instantiate()
		##spawn_key.position += Global.size_block * Vector2(Global.key_x, Global.key_y)
		##spawn_key.door_name = "door_1"
		##add_child(spawn_key)
		##spawn_key.show() 
		##Global.random_spwan_key = false
		##print($key_1.position)
		#pass
##func _physics_process(delta):
##	if Global.random_spwan_key:
	##	spawn()


