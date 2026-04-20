extends Node2D

@onready var player = $spaceship
@onready var enemies = $enemies
@onready var moving_enemies = $moving_enemies
@onready var bullets = $bullets

var enemy_path = preload("res://scenes/enemy.tscn")

var screen_size
var time_start
var block_width: int

var speed = 40
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()
	screen_size = get_viewport_rect().size
	
	spawn_enemy_block(4, 4, 1)
	await get_tree().process_frame
	
	spawn_enemy_block(1, 6, 1)
	await get_tree().process_frame
	
	spawn_enemy_block(2, 8, 1)
	await get_tree().process_frame
	
	spawn_enemy_block(3, 10, 3)
	await get_tree().process_frame
	
	block_width = get_block_width()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# devolver enemigos al nodo enemies
	for enemy in moving_enemies.get_children():
		if enemy.position == enemy.base_position:
			enemy.reparent(enemies, true)
	
	idle_enemy_block(delta)
	if time_start + 2000 <= Time.get_ticks_msec():
		time_start = Time.get_ticks_msec()
		if enemies.get_children().size() != 0:
			var randi_enemy = enemies.get_children()[randi_range(0, enemies.get_children().size()-1)]
			randi_enemy.player_pos = player.global_position 
			randi_enemy.can_move = true
			randi_enemy.reparent(moving_enemies, true)
			block_width = get_block_width()

func idle_enemy_block(delta):
	# movimiento horizontal de enemigos
	var static_enemies = []
	for enemy in enemies.get_children():
		if enemy.can_move:
			static_enemies.append(enemy) 
			
	enemies.position.x += direction * speed * delta
	
	if enemies.position.x <= -30:
		enemies.position.x = -30
		direction = 1

	elif enemies.position.x + block_width >= screen_size.x - 55:
		enemies.position.x = screen_size.x - block_width - 55
		direction = -1

func get_block_width():
	var min_x = INF
	var max_x = -INF
	
	for e in enemies.get_children():
		min_x = min(min_x, e.position.x)
		max_x = max(max_x, e.position.x)
	
	return max_x - min_x

func get_block_height():
	var min_y = INF
	var max_y = -INF
	
	for e in enemies.get_children():
		min_y = min(min_y, e.position.y)
		max_y = max(max_y, e.position.y)
	
	return max_y - min_y

func spawn_enemy_block(type, cant_x, cant_y):
	var spacing_x = 15
	var spacing_y = 15
	
	var start_x = (screen_size.x / 2 - (cant_x * spacing_x) / 2) + 6
	
	var offset_y = 0
	if enemies.get_child_count() > 0:
		offset_y = get_block_height() + spacing_y
	
	var start_y = 30 + offset_y
	
	for i in range(cant_x):
		for j in range(cant_y):
			var enemy = enemy_path.instantiate()
			
			enemy.pos = Vector2(
				start_x + i * spacing_x,
				start_y + j * spacing_y
			)
			
			enemy.base_position = enemy.pos
			enemy.bullets_parent = bullets
			enemy.enemies_node = enemies
			enemy.type = type
			
			enemies.add_child(enemy)

## ---------------------------  not used methods
func spawn_enemy_line(cant):
	var spacing = 30
	var start_x = (screen_size.x/2 - (cant * spacing)/2) + 6

	for i in range(cant):
		var enemy = enemy_path.instantiate()
		
		enemy.pos = Vector2(start_x + i * spacing, 64)
		enemy.player_pos = player.global_position
		
		enemies.add_child.call_deferred(enemy)

func spawn_enemy():
	var enemy = enemy_path.instantiate()
	enemy.pos = Vector2(randi_range(0, screen_size.x), 20)
	enemy.player_pos = player.global_position
	enemies.add_child(enemy)

