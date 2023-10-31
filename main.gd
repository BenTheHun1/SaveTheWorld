extends Node2D

var is_paused = false
var selected_obj
#var selection_enable = true
var textspeed
var textspeedmulti = 64 #64 for offline, 8 or less for web
var filled_points = []
onready var inv = $CanvasLayer/INV/ItemList
var trashresource = load("res://trash.tscn")
var selectedMenuOption = "l"

var tempBuffer = 0
var payout = 0
var totalparts = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var num = -123.123213
	$CanvasLayer/box_bg.visible = false
	$CanvasLayer/box_bg/choice1.visible = false
	$CanvasLayer/box_bg/choice2.visible = false
	$PauseMenu/Pause.visible = false
	print("Selected: None")
	selected_obj = null
	randomize()
	loadGame()
	spawn()
	if OS.get_name() == "HTML5":
		$PauseMenu/Pause/btnQuit.visible = false

func slowtype(text):
	$CanvasLayer/box_bg/choice1.visible = false
	$CanvasLayer/box_bg/choice2.visible = false
	
	$Player.dontextend = true
	$Player.setStop(true)
	$Player.menumode = false
	
	$CanvasLayer/box_bg/box_txt.text = text
	$CanvasLayer/box_bg.visible = true
	$CanvasLayer/box_bg/box_txt.visible_characters = 0
	while $CanvasLayer/box_bg/box_txt.visible_characters < ($CanvasLayer/box_bg/box_txt.text.length() - ($CanvasLayer/box_bg/box_txt.get_line_count() - 1)):
		for _i in range(textspeed):
			yield(get_tree(), "idle_frame")
		$CanvasLayer/box_bg/box_txt.visible_characters += 1
	
	for _i in range(400):
		yield(get_tree(), "idle_frame")
	
	$Player.dontextend = false
	$CanvasLayer/box_bg.visible = false
	$Player.setStop(false)
	

func slowtype_presentChoice(text, c1, c2):
	$CanvasLayer/box_bg/choice1.visible = false
	$CanvasLayer/box_bg/choice2.visible = false
	
	$Player.dontextend = true
	$Player.setStop(true)
	$CanvasLayer/box_bg/box_txt.text = text
	$CanvasLayer/box_bg.visible = true
	$CanvasLayer/box_bg/box_txt.visible_characters = 0
	while $CanvasLayer/box_bg/box_txt.visible_characters < ($CanvasLayer/box_bg/box_txt.text.length() - ($CanvasLayer/box_bg/box_txt.get_line_count() - 1)):
		for _i in range(textspeed):
			yield(get_tree(), "idle_frame")
		$CanvasLayer/box_bg/box_txt.visible_characters += 1
	
	
	$CanvasLayer/box_bg/choice1/Label.text = c1
	$CanvasLayer/box_bg/choice1.play("select")
	$CanvasLayer/box_bg/choice1.visible = true
	
	$CanvasLayer/box_bg/choice2/Label.text = c2
	$CanvasLayer/box_bg/choice2.play("default")
	$CanvasLayer/box_bg/choice2.visible = true
	
	$Player.menumode = true
	selectedMenuOption = "l"

func presentChoice(c1, c2):
	$CanvasLayer/box_bg/choice1/Label.text = c1
	$CanvasLayer/box_bg/choice1.visible = true
	$CanvasLayer/box_bg/choice1.play("select")
	$CanvasLayer/box_bg/choice2/Label.text = c2
	$CanvasLayer/box_bg/choice2.visible = true
	$Player.menumode = true
	selectedMenuOption = "l"

func moveCursor(dir):
	if dir == "l":
		$CanvasLayer/box_bg/choice1.play("select")
		$CanvasLayer/box_bg/choice2.play("default")
		selectedMenuOption = "l"
	elif dir == "r":
		$CanvasLayer/box_bg/choice2.play("select")
		$CanvasLayer/box_bg/choice1.play("default")
		selectedMenuOption = "r"

func confirm():
	if selectedMenuOption == "l":
		if $Player.selected_obj == "greenbin":
			$CanvasLayer/box_bg/choice1.visible = false
			$CanvasLayer/box_bg/choice2.visible = false
			removeFromInv("Bottle", 99999)
			slowtype("You deposited " + String(tempBuffer) + " bottles. Thank you!")
			payout += tempBuffer
			tempBuffer = 0
			print("Payout: " + String(payout))
		elif $Player.selected_obj == "bluebin":
			$CanvasLayer/box_bg/choice1.visible = false
			$CanvasLayer/box_bg/choice2.visible = false
			removeFromInv("Can", 99999)
			slowtype("You deposited " + String(tempBuffer) + " cans. Thank you!")
			payout += tempBuffer
			tempBuffer = 0
			print("Payout: " + String(payout))
		elif $Player.selected_obj == "mech":
			$CanvasLayer/box_bg/choice1.visible = false
			$CanvasLayer/box_bg/choice2.visible = false
			removeFromInv("Robot Part", 99999)
			slowtype("Maybe I'll find a use for them.")
			totalparts += tempBuffer
			tempBuffer = 0
			print("Total Parts: " + String(totalparts))
		elif $Player.selected_obj == "director":
			$CanvasLayer/box_bg/choice1.visible = false
			$CanvasLayer/box_bg/choice2.visible = false
			removeFromInv("Sand Dollar", 99999)
			slowtype("Thanks.")
			$Player.changeMoney(tempBuffer)
			tempBuffer = 0
		elif $Player.selected_obj == "trashbin":
			$CanvasLayer/box_bg/choice1.visible = false
			$CanvasLayer/box_bg/choice2.visible = false
			removeFromInv("Trash", 99999)
			removeFromInv("Weed", 99999)
			slowtype("Trashed.")
	elif selectedMenuOption == "r":
		$Player.menumode = false
		$CanvasLayer/box_bg.visible = false
		$Player.setStop(false)
		$Player.dontextend = false
		

func spawn():
	
	var yes = true
	var total_points = $validpoints.get_child_count()
	
	while filled_points.size() < total_points and is_paused == false:
		var selected_point = round(rand_range(1, total_points))
		if filled_points.has(selected_point):
			pass
		else:
			for _i in range(1000):
				yield(get_tree(), "idle_frame")
			
			#print(selected_point)
			var trash = trashresource.instance()
			add_child(trash)
			trash.position = get_node("validpoints/" + String(selected_point)).position
			
			filled_points.append(selected_point)

func addToInv(type, num):
	var foundit = false
	for i in range(inv.get_item_count()):
		if inv.get_item_text(i) == type:
			inv.set_item_text(i+1, String(num + int(inv.get_item_text(i+1))))
			foundit = true
	if foundit != true:
		inv.add_item(type, null, false)
		inv.add_item(String(num), null, false)
	for i in range(inv.get_item_count()):
		inv.set_item_tooltip_enabled(i, false)

func removeFromInv(type, num):
	for i in range(inv.get_item_count()):
		if inv.get_item_text(i) == type:
			if int(num) == 99999:
				tempBuffer = int(inv.get_item_text(i+1))
				#print("Buffer: " + String(tempBuffer))
				inv.remove_item(i+1)
				inv.remove_item(i)
				
			else:
				inv.set_item_text(i+1, String(-num + int(inv.get_item_text(i+1))))
				if int(inv.get_item_text(i+1)) <= 0:
					inv.remove_item(i+1)
					inv.remove_item(i)
	if tempBuffer != 0:
		$Player.bag_full[0] -= tempBuffer
	for i in range(inv.get_item_count()):
		inv.set_item_tooltip_enabled(i, false)
	$Player.bagCheck()

func loadGame():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	save_game.open("user://savegame.save", File.READ)
	$Player.money = int(save_game.get_line())
	$Player.bag_full[0] = int(save_game.get_line())
	$Player.dir_step = int(save_game.get_line())
	payout = int(save_game.get_line())
	totalparts = int(save_game.get_line())
	$Player.position[0] = float(save_game.get_line())
	$Player.position[1] = float(save_game.get_line())
	while save_game.get_position() < save_game.get_len():
		inv.add_item(save_game.get_line(), null)
	save_game.close()
	$Player.bagCheck()
	$CanvasLayer/money.text = "$" + String($Player.money)
	
func _process(delta):
	textspeed = 1.0 / delta / textspeedmulti
	#print(textspeed)
