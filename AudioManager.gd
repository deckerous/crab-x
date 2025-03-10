extends Node

# Dictionary to store loaded sounds
var sfx = {}
var bgm = {}

var current_music_player : AudioStreamPlayer 

const mute_db := -80.0 # To mute the audio player
const default_music_db := 0.0 # This is for normal volume
const fade_time := 2.0 # The time it takes to fade in/out in seconds

# Audio Players
@onready var sfx_player = AudioStreamPlayer.new()

@onready var bgm_player = AudioStreamPlayer.new()

func _ready():
	# Add the players to the scene
	add_child(sfx_player)
	add_child(bgm_player)
	
	sfx["fireball"] = preload("res://Assets/SFX/fireball.wav")
	sfx["hit"] = preload("res://Assets/SFX/hit1.wav")
	sfx["heal"] = preload("res://Assets/SFX/8bit_heal.wav")
	sfx["explosion"] = preload("res://Assets/SFX/short_explosion.wav")
	sfx["damage"] = preload("res://Assets/SFX/8bit_big_hit.wav")
	sfx["smallDefeat"] = preload("res://Assets/SFX/8bit_impact.wav")
	sfx["bigDefeat"] = preload("res://Assets/SFX/8bit_whale_shot.wav")
	sfx["minus"] = preload("res://Assets/SFX/8bit_loss.wav")
	sfx["unlock"] = preload("res://Assets/SFX/unlock1.wav")
	sfx["plus"] = preload("res://Assets/SFX/unlock2.wav")
	sfx["coin"] = preload("res://Assets/SFX/coin2.wav")
	sfx["truck"] = preload("res://Assets/SFX/engine.wav")
	sfx["woosh"] = preload("res://Assets/SFX/woosh.wav")
	sfx["victory"] = preload("res://Assets/SFX/fanfare.wav")
	sfx["failure"] = preload("res://Assets/SFX/8bit_lose.wav")


	bgm["spagetti"] = preload("res://Assets/SFX/spagetti western.ogg")
	bgm["jungle"] = preload("res://Assets/SFX/Winning the Race.ogg")
	bgm["beach"] = preload("res://Assets/SFX/EasternArcticDubstep.MP3")
	bgm["beachBoss"] = preload("res://Assets/SFX/dark_forces_loop.mp3")
	bgm["fanfare"] = preload("res://Assets/SFX/fanfare.ogg")

	# Enable looping for BGM
	# bgm_player.stream_loop = true

func _physics_process(delta):
	if !bgm_player.playing and PlayerVariable.level_complete == false :
		update_bgm()

### Play Sound Effect (SFX)
func play_sfx(sound_name: String, volume_db: float = 0.0):
	if sound_name in sfx:
		sfx_player.stream = sfx[sound_name]
		sfx_player.volume_db = volume_db
		sfx_player.play()
	else:
		print("SFX not found:", sound_name)

### Play Background Music (BGM)
func play_bgm(music_name: String, volume_db: float = 0.0):
	if music_name in bgm:
		# If music is already playing, fade it out first
		if bgm_player.playing:
			fade_music_out(func():
				# Switch to the new track after fade-out
				bgm_player.stream = bgm[music_name]
				bgm_player.volume_db = default_music_db  # Start at muted volume
				bgm_player.play()
			)
		else:
			# No music playing, just start immediately
			bgm_player.stream = bgm[music_name]
			bgm_player.volume_db = default_music_db
			bgm_player.play()

	else:
		print("BGM not found:", music_name)

### Pause & Resume BGM
func pause_bgm():
	bgm_player.stream_paused = true

func resume_bgm():
	bgm_player.stream_paused = false

### Stop SFX or BGM
func stop_sfx():
	sfx_player.stop()

func stop_bgm():
	bgm_player.stop()

func update_bgm():
	match PlayerVariable.cur_level:
		"main":
			AudioManager.play_bgm("spagetti")
		0:
			AudioManager.play_bgm("spagetti")
		1:
			AudioManager.play_bgm("beach")
		2:
			AudioManager.play_bgm("beach")
		3:
			AudioManager.play_bgm("beach")
		4:
			AudioManager.play_bgm("jungle")
		5:
			AudioManager.play_bgm("jungle")
		6:
			AudioManager.play_bgm("jungle")

func fade_music_out(callback: Callable = func(): pass):
	if bgm_player.playing:
		var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tween.tween_property(bgm_player, "volume_db", mute_db, fade_time)
		tween.tween_callback(callback)
	else:
		callback.call()

func fade_music_in() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bgm_player, "volume_db", default_music_db, fade_time)
