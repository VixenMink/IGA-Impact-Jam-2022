extends EnemyBaseState

export (NodePath) var nextAttackState
export (float) var transitionDelay = 0.0

onready var timer = $Timer
var moveToNextAttackState := false


#State when enemy is waiting to find something
func _ready():
	nameLabel = 'Attack'
	assert(nextAttackState, 'Attack state must transition to an entity specific attack.')


func _get_input(_event):
	pass


func _state_logic(delta):
	selfRef._apply_gravity(delta)
	#selfRef._apply_movement(delta)


func _get_transition(_delta, states_map):
	if selfRef.can_see_target and selfRef.target_in_attack_range and (moveToNextAttackState or transitionDelay == 0.0):
		var stateName = nextAttackState.get_name(nextAttackState.get_name_count() -1)
		return states_map[stateName]
	if !selfRef.can_see_target:
		return states_map['SeekState']
	if selfRef.can_see_target and (moveToNextAttackState or transitionDelay == 0.0):
		var stateName = nextAttackState.get_name(nextAttackState.get_name_count() -1)
		return states_map[stateName]
	if selfRef.can_see_target and !selfRef.target_in_attack_range:
		return states_map['ChaseState']
	if selfRef.can_see_target and !selfRef.target_in_attack_range and (moveToNextAttackState or transitionDelay == 0.0):
		return states_map['ChaseState']
	
	return null


func _enter_state(_new_state, _old_state):
	moveToNextAttackState = false
	
	if transitionDelay > 0:
		timer.wait_time = transitionDelay
		timer.start()


func _exit_state(_old_state, _new_state):
	moveToNextAttackState = false


func _on_anim_complete(_anim_name):
	pass


func _on_Timer_timeout():
	moveToNextAttackState = true
