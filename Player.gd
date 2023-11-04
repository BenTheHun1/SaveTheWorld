extends KinematicBody2D


const SPEED = 80
const SPRINT_SPEED = 160
var speed
var movedir = Vector2(0,0)
var lastmotion
var canAsk = false
var motion
var parent
var animspeed
var selected_obj
var selected_obj2_1
var selected_obj2_2

var bag_full = [0, 30]
var money = 0
var dir_step = 0

var busy = false
var action = false
var boom = false
var idle = false
var inv_out = false
var dontextend = false
var menumode = false
func _ready():
	parent = get_parent()

func _physics_process(delta):
	controls_loop()
	movement_loop()
	
	if Input.is_action_just_pressed("ui_left") and menumode == true:
		get_parent().moveCursor("l")
	elif Input.is_action_just_pressed("ui_right") and menumode == true:
		get_parent().moveCursor("r")
	if Input.is_action_just_pressed("inv") and dontextend == false:
		extendInv()
	if Input.is_action_just_pressed("debug"):
		get_parent().loadGame()
	if Input.is_action_just_pressed("ui_accept") and menumode == true:
		get_parent().confirm()
	elif Input.is_action_just_pressed("ui_accept") and action == false and menumode == false:
		action = true
		$Punch.play()
		if selected_obj != null and busy == false:
			if inv_out == true:
				extendInv()
			if selected_obj == "greenbin":
				get_parent().slowtype_presentChoice("Recycle all Bottles?", "Yes", "No")
			elif selected_obj == "bluebin":
				get_parent().slowtype_presentChoice("Recycle all Cans?", "Yes", "No")
			elif selected_obj == "trashbin":
				get_parent().slowtype_presentChoice("Throw away any non-recyclable trash and weeds?", "Yes", "No")
			elif selected_obj == "recycler":
				if get_parent().payout > 0:
					get_parent().slowtype("Looks like you've recycled " + String(get_parent().payout) + " bottles and cans. Here's $" + String(get_parent().payout) + " for your efforts.")
					changeMoney(get_parent().payout)
					get_parent().payout = 0
				else:
					get_parent().slowtype("Let me know when you recycle any of the stuff you find out there, and I'll compensate you.")
			elif selected_obj == "mech":
				get_parent().slowtype_presentChoice("I can take any Parts off of you. Want me to?", "Sure", "No")
			elif selected_obj == "director":
				if money >= 500 and dir_step == 1:
					get_parent().slowtype("Wow, thanks a ton! We've met our goal for today, but feel free to keep collecting. Every little bit helps!")
					money -= 500
					dir_step == 2
				elif dir_step == 0:
					get_parent().slowtype("Hey, thanks for coming out and volunteering. We're aiming for a goal of $500 to donate.")
					dir_step = 1
				elif dir_step >= 1:
					get_parent().slowtype_presentChoice("How are you making out? By the way, If you find any Sand Dollars, I'll take them off your hands for $1 a piece. Have you found any?", "Yeah", "No")
		elif selected_obj2_1 != null and bag_full[0] < bag_full[1]:
			var trash = parent.get_child(selected_obj2_2)
			var trashtype = trash.anim
			parent.addToInv(trashtype, 1)
			bag_full[0] += 1
			bagCheck()
			trash.queue_free()
		match lastmotion:
			"d":
				$Sprite.play("faction")
			"l":
				$Sprite.play("laction")
			"r":
				$Sprite.play("raction")
			"u":
				$Sprite.play("baction")
		for i in range(animspeed * 25):
				yield(get_tree(), "idle_frame")
		action = false

func controls_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
		$Sprite.speed_scale = 2
	else:
		speed = SPEED
		$Sprite.speed_scale = 1

func movement_loop():
	if busy == false:
		
		motion = movedir.normalized() * speed
		
		move_and_slide(motion, Vector2(0,0))
		if motion.x < 0:
			boom = false
			idle = false
			if not action:
				$Sprite.play("smove")
			$Sprite.flip_h = false
			lastmotion = "l"
		elif motion.x > 0:
			boom = false
			idle = false
			if not action:
				$Sprite.play("smove")
			$Sprite.flip_h = true
			lastmotion = "r"
		elif motion.y > 0:
			boom = false
			idle = false
			if not action:
				$Sprite.play("fmove")
			$Sprite.flip_h = false
			lastmotion = "d"
		elif motion.y < 0:
			boom = false
			idle = false
			if not action:
				$Sprite.play("bmove")
			$Sprite.flip_h = false
			lastmotion = "u"
		else:
			if boom == false:
				boom = true
				$Timer.start(5)
			if idle == false:
				if lastmotion == "d" and not action:
					$Sprite.flip_h = false
					$Sprite.play("fidle")
					
				elif lastmotion == "u"and not action:
					$Sprite.flip_h = false
					$Sprite.play("bidle")
					
				elif lastmotion == "l"and not action:
					$Sprite.flip_h = false
					$Sprite.play("sidle")
					
				elif lastmotion == "r"and not action:
					$Sprite.flip_h = true
					$Sprite.play("sidle")

func setStop(stat):
	if stat == true:
		busy = true
	else:
		busy = false

func _on_Timer_timeout():
	idle = true
	#$Sprite.play("waiting")

func _on_ObjDetect_area_entered(area):
	if area.is_in_group("trash"):
		selected_obj2_1 = area.get_index()
		selected_obj2_2 = area.get_parent().get_index()
		print("Selected: Trash")
	elif area.is_in_group("greenbin"):
		selected_obj = "greenbin"
		print("Selected: Green Bin")
	elif area.is_in_group("bluebin"):
		selected_obj = "bluebin"
		print("Selected: Blue Bin")
	elif area.is_in_group("trashbin"):
		selected_obj = "trashbin"
		print("Selected: Trash Bin")
	elif area.is_in_group("recycler"):
		selected_obj = "recycler"
		print("Selected: Recycler NPC")
	elif area.is_in_group("mechanic"):
		selected_obj = "mech"
		print("Selected: Mechanic NPC")
	elif area.is_in_group("director"):
		selected_obj = "director"
		print("Selected: Director NPC")

func extendInv():
	dontextend = true
	var inv = parent.get_node("CanvasLayer/INV")
	if inv_out == false:
		for i in range(117):
			for _i in range(animspeed):
				yield(get_tree(), "idle_frame")
			inv.position[0] -= 1
		inv_out = true
	else:
		for i in range(117):
			for _i in range(animspeed):
				yield(get_tree(), "idle_frame")
			inv.position[0] += 1
		inv_out = false
	dontextend = false

func bagCheck():
	var bag = parent.get_node("CanvasLayer/INV/BAG")
	if bag_full[0] == 0:
		bag.frame = 0
	elif bag_full[0] <= bag_full[1] / 2:
		bag.frame = 1
	elif bag_full[0] == bag_full[1]:
		bag.frame = 3
	else:
		bag.frame = 2
		
func _on_ObjDetect_area_exited(area):
	if area.is_in_group("trash"):
		selected_obj2_1 = null
		selected_obj2_2 = null
		print("Selected: None")
	elif area.is_in_group("bluebin") or area.is_in_group("greenbin") or area.is_in_group("trashbin") or area.is_in_group("recycler") or area.is_in_group("mechanic") or area.is_in_group("director"):
		selected_obj = null
		print("Selected: None")

func changeMoney(num):
	money += num
	get_parent().get_node("CanvasLayer/money").text = "$" + String(money)
	
func _process(delta):
	animspeed = 1.0 / delta / 128
	#print(animspeed)

