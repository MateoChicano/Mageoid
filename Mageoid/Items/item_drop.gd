extends Node2D

var type : String = "health"
@export var amount_restored : int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pickup_area_entered(area: Area2D) -> void:
	var cplayer = area.owner
	if cplayer.health + amount_restored <= cplayer.max_health:
		cplayer.health += amount_restored
	else:
		cplayer.health = cplayer.max_health
	cplayer.health_label.text = str(cplayer.health)
	self.queue_free()

