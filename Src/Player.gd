extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2.ZERO
export var walk_speed := 100

func change_animation():
	if velocity.x == 0:
		$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Walk")
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var x = 0
	if Input.is_action_pressed("walk_left"):
		x -= walk_speed
	if Input.is_action_pressed("walk_right"):
		x += walk_speed
	velocity.x = x
	position.x += velocity.x * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(delta)
	change_animation()
