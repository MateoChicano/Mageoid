class_name  enemy extends CharacterBody2D


@export var speed : float= 100.0
@export var knockback : float = 100.0
@export var health : int = 5 
const GRAVITY = 1000

func _ready() -> void:
		self.velocity.x = speed

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		self.velocity.y += GRAVITY * delta
	patrol()
	move_and_slide()

func _on_hurtbox_entered(body : Area2D) -> void:
	if body.collision_layer == 2:
		take_damage(body.damage)

func take_damage(damage : int) -> void:
	health -= damage
	if health <= 0 :
		die()

func die() -> void:
	self.queue_free()
	
func patrol() -> void :

	if abs(velocity.x) < 1 :
		speed = -speed
		velocity.x = speed
		
		
