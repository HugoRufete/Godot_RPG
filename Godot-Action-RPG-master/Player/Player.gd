extends CharacterBody2D

class_name  Player


@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 120
@export var FRICTION = 500



var enemy_inattackRange = false
var enemy_attack_cooldown = true
var Health = 100

var player_alive = true

var attack_InProgress = false

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var progress_bar = $ProgressBar

func _ready():
	randomize()
	stats.connect("no_health", Callable(self, "queue_free"))
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	progress_bar.value = Health

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	if Health <= 0:
		player_alive = false
		Health = 0
		print("player dead")
		
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		GlobalScript.player_current_attack = true
		attack_InProgress = true
		
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE


func player():
	pass


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattackRange = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattackRange = false
		

func enemy_attack():
	if enemy_inattackRange and enemy_attack_cooldown == true:
		Health = Health - 20
		enemy_attack_cooldown = false
		$Attack_CD.start()
		print(Health)
		progress_bar.value = Health

func _on_attack_cd_timeout():
	enemy_attack_cooldown = true
