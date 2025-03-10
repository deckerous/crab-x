extends Node

# Dictionary to store loaded sounds
var sfx = {}
var bgm = {}

var current_music_player : AudioStreamPlayer 

const mute_db := -80.0 # To mute the audio player
const default_music_db := -10.0 # This is for normal volume
const fade_time := 2.0 # The time it takes to fade in/out in seconds

# Audio Players
@onready var sfx_player = AudioStreamPlayer.new()

@onready var bgm_player = AudioStreamPlayer.new()

func _ready():
	# Add the players to the scene
	add_child(sfx_player)
	add_child(bgm_player)
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	sfx["fireball"] = preload("res://Assets/SFX/fireball.wav")
	sfx["hit"] = preload("res://Assets/SFX/realistic_gunshot.wav")
	sfx["glock"] = preload("res://Assets/SFX/8bit_glock.wav")
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
	sfx["rpg"] = preload("res://Assets/SFX/8bit_rpg.wav")
	sfx["sniper"] = preload("res://Assets/SFX/sniper.wav")


	bgm["spagetti"] = preload("res://Assets/SFX/spagetti western.ogg")
	bgm["jungle"] = preload("res://Assets/SFX/Winning the Race.ogg")
	bgm["beach"] = preload("res://Assets/SFX/EasternArcticDubstep.MP3")
	bgm["beachBoss"] = preload("res://Assets/SFX/dark_forces_loop.mp3")
	bgm["fanfare"] = preload("res://Assets/SFX/fanfare.ogg")
	bgm["finalBoss"] = preload("res://Assets/SFX/deagle_theme.mp3")

	# Enable looping for BGM
	# bgm_player.stream_loop = true

func _physics_process(delta):
	if !bgm_player.playing and PlayerVariable.level_complete == false :
		update_bgm()
	if !bgm_player.playing and PlayerVariable.level_complete == true:
		await get_tree().create_timer(3).timeout
		update_bgm()

### Play Sound Effect (SFX)
func play_sfx(sound_name: String, volume_db: float = 0.0):
	if sound_name in sfx:
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		
		sfx_player.stream = sfx[sound_name]
		sfx_player.volume_db = volume_db
		match sound_name:
			"damage": 
				sfx_player.volume_db = -15.0
				sfx_player.set_max_polyphony(3)
				sfx_player.set_pitch_scale(randf_range(1, 1.1))
			"fireball": 
				sfx_player.volume_db = -10.0
				sfx_player.set_pitch_scale(randf_range(0.9, 1.1))
			"glock":
				sfx_player.volume_db = -10.0
				sfx_player.set_pitch_scale(randf_range(0.9, 1.1))
			"woosh":
				sfx_player.volume_db = -10.0
				sfx_player.set_pitch_scale(randf_range(1.9, 2.1))
			"sniper": 
				sfx_player.volume_db = -20.0
			"victory":
				sfx_player.volume_db = 5
			"rpg":
				sfx_player.volume_db = 5
			"coin": 
				sfx_player.volume_db = -10.0
		sfx_player.connect("finished", sfx_player.queue_free)
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
				bgm_player.volume_db = default_music_db
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
	var cur_level
	var root_children = get_tree().root.get_children()
	for child in root_children:
		if child is Level:
			cur_level = child.level_id
	if cur_level == "tutorial":
		AudioManager.play_bgm("spagetti")
	elif cur_level == "beach1" or cur_level == "beach2" or cur_level == "beach3":
		AudioManager.play_bgm("beach")
	elif cur_level == "jungle1" or cur_level == "jungle2" or cur_level == "jungle3":
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
