extends Node

const TYPE_FLYINGUP = 0
const TYPE_SPEEDUP = 1
const TYPE_SPEEDDOWN = 2
const ITEM_GROUPS = "items"
const OBSTACLE_GROUP = "obstacles"

var item_active = TYPE_FLYINGUP
var item_inventories = []

var highscore = 1
var level = 1
var star_count = 0
var level_mode = 1

var item_flying_up = 0
var item_speed_up = 0
var item_speed_down = 0

func _ready():
	get_tree().set_auto_accept_quit(false)


func resetGame():
	item_flying_up = 0
	item_speed_up = 0
	item_speed_down = 0
	item_inventories.clear()
	
	star_count = 0
	
	#print("main:reset game")

func getItemCount():
	if (item_active == TYPE_FLYINGUP):
		return item_flying_up
	elif (item_active == TYPE_SPEEDUP):
		return item_speed_up
	elif (item_active == TYPE_SPEEDDOWN):
		return item_speed_down
	else:
		return 0

func addItem(val):
	if (item_inventories[item_active] == TYPE_FLYINGUP):
		item_flying_up += val
	elif (item_inventories[item_active] == TYPE_SPEEDUP):
		item_speed_up += val
	elif (item_inventories[item_active] == TYPE_SPEEDDOWN):
		item_speed_down += val

func addItemFlyingup(val):
	item_flying_up += val

func addItemSpeedup(val):
	item_speed_up += val

func addItemSpeeddown(val):
	item_speed_down += val

func addStar(val):
	star_count += val

func getTimeStamp():
	var dt = OS.get_datetime()
	var date = str(dt["day"]) + "-" + str(dt["month"]) + "-" + str(dt["year"]) + "_" + \
				str(dt["hour"]) + "." + str(dt["minute"]) + "." + str(dt["second"])
	#print(date)
	return date
