extends EnemyBaseState


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Return'


func _get_input(_event):
	pass


func _state_logic(delta):
	if selfRef.global_position.distance_to(selfRef.origin_pos) > 32:
		selfRef.generate_path(selfRef.origin_pos)
	
	selfRef._apply_gravity(delta)
	selfRef._apply_movement(delta)
	
	selfRef.anim_switch('walk')


func _get_transition(_delta, states_map):
	if selfRef.path.size() <= 1 and  selfRef.global_position.distance_to(selfRef.origin_pos) > 0:
		return states_map['DefaultState']
	if selfRef.can_see_target and !selfRef.target_in_attack_range:
		return states_map['ChaseState']
	if selfRef.target_in_attack_range:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	pass


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass
