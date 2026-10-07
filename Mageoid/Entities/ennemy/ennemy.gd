class_name Ennemy extends Entity

@export var damage : int

@onready var pickups : PackedScene = preload("res://Items/item_drop.tscn")
@onready var sprite : Sprite2D = $Sprite2D

func drop_pickups() -> void:
	var pickup_instance = pickups.instantiate()
	var pickup_offset = Vector2(randi_range(-10, 10), randi_range(-10, 10))
	pickup_instance.position = self.position + pickup_offset
	get_parent().add_child(pickup_instance)

func _on_hurtbox_entered(body : Area2D) -> void:
	if body.collision_layer == 2:
		take_damage(body.damage)
	for i in range(3):
		sprite.modulate.v = 15
		await get_tree().create_timer(0.05).timeout
		sprite.modulate.v = 1
		await get_tree().create_timer(0.05).timeout

func die() -> void:
	drop_pickups.call_deferred()
	self.queue_free()
