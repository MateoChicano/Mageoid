class_name  Ennemy extends CharacterBody2D



@export var speed : float= 100.0
@export var knockback : float = 100.0
@export var damage : int = 20
@export var health : int = 5 

@onready var sprite : Sprite2D = $Sprite2D
@onready var pickups : PackedScene = preload("res://Items/item_drop.tscn")
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

func take_damage(amt_taken : int) -> void:
	health -= amt_taken
	if health <= 0 :
		die()

	for i in range(3):
		sprite.modulate.v = 15
		await get_tree().create_timer(0.05).timeout
		sprite.modulate.v = 1
		await get_tree().create_timer(0.05).timeout
	

func die() -> void:
	var pickup_instance = pickups.instantiate()
	pickup_instance.position = self.position
	get_parent().add_child(pickup_instance)
	self.queue_free()
	
func patrol() -> void :
	
	if abs(velocity.x) < 1 :
		speed = -speed
		velocity.x = speed
		
		
