
extends Node2D

var itm_scn = preload("res://scene/Item.tscn")
var player_scn = preload("res://scene/Player.tscn")
var target_scn = preload("res://scene/Target.tscn")

var player
var touch_counter = 0

var is_enable = true


func _ready():
	Globals.set(get_name(), self)
	
	main.resetGame()
	
	get_node("Level").initItem()
	get_node("HUD").setInventory()
	get_node("HUD").updateHUD()
	
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	#to enable this set on emulate_touchscreen in project settings
	#if (event.type == InputEvent.SCREEN_TOUCH && event.is_pressed() && is_enable):
	if (event.type == InputEvent.MOUSE_BUTTON && event.is_pressed() && is_enable && event.button_index == BUTTON_LEFT):
		# alternative to get_global_mouse_pos() --- 100% work 
		#var pos_a = event.global_pos - get_global_transform_with_canvas().get_origin()
		# if Camera zoom not set to 1, pos_a * camera_zoom
		var pos_a = get_global_mouse_pos()
		
		if (event.x > 200 && pos_a.y > -320):
			if (main.getItemCount() >= 1):
				#play sound spawn item
				var item = itm_scn.instance()
				
				# working normally on Android, fixed.
				#item.set_global_pos(get_global_mouse_pos())
				
				# working normally on Android
				item.set_global_pos(pos_a)
				get_node("Items").add_child(item)
				main.addItem(-1)
				get_node("HUD").updateInventory()
				is_enable = false
			else:
				#play sound item not available
				pass
		elif (pos_a.y < -320):
			get_node("HUD/LbInfo").set_text("The Bird flying too high! It's dangerous!")
			pass


func _fixed_process(delta):
	if (not is_enable):
		touch_counter += delta
		
		if (touch_counter >= 0.5):
			is_enable = true
			touch_counter = 0

# trigger from anywhere
func reloadCurrentScene():
	get_tree().reload_current_scene()
