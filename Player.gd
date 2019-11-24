extends KinematicBody2D

signal shoot

var player_id = 8
var info_text_node = "hola"
const MAX_JUMPS = 2
const GRAVITY = 10
const WALK_SPEED = 300
const JUMP_POWER = 300
const FLOOR_NORMAL = Vector2(0, -1)
var velocity = Vector2()
var available_jumps = 0
var life = 100
var shield = 0

var looking_to = Vector2(0, 1)

var _KEY_UP = ""
var _KEY_LEFT = ""
var _KEY_RIGHT = ""

func set_controls(key_left, key_up, key_right):
	_KEY_UP = key_up
	_KEY_LEFT = key_left
	_KEY_RIGHT = key_right

# Called when the node enters the scene tree for the first time.
func _ready():
	print(_KEY_UP)
	looking_to.x = 1
	life = 100;

func _physics_process(delta):
	if is_on_floor():
		available_jumps = 2
	if !is_on_floor():
		velocity.y += GRAVITY
	
	velocity.x = 0
	if Input.is_action_pressed(_KEY_LEFT):
		velocity.x -= WALK_SPEED
		looking_to.x = -1
	if Input.is_action_pressed(_KEY_RIGHT):
		velocity.x += WALK_SPEED
		looking_to.x = 1
	if Input.is_action_just_pressed(_KEY_UP):
		_jump()
		looking_to.y = -1
	if Input.is_action_just_pressed("ui_accept"):
		print("k pasa bro")
		_shoot()
		
	move_and_slide(velocity, FLOOR_NORMAL, false) 

func _jump():
	print(available_jumps)
	if is_on_floor():
		available_jumps = 1
		velocity.y = -JUMP_POWER
		
	# Do not do the first jump when its not in the floor
	elif available_jumps != MAX_JUMPS:
		if available_jumps > 0:
			velocity.y = -JUMP_POWER
			available_jumps -= 1

func _shoot():
	print("shooting to %d" % looking_to.x)
	emit_signal("shoot", self, looking_to)