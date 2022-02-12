extends CanvasLayer

signal spawnPredator
signal spawnPrey
signal spawnResource
signal killMob

onready var Cash = $MarginContainer/BaseBox/TopBox/VBoxContainer/Cash
onready var PredatorPop = $MarginContainer/BaseBox/TopBox/VBoxContainer/Cash
onready var PreyPop = $"MarginContainer/BaseBox/TopBox/VBoxContainer/Predator pop"
onready var ResourcePop = $"MarginContainer/BaseBox/TopBox/VBoxContainer/Resourse Pop"
onready var Progress = $MarginContainer/BaseBox/TopBox/VBoxContainer2/ProgressBar
onready var Round = $MarginContainer/BaseBox/TopBox/VBoxContainer2/Round
onready var PredatorSpawn = $MarginContainer/BaseBox/BottomGrid/PredatorSPawn
onready var PredatorKill = $MarginContainer/BaseBox/BottomGrid/PredatorKill
onready var PreySpawn = $MarginContainer/BaseBox/BottomGrid/PreySpawn
onready var PreyKill = $MarginContainer/BaseBox/BottomGrid/PreyKill
onready var ResourceSpawn = $MarginContainer/BaseBox/BottomGrid/ResourceSpawn
onready var ResourceKill = $MarginContainer/BaseBox/BottomGrid/ResourceKill
onready var NotEnoughMoney = $MarginContainer/BaseBox/MiddleBox/AlertBox

var predatorpopValue = Settings.Predator_Pop.size()
var preypopValue = Settings.Prey_Pop.size()
var resourcepopValue = Settings.Resource_Pop.size()
var cashmoney = Settings.Player_Cash

func _ready():
	Settings.Predator_Pop = get_tree().get_nodes_in_group('Predator')
	Settings.Prey_Pop = get_tree().get_nodes_in_group('Prey')
	Settings.Resource_Pop = get_tree().get_nodes_in_group('Resource')
	predatorpopValue = Settings.Predator_Pop.size()
	preypopValue = Settings.Prey_Pop.size()
	resourcepopValue = Settings.Resource_Pop.size()
	cashmoney = Settings.Player_Cash
	Round.text = str('Round: ' , Settings.GameRound)


func _process(_delta):
	update_hud()

func update_hud():
	update_populations()
	update_cash()

func update_populations():
		PredatorPop.text = str('Predator Population: ' , predatorpopValue)
		PreyPop.text = str("Prey Population: " , preypopValue)
		ResourcePop.text = str('Resource Population: ' , resourcepopValue)

func update_cash():
	Cash.text = str('Cash: $' , cashmoney)
	Settings.Player_Cash = cashmoney

func _on_PredatorSPawn_pressed():
	var cost = 1500
	if cost < cashmoney:
		predatorpopValue = predatorpopValue + 1
		cashmoney = cashmoney - cost
		emit_signal("spawnPredator")
	else:
		NotEnoughMoney.popup()
	update_hud()

func _on_PreySpawn_pressed():
	var cost = 750
	if cost < cashmoney:
		preypopValue = preypopValue + 1
		cashmoney = cashmoney - cost
		emit_signal("spawnPrey")
	else:
		NotEnoughMoney.popup()
	update_hud()

func _on_ResourceSpawn_pressed():
	var cost = 300
	if cost < cashmoney:
		resourcepopValue = resourcepopValue + 1
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

