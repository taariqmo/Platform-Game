extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level(level):
	$Level.text = "Level: " + str(level)

func victory():
	$Level.text = "You Have Completed The Game"

func special_victory():
	$Level.text = "You Have Mastered The Game"

func game_over():
	$Level.text = "You Lose"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
