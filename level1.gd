extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var visible = false

var tui = preload("tui.gd")

var map = [["f", "d", "s", "c"],
		   ["d", "s", "c", "f"],
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
		tui.new(self, get_node("TextEdit"), map, 1000, "res://level2.tscn",
			"You find yourself in a room with the floor painted blue.\n" +
			"The room is filled with giant marine animals, including\n" +
			"fish, crabs, dolphins and snails.\n",
			"A voice announces, \"You have reached the point goal! By the\n" +
			"way, I think we've fixed the bug now - press Enter to re-enable\n" +
			"graphics.\"",
			 get_node("Timer"))
