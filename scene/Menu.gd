extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	if (OS.get_name() == "Android"):
		get_node("LbInfo").set_hidden(true)
	
	set_process(true)
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		get_tree().quit()

func _process(delta):
	get_node("LbFps").set_text("FPS: " + str(OS.get_frames_per_second()))

func _on_Level1_pressed():
	main.level = 1
	get_tree().change_scene("res://scene/Stage_1.tscn")

func _on_Level2_pressed():
	main.level = 2
	get_tree().change_scene("res://scene/Stage_2.tscn")

func _on_Level3_pressed():
	main.level = 3
	get_tree().change_scene("res://scene/Stage_3.tscn")
