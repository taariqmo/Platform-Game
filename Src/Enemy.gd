extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2.ZERO
export var walk_speed := 20
export var jump_speed := 750
export var traction := 0.05
export var gravity := 2000
export var done := false
export var idle_threshold := 0.1
var go_left := true
var go_right := false
export var walk_range := 64
var start := Vector2.ZERO
export var latency := 0.1
onready var latency_remaining := latency
onready var Coin = load("res://Src/Coin.tscn")
onready var Ammo = load("res://Src/Ammo.tscn")
var rng = RandomNumberGenerator.new()

func change_animation():
		if velocity.x == 0:
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("Walk")
			if velocity.x < 0:
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true

# Called when the node enters the scene tree for the first time.
func _ready():
	start = position
	rng.randomize()

func think(delta):
	"""if latency_remaining > 0:
		latency_remaining = max(0.0, latency_remaining - delta)
		return
	else:
		latency_remaining = latency"""
	if is_on_wall():
		go_right = not go_right
		go_left = not go_left

func _physics_process(delta):
	var x = 0
	if not done:
		think(delta)
		if go_left:
			x -= walk_speed
		if go_right:
			x += walk_speed
	#velocity.x = x
	#velocity.x += (x - velocity.x) * traction
	if done:
		velocity.x = 0
	else:
		velocity.x = lerp(velocity.x, x, traction)
	velocity.y += gravity * delta
	#position += velocity * delta
	if abs(velocity.x) < idle_threshold:
		velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	var level = get_parent()
	if not done and level.event_horizon < position.y:
		die()
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		if collider.name == "Player":
			collider.hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_animation()

func die():
	var parent = get_parent()
	var player = parent.find_node("Player")
	if player:
		player.enemies_killed += 1
	done = true
	$AnimatedSprite.flip_v = true
	var timer2 = get_tree().create_timer(1)
	yield(timer2, "timeout")
	if rng.randf() <= 0.2:
		var ammo = Ammo.instance()
		ammo.position = position
		parent.add_child(ammo)
	else:
		var coin = Coin.instance()
		coin.position = position
		parent.add_child(coin)
	queue_free()
