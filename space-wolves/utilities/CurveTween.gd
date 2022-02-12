extends Tween

class_name CurveTween

signal curve_tween(saturation)

export (Curve) var curve
var start = 0.0
var end = 1.0
export (bool) var autostart = false


func _ready():
	if autostart:
		play()


func play(var duration: float = 1.0, var start_in = 0.0, var end_in = 1.0):
	assert(curve, "This CurveTween needs a curve added in the inspector")
	start = start_in
	end = end_in
	var _err = interpolate_method(self, "interp", 0.0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_err = start()


func interp(var saturation):
	emit_signal("curve_tween", start + ((end - start) * curve.interpolate(saturation)))
