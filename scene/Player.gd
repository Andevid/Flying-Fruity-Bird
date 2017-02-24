
extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

#const PROCESS_FIXED = 'Fixed'
#const PROCESS_IDLE  = 'Idle'
#export (String, 'Idle', 'Fixed') var process_method = PROCESS_FIXED

# Member variables
var GRAVITY = 700.0 # Pixels/second 900

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const JUMP_MAX_AIRBORNE_TIME = 0.2
const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel
const MAX_SPEEDUP_TIME = 0.5

var WALK_FORCE = 500
var WALK_MIN_SPEED = 250
var WALK_MAX_SPEED = 300
var JUMP_SPEED = 500

var velocity = Vector2()
var on_air_time = 50
var speedup_time = 0

var jump_counter = 0
var follow_accel = 5.0
var speed = 0.0
var last_velox = 0.0

var target_pos

var is_flyingup = false
var is_speedup = false
var is_speeddown = false
var is_jumping = false
var prev_jump_pressed = false
var walk_right = true
var is_on_target = false

var life_rays


func _ready():
	target_pos = get_node("../Level/Target").get_global_pos()
	#target_pos += Vector2(0, 48)
	get_node("rayGround").add_exception(self)
	
	life_rays = get_node("RayLifes").get_children()
	for ray in life_rays:
		ray.add_exception(self)
		#ray.add_exception(get_node("../Target"))
	
	set_fixed_process(true)
	

func _fixed_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
		
	if (is_speedup):
		WALK_FORCE = 500 *1.5
		WALK_MIN_SPEED = 200 *1.5
		WALK_MAX_SPEED = 350 *1.5
		
		speedup_time += delta
		
		if (speedup_time > MAX_SPEEDUP_TIME):
			is_speedup = false
			speedup_time = 0
			velocity.x = last_velox
			
	else:
		last_velox = velocity.x
		WALK_FORCE = 500
		WALK_MIN_SPEED = 200
		WALK_MAX_SPEED = 350
		
	if (is_speeddown):
		#???
		pass
	
	if (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x += WALK_FORCE
	elif (not walk_right):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x -= WALK_FORCE
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding() && get_collider()):
		var obj = get_collider()
		
		if (obj.is_in_group(main.OBSTACLE_GROUP)):
			print("player: collide with obstacle group")
			#game over
			if (obj.get_script()):
				obj.hit()
			
			Globals.get("Stage").reloadCurrentScene()
			set_fixed_process(false)
			return
		
		if (is_on_target && get_collider().get_name() == "TileMap"):
			var score = 100
			
			get_node("LbScore").set_text("+" + str(score))
			get_node("AnimPlayer").play("finish")
			# sound - FINISH MODE - delay - COMPLETE MODE - popup
			set_fixed_process(false)
		
		# You can check which tile was collision against with this
		#print("collider: " + get_collider().get_name())
		
		for ray in life_rays:
			if (ray.is_colliding() && ray.get_collider()):
				Globals.get("Stage").reloadCurrentScene()
				set_fixed_process(false)
				return
				break
		
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)

#============== end if is_colliding =====================

	#if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		#move(floor_velocity*delta)
	#	print("move with moving platform")
	#	pass
	
	if (is_jumping and velocity.y > 0):
		# If falling, no longer jumping
		is_jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and is_flyingup and not prev_jump_pressed and not is_jumping):
		# Jump must also be allowed to happen 
		# if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		is_jumping = true
		
	
	on_air_time += delta
	prev_jump_pressed = is_flyingup
	
	is_flyingup = false
	is_speeddown = false
	
	# move to finish flag
	if (get_pos().x >= target_pos.x):
		var n = target_pos - get_global_pos()
		speed += follow_accel*delta
		set_pos(get_pos() + n*delta*speed)
		is_on_target = true
	
	if (velocity.x > 1000 or velocity.y > 1200):
		#game over
		get_parent().get_node("HUD/LbInfo").set_text("The Bird falling too fast! The bird can injury!")
		get_parent().reloadCurrentScene()
		set_fixed_process(false)
	elif (get_pos().y > 800):
		get_parent().get_node("HUD/LbInfo").set_text("The Bird flying too low! It's dangers!")
		get_parent().reloadCurrentScene()
		set_fixed_process(false)


func _on_AnimPlayer_finished():
	get_tree().change_scene("res://scene/Menu.tscn")
	
