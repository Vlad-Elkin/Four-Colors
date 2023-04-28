extends Control

var width = ProjectSettings.get_setting("display/window/size/width")*0.75
var height = ProjectSettings.get_setting("display/window/size/height")
var brush_size = 11
var selected_color = Color.black
var canvas = preload("res://scripts/Canvas.gd").new(width,height,brush_size)
var graph = preload("res://scripts/ColorGraph.gd").new(width,height,brush_size)
var texture
var last_pos = null
var pressed:bool = false

func use_pencil(pos):
	if canvas.is_inside(pos.x,pos.y) and pressed:
		graph.area -= canvas.draw_point(pos)
		if last_pos!=null:
			if pos.distance_to(last_pos) >= 1: 
				graph.area -= canvas.draw_line(last_pos,pos)
		last_pos = pos
	update()

func use_bucket(pos):
	if canvas.is_inside(pos.x,pos.y):
		canvas.lock()
		var target_color = canvas.get_pixelv(pos)
		canvas.unlock()
		var node = canvas.span_fill(pos,selected_color,target_color)
		graph.add_node(node)
		var check = graph.check_edges() 
		update()
		return check

func _draw():
	if texture == null:
		texture = ImageTexture.new()
		texture.create_from_image(canvas)
	else:
		texture.set_data(canvas)
	draw_texture(texture,Vector2())
