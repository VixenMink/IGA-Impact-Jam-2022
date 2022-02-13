extends KinematicBody2D

class_name BaseEntity

export (int) var REWARD := 0
export (int) var TYPE := 0
export (int) var SPEED := 0
export (float) var MAX_HEALTH := 10.0
export (float) var DECAY_RATE := 1.0

var state = 'error'

var move_dir = Vector2.ZERO		#where we want to go
#var facing_dir = Vector2.LEFT	#where we are facing in vector notation

var health = MAX_HEALTH

var VELOCITY := Vector2.ZERO
var GRAVITY := Vector2.ZERO
var GRAVITY_DIR := Vector2.ZERO


onready var anim := $AnimationPlayer
onready var damagedtween := $DamagedTween
onready var pivot : Position2D = $HitboxPivot
onready var hurtbox : Area2D = $HurtBox
onready var hitbox : Area2D = $HitboxPivot/HitBox
onready var hitboxCollider : CollisionShape2D = $HitboxPivot/HitBox/CollisionShape2D
onready var line : Line2D = $Line2D
onready var collision_shape = $PhysicsBox
onready var sprite := $Sprite
onready var stateMachine := $StateMachine
onready var nameplate := $NamePlate

var origin_pos := Vector2.ZERO

var pathFinder
var path: Array = []
var detectableEntities: Array = []

var target
var target_in_attack_range := false
var can_see_target := false
var target_last_known_position : Vector2
var debug_los_color := Color(1.0, .329, .298)
var targetPos

var amDead := false
var invulnerable := false
var hungry := true
var canbeKilled := false

var Pred
var Prey
var Resource

signal died
signal ShotThroughTheHart


func _ready():
	var _err = damagedtween.connect("curve_tween", self, "_on_DamagedTween_curve_tween")
	_err = hurtbox.connect("area_entered", self, "_on_hurtbox_entered")
	
	randomize()
	MAX_HEALTH = MAX_HEALTH * rand_range(.75, 1.25)
	
	health = MAX_HEALTH
	origin_pos = get_global_position()
	hitboxCollider.disabled = true
	
	if name != "Player":
		var tree = get_tree()
		if tree.has_group("path_finding"):
			pathFinder = tree.get_nodes_in_group("path_finding")[0]
		
		set_physics_process(false)
		set_process(false)
		
		activate_entity()


func _process(_delta):
	if Settings.ENEMY_DEBUG:
		update()


func _physics_process(_delta):
	
	if detectableEntities.size() > 0:
		can_see_target = _check_target_line_of_sight()
	else:
		can_see_target = false
		target_in_attack_range = false
		target = null
	
	if health < MAX_HEALTH * .75:
		hungry = true
		buildDetectableList()
	if hungry and health == MAX_HEALTH:
		hungry = true



func _ShowYourName():
		nameplate.visible = true


func _hideYourName():
	nameplate.visible = false

func _draw() -> void:
	if can_see_target:
		debug_los_color = Color(1.0, .329, .298)
	elif target and !can_see_target and target_last_known_position:
		debug_los_color = Color.green
		
	targetPos = (target_last_known_position - global_position)
	# If you can't see your target, square off its last k nown location
	if target_last_known_position:
		draw_line(Vector2(targetPos.x - 5, targetPos.y - 5), targetPos, Color.yellow, 1.5, false)
		draw_line(Vector2(targetPos.x + 5, targetPos.y - 5), targetPos, Color.yellow, 1.5, false)
		draw_line(Vector2(targetPos.x - 5, targetPos.y + 5), targetPos, Color.yellow, 1.5, false)
		draw_line(Vector2(targetPos.x + 5, targetPos.y + 5), targetPos, Color.yellow, 1.5, false)
	
	# If you have a target draw a line and circle to it
	if target:
		draw_circle(targetPos, 5, debug_los_color)
		draw_line(Vector2(), targetPos, debug_los_color)


# Movement based on pathfinding
func _apply_movement(_delta, _useGravity = false) -> void:
	VELOCITY = Vector2.ZERO
	line.global_position = Vector2.ZERO
	
	navigate()
	update_facing()
	var _err = move_and_slide(VELOCITY, GRAVITY_DIR, false, 4, PI/4, false)
	
	# Code for pushing things
	for index in get_slide_count():
		var _collision = get_slide_collision(index)


func _apply_gravity(_delta):
	return
	
	#VELOCITY += GRAVITY * delta


# Movement based on force
func _apply_momentum(curVelocity, force) -> bool:
	line.global_position = Vector2.ZERO
	
	curVelocity = curVelocity * force
	var _err = move_and_slide(curVelocity, GRAVITY_DIR, false, 4, PI/4, false)
	
	# Code for pushing things
	for index in get_slide_count():
		var _collision = get_slide_collision(index)
			
		return true
		
	return false


func anim_switch(animation, speed = 1):
	if anim == null or !anim.has_animation(str(animation)):
		#print('fail at animation: ', animation,'_',sprite_dir)
		return
	var newanim = str(animation)
	
	if anim.current_animation != newanim:
		anim.play(newanim, -1, speed)


func _on_hurtbox_entered(attackBox : HitBox):
	if attackBox == null:
		print('whoops: ',self.name)
		return
	
	# if you're invulnerable
	if invulnerable or amDead:
		return
	
	var entity = attackBox.owner
	# You can only be hurt by enemy factions
	
	_take_damage(attackBox, entity)


func _take_damage(attackBox : HitBox, entity):
	var confirmHit = false
	
	# check projectiles first
	if entity.collision_layer == 512:
		health = health - attackBox.DAMAGE
		confirmHit = true
		entity.queue_free()
	# then other hitboxes
	else:
		health = health - attackBox.DAMAGE
		confirmHit = true
	
	if confirmHit:
		if health <= 0:
			amDead = true
			emit_signal("died", self)
			queue_free()


func _on_killMob():
	if (Settings.curTarget != null) and (self.name == Settings.curTarget.name):
		emit_signal("ShotThroughTheHart", self.REWARD, self.TYPE)
		Settings.curTarget = null
		for body in $HitboxPivot/DetectRange.get_overlapping_bodies():
			if body == self:
				continue
			Settings.curTarget = body
			break
		queue_free()


func _take_hunger_damage():
	health = health - DECAY_RATE
		
	if health <= 0:
		amDead = true
		emit_signal("died", self)
		queue_free()


func navigate():
	if path.size() > 1:
		VELOCITY = global_position.direction_to(Vector2(path[1].x, path[1].y)) * SPEED
		if global_position.distance_to(Vector2(path[1].x, path[1].y)) < 16:
			path.pop_front()
	line.points = path


func generate_path(destination : Vector2):
	if pathFinder != null:
		
		path = pathFinder.get_new_path(collision_shape.global_position, destination)
		line.points = path


func update_facing():
	if VELOCITY != Vector2.ZERO:
		print(VELOCITY.angle() + deg2rad(90))
		sprite.rotation = lerp(sprite.rotation, VELOCITY.angle() + deg2rad(90), 0.1)
		pivot.rotation = lerp(pivot.rotation, VELOCITY.angle() + deg2rad(90), 0.1)
		hurtbox.rotation = lerp(hurtbox.rotation, VELOCITY.angle() + deg2rad(90), 0.1)


func _check_target_line_of_sight() -> bool:
	# Snapshot of the physics state at this moment
	var space_state = get_world_2d().direct_space_state
	
	for curTarget in detectableEntities:
		var visionMask = 56

		var result = space_state.intersect_ray(global_position, curTarget.global_position, [self], visionMask)
		
		if result:
			if !(result.collider is KinematicBody2D) :
				continue
			else:
				target = curTarget
				target_last_known_position = curTarget.global_position
				return true
	
	target = null
	target_in_attack_range = false
	return false


func activate_entity():
	set_process(true)
	set_physics_process(true)
	buildDetectableList()


func deactivate_entity():
	set_process(false)
	set_physics_process(false)
	detectableEntities.clear()
	
	if stateMachine.deactivate_state:
		var newState = stateMachine.get_node(stateMachine.deactivate_state)
		stateMachine.set_state(newState)


func amHostileTo(body):
	if collision_layer != body.collision_layer:
		return true
	return false


func _on_DamagedTween_curve_tween(color):
	$Sprite.modulate.a = color


func buildDetectableList():
	detectableEntities.clear()
	for body in $HitboxPivot/DetectRange.get_overlapping_bodies():
		if amHostileTo(body):
			detectableEntities.push_back(body)


func _on_DetectRange_body_entered(body):
	if amHostileTo(body) and !detectableEntities.has(body) and hungry:
		detectableEntities.push_back(body)


func _on_DetectRange_body_exited(body):
	if detectableEntities.has(body):
		detectableEntities.erase(body)
		if body == target:
			target = null


func _on_AttackRange_body_entered(body):
	if body == target:
		target_in_attack_range = true


func _on_AttackRange_body_exited(body):
	if body == target:
		target_in_attack_range = false


func _on_StateMachine_state_changed(current_state):
	if Settings.ENEMY_DEBUG:
		state = str(current_state.nameLabel)
