extends CharacterBody2D

var speed = 4
var Player = null
var health = 80

var player_chase = false
var player = null

@export var ACCELERATION = 200
@export var MAX_SPEED = 50
@export var FRICTION = 180

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var animated_sprite = $AnimatedSprite2D

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	print(health)

func _physics_process(delta):
	if health <= 0:
		queue_free()
		return

	match state:
		IDLE:
			if not animated_sprite.is_playing() or animated_sprite.animation != "Idle":
				animated_sprite.play("Idle")
			# Implementar lógica de estado IDLE si es necesario
			pass
		WANDER:
			# Implementar lógica de estado WANDER si es necesario
			pass
		CHASE:
			if player_chase and Player:
				if not animated_sprite.is_playing() or animated_sprite.animation != "Chase":
					animated_sprite.play("Walk")
				chase_player(delta)
			else:
				state = IDLE

	# Aplicar fricción
	apply_friction(delta)
	move_and_slide()

func enemy():
	pass

func _on_hurt_box_area_entered(area):
	health -= 20
	print(health)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func chase_player(delta):
	if player_chase:
		var direction = (Player.global_position - global_position).normalized()
		velocity += direction * ACCELERATION * delta
		if velocity.length() > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED

func apply_friction(delta):
	if velocity.length() > 0:
		var friction_effect = FRICTION * delta
		if velocity.length() < friction_effect:
			velocity = Vector2.ZERO
		else:
			velocity -= velocity.normalized() * friction_effect

func _on_player_detection_zone_body_entered(body):
	if body.name == "Player":
		Player = body
		player_chase = true
		state = CHASE

func _on_player_detection_zone_body_exited(body):
	if body.name == "Player":
		Player = null
		player_chase = false
		state = IDLE
