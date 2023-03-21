extends Panel


onready var _parent = get_parent()
onready var CanvasPanel = _parent.get_node(@"CanvasPanel")
onready var popup = _parent.get_node(@"Popup")
onready var popupPlayer = popup.get_node(@"Player")
onready var restart = popup.get_node("Restart")

onready var P1C1_button = $Player1/Color1
onready var P1C2_button = $Player1/Color2
onready var P2C1_button = $Player2/Color1
onready var P2C2_button = $Player2/Color2
onready var pencil = $Tools/Line
onready var bucket = $Tools/Fill
onready var change = $Tools/Change
onready var clear = $Tools/Clear
onready var paint = $Tools/Fill/Bucket/Paint


enum PlayerQuery{
	Player1 = 2,Player2 = 1
}
enum ColorQuery{
	Color1,Color2
}
enum DrawingTools{
	Pencil, Bucket
}

var current_player = PlayerQuery.Player1
var current_color = ColorQuery.Color1
var current_tool = DrawingTools.Pencil

var blocking = false

func _ready():
	P1C1_button.connect("pressed",self,"handle_btn",["Color",ColorQuery.Color1])
	P1C2_button.connect("pressed",self,"handle_btn",["Color",ColorQuery.Color2])
	P2C1_button.connect("pressed",self,"handle_btn",["Color",ColorQuery.Color1])
	P2C2_button.connect("pressed",self,"handle_btn",["Color",ColorQuery.Color2])
	pencil.connect("pressed",self,"handle_btn",["Tool",DrawingTools.Pencil])
	bucket.connect("pressed",self,"handle_btn",["Tool",DrawingTools.Bucket])
	change.connect("pressed",self,"handle_btn",["Change"])
	clear.connect("pressed",self,"handle_btn",["Clear"])
	restart.connect("pressed",self,"handle_btn",["Restart"])

func _input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	var pos = mouse_pos - CanvasPanel.rect_global_position
	if not blocking:
		match current_tool:
			DrawingTools.Pencil:
				if event is InputEventMouseButton or event is InputEventScreenTouch:
					if !event.pressed:
						CanvasPanel.last_pos = null
					CanvasPanel.pressed = event.pressed
				CanvasPanel.use_pencil(pos)
			DrawingTools.Bucket:
				if event is InputEventMouseButton or event is InputEventScreenTouch:
					if event.pressed:
						var is_loss = CanvasPanel.use_bucket(pos)
						if is_loss==true:
							blocking = true
							popup.visible = true
							popupPlayer.text = "Игрок %d" % current_player
func _process(_delta):
	var is_Player1 = current_player == PlayerQuery.Player1
	var is_Player2 = current_player == PlayerQuery.Player2
	var is_Color1 = current_color == ColorQuery.Color1
	var is_Color2 = current_color == ColorQuery.Color2
	var is_Bucket = current_tool == DrawingTools.Bucket
	var is_Pencil = current_tool == DrawingTools.Pencil
	
	P1C1_button.disabled = !is_Player1
	P1C2_button.disabled = !is_Player1
	P2C1_button.disabled = !is_Player2
	P2C2_button.disabled = !is_Player2
	$Player1/Label.modulate = Color.yellow if is_Player1 else Color.white
	$Player2/Label.modulate = Color.yellow if is_Player2 else Color.white
	
	bucket.pressed = is_Bucket
	pencil.pressed = is_Pencil
	
	P1C1_button.pressed = is_Player1 and is_Color1 and is_Bucket
	P1C2_button.pressed = is_Player1 and is_Color2 and is_Bucket
	P2C1_button.pressed = is_Player2 and is_Color1 and is_Bucket
	P2C2_button.pressed = is_Player2 and is_Color2 and is_Bucket
	
	if is_Player1 and is_Color1:
		paint.modulate = Color(1,0,0)
		CanvasPanel.selected_color = Color(1,0,0)
	if is_Player1 and is_Color2:
		paint.modulate = Color(0,1,1)
		CanvasPanel.selected_color = Color(0,1,1)
	if is_Player2 and is_Color1:
		paint.modulate = Color(0.5,1,0)
		CanvasPanel.selected_color = Color(0.5,1,0)
	if is_Player2 and is_Color2:
		paint.modulate = Color(0.5,0,1)
		CanvasPanel.selected_color = Color(0.5,0,1)
		
func handle_btn(mode,value = null):
	match mode:
		"Color":
			current_color = value
		"Tool":
			current_tool = value
		"Change":
			match current_player:
				PlayerQuery.Player1:
					current_player = PlayerQuery.Player2
				PlayerQuery.Player2:
					current_player = PlayerQuery.Player1
		"Clear":
			CanvasPanel.clear()
		"Restart":
			var _status = get_tree().reload_current_scene()
