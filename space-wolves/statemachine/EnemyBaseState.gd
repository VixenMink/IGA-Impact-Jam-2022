"""
Base interface for all states: it doesn't do anything in itself
but forces us to pass the right arguments to the methods below
and makes sure every State object had all of these methods.
"""

extends Node

class_name EnemyBaseState

# warning-ignore:unused_signal
signal animate(animation_to_play)
# warning-ignore:unused_signal
signal stop_animate()

var selfRef : BaseEntity
var animationRef : AnimationPlayer
var nameLabel : String

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _initialize(kinematicBody : BaseEntity, animationPlayer: AnimationPlayer):
	selfRef = kinematicBody
	animationRef = animationPlayer

# warning-ignore:unused_argument
func _get_input(event):
	pass

# warning-ignore:unused_argument
func _state_logic(delta):
	pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _get_transition(delta, states_map):
	return null

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _enter_state(new_state, old_state):
	pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _exit_state(old_state, new_state):
	pass

# warning-ignore:unused_argument
func _anim_complete(anim_name):
	pass
