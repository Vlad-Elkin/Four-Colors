extends Panel

onready var _parent = get_parent()
onready var CanvasPanel = _parent.get_node(@"CanvasPanel")
onready var popup = _parent.get_node(@"Popup")
onready var popupLabel = popup.get_node(@"Label")
onready var popupPlayer = popup.get_node(@"Player")
onready var popupRestart = popup.get_node("Restart")
onready var P1C1 = $Player1/Color1
onready var P1C2 = $Player1/Color2
onready var P2C1 = $Player2/Color1
onready var P2C2 = $Player2/Color2
onready var pencil = $Tools/Line
onready var bucket = $Tools/Fill
onready var paint = $Tools/Fill/Bucket/Paint
onready var restart = $Tools/Restart
enum PlayerQuery{
	Player1 = 1,Player2 = 2
}
enum ColorQuery{
	Color1,Color2
}
enum Tools{
	Pencil, Bucket
}
var current_player = PlayerQuery.Player1
var current_color = ColorQuery.Color1
var current_tool = Tools.Pencil
var blocking = false

func _ready():
	P1C1.connect("pressed",self,"handle",["Color",ColorQuery.Color1])
	P1C2.connect("pressed",self,"handle",["Color",ColorQuery.Color2])
	P2C1.connect("pressed",self,"handle",["Color",ColorQuery.Color1])
	P2C2.connect("pressed",self,"handle",["Color",ColorQuery.Color2])
	pencil.connect("pressed",self,"handle",["Tool",Tools.Pencil])
	bucket.connect("pressed",self,"handle",["Tool",Tools.Bucket])
	restart.connect("pressed",self,"handle",["Restart"])
	popupRestart.connect("pressed",self,"handle",["Restart"])

func handle(mode,value = null):
	match mode:
		"Color": current_color = value
		"Tool": current_tool = value
		"Change":
			match current_player:
				PlayerQuery.Player1:
					current_player = PlayerQuery.Player2
				PlayerQuery.Player2:
					current_player = PlayerQuery.Player1
		"Clear": CanvasPanel.clear()
		"Restart": var _status = get_tree().reload_current_scene()

func _input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	var pos = mouse_pos - CanvasPanel.rect_global_position
	if not blocking:
		match current_tool:
			Tools.Pencil:
				#pressed
				if event is InputEventScreenTouch and event.pressed:
					CanvasPanel.pressed = true
					CanvasPanel.use_pencil(pos)
				#dragged
				if event is InputEventScreenDrag:
					CanvasPanel.use_pencil(pos)
				#released
				if event is InputEventScreenTouch and !event.pressed:
					CanvasPanel.use_pencil(pos)
					CanvasPanel.pressed = false
					CanvasPanel.last_pos = null
			Tools.Bucket:
				#pressed
				if event is InputEventScreenTouch and event.pressed:
					current_tool = Tools.Pencil
					match current_player:
						PlayerQuery.Player1:
							current_player = PlayerQuery.Player2
						PlayerQuery.Player2:
							current_player = PlayerQuery.Player1
					var result = CanvasPanel.use_bucket(pos)
					match result:
						"same_color":
							blocking = true
							popup.visible = true
							popupPlayer.text = "Игрок %d" % current_player
						"complete_fill":
							blocking = true
							popup.visible = true
							popupLabel.text = "Теорема"
							popupPlayer.text = "Потверждена"

func _process(_delta):
	var is_Player1 = current_player == PlayerQuery.Player1
	var is_Player2 = current_player == PlayerQuery.Player2
	var is_Color1 = current_color == ColorQuery.Color1
	var is_Color2 = current_color == ColorQuery.Color2
	var is_Bucket = current_tool == Tools.Bucket
	var is_Pencil = current_tool == Tools.Pencil
	P1C1.disabled = !is_Player1
	P1C2.disabled = !is_Player1
	P2C1.disabled = !is_Player2
	P2C2.disabled = !is_Player2
	$Player1/Label.modulate = Color.yellow if is_Player1 else Color.white
	$Player2/Label.modulate = Color.yellow if is_Player2 else Color.white
	bucket.pressed = is_Bucket
	pencil.pressed = is_Pencil
	P1C1.pressed = is_Player1 and is_Color1 and is_Bucket
	P1C2.pressed = is_Player1 and is_Color2 and is_Bucket
	P2C1.pressed = is_Player2 and is_Color1 and is_Bucket
	P2C2.pressed = is_Player2 and is_Color2 and is_Bucket
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
