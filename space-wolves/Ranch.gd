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
	
	connect_children()
	
	Settings.curGameState = Settings.GAME_STATES.PLAY


func _on_game_started():
	pass

func restart_level():
	pass
	
func next_level():
	pass

func connect_children():
	$HUD.connect('spawnPredator', $SpawnControl , '_on_spawnPredator')
	$HUD.connect('spawnPrey', $SpawnControl , '_on_spawnPrey')
	$HUD.connect('spawnResource', $SpawnControl , '_on_spawnResource')
	$SpawnControl.connect("predSpawnComplete", $HUD, '_on_predSpawnComplete')
	$SpawnControl.connect('preySpawnComplete', $HUD, '_on_preySpawnComplete')
	$SpawnControl.connect("resourceSpawnComplete", $HUD, '_on_resourceSpawnComplete')
	
	var creatureArray = get_tree().get_nodes_in_group('wildlife')
	for creature in creatureArray:
		$HUD.connect('killMob', creature, '_on_killMob')
		creature.connect('ShotThroughTheHart', $HUD, '_on_ShotThroughTheHart')


func _on_TickTimer_timeout():
	var wildlifeArray = get_tree().get_nodes_in_group('wildlife')
	for wildlife in  wildlifeArray:
		if wildlife.is_in_group('Resource'):
			continue
		
		wildlife._take_hunger_damage()

