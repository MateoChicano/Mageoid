class_name player extends CharacterBody2D

@export var speed : int
@export var jumpforce : int
@export var iFrames : int = 30
@export var health : int = 99
@export var Bullet : PackedScene

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var handgun : Node2D = $handgun
@onready var body_sprite : Sprite2D = $Sprite2D
@onready var hand_sprite : Sprite2D = $handgun/Sprite2D
@onready var handgun_pos : float = handgun.position.x


var direction : Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var coyote_time : float = 0.2
var facing : Vector2 = Vector2.RIGHT

var can_move : bool = true
var can_jump : bool = true

const GRAVITY : int = 1500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handgun.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if ! self.is_on_floor():
		self.velocity.y += GRAVITY * delta

	handgun.rotation = (get_global_mouse_position() - handgun.global_position).angle()
	get_input()
	if Input.is_action_pressed("aim") :
		handgun.visible = true
		velocity.x = Vector2.ZERO.x
		var dir : Vector2  = (get_global_mouse_position() - handgun.global_position).normalized()
		if dir.x < 0 :
			body_sprite.flip_h = true 
			hand_sprite.flip_v = true
			facing = Vector2.LEFT
		else :
			body_sprite.flip_h = false
			hand_sprite.flip_v = false
			facing = Vector2.RIGHT
	else :
		handgun.visible = false
	
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction.x < 0 : 
		facing = Vector2.LEFT
		body_sprite.flip_h = true
		handgun.position.x = -handgun_pos
	elif input_direction.x > 0 :
		self.facing = Vector2.RIGHT
		body_sprite.flip_h = false
		handgun.position.x = handgun_pos

	if can_move :
		self.velocity.x = input_direction.x * speed

	if (Input.is_action_just_pressed("jump")) and can_jump :
		self.velocity.y -= jumpforce
	if Input.is_action_just_pressed("attack") :
		shoot(facing)

	

func hurt_box_entered(_body : Node2D) -> void :
	print("HIT")

func shoot(dir : Vector2) -> void :
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = handgun.global_transform
	if Input.is_action_pressed("aim") :
		dir = (get_global_mouse_position() - handgun.global_position).normalized()
	else :
		bullet.position = handgun.global_position + Vector2(handgun_pos, 0)
	bullet.rotation = dir.angle()
