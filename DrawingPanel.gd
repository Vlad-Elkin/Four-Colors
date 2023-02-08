extends Control

var width = ProjectSettings.get_setting("display/window/size/width")*0.8
var height = ProjectSettings.get_setting("display/window/size/height")
var canvas = preload("res://Canvas.gd").new(width,height)
var graph = preload("res://ColorGraph.gd").new()

var selected_color = Color.black
var texture

func use_pencil(mouse_pos):
	if mouse_pos.x>0 and mouse_pos.x<width:
		if mouse_pos.y>0 and mouse_pos.y<height:
			canvas.draw_by_pencil(mouse_pos,selected_color)
	update()

func use_bucket(mouse_pos):
	if mouse_pos.x>0 and mouse_pos.x<width:
		if mouse_pos.y>0 and mouse_pos.y<height:
			graph.addVertex(canvas.fill_by_bucket(mouse_pos,selected_color))
	update()

func clear():
	canvas.clear()
	update()

func _draw():
	if texture == null:
		texture = ImageTexture.new()
		texture.create_from_image(canvas)
	else:
		texture.set_data(canvas)
	draw_texture(texture,Vector2())
