extends CanvasLayer

signal spawnPredator
signal spawnPrey
signal spawnResource
signal killPred
signal killPrey
signal killResource
signal killMob

onready var Cash = $MarginContainer/BaseBox/TopBox/VBoxContainer/Cash
onready var PredatorPop = $MarginContainer/BaseBox/TopBox/VBoxContainer/PredatorPop
onready var PreyPop = $MarginContainer/BaseBox/TopBox/VBoxContainer/PreyPop
onready var ResourcePop = $MarginContainer/BaseBox/TopBox/VBoxContainer/ResoursePop
onready var Progress = $MarginContainer/BaseBox/TopBox/VBoxContainer2/ProgressBar
onready var Round = $MarginContainer/BaseBox/TopBox/VBoxContainer2/Round
onready var PredatorSpawn = $MarginContainer/BaseBox/BottomGrid/PredatorSPawn
onready var PredatorKill = $MarginContainer/BaseBox/BottomGrid/PredatorKill
onready var PreySpawn = $MarginContainer/BaseBox/BottomGrid/PreySpawn
onready var PreyKill = $MarginContainer/BaseBox/BottomGrid/PreyKill
onready var ResourceSpawn = $MarginContainer/BaseBox/BottomGrid/ResourceSpawn
onready var ResourceKill = $MarginContainer/BaseBox/BottomGrid/ResourceKill
onready var NotEnoughMoney = $MarginContainer/BaseBox/MiddleBox/AlertBox

var Prey
var Pred
var Resource

#var predatorpopValue = Settings.Predator_Pop.size()
#var preypopValue = Settings.Prey_Pop.size()
#var resourcepopValue = Settings.Resource_Pop.size()
var cashmoney = Settings.Player_Cash

func _ready():
	print(Settings.Predator_Pop)
	print(Settings.Prey_Pop)
	print(Settings.Resource_Pop)
#	Settings.Predator_Pop = get_tree().get_nodes_in_group('Predator')
#	Settings.Prey_Pop = get_tree().get_nodes_in_group('Prey')
#	Settings.Resource_Pop = get_tree().get_nodes_in_group('Resource')
#	predatorpopValue = Settings.Predator_Pop.size()
#	preypopValue = Settings.Prey_Pop.size()
#	resourcepopValue = Settings.Resource_Pop.size()
	cashmoney = Settings.Player_Cash
#	$SpawnControl.connect("predSpawnComplete", self, '_on_predSpawnComplete')
#	$SpawnControl.connect('preySpawnComplete', self, '_on_preySpawnComplete')
#	$SpawnControl.connect("resourceSpawnComplete", self, '_on_resourceSpawnComplete')
	Round.text = str('Round: ' , Settings.GameRound)
	update_hud()

func _process(delta):
	update_hud()

func update_hud():
	update_populations()
	update_cash()

func update_populations():
		PredatorPop.text = str('Predator Population: ' , Settings.Predator_Pop)
		PreyPop.text = str("Prey Population: " , Settings.Prey_Pop)
		ResourcePop.text = str('Resource Population: ' , Settings.Resource_Pop)

func update_cash():
	Cash.text = str('Cash: $' , cashmoney)
	Settings.Player_Cash = cashmoney

func _on_PredatorSPawn_pressed():
	var cost = 1500
	if cost < cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPredator")
	else:
		NotEnoughMoney.popup()
	update_hud()

func _on_PreySpawn_pressed():
	var cost = 750
	if cost < cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPrey")
	else:
		NotEnoughMoney.popup()
	update_hud()

func _on_ResourceSpawn_pressed():
	var cost = 300
	if cost < cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnResource")
	else:
		NotEnoughMoney.popup()
	update_hud()

func _on_PredatorKill_pressed():
	emit_signal("killMob")


func _on_PreyKill_pressed():
	emit_signal("killMob")

func _on_ResourceKill_pressed():
	emit_signal("killMob")

#func _on_predSpawnComplete():
#	predatorpopValue = predatorpopValue + 1
#	update_hud()

#func _on_preySpawnComplete():
#	preypopValue = preypopValue + 1
#	update_hud()

#func _on_resourceSpawnComplete():
#	resourcepopValue = resourcepopValue + 1
#	update_hud()

func _on_ShotThroughTheHart(REWARD, TYPE):
	print('shotrecieved',REWARD,TYPE)
	cashmoney = cashmoney + REWARD
	update_hud()


