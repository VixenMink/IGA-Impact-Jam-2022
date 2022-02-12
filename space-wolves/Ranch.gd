extends "res://addons/toolbox_project/scenes/level/Level.gd"


onready var pathfinding := $Astar
onready var player_id := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if SignalMngr.connect("game_started", self, "_on_game_started") != OK:
		D.e("Game", ["Signal game_started is already connected"])
	if SignalMngr.connect("restart_level", self, "restart_level") != OK:
		D.e("Game", ["Signal restart_level is already connected"])
	if SignalMngr.connect("next_level", self, "next_level")!= OK:
		D.e("Game", ["Signal next_level is already connected"])
	
	pathfinding.create_navigation_map($AStarGrid)
	Settings.curGameState = Settings.GAME_STATES.PLAY

func _on_game_started():
	pass

func restart_level():
	pass
	
func next_level():
	pass
