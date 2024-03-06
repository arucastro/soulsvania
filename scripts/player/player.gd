extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = get_node("Texture") 
@onready var wall_ray: RayCast2D = get_node("WallRay")

var direction : int = 1
var jump_count: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var on_wall: bool = false
var not_on_wall: bool = true

var can_track_input: bool = true

@export var speed: int = 0
@export var jump_speed: int = 0
@export var wall_jump_speed: int = 0

@export var player_gravity: int = 1
@export var wall_gravity: int = 1
@export var wall_impulse_speed: int = 1


func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	
	move_and_slide()
	
	player_sprite.animate(velocity)

func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if(can_track_input == false || attacking):
		velocity.x = 0
		return
	velocity.x = input_direction * speed

func vertical_movement_env() -> void:
	var jump_condition: bool = can_track_input && !attacking
	if (is_on_floor() || is_on_wall()):
		jump_count = 0
	if (Input.is_action_just_pressed("ui_select") && jump_count < 2 && jump_condition):
		jump_count += 1;
		if (next_to_wall() && !is_on_floor()):
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed

func actions_env() -> void:
	attack()
	crouch()
	defend()

func attack() -> void:
	var attack_condition: bool = !attacking && !crouching && !defending
	if (Input.is_action_just_pressed("attack") && attack_condition && is_on_floor()):
		attacking = true
		player_sprite.normal_attack = true

func crouch() -> void:
	if (Input.is_action_pressed("crouch") && is_on_floor() && !defending):
		crouching = true
		defending = false
		can_track_input = false
	elif (!defending):
		crouching = false
		can_track_input = true
		player_sprite.crouch_off = true

func defend() -> void:
	if (Input.is_action_pressed("defend") && is_on_floor() && !crouching):
		defending = true
		crouching = false
		can_track_input = false
	elif (!crouching):
		defending = false
		can_track_input = true
		player_sprite.shield_off = true

func gravity(delta: float) -> void:
	if(next_to_wall()):
		velocity.y +=  delta * wall_gravity
		if (velocity.y >= wall_gravity):
			velocity.y = wall_gravity
	else:
		velocity.y += delta * player_gravity
		if (velocity.y >= player_gravity):
			velocity.y = player_gravity

func next_to_wall() -> bool:
	if (wall_ray.is_colliding() && !is_on_floor()):
		if (not_on_wall):
			velocity.y = 0
			not_on_wall = false
		return true
	else:
		not_on_wall = true
		return false
	
