extends Node

@onready var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var voice_player: AudioStreamPlayer = AudioStreamPlayer.new()

var voice_clips_ch1 = {
	"kamar_berat": preload("res://assets/audio/voices/ch1_kamar_berat.ogg"),
	"gue_bikin": preload("res://assets/audio/voices/ch1_gue_bikin.ogg"),
	"pengen_mi_ayam": preload("res://assets/audio/voices/ch1_pengen_mi_ayam.ogg"),
	"hp_mati": preload("res://assets/audio/voices/ch1_hp_mati.ogg"),
	"cari_charger": preload("res://assets/audio/voices/ch1_cari_charger.ogg"),
	"missed_call": preload("res://assets/audio/voices/ch1_missed_call.ogg")
}

var voice_clips_ch2 = {
	"sepi": preload("res://assets/audio/voices/ch2_sepi.ogg"),
	"udah_ambil": preload("res://assets/audio/voices/ch2_udah_ambil.ogg"),
	"jam_glitch": preload("res://assets/audio/voices/ch2_jam_glitch.ogg"),
	"aneh": preload("res://assets/audio/voices/ch2_aneh.ogg"),
	"kembali_awal": preload("res://assets/audio/voices/ch2_kembali_awal.ogg"),
	"sunyi": preload("res://assets/audio/voices/ch2_sunyi.ogg")
}

func _ready():
	add_child(bgm_player)
	add_child(sfx_player)
	add_child(voice_player)

	bgm_player.bus = "Music"
	sfx_player.bus = "SFX"
	voice_player.bus = "Voice"


func play_bgm(music: AudioStream):
	if music:
		bgm_player.stream = music
		bgm_player.play()


func stop_bgm():
	bgm_player.stop()


func fade_bgm(duration := 1.0):
	var tween = create_tween()
	tween.tween_property(bgm_player,"volume_db",-80.0,duration)
	await tween.finished
	bgm_player.stop()
	bgm_player.volume_db = 0


func play_sfx(sound: AudioStream):
	if sound:
		sfx_player.stream = sound
		sfx_player.play()


func play_voice(stream: AudioStream):
	if stream:
		voice_player.stop()
		voice_player.stream = stream
		voice_player.play()


func stop_voice():
	voice_player.stop()


func play_voice_key(key:String,chapter:int):

	match chapter:

		1:
			if voice_clips_ch1.has(key):
				play_voice(voice_clips_ch1[key])

		2:
			if voice_clips_ch2.has(key):
				play_voice(voice_clips_ch2[key])
