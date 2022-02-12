extends Node

export (NodePath) var kinematic_body
export (NodePath) var animation_player
export(NodePath) var start_state
export(NodePath) var deactivate_state

var states_map = {}

var current_state = null setget set_state
var previous_state = null

signal state_changed(current_state)
signal anim_complete(anim_name)

var selfRef
var animationRef : AnimationPlayer


func _ready():
	selfRef = get_node(kinematic_body)
	animationRef = get_node(animation_player)
	
	for child in get_children():
		var stateName = child.name
		states_map[stateName] = child
		child._initialize(selfRef, animationRef)
		var _err = animationRef.connect("animation_finished", child, "_on_anim_complete")
	assert(start_state, 'State Machine requires an initial state!!')
	current_state = get_node(start_state)
	set_state(current_state)


func _physics_process(delta):
	if Settings.curGameState != Settings.GAME_STATES.PLAY:
		return
	
	if current_state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)


func _input(event):
	if Settings.curGameState != Settings.GAME_STATES.PLAY:
		return
	current_state._get_input(event)


func _state_logic(delta):
	current_state._state_logic(delta)


func _get_transition(delta):
	return current_state._get_transition(delta, states_map)


func _enter_state(new_state, old_state):
	current_state._enter_state(new_state, old_state)


func set_state(new_state):
	previous_state = current_state
	current_state = new_state
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)


func _exit_state(old_state, new_state):
	previous_state._exit_state(new_state, old_state)
	emit_signal("state_changed", new_state)


func _anim_complete(anim_name):
	current_state._on_anim_complete(anim_name)
	emit_signal("anim_complete", anim_name)
