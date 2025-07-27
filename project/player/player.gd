extends CharacterBody2D


var _held = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fish_button"):
		_held = true
	elif event.is_action_released("fish_button"):
		_held = false
	
	print(_held)
