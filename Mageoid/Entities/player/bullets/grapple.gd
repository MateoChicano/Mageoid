class_name Grapple extends Bullet
@export var max_distance : int

@onready var rope : Line2D = $rope
@onready var hook : RigidBody2D = $hook

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hook.linear_velocity.x = max_distance

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rope.set_point_position(1, hook.position)
	
