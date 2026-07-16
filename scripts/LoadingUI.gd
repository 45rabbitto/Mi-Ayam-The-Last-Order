extends CanvasLayer

var target_scene: String = "res://scenes/level/Level_2_Normal.tscn" 

func _ready():
	print("Loading mulai")
	if AudioManager:
		AudioManager.play_sfx("transition")
	
	await get_tree().create_timer(2.0).timeout
	print("Timer selesai")
	
	if has_node("AnimationPlayer"):
		print("Play Fade")
		$AnimationPlayer.play("Fade")
		# Tunggu sesuai durasi animasi (2 detik), bukan animation_finished
		await get_tree().create_timer(2.0).timeout
		print("Fade selesai (timeout)")
	
	print("Pindah scene ke: ", target_scene)
	var err = get_tree().change_scene_to_file(target_scene)
	if err != OK:
		print("GAGAL PINDAH KE SCENE TARGET! Error code: ", err)
