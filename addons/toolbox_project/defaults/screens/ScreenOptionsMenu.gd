extends Screen


onready var btn_video = $MenuLayer/UIBox/MarginContainer/PanelContainer/VBoxContainer/Menu/BtnVideo
onready var btn_audio = $MenuLayer/UIBox/MarginContainer/PanelContainer/VBoxContainer/Menu/BtnAudio
onready var btn_controls = $MenuLayer/UIBox/MarginContainer/PanelContainer/VBoxContainer/Menu/BtnControls

func _ready():
	if !C.SHOW_SETTINGS_VIDEO:
		btn_video.hide()
	if !C.SHOW_SETTINGS_AUDIO:
		btn_audio.hide()
	if !C.SHOW_SETTINGS_KEYBINDINGS:
		btn_controls.hide()
