extends Node2D

onready var hp = $HP
onready var debug = $DEBUG

var textToDisplay = ""
var aa = "";
var parentMob

var showHealth = false

# Called when the node enters the scene tree for the first time.
func _ready():
	parentMob = get_parent()
	#if parentMob.name != "Player":
	#	showHealth = true
	#	hp.visible = true


func translate_state(state):
	match state:
		0:
			return "IDLE"
		1:
			return "ATTACK"
		2:
			return "SEEK"
		3: 
			return "CHASE"
		4:
			return "WANDER"
		5:
			return "RETURN"
	#enum STATES {IDLE, ATTACK, SEEK, CHASE, WANDER, RETURN}

func _process(_delta):
	if Settings.ENEMY_DEBUG:
		var targetName = 'NONE'
		if parentMob.target:
			targetName = parentMob.target.name
		if parentMob.state is String:
			debug.text = str(parentMob.state, ':', targetName, ':CS=', bool(parentMob.can_see_target), ':\nAR=', bool(parentMob.target_in_attack_range), ':\nHungry=', bool(parentMob.hungry))
		else:
			debug.text = str(translate_state(parentMob.state), ':', targetName)
	if showHealth:
		hp.text = str(round(parentMob.health))
	
