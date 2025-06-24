class_name UIManager
extends CanvasLayer

@onready var credits_roll = ResourceLoader.load("res://Scenes/credits_roll.tscn")

@onready var gameoverUI = $GameOver
@onready var sabotageUI = $SabotageScreen
@onready var puzzleUI = $Puzzle
@onready var itemsUI = $Items
@onready var player: Player

func _ready() -> void:
	player = get_parent() as Player
	Global.connect("GameOver", whenGameOver, CONNECT_DEFERRED)
	Global.connect("EndGame", whenGameEnds, CONNECT_DEFERRED)
	
	#Prepare
	clearHUD()
	itemsUI.show()

func whenGameOver():
	#get_tree().paused = true
	itemsUI.hide()
	sabotageUI.hide()
	puzzleUI.hide()
	gameoverUI.show()
	player.is_busted = true
func whenGameEnds():
	clearHUD()
	get_tree().paused = true
	get_tree().change_scene_to_packed(credits_roll)

func clearHUD():
	gameoverUI.hide()
	sabotageUI.hide()
	puzzleUI.clearPuzzles()
	itemsUI.hide()

func itemClicked(item_name: String):
	if sabotageUI.visible or puzzleUI.visible or gameoverUI.visible:
		return
	if item_name == "sheet":
		itemsUI.passCodeUI()
	if item_name == "phrase":
		itemsUI.passPhraseUI()
		#print("Hello there!")
