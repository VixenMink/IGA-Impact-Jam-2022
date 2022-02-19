extends EnemyBaseState

var movetimer_length = 3145
var movetimer = 0


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Wander'


func _get_input(_event):
	pass


func _state_logic(_delta):
	var randoVelocity = selfRef.move_dir.normalized()
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 or selfRef.is_on_wall():
		selfRef.move_dir = random_direction()
		
		movetimer = movetimer_length

	selfRef.sprite.rotation = lerp(selfRef.sprite.rotation, randoVelocity.angle() + deg2rad(90), 0.1)
	selfRef.pivot.rotation = lerp(selfRef.pivot.rotation, randoVelocity.angle() + deg2rad(90), 0.1)
	selfRef.hurtbox.rotation = lerp(selfRef.hurtbox.rotation, randoVelocity.angle() + deg2rad(90), 0.1)
	
	
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
	return Vector2(rand_range(0, 1), rand_range(0, 1))
	
