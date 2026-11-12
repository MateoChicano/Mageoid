class_name Grapple extends Bullet

var max_distance : int = 100

@onready var rope : Line2D = $rope
@onready var hook : RigidBody2D = $hook

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hook.position = rope.get_point_position(0)
	hook.linear_velocity.x = max_distance * 10

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if hook.position.distance_to(rope.get_point_position(0)) > max_distance :
		hook.linear_velocity.x = 0
	rope.set_point_position(1, hook.position)
	
