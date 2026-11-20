class_name Upgrade extends Node2D

enum UpgradeType {
	HEALTH,
	WEAPON,
	BULLET,
}

@export var type : UpgradeType


func _on_upgrade_area_entered(area: Area2D) -> void:
	var cplayer = area.owner
	match type :
		UpgradeType.HEALTH :
			cplayer.max_health += 100
			cplayer.health += 100
			cplayer.heads_up_display.set_health(cplayer.health)
		UpgradeType.WEAPON :
			var chandgun = cplayer.get_node("handgun")
			var weapon_name : String = name.capitalize()
			if not chandgun.available_weapons.has(weapon_name) :
				chandgun.available_weapons.append(weapon_name)
				cplayer.heads_up_display.add_weapon(weapon_name)
			else :
				chandgun.max_ammo += 5
				chandgun.ammo += 5
				cplayer.heads_up_display.set_ammo(chandgun.ammo)
		UpgradeType.BULLET :
			var chandgun = cplayer.get_node("handgun")
			chandgun.set_bullet(name)


	self.queue_free()
