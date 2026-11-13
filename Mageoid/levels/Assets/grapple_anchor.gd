extends Node2D

@onready var rope: Line2D = $rope
@onready var anchor: Marker2D = $Anchor
@onready var grapple_length : float = $hook_detector/CollisionShape2D.shape.radius

var player: Player = null

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		rope.set_point_position(1, rope.to_local(player.global_position))

func _on_hook_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player.grapple_point = self
		rope.set_point_position(1, rope.to_local(player.global_position))

func _on_hook_detector_body_exited(body: Node2D) -> void:
	if body != player:
		return
	else :
		player.grapple_point = null
		player = null
		rope.set_point_position(1, Vector2.ZERO)
