extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var visible = false

var tui = preload("tui.gd")

var map = [["d", "c", "f", "s"],
		   ["s", "f", "c", "d"],
		   ["f", "c", "s", "f"],
		   ["d", "d", "f", "c"]]

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
		tui.new(self, get_node("TextEdit"), map, 1300, "res://level3.tscn",
			"You find yourself in a similar room to before. Guess\n" +
			"they didn't fix that bug after all. Oh well.\n",
			"A voice announces, \"You have reached the point goal! Sorry\n" +
			"the bug wasn't fixed - I think we've done it now. Press Enter\n" +
			"to re-enable graphics again.\"",
			get_node("Timer"))
