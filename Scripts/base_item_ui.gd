class_name BaseItemUI
extends Control

@onready var texture = $texture
@onready var label = $label

var ui_manager: UIManager

func _on_button_pressed() -> void:
	if ui_manager:
		ui_manager.itemClicked(label.text.to_lower())
