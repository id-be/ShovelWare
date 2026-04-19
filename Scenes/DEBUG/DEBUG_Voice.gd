extends Node

func _ready():
	print(AudioServer.get_input_device_list())

func _input(event):
	pass

func _process(delta):
	check_if_speaking()
	pass

func check_if_speaking():
	pass
