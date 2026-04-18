class_name InteractionUI extends InteractionComponent

@export var UI: Control = null

func start():
	if UI:
		UI.show()
func cancel():
	if UI:
		UI.hide()
