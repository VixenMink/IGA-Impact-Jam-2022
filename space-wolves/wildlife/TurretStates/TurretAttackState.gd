extends EnemyBaseState

var attackReady := false
var suppresionCount := 0

#State when enemy is waiting to find something
func _ready():
	nameLabel = 'TurretAttack'
	var _err = $AnimationPlayer.connect("animation_finished", self, '_on_anim_complete')


func _get_input(_event):
	pass


func _state_logic(_delta):
	if selfRef.can_see_target:
		selfRef.pivot.rotation = selfRef.get_angle_to(selfRef.target_last_known_position)

func _get_transition(_delta, states_map):
	if attackReady:
		return states_map['ShootState']
	if suppresionCount > 5 and !selfRef.can_see_target:
		suppresionCount = 0
		return states_map['StandbyState']
	
	return null


func _enter_state(_new_state, _old_state):
	animationRef.play("attack_base")
	$AnimationPlayer.play("attack", -1, .5)


func _exit_state(_old_state, _new_state):
	attackReady = false
	if !selfRef.can_see_target:
		suppresionCount += 1
	if selfRef.can_see_target:
		suppresionCount = 0


func _on_anim_complete(anim_name):
	if anim_name == 'attack':
		attackReady = true
