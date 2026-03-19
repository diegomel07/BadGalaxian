extends Area2D

var bullet_path = preload("res://scenes/bullet.tscn")

var player_pos: Vector2

#@export var speed = randi_range(20,40)
var screen_size: Vector2
var time_start: int
var is_invincible: bool = true

var time = 0
var bezier_points = []
var can_move = false
var allow_create_bezier_points = true

var pos: Vector2
var speed = 0.16


# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()
	global_position = pos
	screen_size = get_viewport_rect().size
	#bezier_points = create_bezier_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > screen_size.y+10:
		queue_free()
	
	if can_move:
		is_invincible = false
		if allow_create_bezier_points:
			bezier_points = create_bezier_points()
			allow_create_bezier_points = false
		
		move_bezier(delta)
		
		if time_start + 2000 <= Time.get_ticks_msec():
			time_start = Time.get_ticks_msec()
			shoot()

func move_normal(delta):
	var velocity = Vector2.ZERO
	velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size+Vector2(0,20))

func move_bezier(delta):
	var t2 = smoothstep(0.0, 1.0, time)
	position = bezier(t2)
	time += delta * speed
	
	if time >= 1:
		time = 0

func bezier(t):
	var q0 = bezier_points[0].lerp(bezier_points[1], t)
	var q1 = bezier_points[1].lerp(bezier_points[2], t)
	var r = q0.lerp(q1, t)
	return r

func create_bezier_points():
	var p0 = global_position
	var p1: Vector2
	if global_position.x < screen_size.x/2:
		p1 = Vector2(global_position.x-50, global_position.y-50)
	else:
		p1 = Vector2(global_position.x+50, global_position.y+50)
	var p2 = Vector2(player_pos.x, player_pos.y)
	
	print(p1)
	return [p0, p1, p2]

func shoot():
	var bullet = bullet_path.instantiate()
	bullet.dir = Vector2.DOWN
	bullet.pos = $shoot.global_position 
	bullet.rota = rotation
	get_parent().add_child(bullet)
	
func is_enemy():
	return true

func _on_area_entered(area):
	if not is_invincible:
		if !area.has_method("is_enemy"):
			queue_free()
		
