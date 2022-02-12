extends EnemyBaseState

var turretReady := false

#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Resume'


func _get_input(_event):
	pass


func _state_logic(_delta):
	pass


func _get_transition(_delta, states_map):
	if turretReady:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("detected")
	if Settings.enable_sound:
		pass


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(anim_name):
	if anim_name == 'detected':
		turretReady = true
