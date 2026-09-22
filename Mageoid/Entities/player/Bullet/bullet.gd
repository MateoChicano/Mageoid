extends Area2D

@export var speed : int = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_bullet_body_entered(body : Node2D) -> void:
	if body.collision_layer == 16:
		body.owner.queue_free()
	queue_free()