extends Node2D

var ver = "1.2.3"
var clog = "- 1.2.3 -\n-Added a Windows icon\n- 1.2.2 -\n-Save and Quit button is hidden in the HTML5 version\n- 1.2.1 -\n-Updated to Godot 3.5.2\n-Added missing pixel to logo\n-Added a simple icon\n-Fixed Quit button appearing in the HTML version\n-Text speed now is based on framerate, should be fairly consistent between platforms\n-Tweaked Changelog formatting\n- 1.2.0 -\n-Updated to Godot 3.3.2\n-Compressed waves ambient sound to improve performance\n-Slowed down text speed, once again\n- 1.1.2 -\n-Added wave and action sound effects.\n-Removed extraneous tiles to slightly improve performance.\n-Restyle buttons to make them more aesthetic.\n- 1.1.1 -\n-Updated to Godot 3.2.3\n-Slowed down text speed to accodomodate improved performance.\n- 1.1.0 -\n-Updated to Godot 3.2.2. Performance should be much improved.\n-Fixed inconsistent button styling when clicked\n-Improved rock Hitboxes, which then required extra rocks to be added.\n- 1.0.2 -\n-Moved Changelog to bottom right, as it was obscuring the Delete Save button\n- 1.0.1 -\n-Patched up hole in southern rocks that could let you out of bounds.\n-If you were already out of bounds, there is a new 'Stuck' button in the Pause menu that teleports you somewhere inconvenient, but in-bounds.\n-Added a changelog, which you are reading now.\n-Hid Title Screen 'Quit' button, which has no function in HTML5"
var save_exists = false
var clog_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Control/ver.text = "v" + ver
	$CanvasLayer/Control/clog_bg/clog.text = clog
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		$CanvasLayer/Control/btnDelSave.visible = true
	else:
		$CanvasLayer/Control/btnDelSave.visible = false
	if OS.get_name() == "HTML5":
		$CanvasLayer/Control/btnQuit.visible = false
	if $CanvasLayer/Control/clog_bg.visible == true:
		$CanvasLayer/Control/clog_bg.visible = false

func _on_btnStart_button_up():
	get_tree().change_scene("res://main.tscn")

func _on_btnQuit_button_up():
	get_tree().quit()

func _on_btnDelSave_button_up():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	$CanvasLayer/Control/btnDelSave.visible = false


func _on_btnChangelog_button_up():
	if clog_open == false:
		$CanvasLayer/Control/clog_bg.visible = true
		$CanvasLayer/Control/btnChangelog.text = "Close"
		clog_open = true
	else:
		$CanvasLayer/Control/clog_bg.visible = false
		$CanvasLayer/Control/btnChangelog.text = "Changelog"
		clog_open = false
