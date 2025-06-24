extends Control

var item_to_be_broken: BaseLevelObject

func sabotage(obj_to_react: BaseLevelObject):
	item_to_be_broken = obj_to_react
	show()

func _on_sabotage_pressed() -> void:
	hide()
	if item_to_be_broken:
		item_to_be_broken.is_broken = true
		item_to_be_broken = null

func _on_close_window_pressed() -> void:
	hide()
