extends Node

@onready var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var voice_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var typing_player: AudioStreamPlayer = AudioStreamPlayer.new()

signal voice_finished

#==========================
# VOICE
#==========================

var voice_clips_ch1 = {

	"kamar_berat": preload("res://assets/audio/Chapter1/voices/ch1_kamar_berat.ogg"),

	"gue_bikin": preload("res://assets/audio/Chapter1/voices/ch1_gue_bikin.ogg"),

	"hp_mati": preload("res://assets/audio/Chapter1/voices/ch1_hp_mati.ogg"),

	"cari_charger": preload("res://assets/audio/Chapter1/voices/ch1_cari_charger.ogg"),

	"missed_call": preload("res://assets/audio/Chapter1/voices/ch1_missed_call.ogg"),

	"pengen_mi_ayam": preload("res://assets/audio/Chapter1/voices/ch1_pengen_mi_ayam.ogg")

}

var voice_clips_ch2 = {
	
	"aneh": preload("res://assets/audio/Chapter2/voices/ch2_aneh.ogg"),

	"jam_glitch": preload("res://assets/audio/Chapter2/voices/Ch2_jam_glitch.ogg"),

	"kembali_awal": preload("res://assets/audio/Chapter2/voices/Ch2_kembali_awal.ogg"),

	"sepi": preload("res://assets/audio/Chapter2/voices/ch2_sepi.ogg"),

	"sunyi": preload("res://assets/audio/Chapter2/voices/ch2_sunyi.ogg"),

	"udah_ambil": preload("res://assets/audio/Chapter2/voices/ch2_udah_ambil.ogg"),

}

#==========================
# BGM
#==========================

var bgm = {

	"chapter1_room": preload("res://assets/audio/Chapter1/bgm/bgm_chapter1_room.wav"),

	"puzzle": preload("res://assets/audio/Chapter1/bgm/bgm_puzzle.mp3"),

	"phone": preload("res://assets/audio/Chapter1/bgm/bgm_phone.mp3")

}

#==========================
# UI
#==========================

var ui = {

	"click": preload("res://assets/audio/Chapter1/ui/click.ogg"),

	"inventory_open": preload("res://assets/audio/Chapter1/ui/inventory_open.mp3"),

	"correct": preload("res://assets/audio/Chapter2/ui/correct.ogg"),
	
	"wrong": preload("res://assets/audio/Chapter2/ui/wrong.ogg")

}

#==========================
# SFX
#==========================

var sfx = {

	"pickup": preload("res://assets/audio/Chapter1/ui/pickup.ogg"),

	"charging": preload("res://assets/audio/Chapter1/sfx/charging.mp3"),

	"puzzle_fail": preload("res://assets/audio/Chapter1/sfx/puzzle_fail.ogg"),

	"puzzle_success": preload("res://assets/audio/Chapter1/sfx/puzzle_success.ogg"),

	"typing": preload("res://assets/audio/Chapter1/sfx/typewriter.mp3"),

	"transition": preload("res://assets/audio/Chapter1/sfx/transition.mp3"),
	
	"clock": preload("res://assets/audio/Chapter2/sfx/Clock_Tick.mp3"),

	"glitch": preload("res://assets/audio/Chapter2/sfx/glitch.ogg"),
	
	"heartbeat": preload("res://assets/audio/Chapter2/sfx/heartbeat.mp3"),
	
	"notification": preload("res://assets/audio/Chapter2/sfx/notification.ogg"),

}

#==========================
# TYPING
#==========================

var typing_loop := false

func start_typing():

	if !sfx.has("typing"):
		return

	typing_loop = true

	typing_player.stop()
	typing_player.stream = sfx["typing"]
	typing_player.play()


func stop_typing():

	typing_loop = false
	typing_player.stop()


func _on_typing_finished():

	if typing_loop:
		typing_player.play()

#==========================
# READY
#==========================

func _ready():

	add_child(bgm_player)
	add_child(sfx_player)
	add_child(voice_player)
	add_child(typing_player)

	bgm_player.bus = "Music"
	sfx_player.bus = "SFX"
	voice_player.bus = "Voice"
	typing_player.bus = "SFX"

	voice_player.finished.connect(_on_voice_finished)
	typing_player.finished.connect(_on_typing_finished)

#==========================
# BGM
#==========================

func play_bgm(key:String):

	if !bgm.has(key):
		return

	if bgm_player.stream == bgm[key] and bgm_player.playing:
		return

	bgm_player.stop()
	bgm_player.stream = bgm[key]
	bgm_player.play()


func stop_bgm():

	bgm_player.stop()

#==========================
# UI
#==========================

func play_ui(key:String):

	if !ui.has(key):
		return

	sfx_player.stop()
	sfx_player.stream = ui[key]
	sfx_player.play()

#==========================
# SFX
#==========================

func play_sfx(key:String):

	if !sfx.has(key):
		return

	sfx_player.stop()
	sfx_player.stream = sfx[key]
	sfx_player.play()


func stop_sfx():

	sfx_player.stop()

#==========================
# VOICE
#==========================

func play_voice(stream: AudioStream):

	if stream == null:
		return

	voice_player.stop()
	voice_player.stream = stream
	voice_player.play()


func stop_voice():

	voice_player.stop()


func play_voice_key(key:String, chapter:int):

	match chapter:

		1:
			if voice_clips_ch1.has(key):
				play_voice(voice_clips_ch1[key])
				
		2:
			if voice_clips_ch2.has(key):
				play_voice(voice_clips_ch2[key])

#==========================
# SIGNAL
#==========================

func _on_voice_finished():

	voice_finished.emit()

#==========================
#RESET
#==========================
func reset_audio():

	bgm_player.stop()
	sfx_player.stop()
	voice_player.stop()
	typing_player.stop()

	bgm_player.stream = null
	sfx_player.stream = null
	voice_player.stream = null
	typing_player.stream = null

	typing_loop = false
