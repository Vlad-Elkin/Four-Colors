extends Control

var width = ProjectSettings.get_setting("display/window/size/width")*0.8
var height = ProjectSettings.get_setting("display/window/size/height")
var brush_size = 11
var selected_color = Color.black

var canvas = preload("res://scripts/Canvas.gd").new(width,height,brush_size)
var graph = preload("res://scripts/ColorGraph.gd").new(brush_size)

var texture

var last_pos = null
var pressed:bool = false

func use_pencil(pos):
	if canvas.is_inside(pos.x,pos.y) and pressed:
		print(pos)
		canvas.draw_point(pos)
		if last_pos!=null:
			if pos.distance_to(last_pos) >= 1: 
				canvas.draw_line(last_pos,pos)
		last_pos = pos
	update()

func use_bucket(pos):
	if canvas.is_inside(pos.x,pos.y):
		canvas.lock()
		var target_color = canvas.get_pixelv(pos)
		canvas.unlock()
		var node = canvas.flood_fill(pos,selected_color,target_color)
		graph.add_node(node)
		graph.find_edges()
		var same_color = graph.check_edges()
		update()
		if same_color: return true

func clear():
	canvas.clear()
	graph.clear()
	update()

func _draw():
	if texture == null:
		texture = ImageTexture.new()
		texture.create_from_image(canvas)
	else:
		texture.set_data(canvas)
	draw_texture(texture,Vector2())
