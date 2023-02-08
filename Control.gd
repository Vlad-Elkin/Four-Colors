extends Control

enum PlayerQuery{
	Player1,Player2
}
enum ColorQuery{
	Color1,Color2
}
enum DrawingTools{
	Pencil, Bucket
}

onready var _parent = get_parent()
onready var TL = _parent.get_node(@"TLPos")
onready var DrawingPanel = _parent.get_node(@"DrawingPanel")

onready var P1C1_button = $Player1/Color1
onready var P1C1_color  = $Player1/Color1/Sprite.self_modulate
onready var P1C2_button = $Player1/Color2
onready var P1C2_color  = $Player1/Color2/Sprite.self_modulate
onready var P2C1_button = $Player2/Color1
onready var P2C1_color  = $Player2/Color1/Sprite.self_modulate
onready var P2C2_button = $Player2/Color2
onready var P2C2_color  = $Player2/Color2/Sprite.self_modulate
onready var pencil = $Tools/Pencil
onready var bucket = $Tools/Bucket
onready var change = $Tools/Change
onready var clear  = $Tools/Clear

var current_player = PlayerQuery.Player1
var current_color = ColorQuery.Color1
var current_tool = DrawingTools.Pencil

func _ready():
	P1C1_button.connect("pressed",self,"pressed_button",["Color1",Color.red])
	P1C2_button.connect("pressed",self,"pressed_button",["Color2",Color.yellow])
	P2C1_button.connect("pressed",self,"pressed_button",["Color1",Color.green])
	P2C2_button.connect("pressed",self,"pressed_button",["Color2",Color.cyan])
	
	bucket.connect("pressed",self,"pressed_button",["Bucket"])
	pencil.connect("pressed",self,"pressed_button",["Pencil"])
	change.connect("pressed",self,"pressed_button",["Change"])
	clear.connect("pressed",self,"pressed_button",["Clear"])
	
func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_pos = event.position
		if TL.position.x<mouse_pos.x:
			mouse_pos.x -= TL.position.x
			match current_tool:
				DrawingTools.Bucket:
					DrawingPanel.use_bucket(mouse_pos)
				DrawingTools.Pencil:
					DrawingPanel.use_pencil(mouse_pos)

func pressed_button(attrs,color = Color.black):
	match attrs:
		"Color1":
			if current_player == PlayerQuery.Player1: 
				P1C1_button.pressed = true
				P1C2_button.pressed = false
				P2C1_button.pressed = false
				P2C2_button.pressed = false
				DrawingPanel.selected_color = color
			elif current_player == PlayerQuery.Player2:
				P1C1_button.pressed = false
				P1C2_button.pressed = false
				P2C1_button.pressed = true
				P2C2_button.pressed = false
				DrawingPanel.selected_color = color
			current_color = ColorQuery.Color1
		"Color2":
			if current_player == PlayerQuery.Player1: 
				P1C1_button.pressed = false
				P1C2_button.pressed = true
				P2C1_button.pressed = false
				P2C2_button.pressed = false
				DrawingPanel.selected_color = color
			elif current_player == PlayerQuery.Player2:
				P1C1_button.pressed = false
				P1C2_button.pressed = false
				P2C1_button.pressed = false
				P2C2_button.pressed = true
				DrawingPanel.selected_color = color
			current_color = ColorQuery.Color2
		"Bucket":
			current_tool = DrawingTools.Bucket
			bucket.pressed = true
			pencil.pressed = false
			if current_player == PlayerQuery.Player1: 
				P1C1_button.pressed = true
				P1C2_button.pressed = false
				P2C1_button.pressed = false
				P2C2_button.pressed = false
				DrawingPanel.selected_color = color
				match current_color:
					ColorQuery.Color1:
						DrawingPanel.selected_color = Color.red
					ColorQuery.Color2:
						DrawingPanel.selected_color = Color.yellow
			elif current_player == PlayerQuery.Player2:
				P1C1_button.pressed = false
				P1C2_button.pressed = false
				P2C1_button.pressed = true
				P2C2_button.pressed = false
				DrawingPanel.selected_color = color
				match current_color:
					ColorQuery.Color1:
						DrawingPanel.selected_color = Color.green
					ColorQuery.Color2:
						DrawingPanel.selected_color = Color.cyan
		"Pencil":
			current_tool = DrawingTools.Pencil
			DrawingPanel.selected_color = color
			bucket.pressed = false
			pencil.pressed = true
			P1C1_button.pressed = false
			P1C2_button.pressed = false
			P2C1_button.pressed = false
			P2C2_button.pressed = false
		"Change":
			match current_player:
				PlayerQuery.Player1: 
					current_player = PlayerQuery.Player2
				PlayerQuery.Player2: 
					current_player = PlayerQuery.Player1
		"Clear":
			DrawingPanel.clear()
	
func _process(_delta):
	match current_player:
		PlayerQuery.Player1:
			P1C1_button.disabled = false
			P1C2_button.disabled = false
			P2C1_button.disabled = true
			P2C2_button.disabled = true
		PlayerQuery.Player2:
			P1C1_button.disabled = true
			P1C2_button.disabled = true
			P2C1_button.disabled = false
			P2C2_button.disabled = false
	match current_tool:
		DrawingTools.Pencil:
			pencil.pressed = true
			bucket.pressed = false
		DrawingTools.Bucket:
			pencil.pressed = false
			bucket.pressed = true
