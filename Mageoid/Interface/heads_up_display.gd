extends Control

@onready var weapon_container : Array = $WeaponContainer.get_children()

func set_health(health : int) -> void:
	$HealthLabel.text = str(health)

func set_ammo(ammo : int) -> void:
	$AmmoLabel.text = str(ammo)

func set_weapon(weapon_name : String) -> void:
	for weapon in weapon_container :
		if weapon.text == weapon_name :
			weapon.modulate = Color.GREEN
		else :
			weapon.modulate = Color.WHITE


func add_weapon(weapon_name : String) -> void :
	var weapon_label : Label = Label.new()
	weapon_label.text = weapon_name
	$WeaponContainer.add_child(weapon_label)
	weapon_container.append(weapon_label)
