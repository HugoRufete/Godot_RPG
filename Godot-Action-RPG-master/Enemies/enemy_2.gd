extends CharacterBody2D


var speed = 50
var player_chase = false
var Player = null

func _physics_process(delta):
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
