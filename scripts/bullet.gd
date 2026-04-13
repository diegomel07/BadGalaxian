extends Area2D

var pos: Vector2
var rota: float
var dir: Vector2
var speed = 100

var from_enemy = false

var screen_size


func _ready():
	global_position = pos
	global_rotation = rota
	screen_size = get_viewport_rect().size
	
func _process(delta):
	position += dir.rotated(rotation) * speed * delta
	if (position.y > screen_size.y + 10) or (position.y < 0):
		queue_free()

func free_bullet():
	return true

func _on_area_entered(area):
	if !area.has_method("free_bullet"):
		if area.has_method("is_enemy") and !area.can_move: 
			pass
		else: queue_free()
