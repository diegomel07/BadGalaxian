extends Area2D

@export var speed = 100

var bullet_path = preload("res://scenes/bullet.tscn")

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("shoot"):
		fire()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = -1
	bullet.pos = $shoot.global_position
	get_parent().add_child(bullet)
