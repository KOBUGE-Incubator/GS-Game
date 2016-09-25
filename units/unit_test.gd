extends KinematicBody2D

onready var world = get_node("/root/world")
var path = []
var start_id = 66
var end_id = 66

func _ready():
	pass
	
func walk():
	get_node("Timer").start()
	#print(path)

func _on_Timer_timeout():
	if path.size() > 0:
		get_node("Timer").start()
		set_pos(world.id_to_px(path[0]))
		path.remove(0)
	else:
		start_id = end_id