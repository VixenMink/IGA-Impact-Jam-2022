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

func _on_breed():
	_on_breedResource()
	_on_breedPredator(1)
	_on_breedPrey(1)

func _on_breedResource():
	var repeatNumber = randi()%4 + 2
	while repeatNumber > 0:
		var spawnlocation = (Settings.SpawnLocations[randi()%Settings.SpawnLocations.size()]).global_position
		var newMob = resourceRef.instance()
		newMob.position = spawnlocation
		newMob.REWARD = 250
		newMob.TYPE = 3
		self.get_parent().add_child(newMob)
		self.get_parent().connect_children()
		repeatNumber = repeatNumber - 1

func _on_breedPredator(howmany: float):
	var repeatNumber = howmany + (randi()%5+1)
	while repeatNumber > 0:
		var spawnlocation = (Settings.SpawnLocations[randi()%Settings.SpawnLocations.size()]).global_position
		var newMob = predatorRef.instance()
		newMob.position = spawnlocation
		newMob.REWARD = 1000
		newMob.TYPE = 1
		self.get_parent().add_child(newMob)
		self.get_parent().connect_children()
		repeatNumber = repeatNumber - 1

func _on_breedPrey(howmany: float):
	var repeatNumber = howmany + (randi()%3+1)
	while repeatNumber > 0:
		var spawnlocation = (Settings.SpawnLocations[randi()%Settings.SpawnLocations.size()]).global_position
		var newMob = preyRef.instance()
		newMob.position = spawnlocation
		newMob.REWARD = 500
		newMob.TYPE = 2
		self.get_parent().add_child(newMob)
		self.get_parent().connect_children()
		repeatNumber = repeatNumber - 1


func intialspawn():
	intialPrey()
	intialResource()

func intialPrey():
	var repeatNumber = randi()%5 + 1
	while repeatNumber > 0:
		var spawnlocation = Settings.SpawnLocations[randi()%Settings.SpawnLocations.size()].global_position
		var newMob = preyRef.instance()
		newMob.position = spawnlocation
		newMob.REWARD = 500
		newMob.TYPE = 2
		self.get_parent().add_child(newMob)
		self.get_parent().connect_children()
		repeatNumber = repeatNumber - 1

func intialResource():
	var repeatNumber = randi()%10 + 2
	while repeatNumber > 0:
		var spawnlocation = (Settings.SpawnLocations[randi()%Settings.SpawnLocations.size()]).global_position
		var newMob = resourceRef.instance()
		newMob.position = spawnlocation
		newMob.REWARD = 250
		newMob.TYPE = 3
		self.get_parent().add_child(newMob)
		self.get_parent().connect_children()
		repeatNumber = repeatNumber - 1
