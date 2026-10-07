class_name Player extends Entity

@export var speed : int = 300
@export var jumpforce : int = 700

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var handgun : Node2D = $handgun
@onready var body_sprite : Sprite2D = $Sprite2D
@onready var hand_sprite : Sprite2D = $handgun/Sprite2D
@onready var handgun_pos : float = handgun.position.x
@onready var idle_timer: Timer = $idle_timer
@onready var health_label : Label = $HeadsUpDisplay/HealthLabel


var max_health : int = 99
var coyote_time : float = 0.2
var facing : Vector2 = Vector2.RIGHT
var ammo : int = 10

var can_move : bool = true
var can_jump : bool = true

const knockback_force : int = 100
const invincibility_time : float = 2
const BULLET_SCENE : PackedScene = preload("res://Entities/player/bullets/bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handgun.visible = false
	health_label.text = str(health)

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
		self.facing = Vector2.LEFT
		body_sprite.flip_h = true
		hand_sprite.flip_v = true

	if Input.is_action_pressed("right") :
		self.facing = Vector2.RIGHT
		body_sprite.flip_h = false
		hand_sprite.flip_v = false

	if can_move :
		self.velocity.x = lerp(self.velocity.x, horizontal_input * speed, 0.25)
	
	if (Input.is_action_just_pressed("jump")) and can_jump :
		self.velocity.y -= jumpforce

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
		var dir : Vector2  = (get_global_mouse_position() - handgun.global_position).normalized()
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

	if Input.is_action_pressed("up") :
		idle_timer.start()
		handgun.visible = true
		if facing == Vector2.LEFT :
			hand_sprite.flip_v = true
		else :
			hand_sprite.flip_v = false
		facing = Vector2.UP


	if Input.is_action_just_pressed("attack") :
		idle_timer.start()
		handgun.visible = true
		if Input.is_action_pressed("weapon_switch") :
			for i in range(ammo) :
				shoot(facing)
		if input_direction != Vector2.ZERO :
			shoot(input_direction)
		else :
			shoot(facing)
	

func hurt_box_entered(body : Node2D) -> void :
	if health - body.damage > 0 :
		var knockback_dir : Vector2 = Vector2(facing.x*-1, -1).normalized()
		velocity.x = knockback_dir.x * 2000
		velocity.y = knockback_dir.y * 700
		take_damage(body.damage)
		health_label.text = str(health)
		for i in range(3):
			body_sprite.modulate.v = 15
			await get_tree().create_timer(0.05).timeout
			body_sprite.modulate.v = 1
			await get_tree().create_timer(0.05).timeout
	else : 
		print("Game over")

func shoot(dir : Vector2) -> void :
	var bullet_instance = BULLET_SCENE.instantiate()
	owner.add_child(bullet_instance)
	bullet_instance.transform = handgun.get_node("cannon").global_transform
	if Input.is_action_pressed("aim") :
		dir = (get_global_mouse_position() - handgun.global_position).normalized()
	else :
		bullet_instance.position = handgun.get_node("cannon").global_position + Vector2(handgun_pos, 0)
	bullet_instance.rotation = dir.angle()


func _on_idle_timer_timeout() -> void:
	handgun.visible = false
	if facing != Vector2.LEFT or facing != Vector2.RIGHT :
		facing = Vector2.RIGHT
		handgun.rotation = facing.angle()
	idle_timer.start()
