extends Area3D

@export var story_index = 1

func _on_body_entered(body):

	if body.name == "Player":

		if StoryManager.current_story == story_index:

			StoryManager.advance_story()

			queue_free()
