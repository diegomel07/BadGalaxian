extends Node2D

@onready var p0 = $p0.position
@onready var p1 = $p1.position
@onready var p2 = $p2.position
@onready var sprite = $Sprite2D

var time = 0

func bezier(t):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.position = bezier(time)
	time += delta
	if time >= 1: time = 0

