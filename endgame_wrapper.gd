extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var endgame = preload("endgame.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	endgame.new(get_node("TextEdit"), self)
