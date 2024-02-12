extends Node2D

@export_range(1,10) var heart_count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_num_hearts()

func set_num_hearts(hc = heart_count):
	for heart in hc:
		add_heart()

func add_heart():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
