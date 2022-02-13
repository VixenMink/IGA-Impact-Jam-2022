extends CanvasLayer

signal spawnPredator
signal spawnPrey
signal spawnResource
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
onready var CurrentTarget = $MarginContainer/BaseBox/TopBox/VBoxContainer2/TargetLabel


var cashmoney = Settings.Player_Cash

func _ready():
	cashmoney = 5000
	


func _process(_delta):
	update_hud()
	Round.text = str('Round: ' , get_parent().roundCount)
	$MarginContainer/BaseBox/TopBox/VBoxContainer2/ProgressBar.value = 30 - get_parent().roundTimer.time_left

func update_hud():
	update_populations()
	update_cash()
	
	var weakTarget = weakref(get_parent().player.curTarget)
	if not weakTarget.get_ref():
		CurrentTarget.text = "No creature below you"
	else:
		CurrentTarget.text = str("Targetting: ", get_parent().player.curTarget.name)
	#$MarginContainer/BaseBox/TopBox/VBoxContainer2/ProgressBar.value = get_parent().roundTimer.


func update_populations():
	PredatorPop.text = str('Predator Population: ' , get_parent().predCount)
	PreyPop.text = str("Prey Population: " , get_parent().preyCount)
	ResourcePop.text = str('Resource Population: ' , get_parent().resourceCount)


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


func _on_PreySpawn_pressed():
	var cost = 750
	if cost < cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPrey")
	else:
		NotEnoughMoney.popup()


func _on_ResourceSpawn_pressed():
	var cost = 300
	if cost < cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnResource")
	else:
		NotEnoughMoney.popup()


func _on_PredatorKill_pressed():
	emit_signal("killMob")


func _on_PreyKill_pressed():
	var weakTarget = weakref(get_parent().player.curTarget)
	if not weakTarget.get_ref():
		print('error on kill')
	else:
		_on_ShotThroughTheHart( get_parent().player.curTarget.REWARD, get_parent().player.curTarget.MY_TYPE)
		get_parent().player.curTarget._on_killMob()
		
	emit_signal("killMob")


func _on_ResourceKill_pressed():
	emit_signal("killMob")


func _on_ShotThroughTheHart(REWARD, _TYPE):
	cashmoney = cashmoney + REWARD
