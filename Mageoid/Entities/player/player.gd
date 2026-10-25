class_name Player extends Entity

@export var speed : int = 300
@export var jumpforce : int = 700

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var handgun : Node2D = $handgun
@onready var body_sprite : Sprite2D = $Sprite2D
@onready var idle_timer: Timer = $Timers/idle_timer
@onready var heads_up_display : Control = $HeadsUpDisplay


var max_health : int = 100
var facing : Vector2 = Vector2.RIGHT

var can_move : bool = true
var can_jump : bool = true
var is_crouched : bool = false
var is_morph : bool = false
var is_charging : bool = false

const knockback_force : int = 100
const invincibility_time : float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heads_up_display.set_health(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if ! self.is_on_floor():
		self.velocity.y += self.GRAVITY * delta

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
		handgun.sprite.flip_v = true

	if Input.is_action_pressed("right") :
		is_crouched = false
		self.facing = Vector2.RIGHT
		body_sprite.flip_h = false
		handgun.sprite.flip_v = false

	if Input.is_action_just_pressed("up") :
		if is_morph :
			is_morph = false
			is_crouched = true
			can_jump = true
		else :
			is_crouched = false
	
	if Input.is_action_pressed("up") :
		
		idle_timer.start()
		handgun.visible = true
		if facing == Vector2.LEFT :
			handgun.sprite.flip_v = true
		else :
			handgun.sprite.flip_v = false
		facing = Vector2.UP
	
	if Input.is_action_just_pressed("down") :
		if is_crouched :
			is_crouched = false
			is_morph = true
			can_jump = false
		else :
			is_crouched = true

	if can_move :
		self.velocity.x = lerp(self.velocity.x, horizontal_input * speed, 0.25)
	
	if (Input.is_action_just_pressed("jump")) and self.is_on_floor() and can_jump:

		self.velocity.y -= jumpforce
		is_crouched = false

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
			handgun.sprite.flip_v = true
			facing = Vector2.LEFT
		else :
			body_sprite.flip_h = false
			handgun.sprite.flip_v = false
			facing = Vector2.RIGHT

	if Input.is_action_just_released("aim"):
		handgun.rotation = facing.angle()
	


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

func _on_idle_timer_timeout() -> void:
	handgun.visible = false
	if body_sprite.flip_h :
		facing = Vector2.LEFT
	else :
		facing = Vector2.RIGHT
	handgun.rotation = facing.angle()
	idle_timer.start()

func blink() -> void :
	body_sprite.modulate.v = 15
	await get_tree().create_timer(0.05).timeout
	body_sprite.modulate.v = 1
	await get_tree().create_timer(0.05).timeout

func get_facing() -> Vector2 :
	return facing

func get_morph() -> bool :
	return is_morph