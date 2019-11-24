extends Node2D

const MAIN_SCENARIO_URI = "res://MainScenario.tscn"

var player = null
var scenario = null

var old_player_life = 100
var new_player_life = 100
var caca = 100

var bullets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var Player = preload("res://Player.tscn")
	var Scenario = preload(MAIN_SCENARIO_URI)
	scenario = Scenario.instance()
	
	player = Player.instance()
	player.set_controls("ui_left", "ui_up", "ui_right")

	player.position.x = 100
	player.position.y = 100
	get_node("LifeCount").text = "%s" % player.life
	
	add_child(scenario)
	add_child(player)
	player.connect("shoot", self, "test")

func test(player, shoot_direction):
	var Bullet = preload("res://Bullet.tscn")
	var bullet = Bullet.instance()
	bullets.append(bullet)
	bullet.position.x = player.position.x
	bullet.position.y = player.position.y
	bullet.speed.x = 10

	add_child(bullet)
	print(shoot_direction)
	print("ola")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	old_player_life = player.life
	update_player_life(player)
	new_player_life = player.life
	
	if(old_player_life != new_player_life):
		get_node("LifeCount").text = "%s" % player.life
		
	if player.life == 0:
		open_game_over()
	
	if caca == 0:
		print("eeee")

func update_player_life(player):
	var bodies = scenario.get_node("DeathArea").get_overlapping_bodies()
	if len(bodies) > 0:
		print("SAMATAO")
		print(bodies)
	
	for body in bodies:
		print(body.get_class().get_name())
		#body.life = 0
		
		
func open_game_over():
	caca = 0
	var Scenario = preload("res://GameOverScenario.tscn")
	remove_child(scenario)
	var new_scenario = Scenario.instance()
	add_child(new_scenario)
	remove_child(player)
	pass