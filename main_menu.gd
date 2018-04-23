extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_play_pressed():
	print("play")
	get_node("PlayButton").set("focus/ignore_mouse", true)
	get_node("CreditsButton").set("focus/ignore_mouse", true)
	get_node("RateButton").set("focus/ignore_mouse", true)
	var scene = preload("res://level5.tscn")
	var node = scene.instance()
	add_child(node)


func _on_credits_pressed():
	print("credits")
	var scene = preload("res://credits.tscn")
	var node = scene.instance()
	add_child(node)


func _on_rate_pressed():
	print("rate")
	OS.shell_open("https://ldjam.com/events/ludum-dare/41/$87811")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("PlayButton").connect("pressed", self, "_on_play_pressed")
	get_node("CreditsButton").connect("pressed", self, "_on_credits_pressed")
	get_node("RateButton").connect("pressed", self, "_on_rate_pressed")
