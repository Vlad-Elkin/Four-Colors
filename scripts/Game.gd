extends Control

func _ready():
	get_tree().paused = false

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().paused = true
		$Menu.show()
		fsm.blocking = true


func _on_Resume_pressed():
	$Menu.hide()
	get_tree().paused = false
	fsm.blocking = false


func _on_Restart_pressed():
	fsm.blocking = false
	var _status = get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().quit()
 

func _on_CanvasPanel_end_game(result):
	if result == null: return
	fsm.blocking = true
	if result == "same_color":
		$Popup/Player.text = "Игрок %d" % fsm.player_get_as_int()
	if result == "complete_fill":
		$Popup/Label.text = "Теорема"
		$Popup/Player.text = "Потверждена"
	$Popup.show()
	$PauseBG.show()
	get_tree().paused = true
