extends EnemyBaseState

var movetimer_length = 3145
var movetimer = 0


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Wander'


func _get_input(_event):
	pass


func _state_logic(_delta):
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 or selfRef.is_on_wall():
		selfRef.move_dir = random_direction()
		selfRef.update_facing()
		movetimer = movetimer_length
	
	var randoVelocity = selfRef.move_dir.normalized()
	selfRef.VELOCITY = randoVelocity
	
	var _err = selfRef._apply_momentum(randoVelocity, selfRef.SPEED)


func _get_transition(_delta, states_map):
	if selfRef.hungry and selfRef.can_see_target and selfRef.target_in_attack_range:
		return states_map['AttackState']
	if selfRef.hungry and selfRef.can_see_target and !selfRef.target_in_attack_range:
		return states_map['ChaseState']
	return null


func _enter_state(_new_state, _old_state):
	#animationRef.play("default")
	selfRef.move_dir = random_direction()


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass


func random_direction():
	randomize()
	match (randi() % 4):
		0:
			return Vector2.LEFT
		1:
			return Vector2.RIGHT
		2:
			return Vector2.UP
		3:
			return Vector2.DOWN
