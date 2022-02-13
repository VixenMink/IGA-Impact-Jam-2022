extends "res://addons/toolbox_project/scenes/level/Level.gd"

signal breedResource
signal breedPredator
signal breedPrey

onready var pathfinding := $Astar
onready var hud := $HUD
onready var player := $PlayerShip
onready var roundTimer := $WorldTimer

var roundCount = 1
var preyCount := 0
var predCount := 0
var resourceCount := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if SignalMngr.connect("game_started", self, "_on_game_started") != OK:
		D.e("Game", ["Signal game_started is already connected"])
	if SignalMngr.connect("restart_level", self, "x") != OK:
		D.e("Game", ["Signal restart_level is already connected"])
	if SignalMngr.connect("next_level", self, "next_level")!= OK:
		D.e("Game", ["Signal next_level is already connected"])
	
	pathfinding.create_navigation_map($AStarGrid)

	Settings.SpawnLocations = $SpawnPoints.get_children()
	Settings.curGameState = Settings.GAME_STATES.PLAY
	
	$SpawnControl.intialspawn()
	
	var _err = $HUD.connect('spawnPredator', $SpawnControl , '_on_spawnPredator')
	_err = $HUD.connect('spawnPrey', $SpawnControl , '_on_spawnPrey')
	_err = $HUD.connect('spawnResource', $SpawnControl , '_on_spawnResource')
	_err = self.connect('breedResource', $SpawnControl, '_on_breedResource')
	_err = self.connect("breedPredator", $SpawnControl, '_on_breedPredator')
	_err = self.connect("breedPrey", $SpawnControl, '_on_breedPrey')


func _on_game_started():
	pass

func restart_level():
	pass
	
func next_level():
	pass


func _process(_delta):
	if predCount < 2:
		$HUD.Warning.text = "Introduce more predators! At least 2 Predators are needed for a stable ecosystem!"
	elif preyCount < 3:
		$HUD.Warning.text = "Introduce more prey! At least 3 prey are needed for a stable ecosystem!"
	elif resourceCount > 10 and resourceCount > 5 * preyCount:
		$HUD.Warning.text = "Hunt flora! The flora will run wild in the system if not culled!"
	else:
		$HUD.Warning.text = ""


func connect_children():
	var creatureArray = get_tree().get_nodes_in_group('wildlife')
	for creature in creatureArray:
		var _err = $HUD.connect('killMob', creature, '_on_killMob')
		_err = creature.connect('ShotThroughTheHart', $HUD, '_on_ShotThroughTheHart')


func _on_TickTimer_timeout():
	var wildlifeArray = get_tree().get_nodes_in_group('wildlife')
	for wildlife in  wildlifeArray:
		if wildlife.is_in_group('Resource'):
			continue
		
		wildlife._take_hunger_damage()


func register_wildlife(wildlifeType : int, change : int):
	if wildlifeType == 1:
		preyCount = preyCount + change
	if wildlifeType == 2:
		predCount = predCount + change
	if wildlifeType == 3:
		resourceCount = resourceCount + change


func _on_WorldTimer_timeout():
	if predCount < 2:
		print("Game Over! Too few predators. Ecological disaster.")
		$HUD.Warning.modulate = Color.red
		SignalMngr.emit_signal("level_lost")
	elif preyCount < 3:
		print("Game Over! Too few prey. Ecological disaster.")
		$HUD.Warning.modulate = Color.red
		SignalMngr.emit_signal("level_lost")
	elif resourceCount > 10 and resourceCount > 5 * preyCount:
		print("Game Over! Too few predators. Ecological disaster.")
		$HUD.Warning.modulate = Color.red
		SignalMngr.emit_signal("level_lost")
	elif roundCount >= 10:
		$HUD.Warning.text = "Maintaining ecological balance is a never ending journey! But for now, you've saved NeoTokyo."
		$HUD.Warning.modulate = Color.yellowgreen
		SignalMngr.emit_signal("level_won")
	else:
		roundCount = roundCount + 1
		breed()


func breed():
	var predcouples
	var preycouples
	
	if predCount >= 2:
		predcouples = floor(predCount/2)
		if predcouples == 0:
			predcouples = 1
		emit_signal('breedPredator', predcouples)
	else:
		pass
	
	if preyCount >= 3:
		preycouples = floor(preyCount/3)
		if preycouples == 0:
			preycouples = 1
		emit_signal("breedPrey", preycouples)
	else:
		pass
	
	emit_signal('breedResource')
