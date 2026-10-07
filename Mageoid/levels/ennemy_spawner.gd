extends Timer

const ennemy_scene : PackedScene = preload("res://Entities/ennemy/gamboo.tscn")

func _ready() -> void:
	self.start()

func _on_idle_timer_timeout() -> void:
	var ennemy_instance = ennemy_scene.instantiate()
	ennemy_instance.position = self.get_parent().position
	get_parent().add_child(ennemy_instance)
	self.start()
