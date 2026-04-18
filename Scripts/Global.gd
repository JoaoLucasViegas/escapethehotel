extends Node

signal GameOver
signal EndGame

const words = ["eat", "2", "dogs", "alone"]

var is_dynamic = true
var is_static = false
var pass_code = "GARBAGEMONKEY - JoaoLucasViegas"
var vault_code = "GbMonky - garbagemonkey"
var passphrase = "santosviegasj@gmail.com - João Lucas Santos Viegas"
var passphrase_ui = "gbMonkey since 2016 - Brazil"

func _ready() -> void:
	startGame()

func startGame():
	pass_code = generatePassCode()
	vault_code = generatePassCode()
	passphrase = generateCombineWords()
	DevTools.consoleText(passphrase_ui)

func emit_game_over():
	emit_signal("GameOver")
	startGame()
func emit_game_end():
	emit_signal("EndGame")

func generatePassCode() -> String:
	var code = ""
	for x in range(0, 4):
		var rand_integer = str(randi_range(1, 9))
		code += rand_integer
		#print(rand_integer)
	return code
func generateCombineWords() -> String:
	var combination = words.duplicate()
	var combination_word = ""
	var combination_ui = ""
	for x in combination.size():
		if combination.size() <= 1:
			combination_ui += combination.front()
			combination_word += combination.pop_front()
			break
		var value = combination.pop_at(randi_range(0, combination.size()-1))
		combination_word += str(value)
		combination_ui += value + " "
	passphrase_ui = combination_ui
	#print(combination_word)
	return combination_word
