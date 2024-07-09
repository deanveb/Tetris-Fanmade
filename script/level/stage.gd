extends Node2D

const blocks_texture : Array[String] = ["res://tetris-assets/block/I_block.png",
								"res://tetris-assets/block/l-block.png",
								"res://tetris-assets/block/left_z_block.png",
								"res://tetris-assets/block/right_L_block.png",
								"res://tetris-assets/block/right_z_block.png",
								"res://tetris-assets/block/square_block.png",
								"res://tetris-assets/block/T_block.png"]
@onready var player_scene = preload("res://scene/game_object/player.tscn")

func spawn_new_player():
	var spawn_point = get_node("SpawnPoint") as Marker2D
	var player = player_scene.instantiate() as CharacterBody2D
	player.ground_touched.connect(_on_player_ground_touched)
	get_node(".").add_child(player)
	var texture : Texture2D = load(blocks_texture[randi() % blocks_texture.size() - 1]) as Texture2D
	player.global_position = spawn_point.global_position
	#player.get_node("Sprite2D").texture = texture
	player.create_collision(player.get_node("Sprite2D"))

func _ready():
	spawn_new_player()

func _on_player_ground_touched():
	spawn_new_player()
