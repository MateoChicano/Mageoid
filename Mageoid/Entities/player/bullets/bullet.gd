class_name Bullet extends Node2D

@export var speed : int
@export var damage : int 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_bullet_body_entered(_body : Node2D) -> void:
		self.queue_free()
