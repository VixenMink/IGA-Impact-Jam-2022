extends EnemyBaseState


var attackComplete := false
var ramTime := false
var attackVelocity


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Ram'


func _get_input(_event):
	pass


func _state_logic(delta):
	if !selfRef.target:
		return
	
	selfRef._apply_gravity(delta)
	if ramTime:
		attackComplete = selfRef._apply_momentum(attackVelocity, 100)


func _get_transition(_delta, states_map):
	if attackComplete or !selfRef.target:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("ram-windup")
	attackComplete = false
	if selfRef.target:
		attackVelocity = selfRef.global_position.direction_to(selfRef.target.global_position)


func _exit_state(_old_state, _new_state):
	attackComplete = false
	ramTime = false
	animationRef.play("RESET")


func _on_anim_complete(anim_name):
	if anim_name == 'ram-windup':
		animationRef.play("ram-fire")
		ramTime = true
