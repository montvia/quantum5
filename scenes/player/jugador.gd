extends CharacterBody2D

@export var speed : int = 200 
var sprint_speed = speed * 2 
var is_sprinting : bool = false 
var animation_walk : float = 1.5 
var animation_sprint = 4 
var last_move : String = "" 
var is_atacking : bool = false 
var last_atack = Vector2()
var game_over : bool = false
var player_position

#var initial_player_position = []

@export var player_health : float = 3.0
@export var enemy_health : float = 3.0
@export var is_human : bool = true #per activar la IA
@onready var ai_controller_2d: Node2D = $AIController2D
@onready var raycast_sensor: RaycastSensor2D = $"RaycastSensor2D"



#recompenses IA

func _on_area_key_1_body_entered(_body):
	position = Vector2(1024.0, 576.0)
	ai_controller_2d.reward += 1.0

func _on_area_door_1_body_entered(_body):
	position = Vector2(1024.0, 576.0)
	if "door_1" in Global.keys_founded:
		ai_controller_2d.reward += 1.0
	else:
		ai_controller_2d.reward -= 1.0




func _on_animated_sprite_2d_animation_finished(): 
	if $AnimatedSprite2D.animation == "atk_" + last_move: 
		is_atacking = false
#		remove_child($area_jugador) 


#func _on_area_enemy_body_entered(body):
func _on_area_2d_2_body_entered(_body):
	if _body.is_in_group("enemy") and not _body.disabled_enemy:
		$Aud_hit.play()
		player_health -= 1
		$AnimationPlayer_hit.play("hit")
		if player_health <= 0:
			Global.random()
			$AnimationPlayer_hit.play("RESET")
			$AnimationPlayer.play("RESET")
			game_over = true
			$AnimatedSprite2D.play("death")
			await $Aud_hit.finished
			$AnimatedSprite2D.play("death")
			#$Aud_gameover.play()
			#await $Aud_gameover.finished
			Global.reset_game = true
			game_over = false
			is_atacking = false
			$AnimatedSprite2D.stop()
			player_health = 3
			position = Vector2(616, 488)
			$AnimatedSprite2D.play("idle_down")
			ai_controller_2d.reset()
			
			#get_tree().reload_current_scene()
		print("el jugador té " + str(player_health) + (" vides" if player_health > 1 else " vida"))
	
func _on_area_jugador_body_entered(_body):
	print(_body.name)
	if _body.is_in_group("enemy"):
		_body.enemy_health -= 1
		ai_controller_2d.reward -= 1.0
		print(_body.enemy_health)

	if _body.is_in_group("tile_map"):
		ai_controller_2d.reward -= 1.0

	
		#var body_name = _body.name
		#if body_name not in Global.enemys:
			#Global.enemys[body_name] = enemy_health - 1
		#else:
			#Global.enemys[body_name] -= 1
		#print(Global.enemys[body_name])

func _ready():
	ai_controller_2d.init(self)
	raycast_sensor.activate()
	$AnimatedSprite2D.play("idle_down")
	last_move = "down"
	$AudioStreamPlayer2D.play()
	#position = initial_player_position
	#game_over_func()
#
#func game_over_func():
	##inicialitza
	#ai_controller_2d.reset()


func _physics_process(delta):
	var movement := Vector2() #moviment 2d
	if game_over == false:
		if ai_controller_2d.heuristic == "human":
			if not is_atacking: 
				#es defineix en quina direcció es el moviment
				if Input.is_action_pressed("right") and Input.is_action_pressed("down"):
					movement.x += 1
					movement.y += 1
					$AnimatedSprite2D.play("down_right")
					last_move = "down_right"
				elif Input.is_action_pressed("left") and Input.is_action_pressed("down"):
					movement.x -= 1
					movement.y += 1
					$AnimatedSprite2D.play("down_left")
					last_move = "down_left"
				elif Input.is_action_pressed("right") and Input.is_action_pressed("up"):
					movement.x += 1
					movement.y -= 1
					$AnimatedSprite2D.play("up_right")
					last_move = "up_right"
				elif Input.is_action_pressed("left") and Input.is_action_pressed("up"):
					movement.x -= 1
					movement.y -= 1
					$AnimatedSprite2D.play("up_left")
					last_move = "up_left"
				elif Input.is_action_pressed("right"):
					movement.x += 1
					$AnimatedSprite2D.play("right")
					last_move = "right"
				elif Input.is_action_pressed("left"):
					movement.x -= 1
					$AnimatedSprite2D.play("left")
					last_move = "left"
				elif Input.is_action_pressed("down"):
					movement.y += 1
					$AnimatedSprite2D.play("down")
					last_move = "down"
				elif Input.is_action_pressed("up"):
					movement.y -= 1
					$AnimatedSprite2D.play("up")
					last_move = "up"
				else: 
					$AnimatedSprite2D.play("idle_" + last_move) #quan no es pren cap boto s'activa l'animació d'aturada
			#activació de la animació d'atac 
			if Input.is_action_just_pressed("atack"):
				is_atacking = true
				$AnimatedSprite2D.play("atk_" + last_move)
				last_atack = "atk_" + last_move
				
				if last_atack == "atk_right":
					$AnimationPlayer.play("atk_right")
				elif last_atack == "atk_left":
					$AnimationPlayer.play("atk_left")
				elif last_atack == "atk_up":
					$AnimationPlayer.play("atk_up")
				elif last_atack == "atk_down":
					$AnimationPlayer.play("atk_down")
				elif last_atack == "atk_up_right":
					$AnimationPlayer.play("atk_up_right")
				elif last_atack == "atk_up_left":
					$AnimationPlayer.play("atk_up_left")
				elif last_atack == "atk_down_right":
					$AnimationPlayer.play("atk_down_right")
				elif last_atack == "atk_down_left":
					$AnimationPlayer.play("atk_down_left")

	#		if is_atacking == true:
	#			atack_area.position = last_atack * 7

				#animacions de corre
			if $AnimatedSprite2D.animation == last_move:
				if Input.is_action_pressed("sprint"):
					is_sprinting = true
					$AnimatedSprite2D.set_speed_scale(animation_sprint)
				else:
					is_sprinting = false
					$AnimatedSprite2D.set_speed_scale(animation_walk)
					
		#if game_over == true and not Global.reset_game:
			#$AnimatedSprite2D.play("death")
	# si is_human=f la IA controla el personatge
		else:
			movement.x = ai_controller_2d.move.x
			movement.y = ai_controller_2d.move.y
			
	if Global.reset_game:
		player_health = 3
		position = Vector2(304, 264)
	#normalitzar els vectors
	if movement.length() > 0:
		movement = movement.normalized() * speed
		if is_sprinting:
			movement *= 2 # velocitat * 2
	
	if player_health == 3:
		$CanvasLayer/animspr_health.play("3_cors")
	elif player_health == 2:
		$CanvasLayer/animspr_health.play("2_cors")
	elif player_health == 1:
		$CanvasLayer/animspr_health.play("1_cor")
	elif player_health <= 0:
		$CanvasLayer/animspr_health.play("0_cors")
	#
	#if Global.reset_game == true:
		#$AnimatedSprite2D.stop("death")
		#player_health = 3
		#position = Vector2(616, 488)
		##position = initial_player_position
	
	
		
	move_and_collide(movement * delta)
	#move_and_slide()
	
