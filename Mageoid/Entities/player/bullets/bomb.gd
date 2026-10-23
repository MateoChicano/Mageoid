extends Bullet

@onready var explode_zone : CollisionShape2D = $Area2D/explode_zone
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var explode_timer : Timer = $explode_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode_zone.disabled = true


func explode() -> void :
	print("boom")
	explode_zone.disabled = false
	animationPlayer.play("explode")

func _on_explode_timer_timeout() -> void:
	explode()


func _on_explode_animation_finished(_anim_name: StringName) -> void:
	queue_free()
