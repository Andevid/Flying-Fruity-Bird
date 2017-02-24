extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Globals.set(get_name(), self)
	pass
