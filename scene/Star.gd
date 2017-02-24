extends Area2D

var players = []
var taken = false
var follow_accel = 25.0
var speed = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_VisEnabler_enter_screen():
	get_node("AnimPlayer").play("star_idle")

func _on_VisEnabler_exit_screen():
	get_node("AnimPlayer").stop()

func _on_body_enter(body):
	if body extends preload("res://scene/Player.gd"):
		if (not taken):
			main.addStar(1)
			get_node("Star").hide()
			get_node("StarEffect1").hide()
			get_node("StarEffect2").hide()
			get_node("Particles").set_emitting(true)
			get_node("Particles").set_emit_timeout(0.75)
			get_node("Collision").set_trigger(true)
			#get_node("sound").play("shine")
			get_node("DeathClock").start()
			taken = true


func _process(delta):
	if players.size():
		if not taken:
			var a = players[0]
			var n = a.get_global_pos() - get_global_pos()
			speed += follow_accel*delta
			set_pos(get_pos() + n*delta*speed)
	else:
		set_process(false)
		speed = 0.0
		if not taken:
			get_node("Particles").set_emitting(false)

func _on_Magnet_body_enter( body ):
	if body extends preload("res://scene/Player.gd"):
		players.push_back(body)
		set_process(true)
		#get_node("Particles").set_emitting(true)
		#get_node("Particles").set_emit_timeout(0)

func _on_Magnet_body_exit( body ):
	if body extends preload("res://scene/Player.gd"):
		players.erase(body)

func _on_DeathClock_timeout():
	queue_free()
