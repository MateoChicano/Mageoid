extends Control

@onready var options_panel: Panel = $OptionsPanel
@onready var play_button: Button = $MenuContainer/VBoxContainer/PlayButton
@onready var options_button: Button = $MenuContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $MenuContainer/VBoxContainer/QuitButton
@onready var back_button: Button = $OptionsPanel/VBoxContainer/BackButton


func _ready() -> void:
	options_panel.visible = false


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/test_level.tscn")


func _on_options_pressed() -> void:
	options_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	options_panel.visible = false
