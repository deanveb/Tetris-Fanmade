extends Area2D

@export var SPEED : int = 100

func _process(delta):
	position.x += SPEED * delta
