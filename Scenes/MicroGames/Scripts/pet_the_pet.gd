extends Node2D

@export var bgs = []
@onready var bg = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_bg = randi_range(0, bgs.size()-1)
	bg.set_texture(bgs[my_bg])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
