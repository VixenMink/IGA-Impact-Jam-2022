extends RigidBody2D

var origin
var projectile_speed = 300
var life_time = 3
var fire_direction
var skill_name
var animation
var knockback = 100
var spawnpoint
var DAMAGE = 1
var FACTION = Settings.FACTIONS.PROJECTILE

func _ready():
	if origin == Settings.FACTIONS.PLAYER:
		collision_mask = 273
		$Hitbox.collision_mask = 16
		
	elif origin == Settings.FACTIONS.ENEMIES:
		collision_mask = 261
		$Hitbox.collision_mask = 4
		
	$Hitbox.DAMAGE = DAMAGE
	$Hitbox.KNOCKBACK = knockback
	var skill_texture = load("res://assets/" + skill_name + ".png")
	$Sprite.texture = skill_texture
	spawnpoint = global_position
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	$Timer.wait_time = life_time
	$Timer.start()
	if Settings.enable_sound:
		pass
	
func _reflected():
	if origin == Settings.FACTIONS.PLAYER:
		$Hitbox.DAMAGE = $Hitbox.DAMAGE * 2
		collision_mask = 261
		$Hitbox.collision_mask = 4
		$Sprite.set_modulate(Color(255,35,35,1))
		
	elif origin == Settings.FACTIONS.ENEMIES:
		$Hitbox.DAMAGE = $Hitbox.DAMAGE * 2
		collision_mask = 273
		$Hitbox.collision_mask = 16
		$Sprite.set_modulate(Color(35,35,35,.5))

# A blocked shot can hurt no one at all
func _blocked():
	$Sprite.set_modulate(Color(.5,0,0,1))
	$Hitbox.DAMAGE = 0
	collision_mask = 257
	$Hitbox.collision_mask = 0


func _process(delta):
	$Sprite.rotate(25 * delta)


func _on_Timer_timeout():
	queue_free()
