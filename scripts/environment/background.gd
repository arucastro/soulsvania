extends ParallaxBackground
class_name Background

@export var can_process: bool
@export var layer_speed: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!can_process):
		set_physics_process(false)

func _physics_process(delta):
	for index in get_child_count():
		if get_child(index) is ParallaxLayer:
			get_child(index).motion_offset.x -= delta * layer_speed[index]
