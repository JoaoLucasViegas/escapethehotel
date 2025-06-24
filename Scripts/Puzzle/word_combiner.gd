extends Control

@onready var words = $Words

var idx_word = 0
var key = ""

func _ready() -> void:
	var idx = 0
	for label in words.get_children():
		if label is Label:
			label.text = Global.words[idx]
		idx += 1

func _physics_process(_delta: float) -> void:
	var idx = 0
	for label in words.get_children():
		if idx != idx_word:
			label.hide()
			idx += 1
			continue
		else:
			label.show()
		idx += 1
	key = words.get_child(idx_word).text

func _on_up_word_pressed() -> void: #backwards
	if idx_word < words.get_child_count() - 1:
		idx_word += 1
	else:
		idx_word = 0
	$KeySound.pitch_scale = randf_range(1.25, 1.45)
	$KeySound.play()

func _on_down_word_pressed() -> void: #forwards
	if idx_word > 0:
		idx_word -= 1
	else:
		idx_word = words.get_child_count() - 1
	$KeySound.pitch_scale = randf_range(1.25, 1.45)
	$KeySound.play()
