extends KinematicBody2D

var spd = 500
var acc = 8
var dec = 10

var jump_time = 0.15
var jump_timer = 0

var grounded = true

var jump = 600

var gravity = 900
var low_jump_gravity = 4
var fall_gravity = 2

var terminal_velocity = 900

var jumping = false

var jump_pressed = false
var jump_press_timer = 0
var jump_press_time = 0.03

var speed = Vector2()

func _ready():
	pass

func move(delta):
	var desiredSpeed = 0
	
	if Input.is_action_pressed("btn_right"):
		desiredSpeed = 1
	if Input.is_action_pressed("btn_left"):
		desiredSpeed -= 1
	
	desiredSpeed *= spd
	
	#different acceleration and deceleration values
	if desiredSpeed == 0:
		speed += Vector2((-speed.x)*dec*delta, 0)
	else:
		speed.x += (desiredSpeed-speed.x)*acc*delta
	
	#add gravity if not grounded
	if !grounded:
		speed.y += gravity*delta
	
	#add a terminal fall velocity
	if speed.y > terminal_velocity:
		speed.y = terminal_velocity
	pass

func jump(delta):
	#code for gravity when falling
	if speed.y > 0:
		jumping = false
		speed += Vector2(0, gravity*(fall_gravity-1)*delta)
	#when a jump starts
	if jump_pressed and Input.is_action_pressed("btn_jump") and grounded:
		jumping = true
		grounded = false
		speed.y = -jump
	#when you release the jump
	if Input.is_action_just_released("btn_jump"):
		jumping = false
	#gravity for when you stop jumping
	if !jumping and !grounded:
		speed += Vector2(0, gravity*(low_jump_gravity-1)*delta)
	pass

func _physics_process(delta):
	move(delta)
	jump(delta)
	
	#the code below makes it so you have a small time (jump_time) to jump off a platform when you have already stepped out of it
	if !is_on_floor():
		if grounded and jump_timer == 0:
			jump_timer = jump_time
	else:
		grounded = true
		jump_timer = 0
	
	if jump_timer > 0:
		jump_timer -= delta
		if jump_timer <= 0:
			grounded = false
			jump_timer = 0
	
	#this moves the player
	speed = move_and_slide(speed, Vector2(0, -1))
	pass

func _process(delta):
	#this makes a variable (jump_pressed) true for when jump is pressed and 0.03 seconds later, so that when doing jumps quickly it feels better
	if jump_pressed:
		jump_press_timer -= delta
		if jump_press_timer <= 0:
			jump_pressed = false
			jump_press_timer = 0
	if Input.is_action_just_pressed("btn_jump"):
		jump_pressed = true
		jump_press_timer = jump_press_time
	
	#reload when pressing Esc
	if Input.is_action_just_pressed("btn_escape"):
		get_tree().reload_current_scene()
	pass
