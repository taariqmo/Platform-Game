extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2.ZERO
export var walk_speed := 100
export var jump_speed := 750
export var traction := 0.05
export var gravity := 2000
export var coins := 0
export var lives := 3
export var health := 3
export var done := false
export var idle_threshold := 0.1
var was_hit := false
onready var Bullet = load("res://Src/Bullet.tscn")

func change_animation():
	if not health:
		$AnimatedSprite.play("Death")
		if $AnimatedSprite.flip_h == true:
			rotation_degrees = 90
		else:
			rotation_degrees = 270
	elif was_hit:
		if $AnimatedSprite.animation == "Hit":
			if not $AnimatedSprite.playing:
				was_hit = false
		else:
			$AnimatedSprite.play("Hit")
	elif is_on_floor():
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
	if health:
		if Input.is_action_pressed("walk_left"):
			x -= walk_speed
		if Input.is_action_pressed("walk_right"):
			x += walk_speed
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y -= jump_speed
	#velocity.x = x
	#velocity.x += (x - velocity.x) * traction
	velocity.x = lerp(velocity.x, x, traction)
	velocity.y += gravity * delta
	#position += velocity * delta
	if abs(velocity.x) < idle_threshold:
		velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	var level = get_parent()
	if not done and level.event_horizon < position.y:
		die()
	elif health:
		if Input.is_action_just_pressed("attack"):
			var bullet = Bullet.instance()
			bullet.position = position
			if $AnimatedSprite.flip_h:
				bullet.direction = -1
				bullet.position.x -= $CollisionShape2D.shape.extents.x * 2
			else:
				bullet.position.x += $CollisionShape2D.shape.extents.x * 2
				bullet.direction = 1
			level.add_child(bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_animation()

func collect_coin():
	coins += 1
	$HUD.set_coins(coins)

func die():
	if not done and not $AudioStreamPlayer.playing:
		health = 0
		$AudioStreamPlayer.play()
		$HUD.stop_timer()

func refresh():
	$HUD.set_coins(coins)
	$HUD.set_lives(lives)


func _on_AudioStreamPlayer_finished():
	lives -= 1
	$HUD.set_lives(lives)
	get_parent().loss = true
	done = true

func get_time():
	$HUD.get_time()

func stop_timer():
	$HUD.stop_timer()

func collect_life():
	lives += 1
	$HUD.set_lives(lives)

func lose_health():
	health = max(health - 1, 0)
	$HUD.set_health(health)
	if health == 0:
		die()

func hit():
	if was_hit == false:
		was_hit = true
		lose_health()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hit":
		$AnimatedSprite.stop()
		was_hit = false
