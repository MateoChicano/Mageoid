extends Node2D

@onready var player : Player = self.get_parent()
@onready var idle_timer : Timer = player.get_node("Timers/idle_timer")
@onready var charge_timer : Timer = player.get_node("Timers/charge_timer")
@onready var heads_up_display : Control = player.get_node("HeadsUpDisplay")

@onready var sprite : Sprite2D = $Sprite2D
@onready var handgun_pos : float = self.position.x
@onready var charge_ball : Node2D = $cannon/charge_ball

const BULLET_SCENE : PackedScene = preload("res://Entities/player/bullets/bullet.tscn")
const CHARGED_BULET_SCENE : PackedScene = preload("res://Entities/player/bullets/charge_bullet.tscn")
const BOMB_SCENE : PackedScene = preload("res://Entities/player/bullets/bomb.tscn")
var missile_scene : PackedScene = load("res://Entities/player/bullets/missile.tscn")


var available_weapons : Array = ["missile"]
var selected_weapon : String
var weapon_index : int = 0

var max_ammo : int = 100
var ammo : int = max_ammo

var is_charging : bool = false

func _ready() -> void:
	self.visible = false
	charge_ball.visible = false
	for weapon in available_weapons :
		heads_up_display.add_weapon(weapon)
	heads_up_display.set_ammo(ammo)
	heads_up_display.set_weapon(available_weapons[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	get_input()

func get_input() -> void :

	var input_direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("attack") :
		if player.get_morph() :
			var bomb_instance = BOMB_SCENE.instantiate()
			bomb_instance.position = player.position
			get_tree().current_scene.add_child(bomb_instance)
		else :
			idle_timer.start()
			charge_timer.start()
			self.visible = true
			if Input.is_action_pressed("weapon_switch") :
				var ammo_consumed : int = 1
				match selected_weapon :
					"super_missile" :
						ammo_consumed = 10

				if ammo >= ammo_consumed :
					ammo-=ammo_consumed
					heads_up_display.set_ammo(ammo)
					shoot(player.get_facing(), "missile")
					return
				else :
					return
			if input_direction :
				shoot(input_direction)
			else :
				shoot(player.get_facing())

	if Input.is_action_pressed("attack") :
		if Input.is_action_pressed("weapon_switch") :
			pass
		else :
			if charge_timer.time_left < 0.5 :
				is_charging = true
				charge_ball.visible = true
				charge_ball.scale = Vector2(1/charge_timer.time_left, 1/charge_timer.time_left)
				if charge_ball.scale > Vector2(10,10):
					charge_ball.scale = Vector2(10,10)
					player.blink()

	if Input.is_action_just_pressed("weapon_select") :
		weapon_index = (weapon_index + 1) % available_weapons.size()
		selected_weapon = available_weapons[weapon_index]
		heads_up_display.set_weapon(selected_weapon)
		missile_scene = set_weapon(selected_weapon)

	if Input.is_action_just_pressed("weapon_switch") :
		self.visible = true
		sprite.modulate = Color.RED

	if Input.is_action_just_released("weapon_switch") :
		idle_timer.start()
		sprite.modulate = Color.WHITE 


	if Input.is_action_just_released("attack") and is_charging:
		is_charging = false
		charge_ball.visible = false

		if charge_timer.is_stopped():
			# Timer finished: held long enough.
			var dir: Vector2 = input_direction if input_direction else player.get_facing()
			shoot(dir, "charge")
		else:
			# Released too soon; cancel the charge.
			charge_timer.stop()

func shoot(dir : Vector2, modifier : String = "") -> void :
	var bullet_instance
	if modifier :
		match modifier :
			"missile" :
				bullet_instance = missile_scene.instantiate()
			"charge" :
				bullet_instance = CHARGED_BULET_SCENE.instantiate()
				bullet_instance.scale = Vector2(2, 2)
	else :
		bullet_instance = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.transform = self.get_node("cannon").global_transform
	bullet_instance.position = self.get_node("cannon").global_position + Vector2(handgun_pos, 0)
	bullet_instance.rotation = dir.angle()

func set_weapon(weapon_name : String) -> PackedScene :
	return load("res://Entities/player/bullets/"+weapon_name+".tscn")