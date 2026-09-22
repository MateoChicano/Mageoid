class_name player extends CharacterBody2D

@export var speed : int
@export var jumpforce : int
@export var iFrames : int = 30
@export var health : int = 99
@export var Bullet : PackedScene

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var hurtbox : CollisionShape2D = $hurtbox/CollisionShape2D
@onready var cannon : Node2D = $cannon
@onready var sprite : Sprite2D = $Sprite2D
@onready var cannon_mesh : MeshInstance2D = $cannon_mesh
@onready var cannon_pos : float = cannon.position.x


var direction : Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var coyote_time : float = 0.2
var facing : Vector2 = Vector2.RIGHT

var can_move : bool = true
var can_jump : bool = true

const GRAVITY : int = 1500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if ! self.is_on_floor():
		self.velocity.y += GRAVITY * delta

	cannon_mesh.rotation = (get_global_mouse_position() - cannon.global_position).angle()
	get_input()
	if Input.is_action_pressed("aim") :
		velocity = Vector2.ZERO
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction.x < 0 : 
		facing = Vector2.LEFT
		sprite.flip_h = true
		cannon.position.x = -cannon_pos
	elif input_direction.x > 0 :
		self.facing = Vector2.RIGHT
		sprite.flip_h = false
		cannon.position.x = cannon_pos

	if can_move :
		self.velocity.x = input_direction.x * speed

	if (Input.is_action_pressed("jump")) and can_jump :
		self.velocity.y -= jumpforce
	if Input.is_action_just_pressed("attack") :
		shoot(facing)

	

func hurt_box_entered(_body : Node2D) -> void :
	print("HIT")

func shoot(dir : Vector2) -> void :
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = cannon.global_transform
	if Input.is_action_pressed("aim") :
		dir = (get_global_mouse_position() - cannon.global_position).normalized()
	else :
		bullet.position = cannon.global_position + Vector2(cannon_pos, 0)
	bullet.rotation = dir.angle()
