extends Node

signal chapter_changed(chapter)

var current_chapter := 1

var chapter_scenes := {

	1: "res://scenes/levels/level_01.tscn",
	2: "res://scenes/levels/level_02.tscn",
	3: "res://scenes/levels/level_03.tscn",
	4: "res://scenes/levels/level_04.tscn",
	5: "res://scenes/levels/level_05.tscn"
}

func start_game():

	current_chapter = 1

	load_chapter(current_chapter)

func next_chapter():

	current_chapter += 1

	if chapter_scenes.has(current_chapter):

		load_chapter(current_chapter)

	else:

		print("SEMUA CHAPTER SELESAI")

func load_chapter(chapter:int):

	if chapter_scenes.has(chapter):

		chapter_changed.emit(chapter)

		get_tree().change_scene_to_file(
			chapter_scenes[chapter]
		)

func restart_current_chapter():

	load_chapter(current_chapter)
