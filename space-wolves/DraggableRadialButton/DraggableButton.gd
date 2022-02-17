extends Control

var previousLocation : Vector2
export (bool) var menuOpen = false

onready var ringMenu : RadialContainer = $RadialContainer
onready var pressedImage = preload("res://assets/tests/cc_unitLeoTest01.png")
onready var normalImage = preload("res://assets/tests/cc_unitLeoTest01.png")

signal button_state_changed(value)


func _ready():
	if !menuOpen:
		ringMenu.disable_buttons()
	else:
		open_menu()
	#$MenuButton.set_normal_texture(pressedImage)


func open_menu():
	ringMenu.enable_buttons()
	menuOpen = true
	#$MenuButton.set_normal_texture(pressedImage)


func _on_MenuButton_button_down():
	previousLocation = get_global_position()


func _on_MenuButton_button_up():
	if previousLocation == get_global_position():
		if menuOpen:
			ringMenu.disable_buttons()
			menuOpen = false
			#$MenuButton.set_normal_texture(normalImage)
			emit_signal("button_state_changed", false)
		else:
			ringMenu.enable_buttons()
			menuOpen = true
			#$MenuButton.set_normal_texture(pressedImage)
			emit_signal("button_state_changed", true)


func clearHuntButton():
	$RadialContainer/KillTarget/Panel/icon.texture = null
	$RadialContainer/KillTarget/Panel/Label.text = str('$0')


func updateHuntButton(target : BaseEntity):
	var type = 'flora'
	if target.MY_TYPE == 1:
		type = 'prey'
	elif target.MY_TYPE == 2:
		type = 'predator'
	var cost = target.REWARD
	$RadialContainer/KillTarget/Panel/icon.texture = load(str('res://assets/icons/',type,'-icon.png'))
	$RadialContainer/KillTarget/Panel/Label.text = str('$',cost)
