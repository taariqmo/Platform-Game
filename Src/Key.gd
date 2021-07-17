extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var id = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Key_body_entered(body):
	if body.health and body.name == "Player" and not $AudioStreamPlayer.playing and not body.done:
		$AudioStreamPlayer.play()
		$CollisionShape2D.queue_free()
		body.collect_key(id)


func _on_AudioStreamPlayer_finished():
	queue_free()
