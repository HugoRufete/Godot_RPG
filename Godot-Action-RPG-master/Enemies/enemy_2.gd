extends CharacterBody2D


var speed = 150
var player_chase = false
var Player = null

var health = 100
var player_inattack_zone = false

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
	
func enemy():
	pass




func _on_hurt_box_area_entered(area):
	print("asdasd")
