extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var visible = false

var tui = preload("tui.gd")

var map = [["d", "f", "f", "s"],
		   ["f", "c", "c", "f"],
		   ["s", "f", "f", "s"],
		   ["c", "d", "d", "c"]]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#self.connect("input_event", self, "_on_input")
	set_process(true)
	get_node("TextEdit").hide()


func _process(delta):
	if Input.is_mouse_button_pressed(1) and not visible:
		print("clicked")
		get_node("TextEdit").show()
		visible = true
		tui.new(self, get_node("TextEdit"), map, 1000, "res://level4.tscn",
			"Still haven't fixed the bug, eh? The animals in this\n" +
			"room are looking more sick and unhappy than ever.\n",
			"A voice announces, \"You have reached the point goal! You might\n" +
			"have encountered a bug in this room - we're prioritizing getting\n" +
			"graphics to work over small bugs like these. Press Enter, again,\n"+
			"to re-enable graphics.\"",
			 get_node("Timer"))
