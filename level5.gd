extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var visible = false

var tui = preload("tui.gd")

var map = [["f", "c", "d", "s"],
		   ["s", "f", "c", "d"],
		   ["d", "s", "f", "c"],
		   ["c", "d", "s", "f"]]

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
		tui.new(self, get_node("TextEdit"), map, 1000, "res://main_menu.tscn",
			"You find yourself in the same room, but with a seemingly\n" +
			"impossible puzzle. A note in your hands reads, \"We're\n" +
			"working on fixing the problem, and in the meantime here's\n" +
			"an impossible puzzle for you to distract yourself with.\nEnjoy.\"\n",
			"A voice announces, \"You have reached the point goal! We figured\n" +
			"out what the problem was, and we're working to fix it. Please\n" +
			"expect a fix in 2-3 working days. In the meantime, press Enter\n"+
			"to re-enable graphics.\"",
			 get_node("Timer"), true)
