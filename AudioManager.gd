extends Node

# Dictionary to store loaded sounds
var sfx = {}
var bgm = {}

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
	bgm["race"] = preload("res://Assets/SFX/Winning the Race.ogg")
	bgm["desert"] = preload("res://Assets/SFX/EasternArcticDubstep.MP3")
	bgm["fanfare"] = preload("res://Assets/SFX/fanfare.ogg")

	# Enable looping for BGM
	# bgm_player.stream_loop = true

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
		bgm_player.stream = bgm[music_name]
		bgm_player.volume_db = volume_db
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
