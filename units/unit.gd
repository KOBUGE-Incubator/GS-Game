extends KinematicBody2D

onready var world = get_node("/root/world")
export var health = 100
export var walking_speed = 0
export var attack_mode = 0
export var flag = true
export var selectable = true
export var multi_select = false
export var size = 1

var pos = Vector2(0,0)
var flag_pos = Vector2(0,0)

func _ready():
	if flag == true:
		pass