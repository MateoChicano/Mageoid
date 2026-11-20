extends CanvasLayer

@onready var menu_panel: Control = $MenuPanel
@onready var options_panel: Panel = $OptionsPanel
@onready var resume_button: Button = $MenuPanel/VBoxContainer/ResumeButton
@onready var options_button: Button = $MenuPanel/VBoxContainer/OptionsButton
@onready var return_button: Button = $MenuPanel/VBoxContainer/ReturnButton
@onready var back_button: Button = $OptionsPanel/VBoxContainer/BackButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	menu_panel.visible = true
	options_panel.visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	return_button.pressed.connect(_on_return_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_resume()
		else:
			_pause()
		get_viewport().set_input_as_handled()


func _pause() -> void:
	get_tree().paused = true
	visible = true
	menu_panel.visible = true
	options_panel.visible = false
	resume_button.grab_focus()


func _resume() -> void:
	get_tree().paused = false
	visible = false
	options_panel.visible = false


func _on_resume_pressed() -> void:
	_resume()


func _on_options_pressed() -> void:
	menu_panel.visible = false
	options_panel.visible = true
	back_button.grab_focus()


func _on_back_pressed() -> void:
	options_panel.visible = false
	menu_panel.visible = true
	options_button.grab_focus()


func _on_return_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Interface/Menus/TitleScreen.tscn")
