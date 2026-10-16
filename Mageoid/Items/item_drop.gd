extends Node2D

@export var type : String
var types : Array = ["health", "ammo"]

func _ready() -> void:
	self.type = types[randi() % types.size()]
	match type :
		"health" :
			$MeshInstance2D.modulate = Color.GREEN
		"ammo" :
			$MeshInstance2D.modulate = Color.RED
			
func _on_pickup_area_entered(area: Area2D) -> void:
	var cplayer = area.owner
	var amount_restored : int = 0
	match type :
		"health" :
			amount_restored = 20
			cplayer.max_health += amount_restored
			if cplayer.health + amount_restored > cplayer.max_health :
				cplayer.health = cplayer.max_health
			cplayer.heads_up_display.set_health(cplayer.health)
		"ammo" :
			amount_restored = 5
			cplayer.ammo += 5
			if cplayer.ammo > cplayer.max_ammo :
				cplayer.ammo = cplayer.max_ammo
			cplayer.heads_up_display.set_ammo(cplayer.ammo)
	self.queue_free()
