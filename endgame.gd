extends Node

var map = [
"chdhh",
"h----",
"ze---"
]
var map_w = 4
var map_h = 2
var startx = map_w
var starty = 0
var position = [starty, startx]

var textedit
var scene
var done = false

func _init(textedit, scene):
	self.textedit = textedit
	self.scene = scene
	textedit.insert_text_at_cursor("You enter the dimly lit passageway. As you start crawling\nthrough, a door slams shut behind you. You're trapped\nin here now - best to explore.\n")
#	while not done:
#		prompt()
	textedit.grab_focus()
	var thread = Thread.new()
	thread.start(self, "_start_tui")


func _start_tui(userdata):
	print("a")
	while not done:
		_prompt()
	return 0


func _prompt():
	# what's here?
	print(position)
	if map[position[0]][position[1]] == "h":
		textedit.insert_text_at_cursor("You are in a dimly lit hallway.\n")
	elif map[position[0]][position[1]] == "d":
		textedit.insert_text_at_cursor("You see a window overlooking an office with a few\nprogrammers sitting at computers. One is drinking beer\nand laughing, one is idly browsing Reddit,\nand another is playing Fortnite. A man in a suit\nwalks in, and all of a sudden they alt-tab to other\nwindows, in which can be seen the ugliest user interface\nknown to man. You try not to vomit.\n")
	elif map[position[0]][position[1]] == "c":
		textedit.insert_text_at_cursor("You are at a corner of the dimly lit hallway. Through a\ncrack, you can hear a roaring tide and see a vast blue\nocean.\n")
	elif map[position[0]][position[1]] == "z":
		textedit.insert_text_at_cursor("You see an opening to the west directly leading to the\nocean. Your fear of heights won't let you jump out. On the\neast, you see a window overlooking a smelly\nroom filled with marine animals. These animals look\nsadder than ever - crab upon crab stacked on top of each\nother, a sack filled with struggling dolphins, and the\ndirtiest fish tank you've ever seen. A worker in a yellow\nprotective suit walks in, fills a bag with all the\ndead animals, and leaves. You're so outraged that you kick\nthrough the window, shattering it into hundreds of\ntiny pieces.\n")
	elif map[position[0]][position[1]] == "e":
		textedit.insert_text_at_cursor("You push through the shards of glass, taking caution not\nto cut yourself, and look around. You're horrified by this\nmess, and don't know what to do to stop it. You pull\nout your phone, to hopefully call someone,\nbut discover you have no reception. As you're worrying\nabout this, you hear noises behind you. The animals have\nclimbed onto a shipping container and are starting to\nclimb out into the ocean! A team of crabs lifts the\nfish tank and completely pushes it in, then start carrying\nout the dolphins. As each and every animal makes it out,\nyou feel an intense sense of joy. You then leave the\nbuilding, quickly, trying not to risk being discovered.\n\nThe End\nPress Enter to go to the starting screen.")
		var line_count = textedit.get_line_count()
		while textedit.get_line_count() == line_count:
			pass
		self.scene.get_tree().change_scene("res://main_menu.tscn")
		self.scene.queue_free()
		done = true
	
	# get input
	textedit.insert_text_at_cursor(">")
	var line_count = textedit.get_line_count()
	while textedit.get_line_count() == line_count:
		pass
		
	# parse input
	var input = textedit.get_line(line_count-1)
	input = input.substr(1, input.length())
	
	if input in ["help", "?", "oh man I am not good with computer plz to help"]:
		textedit.insert_text_at_cursor("Try this: go <direction>.\n")
	
	elif input in ["go north", "go n", "n"]:
		if position[0] == 0 or map[position[0]-1][position[1]] == "-":
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			position[0] -= 1
	
	elif input in ["go south", "go s", "s"]:
		if position[0] == map_h or map[position[0]+1][position[1]] == "-":
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			position[0] += 1
	
	elif input in ["go west", "go w", "w"]:
		if position[1] == 0 or map[position[0]][position[1]-1] == "-":
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			position[1] -= 1
	
	elif input in ["go east", "go e", "e"]:
		if position[1] == map_w or map[position[0]][position[1]+1] == "-":
			if position[0] == starty:
				textedit.insert_text_at_cursor("You bang on the door frantically, but it doesn't budge.\n")
			else:
				textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			position[1] += 1
