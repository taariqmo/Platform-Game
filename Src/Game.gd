extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var current_level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var level := load("res://Src/Level" + str(current_level) + ".tscn")
	var scene = level.instance()
	add_child(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
