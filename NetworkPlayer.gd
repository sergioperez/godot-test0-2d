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
