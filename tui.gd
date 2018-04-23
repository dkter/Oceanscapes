extends Node

var textedit
var map
var orig_map
var point_limit
var next_level
var endtext
var scene
var last_level
var position = [0, 0]
var has_item = false
var points = 0
var itempos
var things
var doing_endgame = false
#var wait_for_enter = preload("wait_for_enter.gd")

func _init(scene, textedit, map, point_limit, next_level, starttext, endtext, random_timer_because_godot_is_bad, last_level = false):
	self.scene = scene
	self.textedit = textedit
	self.map = map
	self.orig_map = str2var(var2str(map))
	self.point_limit = point_limit
	self.next_level = next_level
	self.endtext = endtext
	self.last_level = last_level
	
	textedit.set_readonly(true)
	textedit.grab_focus()
	textedit.cursor_set_line(0)
	textedit.set_text("ERROR 0x02324FFBC\nAttempting to recover....")
	
	random_timer_because_godot_is_bad.set_wait_time(3)
	random_timer_because_godot_is_bad.start()
	yield(random_timer_because_godot_is_bad, "timeout")
	textedit.set_text(starttext + "\n")
	set_process_input(true)
	#_start_tui()
	var thread = Thread.new()
	thread.start(self, "_start_tui")


func _start_tui(userdata):
	while points < point_limit:
		if not doing_endgame:
			_prompt()
	textedit.insert_text_at_cursor(self.endtext)
	var line_count = textedit.get_line_count()
	while textedit.get_line_count() == line_count:
		pass
	self.scene.get_tree().change_scene(self.next_level)
	self.scene.queue_free()
	return 0
	

func _prompt():
	textedit.set_readonly(false)
	textedit.cursor_set_line(textedit.get_line_count())
	var animal = map[position[0]][position[1]]
	if animal == "f":
		textedit.insert_text_at_cursor("You are standing in front of a fish, gasping for oxygen\nin its cramped bowl.\n")
	elif animal == "c":
		textedit.insert_text_at_cursor("You are standing in front of a crab, helplessly flailing\nabout on its back. It looks miserable.\n")
	elif animal == "s":
		textedit.insert_text_at_cursor("You are standing in front of a sea snail, getting tired\nof the disgusting blue floor and longing for the ocean.\n")
	elif animal == "d":
		textedit.insert_text_at_cursor("You are standing in front of a dolphin, trying to use its\ntail to flop about and maybe get somewhere.\n")
	
	if last_level:
		textedit.insert_text_at_cursor("You spot a small passageway to the west, barely big enough\nfor you to crawl through.\n")
	
	textedit.insert_text_at_cursor(">")
	
	# get input
	var line_count = textedit.get_line_count()
	while textedit.get_line_count() == line_count:
		pass
	
	# parse input
	var input = textedit.get_line(line_count-1)
	input = input.substr(1, input.length())
	
	if input in ["help", "?", "oh man I am not good with computer plz to help"]:
		textedit.insert_text_at_cursor("Try this: go <direction>. You can also pick things up,\n drop things, or restart if you get stuck.\n")
	
	elif input in ["restart", "refresh"]:
		map = str2var(var2str(orig_map))
		position = [0, 0]
		has_item = false
		textedit.insert_text_at_cursor("Restarted!\n")
	
	elif input in ["go north", "go n", "n"]:
		if position[0] == 0:
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			if has_item and (itempos[0] > position[0] or (itempos[1] != position[1] and itempos[0] != position[0]-1)):
				textedit.insert_text_at_cursor("An invisible wall prevents you from moving any further\nnorth.\n")
			else:
				position[0] -= 1
	
	elif input in ["go south", "go s", "s"]:
		if position[0] == 3:
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			if has_item and (itempos[0] < position[0] or (itempos[1] != position[1] and itempos[0] != position[0]+1)):
				textedit.insert_text_at_cursor("An invisible wall prevents you from moving any further\nsouth.\n")
			else:
				position[0] += 1
	
	elif input in ["go west", "go w", "w"]:
		if position[1] == 0:
			if last_level:
				self.scene.get_tree().change_scene("res://endgame.tscn")
				doing_endgame = true
				self.scene.queue_free()
			else:
				textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			if has_item and (itempos[1] > position[1] or (itempos[1] != position[1]-1 and itempos[0] != position[0])):
				textedit.insert_text_at_cursor("An invisible wall prevents you from moving any further\nwest.\n")
			else:
				position[1] -= 1
	
	elif input in ["go east", "go e", "e"]:
		if position[1] == 3:
			textedit.insert_text_at_cursor("You can't go that way.\n")
		else:
			if has_item and (itempos[1] < position[1] or (itempos[1] != position[1]+1 and itempos[0] != position[0])):
				textedit.insert_text_at_cursor("An invisible wall prevents you from moving any further\neast.\n")
			else:
				position[1] += 1
	
	elif input in ["pick up fish", "pick up fish bowl", "get fish", "get fish bowl"]:
		if has_item:
			if position == itempos:
				textedit.insert_text_at_cursor("There's nothing to pick up here.\n")
			else:
				textedit.insert_text_at_cursor("You can't carry two animals at a time!\n")
		elif map[position[0]][position[1]] != "f":
			textedit.insert_text_at_cursor("There's no fish here.\n")
		else:
			has_item = true
			itempos = [] + position
			textedit.insert_text_at_cursor("You pick up the fish bowl. The sickly fish inside looks at\nyou with hope in her eyes...\n")
			
	elif input in ["pick up crab", "get crab"]:
		if has_item:
			if position == itempos:
				textedit.insert_text_at_cursor("There's nothing to pick up here.\n")
			else:
				textedit.insert_text_at_cursor("You can't carry two animals at a time!\n")
		elif map[position[0]][position[1]] != "c":
			textedit.insert_text_at_cursor("There's no crab here.\n")
		else:
			has_item = true
			itempos = [] + position
			textedit.insert_text_at_cursor("You pick up the crab, trying to comfort it so it doesn't\npinch you.\n")
			
	elif input in ["pick up dolphin", "get dolphin"]:
		if has_item:
			if position == itempos:
				textedit.insert_text_at_cursor("There's nothing to pick up here.\n")
			else:
				textedit.insert_text_at_cursor("You can't carry two animals at a time!\n")
		elif map[position[0]][position[1]] != "d":
			textedit.insert_text_at_cursor("There's no dolphin here.\n")
		else:
			has_item = true
			itempos = [] + position
			textedit.insert_text_at_cursor("You pick up the dolphin. It's a bit slippery but you\nmanage to hold it securely.\n")
			
	elif input in ["pick up snail", "get snail"]:
		if has_item:
			if position == itempos:
				textedit.insert_text_at_cursor("There's nothing to pick up here.\n")
			else:
				textedit.insert_text_at_cursor("You can't carry two animals at a time!\n")
		elif map[position[0]][position[1]] != "s":
			textedit.insert_text_at_cursor("There's no snail here.\n")
		else:
			has_item = true
			itempos = [] + position
			textedit.insert_text_at_cursor("You pick up the snail, holding it carefully in your\nright palm.\n")
	
	elif input in ["drop fish", "drop fish bowl"]:
		drop("fish", "f")
	elif input == "drop snail":
		drop("snail", "s")
	elif input == "drop dolphin":
		drop("dolphin", "d")
	elif input == "drop crab":
		drop("crab", "c")
	
	else:
		textedit.insert_text_at_cursor("I don't know what that means.\n")
	
	print(position)
	print(map)
	print(things)


func drop(animal, symbol):
	if has_item and map[itempos[0]][itempos[1]] == symbol:
		has_item = false
		var tempanimal = map[itempos[0]][itempos[1]]
		map[itempos[0]][itempos[1]] = map[position[0]][position[1]]
		var result = check_match(itempos, tempanimal)
		
		if symbol == "f":
			textedit.insert_text_at_cursor("You drop the fish bowl. Luckily, the glass is reinforced,\nso it doesn't break.\n")
		elif symbol == "d":
			textedit.insert_text_at_cursor("You drop the heavy dolphin onto the ground. Your shoulders\nthank you.\n")
		elif symbol == "c":
			textedit.insert_text_at_cursor("You place the crab onto the ground, thanking it for not\npinching you.\n")
		elif symbol == "s":
			textedit.insert_text_at_cursor("You drop the snail onto the ground. Now that you think of\nit, the snail is disproportionately big. You wonder why.\n")
			
		if position == itempos:
			map[position[0]][position[1]] = map[itempos[0]][itempos[1]]
			map[itempos[0]][itempos[1]] = tempanimal
		elif result[0] == 3:
			textedit.insert_text_at_cursor("With a brilliant flash of light, the %s and its\nneighbours disappear. A booming voice announces,\n\"500 POINTS!\"\n" % animal)
			points += 500
			#map[itempos[0]][itempos[1]] = map[position[0]][position[1]]
			# make things fall
			for animalpos in result[1]:
				map[animalpos[0]][animalpos[1]] = ""
			# horizontal
			if result[1][0][0] == result[1][1][0]:
				for animalpos in result[1]:
					for y in range(animalpos[0], -1, -1):
						if map[y][animalpos[1]] != "":
							map[y+1][animalpos[1]] = map[y][animalpos[1]]
							map[y][animalpos[1]] = ""
			# vertical
			if result[1][0][1] == result[1][1][1]:
				for animalpos in result[1]:
					if animalpos[0] == 3:
						# touches bottom
						map[3][animalpos[1]] = map[0][animalpos[1]]
						map[0][animalpos[1]] = ""
				#var animalpos = result[1][0]
				#for y in range(3, 0, -1):
				#	if map[y][animalpos[1]] != "":
				#		# there can only be one, move to the bottom
				#		map[3][animalpos[1]] = map[y][animalpos[1]]
			#for animalpos in result[0]:
			#	for y in range(animalpos[0], 0, -1):
			#		if map[y][animalpos[1]] != "":
			#			map[animalpos[0]][animalpos[1]] = map[y][animalpos[1]]
			#			things.append(map[y][animalpos[1]])
			#			map[y][animalpos[1]] = ""
			#			break
		elif result[0] == 4:
			textedit.insert_text_at_cursor("With a brilliant flash of light, the %s and its\nneighbours disappear. A booming voice announces,\n\"800 POINTS!\"\n" % animal)
			points += 800
			# make things fall
			for animalpos in result[1]:
				map[animalpos[0]][animalpos[1]] = ""
			# horizontal
			if result[1][0][0] == result[1][1][0]:
				for animalpos in result[1]:
					for y in range(animalpos[0], -1, -1):
						if map[y][animalpos[1]] != "":
							map[y+1][animalpos[1]] = map[y][animalpos[1]]
							map[y][animalpos[1]] = ""
			# vertical: nothing actually needs to happen
		else:
			map[position[0]][position[1]] = map[itempos[0]][itempos[1]]
			map[itempos[0]][itempos[1]] = tempanimal
			textedit.insert_text_at_cursor("A gust of wind blows the %s back to its original\nspot.\n" % animal)
	else:
		textedit.insert_text_at_cursor("%s? What %s?\n" % [animal.capitalize(), animal])


func check_match(coords, animal):
	#var animal = map[coords[0]][coords[1]]
	# vertical
	if position[1] < 3 and map[position[0]][position[1]+1] == animal:
		if position[1] < 2 and map[position[0]][position[1]+2] == animal:
			if position[1] < 1 and map[position[0]][position[1]+3] == animal:
				return [4, [[position[0], position[1]+3],
							[position[0], position[1]+2],
							[position[0], position[1]+1],
							[position[0], position[1]]]]
			if position[1] > 0 and map[position[0]][position[1]-1] == animal:
				return [4, [[position[0], position[1]-1],
							[position[0], position[1]+2],
							[position[0], position[1]+1],
							[position[0], position[1]]]]
			return [3, [[position[0], position[1]+2],
						[position[0], position[1]+1],
						[position[0], position[1]]]]
		if position[1] > 0 and map[position[0]][position[1]-1] == animal:
			if position[1] > 1 and map[position[0]][position[1]-2] == animal:
				return [4, [[position[0], position[1]-1],
							[position[0], position[1]-2],
							[position[0], position[1]+1],
							[position[0], position[1]]]]
			return [3, [[position[0], position[1]-1],
						[position[0], position[1]+1],
						[position[0], position[1]]]]
	if position[1] > 0 and map[position[0]][position[1]-1] == animal:
		if position[1] > 1 and map[position[0]][position[1]-2] == animal:
			if position[1] > 2 and map[position[0]][position[1]-3] == animal:
				return [4, [[position[0], position[1]-3],
							[position[0], position[1]-2],
							[position[0], position[1]-1],
							[position[0], position[1]]]]
			return [3, [[position[0], position[1]-2],
						[position[0], position[1]-1],
						[position[0], position[1]]]]
	# horizontal
	if position[0] < 3 and map[position[0]+1][position[1]] == animal:
		if position[0] < 2 and map[position[0]+2][position[1]] == animal:
			if position[0] < 1 and map[position[0]+3][position[1]] == animal:
				return [4, [[position[0]+3, position[1]],
							[position[0]+2, position[1]],
							[position[0]+1, position[1]],
							[position[0], position[1]]]]
			if position[0] > 0 and map[position[0]-1][position[1]] == animal:
				return [4, [[position[0]-1, position[1]],
							[position[0]+2, position[1]],
							[position[0]+1, position[1]],
							[position[0], position[1]]]]
			return [3, [[position[0]+2, position[1]],
						[position[0]+1, position[1]],
						[position[0], position[1]]]]
		if position[0] > 0 and map[position[0]-1][position[1]] == animal:
			if position[0] > 1 and map[position[0]-2][position[1]] == animal:
				return [4, [[position[0]-1, position[1]],
							[position[0]-2, position[1]],
							[position[0]+1, position[1]],
							[position[0], position[1]]]]
			return [3, [[position[0]-1, position[1]],
						[position[0]+1, position[1]],
						[position[0], position[1]]]]
	if position[0] > 0 and map[position[0]-1][position[1]] == animal:
		if position[0] > 1 and map[position[0]-2][position[1]] == animal:
			if position[0] > 2 and map[position[0]-3][position[1]] == animal:
				return [4, [[position[0]-3, position[1]],
							[position[0]-2, position[1]],
							[position[0]-1, position[1]],
							[position[0], position[1]]]]
			return [3, [[position[0]-2, position[1]],
						[position[0]-1, position[1]],
						[position[0], position[1]]]]
	return [0, []]

