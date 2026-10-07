class_name Entity extends CharacterBody2D

@export var health : int

const GRAVITY : int = 1500

func take_damage(amt_taken : int) -> void:
    health -= amt_taken
    if health <= 0 :
        die()

func die() -> void:
    self.queue_free()