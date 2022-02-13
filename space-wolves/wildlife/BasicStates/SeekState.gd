extends EnemyBaseState

export (float) var min_wait_time = 2
export (float) var max_wait_time = 4

onready var timer = $Timer
var shouldReturn := false
var moveTarget : Vector2


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Seek'


func _get_input(_event):
	pass


func _state_logic(delta):
	if selfRef.can_see_target:
		return
	
	selfRef.generate_path(moveTarget)
	
	if selfRef.path.size() <= 1 and selfRef.global_position.distance_to(moveTarget) >= 32:
		var steerVelocity = selfRef.global_position.direction_to(moveTarget)
		selfRef.VELOCITY = steerVelocity
		selfRef.update_facing()
		var _retVal = selfRef._apply_momentum(steerVelocity, 16)
	
	if (selfRef.path.size() <= 1 and selfRef.global_position.distance_to(moveTarget) < 32) and timer.is_stopped():
		selfRef.VELOCITY = Vector2.ZERO
		timer.wait_time = rand_range(min_wait_time, max_wait_time)
		timer.start()
		
	selfRef._apply_movement(delta)
	selfRef._apply_gravity(delta)


func _get_transition(_delta, states_map):
	if !selfRef.hungry:
		return states_map['ReturnState']
	if shouldReturn:
		return states_map['ReturnState']
	if selfRef.can_see_target and !selfRef.target_in_attack_range:
		return states_map['ChaseState']
	if selfRef.can_see_target and selfRef.target_in_attack_range:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	moveTarget = selfRef.target_last_known_position
	shouldReturn = false


func _exit_state(_old_state, _new_state):
	shouldReturn = false
	timer.stop()


func _on_anim_complete(_anim_name):
	pass


func _on_Timer_timeout():
	shouldReturn = true
