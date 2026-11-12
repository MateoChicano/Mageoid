extends Node2D

@onready var rope : Line2D = $rope
var player : Player = null

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		rope.set_point_position(1, rope.to_local(player.global_position))


func _on_hook_detector_body_entered(body: Node2D) -> void:
	player = body
	rope.set_point_position(1, rope.to_local(body.global_position))


func _on_hook_detector_body_exited(body: Node2D) -> void:
	player = null
	rope.set_point_position(1, Vector2.ZERO)
