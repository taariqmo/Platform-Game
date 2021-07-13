extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2.ZERO
export var walk_speed := 100
export var jump_speed := 750
export var gravity := 2000
export var coins := 0

func change_animation():
	if is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("Walk")
			if velocity.x < 0:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("Jump")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.smoothing_enabled = true

func _physics_process(delta):
	var x = 0
	if Input.is_action_pressed("walk_left"):
		x -= walk_speed
	if Input.is_action_pressed("walk_right"):
		x += walk_speed
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y -= jump_speed
	velocity.x = x
	velocity.y += gravity * delta
	#position += velocity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(delta)
	change_animation()

func collect_coin():
	coins += 1
	$HUD.set_coins(coins)
