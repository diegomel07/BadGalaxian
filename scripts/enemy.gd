extends Area2D

var pos = Vector2(0,0)

@export var speed = randi_range(40,60)
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = pos
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > screen_size.y+10:
		queue_free()
	
	var velocity = Vector2.ZERO
	velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size+Vector2(0,20))


func _on_area_entered(area):
	queue_free()
