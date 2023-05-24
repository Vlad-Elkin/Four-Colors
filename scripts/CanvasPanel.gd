extends Control

var width = ProjectSettings.get_setting("display/window/size/width")*0.75
var height = ProjectSettings.get_setting("display/window/size/height")
var brush_size = 11
var selected_color = Color.black
var canvas = preload("res://scripts/Canvas.gd").new(width,height,brush_size)
var graph = preload("res://scripts/ColorGraph.gd").new(width,height,brush_size)
var pressed:bool
var past_texture
var texture
var last_pos = null
signal end_game(result)

func _input(event):
	if fsm.blocking: return
	var pos = event.position-rect_position
	if pos.x > width:
		last_pos = null
		return
	if pos.x <= 0: 
		last_pos = null
		return
	if pos.y > height: 
		last_pos = null
		return
	if pos.y <= 0: 
		last_pos = null
		return
	match fsm.current_tool:
		"PENCIL":
			if event is InputEventScreenTouch and event.pressed:
				pressed = true
				use_pencil(pos)
			if event is InputEventScreenDrag:
				use_pencil(pos)
			if event is InputEventScreenTouch and !event.pressed:
				use_pencil(pos)
				last_pos = null
				pressed = false
		"BUCKET":
			if event is InputEventScreenTouch and event.pressed:
				use_bucket(pos)

func use_pencil(pos):
	if not pressed: return
	graph.used_area += canvas.draw_point(pos)
	if last_pos!=null:
		if pos.distance_to(last_pos) >= 1: 
			graph.used_area += canvas.draw_line(last_pos,pos)
	last_pos = pos
	update()

func use_bucket(pos):
	canvas.lock()
	var target_color = canvas.get_pixelv(pos)
	canvas.unlock()
	if target_color != Color.white: return
	var node = canvas.span_fill(pos,selected_color,target_color)
	graph.add_node(node)
	var result = graph.check_edges() 
	update()
	fsm.player_switch()
	fsm.tool_switch()
	emit_signal("end_game",result)


func _draw():
	if texture == null:
		texture = ImageTexture.new()
		texture.create_from_image(canvas)
	else:
		texture.set_data(canvas)
	draw_texture(texture,Vector2())
