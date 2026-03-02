extends Node2D

var enemy_path = preload("res://scenes/enemy.tscn")
var screen_size
var time_start

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_start + 2000 <= Time.get_ticks_msec():
		time_start = Time.get_ticks_msec()
		spawn_enemy() 
		
		
func spawn_enemy():
	var enemy = enemy_path.instantiate()
	enemy.pos = Vector2(randi_range(0, screen_size.x), -10)
	get_parent().add_child(enemy)
	
	
	

