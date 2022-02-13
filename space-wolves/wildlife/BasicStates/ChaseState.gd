extends EnemyBaseState


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Chase'


func _get_input(_event):
	pass


func _state_logic(delta):
	if !selfRef.can_see_target:
		return
	
	var moveTarget = selfRef.target_last_known_position
	
	selfRef.generate_path(moveTarget)
	
	if selfRef.path.size() == 0:
		selfRef.path = []
		var steerVelocity = selfRef.global_position.direction_to(moveTarget)
		selfRef.VELOCITY = steerVelocity
		selfRef.update_facing()
		
		var _retVal = selfRef._apply_momentum(selfRef.VELOCITY, selfRef.SPEED/2.0)
	
	selfRef._apply_gravity(delta)
	selfRef._apply_movement(delta)
	
	#if selfRef.path.size() == 1:
	#	var steerVelocity = selfRef.global_position.direction_to(moveTarget)
	#	var _retVal = selfRef._apply_momentum(steerVelocity, selfRef.SPEED)
	
	selfRef.anim_switch('walk')


func _get_transition(_delta, states_map):
	if !selfRef.hungry:
		return states_map['ReturnState']
	if selfRef.target_in_attack_range:
		return states_map['AttackState']
	if !selfRef.can_see_target:
		return states_map['SeekState']
	if selfRef.can_see_target and !selfRef.target_in_attack_range and selfRef.path.size() == 0:
		#print('Cant reach target but can shoot them, attacking anyway')
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	pass


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass
