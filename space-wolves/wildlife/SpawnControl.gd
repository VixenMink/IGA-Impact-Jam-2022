extends Node

signal predSpawnComplete
signal preySpawnComplete
signal resourceSpawnComplete

#var HUD = get_tree().get_root().find_node('HUD', true, false)
var predatorRef = load('res://space-wolves/wildlife/PredatorMob.tscn')
var preyRef = load('res://space-wolves/wildlife/PreyMob.tscn')
var resourceRef = load ('res://space-wolves/wildlife/ResourceMob.tscn')


func _ready():
	randomize()
#	$HUD.connect('spawnPredator', self, '_on_spawnPredator')
#	$HUD.connect('spawnPrey', self, '_on_spawnPrey')
#	$HUD.connect('spawnResource', self, '_on_spawnResource')
	intialspawn()


func _on_spawnPredator():
	var spawnlocation = get_parent().get_node('PlayerShip').global_position
	var newMob = predatorRef.instance()
	newMob.position = spawnlocation
	newMob.REWARD = 1000
	newMob.TYPE = 1
	self.get_parent().add_child(newMob)
	self.get_parent().connect_children()
	
	emit_signal("predSpawnComplete")

func _on_spawnPrey():
	var spawnlocation = get_parent().get_node('PlayerShip').global_position
	var newMob = preyRef.instance()
	newMob.position = spawnlocation
	newMob.REWARD = 500
	newMob.TYPE = 2
	self.get_parent().add_child(newMob)
	self.get_parent().connect_children()
	
	emit_signal("preySpawnComplete")

func _on_spawnResource():
	var spawnlocation = get_parent().get_node('PlayerShip').global_position
	var newMob = resourceRef.instance()
	newMob.position = spawnlocation
	newMob.REWARD = 250
	newMob.TYPE = 3
	self.get_parent().add_child(newMob)
	self.get_parent().connect_children()
	
	emit_signal("resourceSpawnComplete")

func intialspawn():
	intialPrey()
	intialResource()

func intialPrey():
	pass

func intialResource():
	pass
