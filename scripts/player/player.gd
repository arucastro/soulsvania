extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture") 

var jump_count: int = 0
var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var can_track_input: bool = true

@export var speed: int = 0
@export var jump_speed: int = 0
@export var player_gravity: int = 1


func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	
	move_and_slide()
	
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	if (is_on_floor()):
		jump_count = 0
	if (Input.is_action_just_pressed("ui_select") && jump_count < 2):
		jump_count += 1;
		velocity.y = jump_speed

func actions_env() -> void:
	attack()
	crouch()
	defend()

func attack() -> void:
	var attack_condition: bool = !attacking && !crouching && !defending
	if (Input.is_action_just_pressed("attack") && attack_condition && is_on_floor()):
		attacking = true

func crouch() -> void:
	if (Input.is_action_pressed("crouch") && is_on_floor() && !defending):
		crouching = true
		defending = false
		can_track_input = false
	elif (!defending):
		crouching = false
		can_track_input = true

func defend() -> void:
	if (Input.is_action_pressed("defend") && is_on_floor() && !crouching):
		defending = false
		can_track_input = false
	elif (!crouching):
		defending = false
		can_track_input = true

func gravity(delta: float) -> void:
	velocity.y += delta * player_gravity
	if (velocity.y >= player_gravity):
		velocity.y = player_gravity
