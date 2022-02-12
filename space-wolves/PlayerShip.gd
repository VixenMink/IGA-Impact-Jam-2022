extends KinematicBody2D

signal ShowYourName
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2.ZERO
var curTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func get_input():
	var input = Vector2.ZERO
	
	
	if Input.is_action_pressed('ui_right'):
		input.x += 1
	if Input.is_action_pressed('ui_left'):
		input.x -= 1
	if Input.is_action_pressed('ui_down'):
		input.y += 1
	if Input.is_action_pressed('ui_up'):
		input.y -= 1
	
	return input

func _physics_process(delta):
	var direction = get_input()
	if direction: 
		velocity = lerp(velocity, 128 * direction, .5)
	else:
		velocity = lerp(velocity, Vector2.ZERO, .3)
	velocity = move_and_slide(velocity)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		print(curTarget)


func _on_Area2D_body_entered(body):
	print(body.name)
	body._ShowYourName()
	curTarget = body


func _on_CaptureArea_body_exited(body):
	body._hideYourName()
