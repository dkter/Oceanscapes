extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_back_pressed():
	self.queue_free()


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Button").connect("pressed", self, "_on_back_pressed")
