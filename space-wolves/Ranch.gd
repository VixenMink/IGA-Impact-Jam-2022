extends "res://addons/toolbox_project/scenes/level/Level.gd"

onready var pathfinding := $Astar
onready var hud := $HUD
onready var player := $PlayerShip
onready var roundTimer := $WorldTimer
onready var tickTimer := $TickTimer
onready var spawnControl := $SpawnControl

var roundCount := 1
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
	Settings.curGameState = Settings.GAME_STATES.PAUSE
	tickTimer.stop()
	roundTimer.stop()
		
	spawnControl.intialspawn()
	
	var _err = hud.connect('spawnPredator', spawnControl, '_on_spawnPredator')
	_err = hud.connect('spawnPrey', spawnControl, '_on_spawnPrey')
	_err = hud.connect('spawnResource', spawnControl, '_on_spawnResource')


func _on_game_started():
	pass

func restart_level():
	pass
	
func next_level():
	pass


func _process(_delta):
	if Settings.curGameState == Settings.GAME_STATES.PLAY and tickTimer.is_stopped():
		tickTimer.start()
		roundTimer.start()
	if predCount < 2:
		hud.WarningBox.show()
		hud.WarningText.text = "At least 2 Predators are needed for a stable ecosystem!\n Introduce more predators! "
		hud.pulseButton('PredatorSpawn')
	elif preyCount < 3:
		hud.WarningBox.show()
		hud.WarningText.text = "At least 3 prey are needed for a stable ecosystem!\nIntroduce more prey! "
		hud.pulseButton('PreySpawn')
	elif resourceCount > 10 and resourceCount > 5 * preyCount:
		hud.WarningBox.show()
		hud.WarningText.text = "The flora will run wild in the system if not culled!\nCull flora!"
		hud.pulseButton('KillTarget')
	elif Settings.Player_Cash < roundCount * 500:
		hud.WarningBox.show()
		hud.WarningText.text = "You don't have enough money to upkeep your ranch!\nCull wildlife to earn money!"
		hud.pulseButton('KillTarget')
	else:
		hud.WarningBox.hide()


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
		SignalMngr.emit_signal("level_lost")
	elif preyCount < 3:
		print("Game Over! Too few prey. Ecological disaster.")
		SignalMngr.emit_signal("level_lost")
	elif resourceCount > 10 and resourceCount > 5 * preyCount:
		print("Game Over! Too few predators. Ecological disaster.")
		SignalMngr.emit_signal("level_lost")
	elif Settings.Player_Cash < roundCount * 500:
		print("Game Over! You can't afford to run the reserve any more.")
		SignalMngr.emit_signal("level_lost")
	elif roundCount >= 10:
		hud.WarningText.text = "Maintaining ecological balance is a never ending journey! But for now, you've saved NeoTokyo."
		hud.WarningText.modulate = Color.yellowgreen
		SignalMngr.emit_signal("level_won")
	else:
		roundCount = roundCount + 1
		breed()


func breed():
	if predCount >= 2:
		var predcouples = floor(predCount/2)
		if predcouples == 0:
			predcouples = 1
		spawnControl.breedPredator(predcouples)
	
	if preyCount >= 3:
		var preycouples = floor(preyCount/3)
		if preycouples == 0:
			preycouples = 1
		spawnControl.breedPrey(preycouples)
	
	spawnControl.breedResource()
