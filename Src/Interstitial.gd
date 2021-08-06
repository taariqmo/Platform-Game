extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var done := false
var level := -1
var lives_remaining := -1
var coins_collected := -1
var powerups_collected := -1
var enemies_killed := -1
var bullets_fired := -1
var showing_stats := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level(level):
	$Level.text = "Level: " + str(level)

func victory():
	done = true
	$Level.text = "You Have Completed The Game\nClick Enter to see your stats"

func special_victory(level, lives, coins, bullets, enemies, extra_life_powerups, jump_powerups, speed_powerups, star_powerups):
	done = true
	$Level.text = "You Have Mastered The Game\nClick Enter to see your stats"

func game_over():
	$Level.text = "You Lose\nClick Enter to see your stats"

func set_end_level():
	if done == true:
		$EndScreen/EndLevel.text = "All Levels Completed"
		$EndScreen/EndLevel.visible = true
	elif done == false:
		$EndScreen/EndLevel.text = "Level Failed: " + str(level)
		$EndScreen/EndLevel.visible = true

func set_end_lives():
	if done == false:
		$EndScreen/EndLives.text = "Lives Remaining: 0"
		$EndScreen/EndLives.visible = true
	if done == true:
		$EndScreen/EndLives.text = "Lives Remaining: " + str(lives_remaining)
		$EndScreen/EndLives.visible = true

func set_end_coins():
	$EndScreen/EndCoins.text = "Coins Collected: " + str(coins_collected)
	$EndScreen/EndCoins.visible = true

func set_end_bullets():
	$EndScreen/EndBullets.text = "Bullets Fired: " + str(bullets_fired)
	$EndScreen/EndBullets.visible = true

func set_end_enemies():
	$EndScreen/EndEnemies.text = "Enemies Killed: " + str(enemies_killed)
	$EndScreen/EndEnemies.visible = true

func set_end_powerups():
	$EndScreen/EndPowerups.text = "Powerups Collected: " + str(powerups_collected)
	$EndScreen/EndPowerups.visible = true

func show_stats():
	showing_stats = true
	$Level.text = "Press Enter to return to main screen"
	set_end_level()
	set_end_lives()
	set_end_coins()
	set_end_powerups()
	set_end_enemies()
	set_end_bullets()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("end_screen"):
		if showing_stats:
			get_tree().change_scene("res://Src/Main.tscn")
		else:
			show_stats()
