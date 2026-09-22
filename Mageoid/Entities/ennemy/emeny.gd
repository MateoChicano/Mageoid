class_name  enemy extends CharacterBody2D


@export var speed : float= 100.0
@export var knockback : float = 100.0
const GRAVITY = 1000

func _ready() -> void:
		self.velocity.x = speed

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		self.velocity.y += GRAVITY * delta
	patrol()
	move_and_slide()

func die() -> void:
	self.queue_free()

func hurtbox_entered(area: Area2D) -> void:
	if area.position.y > get_node("hurtbox").position.y :
		if area.collision_layer == 2 :
			die()
	
func patrol() -> void :

	if abs(velocity.x) < 1 :
		speed = -speed
		velocity.x = speed
		
		
