extends Node2D

const tile = preload("res://tile.tscn")
const unit_test = preload("res://units/unit_test.tscn")
const TILE_SIZE = 32

onready var as = AStar.new()

#just for test

var map = []
var map_tiles = []

func _ready():
	var i = 0
	var f_in = File.new()
	f_in.open("res://map.json",File.READ)
	var line = {}
	line.parse_json(f_in.get_line())
	map = line['map']
	map_tiles = line['map_tiles']
	for y in range(map.size()):
		for x in range(map[0].size()):
			var tile_new = tile.instance()
			tile_new.set_name("tile_"+str(y)+"_"+str(x))
			tile_new.set_pos(Vector2(x*TILE_SIZE+TILE_SIZE/2,y*TILE_SIZE+TILE_SIZE/2))
			tile_new.get_node("tiles").set_frame(map_tiles[y][x])
			add_child(tile_new)
			as.add_point(i,Vector3(x,y,0))
			i += 1
	
	#Connects cells right and down. Possible duplicates ?
	i = 0
	for y in range(map.size()):
		for x in range(map[0].size()):
			if y > 0 and x > 0 and y < map.size() and x < map[0].size():
				if map[y][x] == 0 and map[y][x+1] == 0:
					as.connect_points(i,i+1)
				if map[y][x] == 0 and map[y+1][x] == 0:
					as.connect_points(i,i+map[0].size())
			i += 1
	
	add_unit_to_id(33)
	set_process_input(true)
	

func add_unit_to_id(id):
	var unit_new = unit_test.instance()
	unit_new.set_pos(id_to_px(id))
	unit_new.set_z(2)
	add_child(unit_new)

func px_to_id(pos):
	var x = floor(pos.x/TILE_SIZE)
	var y = floor(pos.y/TILE_SIZE)
	var id = y * map[0].size() + x
	return id
	
func id_to_px(id):
	id = int(id)
	var x = id % map[0].size()
	var y = id / map[0].size()
	return Vector2(x*TILE_SIZE+TILE_SIZE/2,y*TILE_SIZE+TILE_SIZE/2)
	
func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.button_index == 1 && event.pressed && not event.is_echo():
		if get_node("unit_test").path.size() == 0:
			get_node("unit_test").end_id = px_to_id(event.pos)
			get_node("unit_test").path = as.get_id_path(get_node("unit_test").start_id,get_node("unit_test").end_id)
			get_node("unit_test").walk()
		else:
			print("still walking")