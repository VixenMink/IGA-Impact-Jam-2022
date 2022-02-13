extends KinematicBody2D

onready var camera = $Camera2D


# camera zoom
export (float) var pan_speed = 10.0
export (float) var speed = 25.0
export (float) var zoom_speed = 25.0
export (float) var zoom_margin = 0.1

export (float) var zoom_min = 0.5
export (float) var zoom_max = 2.5

var zoom_pos = Vector2()
var zoom_factor = 1.0
var zooming = false


# Player varibles
var velocity := Vector2.ZERO
var curTarget


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	camera.zoom.x = lerp (camera.zoom.x, camera.zoom.x * zoom_factor, zoom_speed * delta)
	camera.zoom.y = lerp (camera.zoom.y, camera.zoom.y * zoom_factor, zoom_speed * delta)
	
	camera.zoom.x = clamp(camera.zoom.x, zoom_min, zoom_max)
	camera.zoom.y = clamp(camera.zoom.y, zoom_min, zoom_max)
	
	if not zooming:
		zoom_factor = 1.0

func get_input():
	var input = Vector2.ZERO
	
	if Input.is_action_pressed('game_right'):
		input.x += 1
	if Input.is_action_pressed("game_left"):
		input.x -= 1
	if Input.is_action_pressed('game_down'):
		input.y += 1
	if Input.is_action_pressed('game_up'):
		input.y -= 1
	
	return input


func _physics_process(_delta):
	var direction = get_input()
	if direction: 
		velocity = lerp(velocity, 128 * direction, .5)
		$Sprite.rotation = lerp($Sprite.rotation, velocity.angle() + deg2rad(90), 0.1)
		$Sprite/Particles2D.emitting = true
	else:
		velocity = lerp(velocity, Vector2.ZERO, .3)
		$Sprite.rotation = lerp($Sprite.rotation, velocity.angle() + deg2rad(90), 0.1)
		$Sprite/Particles2D.emitting = false
	velocity = move_and_slide(velocity)


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print(curTarget)
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_factor -= 0.01 * zoom_speed
				zoom_pos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_factor += 0.01 * zoom_speed
				zoom_pos = get_global_mouse_position()
		else: 
			zooming = false
  

func _on_Area2D_body_entered(body):
	body._ShowYourName()
	Settings.curTarget = body
	curTarget = body


func _on_CaptureArea_body_exited(body):
	body._hideYourName()


