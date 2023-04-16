extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum LEGIONAR_STATE { PATROL, ATTACK, FLEE }

var health = 5
var targeted_entity = null
var current_state : LEGIONAR_STATE = LEGIONAR_STATE.PATROL
var move_direction : Vector2 = Vector2.ZERO
var previous_position : Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters()
	state_machine.travel("Walk")
	if randf_range(0, 1) > 0.5:
		move_direction = Vector2(1, 0)
	else:
		move_direction = Vector2(-1, 0)
#
func flip_direction():
	if move_direction.x == -1:
		move_direction = Vector2(1, 0)
	else:
		move_direction = Vector2(-1, 0)
	
func _physics_process(delta):
	velocity = move_direction * SPEED
	move_and_slide()
	update_animation_parameters()
	if (previous_position == self.position):
		flip_direction()
	previous_position = self.position

func update_animation_parameters():
	if(move_direction != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_direction)
		
