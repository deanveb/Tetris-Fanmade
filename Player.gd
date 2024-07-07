extends CharacterBody2D


@export var SPEED = 24
@export var SPEEDUP = 500
@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var player = $"."
@onready var gravity_timer = $GravityTimer
@onready var moving_timer = $MovingTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#Source: https://forum.godotengine.org/t/how-can-i-create-collisionpolygon2d-from-one-sprite-programatically/20973/2
	var image = Image.new()
	image.load(sprite_2d.texture.resource_path)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	for polygon in polygons:
		var collider = CollisionPolygon2D.new()
		collider.polygon = polygon
		collider.position -= Vector2(sprite_2d.texture.get_size().x / 2, sprite_2d.texture.get_size().y / 2)
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
	move_and_slide()

func _on_gravity_timer_timeout():
	if !is_on_floor():
		position.y += SPEED
		move_and_slide()

func _on_moving_timer_timeout():
	var direction = Input.get_axis("left", "right")
	if direction:
		position.x += direction * SPEED
	move_and_slide()
