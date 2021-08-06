extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var current_level = 0
export var coins := -1
export var lives := -1
export var special_threshold := 1000

func back_to_main():
	var timer := get_tree().create_timer(10)
	yield(timer, "timeout")
	get_tree().change_scene("res://Src/Main.tscn")

func next_level(increment):
	var key := 0
	var powerups_collected := 0
	var enemies_killed := 0
	var bullets_fired := 0
	if $Level:
		var player = $Level.get_node("Player")
		assert(current_level == 0 or player)
		coins = player.coins
		lives = player.lives
		powerups_collected = player.powerups_collected
		enemies_killed = player.enemies_killed
		bullets_fired = player.bullets_fired
		if player.health:
			key = player.key
		player.key = 0
	if key:
		current_level = key
	else:
		current_level += increment
	for node in get_children():
		node.queue_free()
	var interstitial := load ("res://Src/Interstitial.tscn")
	var interstitial_scene = interstitial.instance()
	interstitial_scene.lives_remaining = lives
	interstitial_scene.coins_collected = coins
	interstitial_scene.powerups_collected = powerups_collected
	interstitial_scene.enemies_killed = enemies_killed
	interstitial_scene.bullets_fired = bullets_fired
	interstitial_scene.level = current_level
	interstitial_scene.set_level(current_level)
	add_child(interstitial_scene)
	if $Level and lives < 0:
		interstitial_scene.game_over()
		return
	var level := load("res://Src/Level" + str(current_level) + ".tscn")
	if not level:
		if current_level >= special_threshold:
			interstitial_scene.special_victory()
		else:
			interstitial_scene.victory()
		return
	var timer := get_tree().create_timer(5)
	yield(timer, "timeout")
	var scene = level.instance()
	add_child(scene)
	interstitial_scene.queue_free()
	var player = $Level.get_node("Player")
	if coins >= 0:
		player.coins = coins
		player.lives = lives
	else:
		coins = player.coins
		lives = player.lives
	player.refresh()

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Level and $Level.win:
		next_level(1)
	if $Level and $Level.loss:
		next_level(0)
