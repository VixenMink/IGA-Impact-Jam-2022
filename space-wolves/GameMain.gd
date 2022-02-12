extends Node2D

const Level = preload("res://game2/BattleIsland.tscn")
var level

# Called when the node enters the scene tree for the first time.
func _ready():
		# Connect Signals
	if SignalMngr.connect("game_started", self, "_on_game_started") != OK:
		D.e("Game", ["Signal game_started is already connected"])
	if SignalMngr.connect("restart_level", self, "restart_level") != OK:
		D.e("Game", ["Signal restart_level is already connected"])
	if SignalMngr.connect("next_level", self, "next_level")!= OK:
		D.e("Game", ["Signal next_level is already connected"])


func start_level():
	StateMngr.score.state = 0
	if level:
		remove_child(level)
		level.queue_free()
	level = Level.instance()
	add_child(level)
	SignalMngr.emit_signal("level_started", level)


func _on_game_started():
	start_level()
	
func restart_level():
	start_level()

func next_level():
	start_level()
