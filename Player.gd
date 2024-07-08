extends CharacterBody2D


@export var SPEED = 24
@export var SPEEDUP = 500
@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var player = $"."
@onready var gravity_timer = $GravityTimer
@onready var moving_timer = $MovingTimer
@onready var player_solidified_scene = preload("res://scene/game_object/player_solidified.tscn")
@onready var collider = CollisionPolygon2D.new()


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#Source: https://forum.godotengine.org/t/how-can-i-create-collisionpolygon2d-from-one-sprite-programatically/20973/2
	var image = Image.new()
	image.load(sprite_2d.texture.resource_path)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	print(polygons)
	for polygon in polygons:
		collider.polygon = polygon
		collider.position -= Vector2(sprite_2d.texture.get_size().x / 2, sprite_2d.texture.get_size().y / 2)
		var mark = load("res://tetris-assets/bluebird-downflap.png")
		collider.name = "collider"
		print(collider.name)
		add_child(collider)

func _physics_process(delta):
	if Input.is_action_pressed("down"):
		velocity.y = 1 * SPEEDUP
		moving_timer.stop()
		gravity_timer.stop()
	else:
		velocity.y = 0
		if moving_timer.is_stopped() and gravity_timer.is_stopped():
			moving_timer.start()
			gravity_timer.start()
	if Input.is_action_just_pressed("Rotate"):
		rotation += deg_to_rad(90)
	move_and_slide()

func _on_gravity_timer_timeout():
	if !is_on_floor():
		position.y += SPEED
		move_and_slide()
	else:
		var player_block : StaticBody2D = player_solidified_scene.instantiate() as StaticBody2D
		player_block.global_position = global_position
		player_block.get_node("Sprite2D").texture = sprite_2d.texture
		player_block.add_child(collider.duplicate())
		get_node("..").add_child(player_block)
		queue_free()

func _on_moving_timer_timeout():
	var direction = Input.get_axis("left", "right")
	if direction:
		position.x += direction * SPEED
	move_and_slide()
