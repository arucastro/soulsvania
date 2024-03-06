extends Sprite2D
class_name PlayerTexture

@export var animation: AnimationPlayer
@export var player: CharacterBody2D

var normal_attack: bool = false
var suffix: String = "_right"
var shield_off: bool = false
var crouch_off: bool = false

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if (player.attacking || player.defending || player.crouching || player.next_to_wall()):
		action_behavior()
	elif (direction.y != 0):
		vertical_behavior(direction)
	elif (player.landing == true):
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	print(direction)

func verify_position(direction: Vector2) -> void: 
	if (direction.x > 0):
		flip_h = false
		suffix = "_right"
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.target_position = Vector2(5.5,0)
	elif (direction.x < 0): 
		flip_h = true
		suffix = "_left"
		player.direction = 1
		position = Vector2(-2, 0)
		player.wall_ray.target_position = Vector2(-7.5,0)

func action_behavior() -> void:
	if (player.next_to_wall()):
		animation.play("wall_slide")
	elif (player.attacking && normal_attack):
		animation.play("attack" + suffix)
	elif (player.defending && shield_off):
		animation.play("shield")
		shield_off = false
	elif (player.crouching && crouch_off):
		animation.play("crouch")
		crouch_off = false

func horizontal_behavior(direction: Vector2) -> void:
	animation.play("run") if (direction.x != 0) else animation.play("idle")

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")

func on_animation_finished(anim_name: String):
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
			
		"attack_left":
			player.attacking = false
			normal_attack = false
		
		"attack_right":
			player.attacking = false
			normal_attack = false
		
