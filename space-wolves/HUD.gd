extends CanvasLayer

signal spawnPredator
signal spawnPrey
signal spawnResource
signal killMob

onready var Progress = $MarginContainer/BaseBox/TopBox/LeftBox/ProgressBar
onready var Cash = $MarginContainer/BaseBox/TopBox/LeftBox/HBoxContainer/Cash
onready var Round = $MarginContainer/BaseBox/TopBox/LeftBox/HBoxContainer/Round

onready var PredatorPop = $MarginContainer/BaseBox/TopBox/LeftBox/GridContainer/PredatorPop
onready var PreyPop = $MarginContainer/BaseBox/TopBox/LeftBox/GridContainer/PreyPop
onready var ResourcePop = $MarginContainer/BaseBox/TopBox/LeftBox/GridContainer/ResoursePop

onready var PredatorSpawn = $DraggableButton/RadialContainer/Control4/PredatorSpawn
onready var PreySpawn = $DraggableButton/RadialContainer/Control3/PreySpawn
onready var ResourceSpawn = $DraggableButton/RadialContainer/Control/ResourceSpawn
onready var KillTarget = $DraggableButton/RadialContainer/Control2/KillTarget

onready var WarningText = $MarginContainer/BaseBox/BottomBox/BottomPanel/WarningLabel
onready var WarningBox = $MarginContainer/BaseBox/BottomBox
onready var NotEnoughMoneyAlert = $AlertBox
onready var tween = $CurveTween

onready var zoomInButton := $MarginContainer/BaseBox/MiddleBox/ZoomBox/ZoomButtonBox/ZoomIn
onready var zoomOutButton := $MarginContainer/BaseBox/MiddleBox/ZoomBox/ZoomButtonBox/ZoomOut

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
	PredatorPop.text = str(get_parent().predCount)
	PreyPop.text = str(get_parent().preyCount)
	ResourcePop.text = str(get_parent().resourceCount)
	Cash.text = str('Cash: $' , cashmoney)
	Settings.Player_Cash = cashmoney
	
	var weakTarget = weakref(get_parent().player.curTarget)
	#print('1:', get_parent().player.curTarget)
	if not weakTarget.get_ref():
		#CurrentTarget.text = "No creature below you"
		KillTarget.disabled = true
		$DraggableButton.clearHuntButton()
	else:
		#CurrentTarget.text = str("Targeting: ", weakTarget.get_ref().name)
		KillTarget.disabled = false
		$DraggableButton.updateHuntButton(weakTarget.get_ref())


func _on_PredatorSpawn_pressed():
	if Settings.curGameState == Settings.GAME_STATES.PAUSE:
		Settings.curGameState = Settings.GAME_STATES.PLAY
	var cost = 1500
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPredator")
	else:
		NotEnoughMoneyAlert.popup()


func _on_PreySpawn_pressed():
	if Settings.curGameState == Settings.GAME_STATES.PAUSE:
		Settings.curGameState = Settings.GAME_STATES.PLAY
	var cost = 750
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnPrey")
	else:
		NotEnoughMoneyAlert.popup()


func _on_ResourceSpawn_pressed():
	if Settings.curGameState == Settings.GAME_STATES.PAUSE:
		Settings.curGameState = Settings.GAME_STATES.PLAY
	var cost = 300
	if cost <= cashmoney:
		cashmoney = cashmoney - cost
		emit_signal("spawnResource")
	else:
		NotEnoughMoneyAlert.popup()


func _on_KillTarget_pressed():
	if Settings.curGameState == Settings.GAME_STATES.PAUSE:
		Settings.curGameState = Settings.GAME_STATES.PLAY
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
	focusButton.rect_scale = Vector2(saturation, saturation)
