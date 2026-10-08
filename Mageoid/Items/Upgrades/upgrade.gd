class_name Upgrade extends Node2D

@export var type : String


func _on_upgrade_area_entered(area: Area2D) -> void:
	var cplayer = area.owner
	match type :
		"health" :
			cplayer.max_health += 100
			cplayer.health += 100
			cplayer.heads_up_display.set_health(cplayer.health)
		"weapon" :
			if not cplayer.available_weapons.has(name) :
				cplayer.available_weapons.append(name)
			else :
				cplayer.max_ammo += 5
				cplayer.ammo += 5
				cplayer.heads_up_display.set_ammo(cplayer.ammo)
	self.queue_free()
