extends EnemyBaseState


var attackComplete := false


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Strike'


func _get_input(_event):
	pass


func _state_logic(delta):
	selfRef._apply_gravity(delta)


func _get_transition(_delta, states_map):
	if attackComplete:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("attack-eat")
	attackComplete = false


func _exit_state(_old_state, _new_state):
	attackComplete = false
	selfRef.health = selfRef.health + 1


func _on_anim_complete(anim_name):
	if anim_name.begins_with('attack'):
		attackComplete = true
