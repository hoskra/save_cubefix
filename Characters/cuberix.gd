extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var game_level = get_owner()

func getSpeed():
	if(game_level.potionActive):
		return SPEED + 600
	else:
		return SPEED
		
func _ready():
	update_animation_parameters(Vector2(0,0))

func _physics_process(delta):
	if(game_level.selected_player == 1):
		handle_movement(delta)
		move_and_slide()
		pick_new_state()

func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * getSpeed()
	else:
		velocity.x = move_toward(velocity.x, 0, getSpeed())
		
	update_animation_parameters(Vector2(direction, 0))

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
