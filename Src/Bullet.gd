extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed := 1000
var direction := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position.x += speed * delta * direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bullet_body_entered(body):
	if body.name == "Enemy":
		body.die()
	queue_free()
