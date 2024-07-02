extends CharacterBody2D


var speed = 50
var player_chase = false
var Player = null

var health = 100
var player_inattack_zone = false

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (Player.position - position)/speed
		$AnimatedSprite2D.play("Idle_2")
		if(Player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
		else:
				$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle_2")
	

func _on_detection_area_body_entered(body):
	Player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	Player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		
	if body.has_method("espada"):
		health = health - 20

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and GlobalScript.player_current_attack == true:
		health = health - 20
		print("slime health = ", health)
		if health <= 0:
			self.queue_free()
