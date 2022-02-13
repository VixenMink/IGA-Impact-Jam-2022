extends "res://addons/toolbox_project/scenes/level/Level.gd"

signal breedResource
signal breedPredator
signal breedPrey

onready var pathfinding := $Astar
onready var player_id := 1

var howmany

# Called when the node enters the scene tree for the first time.
func _ready():
	if SignalMngr.connect("game_started", self, "_on_game_started") != OK:
		D.e("Game", ["Signal game_started is already connected"])
	if SignalMngr.connect("restart_level", self, "restart_level") != OK:
		D.e("Game", ["Signal restart_level is already connected"])
	if SignalMngr.connect("next_level", self, "next_level")!= OK:
		D.e("Game", ["Signal next_level is already connected"])
	
	pathfinding.create_navigation_map($AStarGrid)

	Settings.SpawnLocations = $SpawnPoints.get_children()
	Settings.curGameState = Settings.GAME_STATES.PLAY
	
	$SpawnControl.intialspawn()
	connect_children()


func _on_game_started():
	pass

func restart_level():
	pass
	
func next_level():
	pass

func set_child_values():
	var predArray = get_tree().get_nodes_in_group('Predator')
	var preyArray = get_tree().get_nodes_in_group('Prey')
	var resourceArray = get_tree().get_nodes_in_group('Resources')
	for pred in predArray:
		pred.REWARD = 1000
		pred.TYPE = 1
	for prey in preyArray:
		prey.REWARD = 500
		prey.TYPE = 2
	for resource in resourceArray:
		resource.REWARD = 250
		resource.TYPE = 3

func connect_children():
	$HUD.connect('spawnPredator', $SpawnControl , '_on_spawnPredator')
	$HUD.connect('spawnPrey', $SpawnControl , '_on_spawnPrey')
	$HUD.connect('spawnResource', $SpawnControl , '_on_spawnResource')
	$SpawnControl.connect("predSpawnComplete", $HUD, '_on_predSpawnComplete')
	$SpawnControl.connect('preySpawnComplete', $HUD, '_on_preySpawnComplete')
	$SpawnControl.connect("resourceSpawnComplete", $HUD, '_on_resourceSpawnComplete')
	self.connect('breedResource', $SpawnControl, '_on_breedResource')
	self.connect("breedPredator", $SpawnControl, '_on_breedPredator')
	self.connect("breedPrey", $SpawnControl, '_on_breedPrey')
	
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


func _on_WorldTimer_timeout():
	breed()

func breed():
	var predcouples
	var preycouples
	if Settings.Predator_Pop >= 2:
		predcouples = floor(Settings.Predator_Pop/2)
		if predcouples == 0:
			predcouples = 1
		emit_signal('breedPredator', predcouples)
	else:
		pass
	
	if Settings.Prey_Pop >= 3:
		preycouples = floor(Settings.Prey_Pop/3)
		if preycouples == 0:
			preycouples = 1
		emit_signal("breedPrey", preycouples)
	else:
		pass
	
	emit_signal('breedResource')
