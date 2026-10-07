extends Control


func set_health(health : int) -> void:
	$HealthLabel.text = str(health)

func set_ammo(ammo : int) -> void:
	$AmmoLabel.text = str(ammo)

func set_weapon(weapon_name : String) -> void:
	$WeaponLabel.text = weapon_name
