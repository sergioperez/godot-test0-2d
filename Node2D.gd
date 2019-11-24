extends Node2D

# TODO: Remove GAME_ID constant, its just to try things :)
var GAME_ID = 0
const MAIN_SCENARIO_URI = "res://MainScenario.tscn"

var scenario = null


var old_player_life = 100
var new_player_life = 100
var players = []
var network_players = []
var bullets = []
var Player = preload("res://Player.tscn")
var Scenario = preload(MAIN_SCENARIO_URI)

var tcp_client = null

# Called when the node enters the scene tree for the first time.
func _ready():
	scenario = Scenario.instance()
	add_child(scenario)
	
	var player = spawn_new_player(100, 100)
	players.append(player)
	get_node("LifeCount").text = "%s" % player.life
	
	var network_player = spawn_network_player(600, 100)
	network_players.append(network_player)
	tcp_client = _tcp_connect()
	#_read_tcp_messages(tcp_client)

func _tcp_connect():
	var tcp_client = StreamPeerTCP.new()
	if !tcp_client.is_connected_to_host():
		print("Connecting")
		tcp_client.connect_to_host("127.0.0.1", 18000)
	return tcp_client

	
func spawn_new_player(x, y):
	var player = Player.instance()
	player.set_controls("ui_left", "ui_up", "ui_right")
	player.position.x = x
	player.position.y = y
	add_child(player)
	return player
	#player.connect("shoot", self, "player_shoot")
	
func spawn_network_player(x, y):
	var network_player = Player.instance()
	network_player.position.x = x
	network_player.position.y = y
	add_child(network_player)
	return network_player

func player_shoot(player, shoot_direction):
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
	check_death_area()
	_write_tcp_messages(tcp_client)
	_read_tcp_messages(tcp_client)
	
func _write_tcp_messages(tcp_client):
	var message = str(GAME_ID) + "," + str(players[0].position.x) \
						 + "," + str(players[0].position.y)
	if tcp_client.is_connected_to_host():
		tcp_client.put_string(message)
	
func _read_tcp_messages(tcp_client):
	#if tcp_client.is_connected_to_host():
		#print(str(tcp_client.get_string()))
	print(tcp_client.get_string(5))
	pass

func check_death_area():
	var death_area_bodies = scenario.get_node("DeathArea").get_overlapping_bodies()
	
	for body in death_area_bodies:
		if body is Node2D:
			print("samatao")
			remove_child(body)
		if body is KinematicBody2D:
			open_game_over(body)
			
		#print(body.get_class().get_name())
		#body.life = 0
		
		
func open_game_over(death_player):
	var Scenario = preload("res://GameOverScenario.tscn")
	remove_child(scenario)
	var new_scenario = Scenario.instance()
	add_child(new_scenario)
	remove_child(death_player)
	pass