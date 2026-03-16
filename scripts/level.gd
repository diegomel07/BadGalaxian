extends Node2D

@onready var player = $spaceship
@onready var enemies = $enemies

var enemy_path = preload("res://scenes/enemy.tscn")

var screen_size
var time_start

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()
	screen_size = get_viewport_rect().size
	spawn_enemy_block(1, 10, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_start + 2000 <= Time.get_ticks_msec():
		time_start = Time.get_ticks_msec()
		enemies.get_children()[randi_range(0, enemies.get_children().size()-1)].can_move = true

func spawn_enemy_block(type, cant_x, cant_y):
	var spacing_x = 15
	var spacing_y = 15
	
	var start_x = (screen_size.x / 2 - (cant_x * spacing_x) / 2) + 6
	var start_y = 64
	
	for i in range(cant_x):
		for j in range(cant_y):
			var enemy = enemy_path.instantiate()
	
			enemy.pos = Vector2(
				start_x + i * spacing_x,
				start_y + j * spacing_y
			)
			
			enemy.player_pos = player.global_position
			enemies.add_child.call_deferred(enemy)

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

