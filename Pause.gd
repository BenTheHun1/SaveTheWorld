extends Control


func _input(event):
	if event.is_action_pressed("pause"):
		var new_paused_state = not get_tree().paused
		get_parent().get_parent().is_paused = new_paused_state
		get_tree().paused = new_paused_state
		self.visible = new_paused_state
		if new_paused_state == false:
			get_parent().get_parent().spawn()

func _on_btnResume_button_up():
	var new_paused_state = not get_tree().paused
	get_parent().get_parent().is_paused = new_paused_state
	get_tree().paused = new_paused_state
	self.visible = new_paused_state
	if new_paused_state == false:
		get_parent().get_parent().spawn()

func _on_btnQuit_button_up():
	_on_btnSave_button_up()
	get_tree().quit()

func _on_btnSave_button_up():
	var inv = get_parent().get_parent().get_node("CanvasLayer/INV/ItemList")
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(String(get_parent().get_parent().get_node("Player").money))
	save_game.store_line(String(get_parent().get_parent().get_node("Player").bag_full[0]))
	save_game.store_line(String(get_parent().get_parent().get_node("Player").dir_step))
	save_game.store_line(String(get_parent().get_parent().payout))
	save_game.store_line(String(get_parent().get_parent().totalparts))
	save_game.store_line(String(get_parent().get_parent().get_node("Player").position[0]))
	save_game.store_line(String(get_parent().get_parent().get_node("Player").position[1]))
	for i in range(inv.get_item_count()):
		save_game.store_line(inv.get_item_text(i))
	save_game.close()


func _on_Button_button_up():
	var home = Vector2(1130,-195)
	get_parent().get_parent().get_node("Player").position = home
