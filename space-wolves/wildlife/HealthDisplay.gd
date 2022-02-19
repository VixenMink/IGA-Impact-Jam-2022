extends Node2D


var bar_red = preload("res://assets/tests/barHorizontal_red.png")
var bar_green = preload("res://assets/tests/barHorizontal_green.png")
var bar_yellow = preload("res://assets/tests/barHorizontal_yellow.png")

onready var healthbar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() and get_parent().get("MAX_HEALTH"):
		healthbar.max_value = get_parent().MAX_HEALTH


func _process(_delta):
	global_rotation = 0


func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
   
	healthbar.value = value
