extends EnemyBaseState


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Nothing'


func _get_input(_event):
	pass


func _state_logic(delta):
	selfRef._apply_gravity(delta)
	selfRef._apply_movement(delta)


func _get_transition(_delta, _states_map):
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("default")


func _exit_state(_old_state, _new_state):
	pass


func _on_anim_complete(_anim_name):
	pass

