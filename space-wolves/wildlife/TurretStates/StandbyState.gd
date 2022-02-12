extends EnemyBaseState

var turretReady := false

#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Standby'


func _get_input(_event):
	pass


func _state_logic(_delta):
	pass


func _get_transition(_delta, states_map):
	if selfRef.can_see_target:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("attack_base")


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass
