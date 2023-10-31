extends StaticBody2D

var anim

# Called when the node enters the scene tree for the first time.
func _ready():
	var select = round(rand_range(0,100))
	#print(select)
	if select <= 3:
		anim = "Robot Part"
		$AnimatedSprite.animation = anim
	elif select <= 10:
		anim = "Sand Dollar"
		$AnimatedSprite.animation = anim
	elif select <= 25:
		anim = "Weed"
		$AnimatedSprite.animation = anim
	elif select <= 40:
		anim = "Trash"
		$AnimatedSprite.animation = anim
		$AnimatedSprite.frame = round(rand_range(0,$AnimatedSprite.frames.get_frame_count(anim)-1))
	elif select <= 60:
		anim = "Bottle"
		$AnimatedSprite.animation = anim
	else:
		anim = "Can"
		$AnimatedSprite.animation = anim
		$AnimatedSprite.frame = round(rand_range(0,$AnimatedSprite.frames.get_frame_count(anim)-1))
