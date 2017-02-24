
extends CanvasLayer

var item_invent


func _ready():
	Globals.set(get_name(), self)
	
	item_invent = get_node("Panel/ItemInventory")
	set_process(true)
	set_process_input(true)
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		_on_BtnBack_pressed()

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_RIGHT && event.is_pressed()):
		changeItem()
	
	if (event.type == InputEvent.KEY && event.scancode == KEY_CONTROL && event.is_pressed()):
		changeItem()

func changeItem():
	var a = item_invent.get_selected()
	var b = a + 1
	
	#print("hud:b: " + str(b))
	if (b == item_invent.get_button_count()):
		b = 0
	 
	item_invent.set_selected(b)
	main.item_active = b

func _process(delta):
	updateHUD()

func updateHUD():
	get_node("LbLevel").set_text("LEVEL: " + str(main.level))
	get_node("LbStar").set_text("STAR* " + str(main.star_count))
	get_node("LbLife").set_text("$ $ $ $ $")
	get_node("LbFps").set_text("FPS: " + str(OS.get_frames_per_second()))

# call from Stage::ready
func setInventory():
	#print("HUD: " + str(main.item_flying_up))

	if (main.item_flying_up):
		item_invent.add_icon_button(load("res://image/fruit_1.png"), str(main.item_flying_up))
		main.item_inventories.append(main.TYPE_FLYINGUP)   
	
	if (main.item_speed_up):
		item_invent.add_icon_button(load("res://image/fruit_2.png"), str(main.item_speed_up))
		main.item_inventories.append(main.TYPE_SPEEDUP)
		
	if (main.item_speed_down):
		item_invent.add_icon_button(load("res://image/fruit_3.png"), str(main.item_speed_down))
		main.item_inventories.append(main.TYPE_SPEEDDOWN)   
	
	main.item_active = item_invent.get_selected()
	


# call from Stage::_input
func updateInventory():
	item_invent.set_button_text(main.item_active, str(main.getItemCount()))

func _on_ItemInventory_button_selected( button_idx ):
	main.item_active = button_idx

func _on_BtnBack_pressed():
	get_tree().change_scene("res://scene/Menu.tscn")
	
