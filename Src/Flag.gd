extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal win

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Flag_body_entered(body):
	if body.name == "Player" and not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
		body.done = true


func _on_AudioStreamPlayer_finished():
	emit_signal("win")
