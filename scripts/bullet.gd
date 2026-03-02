extends Area2D

var pos
var dir
var screen_size
@export var speed = 100

func _ready():
	global_position = pos
	screen_size = get_viewport_rect().size
	
func _process(delta):
	if position.y < -10:
		queue_free()
	
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.y += dir
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta



func _on_area_entered(area):
	queue_free()
