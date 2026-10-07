extends Ennemy

@export var speed : int 

func _ready() -> void:
		self.velocity.x = speed

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		self.velocity.y += self.GRAVITY * delta
	patrol()
	move_and_slide()
	
func patrol() -> void :
	
	if abs(velocity.x) < 1 :
		speed = -speed
		velocity.x = speed
		
		
