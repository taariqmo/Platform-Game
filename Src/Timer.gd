extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

enum TimeFormat {
	FORMAT_HOURS = 1
	FORMAT_MINUTES = 2
	FORMAT_SECONDS = 4
	FORMAT_DEFAULT = 7
}

export var DIGITS = 6

func format_time(time, format = TimeFormat.FORMAT_DEFAULT, digit_format = "%02d"):
	var digits = []
	if format & TimeFormat.FORMAT_HOURS:
		var hours = digit_format % [time/3600]
		digits.append(hours)
	if format & TimeFormat.FORMAT_MINUTES:
		var minutes = digit_format % [time/60]
		digits.append(minutes)
	if format &TimeFormat.FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)
	var formatted = String()
	var colon = ":"
	for digit in digits:
		formatted += digit + colon
	if not formatted.empty():
		formatted = formatted.rstrip(colon)
	return formatted

func stop_timer():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = format_time(time)
	time += delta
