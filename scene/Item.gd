extends Area2D

var timer
var item_type = 1
var is_flyingup = false
var is_speedup = false
var is_speeddown = false

var players = []
var taken = false


func _ready():
	item_type = main.item_inventories[main.item_active]
	
	if (item_type == main.TYPE_FLYINGUP):
		get_node("Sprite").set_texture(preload("res://image/fruit_1.png"))
		is_flyingup = true
	elif (item_type == main.TYPE_SPEEDUP):
		get_node("Sprite").set_texture(preload("res://image/fruit_2.png"))
		is_speedup = true
	elif (item_type == main.TYPE_SPEEDDOWN):
		get_node("Sprite").set_texture(preload("res://image/fruit_3.png"))
		is_speeddown = true
	
	timer = get_node("Timer")
	timer.set_wait_time(2)
	timer.start()
	
	# add timer delay before active
	
	pass

func getType():
	return item_type

func _on_Timer_timeout():
	disable()
	get_node("AnimPlayer").play("fade_out")

func disable():
	get_node("Collision").set_trigger(true)
	#remove_from_group(main.ITEM_GROUPS)

func _on_AnimPlayer_finished():
	queue_free()

func _on_Item_body_enter( body ):
	if body extends preload("res://scene/Player.gd"):
		if (not taken):
			#get_node("sound").play("shine")
			players.push_back(body)
			get_node("Sprite").hide()
			get_node("Collision").set_trigger(true)
			get_node("Particles").set_emitting(true)
			get_node("Timer").stop()
			get_node("Timer").set_wait_time(1)
			get_node("Timer").start()
			disable()
			taken = true
			
			if (is_flyingup):
				body.is_flyingup = true
			elif (is_speedup):
				body.is_speedup = true
			elif (is_speeddown):
				body.is_speeddown = true
			
			#print("item:speedup: " + str(is_speedup))


func _on_Item_body_exit( body ):
	if body extends preload("res://scene/Player.gd"):
		players.erase(body)
