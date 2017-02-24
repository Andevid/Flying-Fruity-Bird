extends Node2D

export var item_flyingup = 0
export var item_speedup = 0
export var item_speed_down = 0


func _ready():
	Globals.set(get_name(), self)
	
func initItem():
	main.addItemFlyingup(item_flyingup)
	main.addItemSpeedup(item_speedup)
	main.addItemSpeeddown(item_speed_down)
	
	#print("level: " + str(item_flyingup))
	pass

