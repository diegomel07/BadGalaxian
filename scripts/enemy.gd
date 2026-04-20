extends Area2D

var bullet_path = preload("res://scenes/bullet.tscn")
var bullets_parent: Node

var player_pos_on_launching: Vector2
var current_player_pos: Vector2

var type = 1
var screen_size: Vector2
var time_start: int

var time = 0
var bezier_points = []
var can_move = false
var allow_create_bezier_points = true
var base_position: Vector2
var enemies_node

var pos: Vector2
var speed = 0.23
var return_speed = 120
var returning = false
var is_rotating = false
var finished_rotation = false

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_by_type()
	time_start = Time.get_ticks_msec()
	global_position = pos
	screen_size = get_viewport_rect().size
	#bezier_points = create_bezier_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > screen_size.y + 10 and !returning:
		start_return()
	
	if returning:
		return_to_base(delta)
		return
	
	if can_move:
		if allow_create_bezier_points:
			bezier_points = create_bezier_points()
			allow_create_bezier_points = false
		
		move_bezier(delta)
		
		if time_start + 2000 <= Time.get_ticks_msec():
			time_start = Time.get_ticks_msec()
			shoot()

func setup_by_type():
	match type:
		1:
			$AnimatedSprite2D.sprite_frames = preload("res://recursos/enemy_1.tres")
		2:
			$AnimatedSprite2D.sprite_frames = preload("res://recursos/enemy_2.tres")
		3:
			$AnimatedSprite2D.sprite_frames = preload("res://recursos/enemy_3.tres")
		4:
			$AnimatedSprite2D.sprite_frames = preload("res://recursos/enemy_4.tres")
	
	$AnimatedSprite2D.play("idle")

func move_bezier(delta):
	var t2 = smoothstep(0.0, 1.0, time)
	
	var prev_pos = position
	position = bezier(t2)
	
	# calcular dirección de movimiento
	var velocity = position - prev_pos
	
	# FASES
	if t2 > 0.5 and not finished_rotation:
		# fase de rotación animada
		if not is_rotating:
			$AnimatedSprite2D.play("rotation")
			is_rotating = true
	else:
		# terminó la rotación → mirar al jugador SIEMPRE
		finished_rotation = true
		is_rotating = false
		
		var dir_to_player = (current_player_pos - global_position) * Vector2(1,-1)
		if dir_to_player.length() > 0:
			rotation = dir_to_player.angle()
	
	time += delta * speed
	
	if time >= 1:
		time = 0
		is_rotating = false
		finished_rotation = false
		$AnimatedSprite2D.play("idle")

func bezier(t):
	var q0 = bezier_points[0].lerp(bezier_points[1], t)
	var q1 = bezier_points[1].lerp(bezier_points[2], t)
	var r = q0.lerp(q1, t)
	return r

func create_bezier_points():
	var p0 = global_position
	var p1: Vector2
	if global_position.x < screen_size.x/2:
		p1 = Vector2(global_position.x-100, global_position.y-50)
	else:
		p1 = Vector2(global_position.x+100, global_position.y+50)
	var p2 = Vector2(player_pos_on_launching.x, player_pos_on_launching.y + 40)
	
	return [p0, p1, p2]

func shoot():
	if returning:
		return
	
	var bullet = bullet_path.instantiate()
	
	bullets_parent.add_child(bullet)
	
	bullet.global_position = $shoot.global_position
	bullet.dir = Vector2.DOWN
	bullet.from_enemy = true
	
func is_enemy():
	return true

func _on_area_entered(area):
	if !area.has_method("is_enemy"):
		if area.has_method("free_bullet") and !area.from_enemy:
			area.queue_free()
			queue_free()

func start_return():
	returning = true
	can_move = false
	
	# TP SOLO UNA VEZ
	rotation = 0
	position.y = -50

func return_to_base(delta):

	var target = enemies_node.to_global(base_position)

	var dir = (target - global_position).normalized()

	global_position += dir * return_speed * delta

	if global_position.distance_to(target) < 5:
		returning = false
		
		reparent(enemies_node, true)
		
		position = base_position
		
		# reset
		time = 0
		allow_create_bezier_points = true
		can_move = false


# ------------------ not used

func move_normal(delta):
	var velocity = Vector2.ZERO
	velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size+Vector2(0,20))
