extends Node2D

@onready var sprite = $Sprite2D
@onready var A: Vector2 = $A.position
@onready var B: Vector2 = $B.position

var vel = 50
var dir: Vector2
var t = 0
var speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta * speed
	var pos = A.lerp(B, t) # interpolacion entre A y B por t
	
	var dir = (B - A).normalized() # direcion de A a B
	var perp = dir.orthogonal() 

	var wave = perp * sin(t * 10.0) * 40

	sprite.position = pos + wave


