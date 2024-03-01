extends Sprite2D
class_name PlayerTexture

@export var animation: AnimationPlayer
@export var player: CharacterBody2D

func animate(direction: Vector2) -> void:
	verify_position(direction)
	if (direction.y != 0):
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
	elif (direction.x < 0): 
		flip_h = true

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
