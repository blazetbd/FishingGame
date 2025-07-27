extends CharacterBody2D


@export var fishing_bob: PackedScene
@export var min_windup_time: float = .1
@export var max_windup_time:float = 2.0
@export var min_force: float = 100.0
@export var max_force: float = 500.0


var _held := false
var held_start_time: float = 0.0
var fishing := false
var curr_bob: RigidBody2D
var fishing_cd := 10


@onready var line_2d: Line2D = $Line2D
@onready var timer: Timer = $Timer


func _input(event: InputEvent) -> void:
	if event.is_action_released("fish_button"):
		if _held and !fishing:
			start_fishing()

func _physics_process(_delta: float) -> void:
	if line_2d and curr_bob:
		line_2d.position = Vector2.ZERO
		line_2d.points = [
			Vector2.ZERO,                        
			curr_bob.global_position - global_position 
		]
	
	if Input.is_action_just_pressed("fish_button"):
		if !fishing:
			_held = true
			held_start_time = Time.get_ticks_msec() / 1000.0
		else:
			curr_bob.queue_free()
			reset_line()
			fishing_cd = 10
			fishing = false
	elif Input.is_action_just_released("fish_button"):
		if _held and !fishing:
			fishing = true
			_held = false
			var held_duration = (Time.get_ticks_msec() / 1000.0) - held_start_time
			launch_bob(held_duration)


func start_fishing() -> void:
	timer.start(1)


func launch_bob(duration: float) -> void:
	var clamped_duration = clamp(duration, min_windup_time, max_windup_time)
	var launch_force = lerp(min_force, max_force, (clamped_duration - min_windup_time) / (max_windup_time - min_windup_time))
	
	var new_object = fishing_bob.instantiate()
	
	var angle_offset = -PI / 4
	var launch_direction = Vector2(1, 0).rotated(rotation + angle_offset).normalized()
	
	var spawn_offset = launch_direction * 20
	new_object.global_position = global_position + spawn_offset
	curr_bob = new_object
	
	get_parent().add_child(new_object)
	
	if new_object is RigidBody2D:
		new_object.apply_central_impulse(launch_direction * launch_force)


func reset_line():
	line_2d.points = [
			Vector2.ZERO,                        
			Vector2.ZERO
		]


func _on_timer_timeout() -> void:
	fishing_cd -= 1
	print(fishing_cd)
	
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(1,10)
	
	if random_number == 1 or fishing_cd <= 0:
		timer.stop()
		print("Fish!")
