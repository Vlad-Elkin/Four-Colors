extends Node

enum PLAYER_STATES{PLAYER_1,PLAYER_2}
enum COLOR_STATES{COLOR_1,COLOR_2}
enum TOOL_STATES{PENCIL,BUCKET}

var current_player = PLAYER_STATES.PLAYER_1 setget player_set,player_get
var current_color = COLOR_STATES.COLOR_1 setget color_set,color_get
var current_tool = TOOL_STATES.PENCIL setget tool_set,tool_get

var blocking:bool = false

func player_set(value):
	current_player = PLAYER_STATES.get(value)

func player_get():
	return PLAYER_STATES.keys()[current_player]

func player_get_as_int():
	return current_player+1
	
func player_switch():
	match current_player:
		PLAYER_STATES.PLAYER_1: current_player = PLAYER_STATES.PLAYER_2
		PLAYER_STATES.PLAYER_2: current_player = PLAYER_STATES.PLAYER_1

func color_set(value):
	current_color = COLOR_STATES.get(value)

func color_get():
	return COLOR_STATES.keys()[current_color]

func color_switch():
	match current_color:
		COLOR_STATES.COLOR_1: current_color = COLOR_STATES.COLOR_2
		COLOR_STATES.COLOR_2: current_color = COLOR_STATES.COLOR_1

func tool_set(value):
	current_tool = TOOL_STATES.get(value)

func tool_get():
	return TOOL_STATES.keys()[current_tool]

func tool_switch():
	match current_tool:
		TOOL_STATES.PENCIL: current_tool = TOOL_STATES.BUCKET
		TOOL_STATES.BUCKET: current_tool = TOOL_STATES.PENCIL
