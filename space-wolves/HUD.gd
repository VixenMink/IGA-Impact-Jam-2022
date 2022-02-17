extends CanvasLayer

signal spawnPredator
signal spawnPrey
signal spawnResource
signal killMob

onready var Cash = $MarginContainer/BaseBox/TopBox/LeftBox/Cash
onready var PredatorPop = $MarginContainer/BaseBox/TopBox/LeftBox/PredatorPop
onready var PreyPop = $MarginContainer/BaseBox/TopBox/LeftBox/PreyPop
onready var ResourcePop = $MarginContainer/BaseBox/TopBox/LeftBox/ResoursePop
onready var Progress = $MarginContainer/BaseBox/TopBox/LeftBox/ProgressBar
onready var Round = $MarginContainer/BaseBox/TopBox/LeftBox/Round

onready var PredatorSpawn = $DraggableButton/RadialContainer/PredatorSpawn
onready var PreySpawn = $DraggableButton/RadialContainer/PreySpawn
onready var KillTarget = $DraggableButton/RadialContainer/KillTarget
onready var ResourceSpawn = $DraggableButton/RadialContainer/ResourceSpawn

onready var WarningText = $MarginContainer/BaseBox/BottomBox/BottomPanel/WarningLabel
onready var WarningBox = $MarginContainer/BaseBox/BottomBox
onready var NotEnoughMoneyAlert = $AlertBox
onready var tween = $CurveTween

var cashmoney = Settings.Player_Cash
var focusButton

func _ready():
	cashmoney = 5000
	PredatorSpawn.connect("pressed", self, "_on_PredatorSpawn_pressed")
	PreySpawn.connect("pressed", self, "_on_PreySpawn_pressed")
	ResourceSpawn.connect("pressed", self, "_on_ResourceSpawn_pressed")
	KillTarget.connect("pressed", self, "_on_KillTarget_pressed")



func _process(_delta):
	update_hud()
	Round.text = str('Generation: ' , get_parent().roundCount)
	Progress.value = 30 - get_parent().roundTimer.time_left


func update_hud():
	PredatorPop.text = str('Predator Population: ', get_parent().predCount)
	PreyPop.text = str("Prey Population: ", get_parent().preyCount)
	ResourcePop.text = str('Flora Population: ', get_parent().resourceCount)
	Cash.text = str('Cash: $' , cashmoney)
	Settings.Player_Cash = cashmoney
	
	var weakTarget = weakref(get_parent().player.curTarget)
	#print('1:', get_parent().player.curTarget)
	if not weakTarget.get_ref():
		#CurrentTarget.text = "No creature below you"
		$DraggableButton/RadialContainer/KillTarget.disabled = true
		$DraggableButton.clearHuntButton()
	else:
		#CurrentTarget.text = str("Targeting: ", weakTarget.get_ref().name)
		$DraggableButton/RadialContainer/KillTarget.disabled = false
		$DraggableButton.updateHuntButton(weakTarget.get_ref())


func _on_PredatorSpawn_pressed():
	var cost = 1500
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPredator")
	else:
		NotEnoughMoneyAlert.popup()


func _on_PreySpawn_pressed():
	var cost = 750
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPrey")
	else:
		NotEnoughMoneyAlert.popup()


func _on_ResourceSpawn_pressed():
	var cost = 300
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnResource")
	else:
		NotEnoughMoneyAlert.popup()


func _on_KillTarget_pressed():
	var weakTarget = weakref(get_parent().player.curTarget)
	if not weakTarget.get_ref():
		print('Error on kill')
	else:
		cashmoney = cashmoney + weakTarget.get_ref().REWARD
		weakTarget.get_ref()._on_killMob()
		yield(get_tree(), "idle_frame")
		get_parent().player.retarget()
	
	emit_signal("killMob")


func pulseButton(buttonName):
	if tween.is_active():
		pass
	else:
		if buttonName == "PredatorSpawn":
			focusButton = PredatorSpawn
		if buttonName == "PreySpawn":
			focusButton = PreySpawn
		if buttonName == "ResourceSpawn":
			focusButton = ResourceSpawn
		if buttonName == "KillTarget":
			focusButton = KillTarget
		
		tween.play(2.5, .5, 1)


func _on_CurveTween_curve_tween(saturation):
	focusButton.modulate = Color(1, saturation, saturation, 1)
	focusButton.rect_scale = Vector2(saturation, saturation)
