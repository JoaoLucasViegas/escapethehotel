extends Control

@onready var base_item = preload("res://Prefabs/components/base_item_ui.tscn")
@onready var item_list = $List

@onready var pass_code_ui = $Passcode
@onready var pass_code_label = $Passcode/ColorRect/Label

@onready var passphrase_ui = $PassPhrase
@onready var passphrase_label = $PassPhrase/ColorRect/Label

@export var ui_manager: UIManager

func _ready() -> void:
	var random_num = randi_range(0, 1)
	if bool(random_num):
		pass_code_label.text = Global.pass_code + "\n" + Global.vault_code
	else:
		pass_code_label.text = Global.vault_code + "\n" + Global.pass_code
	passphrase_label.text = Global.passphrase_ui

func _physics_process(_delta: float) -> void:
	if ui_manager:
		visible = !ui_manager.puzzleUI.visible and !ui_manager.gameoverUI.visible

func new_item(item_to_add: Item):
	var item_mask: BaseItemUI = base_item.instantiate()
	item_list.add_child(item_mask)
	if item_to_add.item_icon:
		item_mask.texture.texture = item_to_add.item_icon
	item_mask.label.text = item_to_add.item_name
	item_mask.ui_manager = ui_manager
	
	item_to_add.queue_free()

func passCodeUI():
	pass_code_ui.visible = visible
func passPhraseUI():
	passphrase_ui.visible = visible

func _on_close_window_pressed() -> void:
	pass_code_ui.visible = false
	passphrase_ui.visible = false
