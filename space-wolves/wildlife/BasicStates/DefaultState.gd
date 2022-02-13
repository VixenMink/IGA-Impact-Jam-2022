extends EnemyBaseState


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Default'


func _get_input(_event):
	pass


func _state_logic(delta):
	selfRef._apply_gravity(delta)
	selfRef._apply_movement(delta)


func _get_transition(_delta, states_map):
	if selfRef.can_see_target and selfRef.target_in_attack_range:
		return states_map['AttackState']
	if selfRef.can_see_target and !selfRef.target_in_attack_range:
		return states_map['ChaseState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("default")
	pass


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass
