extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var current_level = 0

func next_level():
	for node in get_children():
		node.queue_free()
	current_level += 1
	var interstitial := load ("res://Src/interstitial.tscn")
	var interstitial_scene = interstitial.instance()
	interstitial_scene.set_level(current_level)
	add_child(interstitial_scene)
	var level := load("res://Src/Level" + str(current_level) + ".tscn")
	if not level:
		interstitial_scene.victory()
	var timer := get_tree().create_timer(5)
	yield(timer, "timeout")
	var scene = level.instance()
	add_child(scene)
	interstitial_scene.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	next_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Level and $Level.finish:
		next_level()
