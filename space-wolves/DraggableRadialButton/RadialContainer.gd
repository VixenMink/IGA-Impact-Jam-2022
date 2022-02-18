tool
extends Container

#Creates a radial container node
class_name RadialContainer

export var button_radius = 100 #in godot position units
export var radial_width = 50 #in godot position units

# Called when the node enters the scene tree for the first time.
func _ready():
	place_buttons()

#Repositions the buttons
func place_buttons():
	var buttons = get_children()

	#Stop before we cause problems when no buttons are available
	if buttons.size() == 0:
		return

	#Amount to change the angle for each button
	var angle_offset = (2*PI)/buttons.size() #in degrees

	var angle = 0 #in radians
	for btn in buttons: 
		#calculates the buttons location on the circle
		var circle_pos = Vector2(button_radius, 0).rotated(angle)
		
		#set button's position
		#>we want to center the element on the circle. 
		#>to do this we need to offset the calculated x and y respectively by half the height and width
		btn.get_child(0).rect_position = circle_pos-(btn.get_child(0).get_size()/2)
		
		#Advance to next angle position
		angle += angle_offset

func disable_buttons():
	var buttons = get_children()

	#Stop before we cause problems when no buttons are available
	if buttons.size() == 0:
		return
	
	for btn in buttons:
		btn.get_child(0).disabled = true
		btn.get_child(0).visible = false

func enable_buttons():
	var buttons = get_children()

	#Stop before we cause problems when no buttons are available
	if buttons.size() == 0:
		return
	
	for btn in buttons:
		btn.get_child(0).disabled = false
		btn.get_child(0).visible = true

#utility function for adding buttons and recalculating their positions
#TODO: Should probably just use a signal to run place_button on any tree change
func add_button(btn):
	add_child(btn)
	place_buttons()
