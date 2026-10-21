class_name Player extends Entity

@export var speed : int = 300
@export var jumpforce : int = 700

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var handgun : Node2D = $handgun
@onready var body_sprite : Sprite2D = $Sprite2D
@onready var hand_sprite : Sprite2D = $handgun/Sprite2D
@onready var handgun_pos : float = handgun.position.x
@onready var idle_timer: Timer = $Timers/idle_timer
@onready var charge_timer : Timer = $Timers/charge_timer
@onready var heads_up_display : Control = $HeadsUpDisplay
@onready var charge_ball : Node2D = $handgun/cannon/charge_ball


var max_health : int = 100
var facing : Vector2 = Vector2.RIGHT
var available_weapons : Array = ["missile"]
var selected_weapon : String
var weapon_index : int = 0

var max_ammo : int = 100
var ammo : int = max_ammo

var missile_scene : PackedScene = load("res://Entities/player/bullets/missile.tscn")


var can_move : bool = true
var can_jump : bool = true
var is_crouched : bool = false
var is_morph : bool = false
var is_charging : bool = false

const knockback_force : int = 100
const invincibility_time : float = 2
const BULLET_SCENE : PackedScene = preload("res://Entities/player/bullets/bullet.tscn")
const CHARGED_BULET_SCENE : PackedScene = preload("res://Entities/player/bullets/charge_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charge_ball.visible = false
	handgun.visible = false
	heads_up_display.set_health(health)
	heads_up_display.set_ammo(ammo)
	for weapon in  available_weapons :
		heads_up_display.add_weapon(weapon)
	heads_up_display.set_weapon(available_weapons[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if ! self.is_on_floor():
		self.velocity.y += self.GRAVITY * delta

	can_jump = is_on_floor()
	get_input()
	move_and_slide()

func get_input():
	
	var horizontal_input = Input.get_axis("left", "right")
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction:
		handgun.rotation = input_direction.angle()

	if Input.is_action_pressed("left") : 
		is_crouched = false
		self.facing = Vector2.LEFT
		body_sprite.flip_h = true
		hand_sprite.flip_v = true

	if Input.is_action_pressed("right") :
		is_crouched = false
		self.facing = Vector2.RIGHT
		body_sprite.flip_h = false
		hand_sprite.flip_v = false

	if Input.is_action_pressed("up") :
		if is_morph :
			is_morph = false
			is_crouched = true
		else :
			is_crouched = false
		idle_timer.start()
		handgun.visible = true
		if facing == Vector2.LEFT :
			hand_sprite.flip_v = true
		else :
			hand_sprite.flip_v = false
		facing = Vector2.UP
	
	if Input.is_action_just_pressed("down") :
		if is_crouched :
			is_crouched = false
			is_morph = true
		else :
			is_crouched = true

	if can_move :
		self.velocity.x = lerp(self.velocity.x, horizontal_input * speed, 0.25)
	
	if (Input.is_action_just_pressed("jump")) and can_jump :
		self.velocity.y -= jumpforce
		is_crouched = false

	if Input.is_action_just_pressed("weapon_select") :
		weapon_index = (weapon_index + 1) % available_weapons.size()
		selected_weapon = available_weapons[weapon_index]
		heads_up_display.set_weapon(selected_weapon)
		missile_scene = set_weapon(selected_weapon)

	if Input.is_action_just_pressed("weapon_switch") :
		handgun.visible = true
		hand_sprite.modulate = Color.RED

	if Input.is_action_just_released("weapon_switch") :
		idle_timer.start()
		hand_sprite.modulate = Color.WHITE 


	if Input.is_action_pressed("aim") :
		idle_timer.start()
		handgun.visible = true
		velocity.x /= 3

		if is_on_floor() :
			velocity = Vector2.ZERO
			can_jump = false
		else :
			can_jump = true
		var dir : Vector2  = input_direction.normalized()
		handgun.rotation = dir.angle()

		if dir.x < 0 :
			body_sprite.flip_h = true 
			hand_sprite.flip_v = true
			facing = Vector2.LEFT
		else :
			body_sprite.flip_h = false
			hand_sprite.flip_v = false
			facing = Vector2.RIGHT

	if Input.is_action_just_released("aim"):
		handgun.rotation = facing.angle()
	

	if Input.is_action_just_pressed("attack") :
		idle_timer.start()
		charge_timer.start()
		handgun.visible = true
		if Input.is_action_pressed("weapon_switch") :
			var ammo_consumed : int = 1
			match selected_weapon :
				"super_missile" :
					ammo_consumed = 10

			if ammo >= ammo_consumed :
				ammo-=ammo_consumed
				heads_up_display.set_ammo(ammo)
				shoot(facing, "missile")
				return
			else :
				return
		if input_direction :
			shoot(input_direction)
		else :
			shoot(facing)

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
					blink()

			


	if Input.is_action_just_released("attack") and is_charging:
		is_charging = false
		charge_ball.visible = false

		if charge_timer.is_stopped():
			# Timer finished: held long enough.
			var dir: Vector2 = input_direction if input_direction else facing
			shoot(dir, "charge")
		else:
			# Released too soon; cancel the charge.
			charge_timer.stop()




func hurt_box_entered(body : Node2D) -> void :
	if health - body.damage > 0 :
		var knockback_dir : Vector2 = Vector2(facing.x*-1, -1).normalized()
		velocity.x = knockback_dir.x * 5000
		velocity.y = knockback_dir.y * 500
		take_damage(body.damage)
		heads_up_display.set_health(health)
		for i in range(3):
			await blink()
	else : 
		print("Game over")

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
	owner.add_child(bullet_instance)
	bullet_instance.transform = handgun.get_node("cannon").global_transform
	bullet_instance.position = handgun.get_node("cannon").global_position + Vector2(handgun_pos, 0)
	bullet_instance.rotation = dir.angle()

func _on_idle_timer_timeout() -> void:
	handgun.visible = false
	if facing != Vector2.LEFT or facing != Vector2.RIGHT :
		facing = Vector2.RIGHT
		handgun.rotation = facing.angle()
	idle_timer.start()

func set_weapon(weapon_name : String) -> PackedScene :
	return load("res://Entities/player/bullets/"+weapon_name+".tscn")

func blink() -> void :
	body_sprite.modulate.v = 15
	await get_tree().create_timer(0.05).timeout
	body_sprite.modulate.v = 1
	await get_tree().create_timer(0.05).timeout