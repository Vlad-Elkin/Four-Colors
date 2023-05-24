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

func _ready():
	P1C1.connect("pressed",self,"handle",["Color","COLOR_1"])
	P1C2.connect("pressed",self,"handle",["Color","COLOR_2"])
	P2C1.connect("pressed",self,"handle",["Color","COLOR_1"])
	P2C2.connect("pressed",self,"handle",["Color","COLOR_2"])
	pencil.connect("pressed",self,"handle",["Tool","PENCIL"])
	bucket.connect("pressed",self,"handle",["Tool","BUCKET"])

func handle(mode,value = null):
	match mode:
		"Color": fsm.current_color = value
		"Tool": fsm.current_tool = value
		"Undo": emit_signal("undo")

func _process(_delta):
	var is_Player1 = fsm.current_player == "PLAYER_1"
	var is_Player2 = fsm.current_player == "PLAYER_2"
	var is_Color1 = fsm.current_color == "COLOR_1"
	var is_Color2 = fsm.current_color == "COLOR_2"
	var is_Bucket = fsm.current_tool == "BUCKET"
	var is_Pencil = fsm.current_tool == "PENCIL"
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
