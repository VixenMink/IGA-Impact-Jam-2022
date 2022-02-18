extends Button


# Based on code by kidscancode
# https://kidscancode.org/godot_recipes/ui/cooldown_button/
onready var sweep = $Sweep
export var cooldown = 1.0


func _ready():
	$Timer.wait_time = cooldown
	sweep.value = 0
	set_process(false)
	var _err = connect("pressed", self, '_on_AbilityButton_pressed')
	_err = $Timer.connect("timeout", self, '_on_Timer_timeout')


func _process(_delta):
	sweep.value = int(($Timer.time_left / cooldown) * 100)


func _on_AbilityButton_pressed():
	disabled = true
	set_process(true)
	$Timer.start()


func _on_Timer_timeout():
	sweep.value = 0
	disabled = false
	set_process(false)
