extends Area2D

@export var speed = 50

var bullet_path = preload("res://scenes/bullet.tscn")
var bullet: Area2D

var screen_size
var can_shoot: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_instance_valid(bullet):
		can_shoot = false
	else: can_shoot = true
		
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("shoot"):
		if can_shoot: shoot()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func shoot():
	bullet = bullet_path.instantiate()
	bullet.dir = Vector2.UP	
	bullet.pos = $shoot.global_position
	bullet.rota = rotation
	get_parent().add_child(bullet)

func _on_area_entered(area):
	# fockin dies
	queue_free()
