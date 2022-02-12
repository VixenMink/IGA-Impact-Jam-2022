extends EnemyBaseState

var shotInstance = preload("res://utilities/RangedSingleTarget.tscn")

export (float) var delayUntilAttack = 2
export (int) var projectileSpeed = 75
onready var timer = $Timer

var attackComplete := false
var startAttack := false
var attackTarget


#State when enemy is waiting to find something
func _ready():
	 nameLabel = 'Shoot'


func _get_input(_event):
	pass


func _state_logic(delta):

	selfRef._apply_gravity(delta)
	
	if startAttack:
		startAttack = false
		selfRef.pivot.rotation = selfRef.get_angle_to(attackTarget)
		
		var shot = shotInstance.instance()
		shot.rotation = selfRef.get_angle_to(attackTarget)
		shot.global_position = selfRef.pivot.get_node("ProjectilePoint").global_position
		shot.skill_name = "antibody"
		shot.projectile_speed = projectileSpeed
		shot.origin = selfRef.FACTION
		selfRef.level_manager.add_child(shot)
		
		attackComplete = true


func _get_transition(_delta, states_map):
	if attackComplete:
		return states_map['AttackState']
	
	return null


func _enter_state(_new_state, _old_state):
	attackComplete = false
	startAttack = false
	
	attackTarget = selfRef.target_last_known_position
	
	timer.wait_time = delayUntilAttack
	timer.start()


func _exit_state(_old_state, _new_state):
	attackComplete = false
	startAttack = false
	timer.stop()


func _on_anim_complete(_anim_name):
	pass


func _on_Timer_timeout():
	startAttack = true
