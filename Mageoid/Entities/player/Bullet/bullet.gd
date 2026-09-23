class_name Bullet extends Area2D

@export var speed : int = 1000
@export var damage : int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_bullet_body_entered(_body : Node2D) -> void:
	queue_free()