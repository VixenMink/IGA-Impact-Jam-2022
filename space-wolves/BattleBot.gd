extends KinematicBody2D

export (float, 0, 2000, 40) var linear_speed_max := 600.0 
export (float, 0, 9000, 10.0) var linear_acceleration_max := 40.0 
export (float, 0, 100, 0.1) var arrival_tolerance := 10.0 
export (float, 0, 500, 10) var deceleration_radius := 100.0 
export (float, 0, 5, 0.1) var predict_time := 0.3 
export (float, 0, 200, 10.0) var path_offset := 20.0 

export (NodePath) var astarNodePath
export (NodePath) var targetNodePath

var _velocity := Vector2.ZERO
var _accel := GSAITargetAcceleration.new()
var _drag := 0.1

var aStarRef: Astar
var targetRef : BaseEntity

onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var path : GSAIPath
onready var follow : GSAIFollowPath

var isActive = false


func setup() -> void:
	aStarRef = get_node(astarNodePath)
	targetRef = get_node(targetNodePath)
	var newRoute = aStarRef.get_new_path(self.global_position, targetRef.global_position)
	
	path = GSAIPath.new( newRoute, false)
	follow = GSAIFollowPath.new(agent, path, 0, 0)
	
	follow.path_offset = path_offset
	follow.prediction_time = predict_time
	follow.deceleration_radius = deceleration_radius
	follow.arrival_tolerance = arrival_tolerance

	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_speed_max = linear_speed_max
	agent.linear_drag_percentage = _drag


func _physics_process(delta: float) -> void:
	if isActive and Settings.curGameState == Settings.GAME_STATES.PLAY and targetRef:
		var newRoute = aStarRef.get_new_path(self.global_position, targetRef.global_position)
		if newRoute.size() > 1:
			path.create_path(newRoute)
			follow.path = path
			follow.calculate_steering(_accel)
			agent._apply_steering(_accel, delta)
	elif !isActive and Settings.curGameState == Settings.GAME_STATES.PLAY:
		setup()
		isActive = true
