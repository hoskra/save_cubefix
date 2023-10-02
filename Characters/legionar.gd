extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum LEGIONAR_STATE { PATROL, ATTACK, FLEE, DEAD }
var player = null

var health = 5
var targeted_entity = null
var current_state : LEGIONAR_STATE = LEGIONAR_STATE.PATROL
var move_direction : Vector2 = Vector2.ZERO
var previous_position : Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var attack = $/root/GameLevel/Sounds/attack;
@onready var game_level = get_parent().get_parent()

var is_ready = false

func set_health_bar():
	$HealthBar.value = health

func _ready():
	update_animation_parameters()
	set_health_bar()
	
	state_machine.travel("Walk")
	if randf_range(0, 1) > 0.5:
		move_direction = Vector2(1, 0)
	else:
		move_direction = Vector2(-1, 0)
	is_ready = true	
#
func flip_direction():
	if move_direction.x == -1:
		move_direction = Vector2(1, 0)
	else:
		move_direction = Vector2(-1, 0)
	
func _physics_process(_delta):
	match current_state:
		LEGIONAR_STATE.DEAD:
			$Sprite2D.frame = 0;
			$CollisionShape2D.disabled = true
			return
		LEGIONAR_STATE.PATROL:
			velocity = move_direction * SPEED
			move_and_slide()
			if (previous_position == self.position):
				flip_direction()
			
		LEGIONAR_STATE.ATTACK:
			if Input.is_action_just_pressed("attack"):
				health -= 1
				set_health_bar()
				attack.play()
				if health == 0:
					current_state = LEGIONAR_STATE.DEAD
					await get_tree().create_timer(2).timeout
					queue_free()
			if ((player.position - self.position)[0]) < 0:
				move_direction = Vector2(-1, 0)
			else:
				move_direction = Vector2(1, 0)
				
			velocity = move_direction * SPEED
			move_and_slide()
	
	if current_state != LEGIONAR_STATE.DEAD:
		update_animation_parameters()
	previous_position = self.position

func update_animation_parameters():
	if(move_direction != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_direction)		

func _on_alert_body_entered(body):
	if (body.name == "cuberix" or body.name == "cubelix") and current_state != LEGIONAR_STATE.DEAD:
		print(body.name, " in")
		player = body
		current_state = LEGIONAR_STATE.ATTACK 

func _on_alert_body_exited(body):
	if (body.name == "cuberix" or body.name == "cubelix") and current_state != LEGIONAR_STATE.DEAD:
		print(body.name, " out")
		player = null
		current_state = LEGIONAR_STATE.PATROL
