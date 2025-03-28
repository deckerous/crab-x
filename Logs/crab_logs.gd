extends Node

# Dev mode: Set to true to eat logs
@export var developer_logs: bool = true
@export var version: String = "1.0.2"

# Login Check
@onready var logged_in = false

# Firestore Data
var firestore_collection: FirestoreCollection
var user_info: Dictionary = {}

# Global Statistics
var time_elapsed: float = 0.0
var last_input: float = 0.0
var logged_AFK: bool = false

# Stage Statistic Collection
var curr_tutorial_step: String = ""
var curr_stage_id: String = "main_menu"
var stage_time_elapsed: float = 0.0
var stage_deaths: int = 0
var in_stage = false

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	if OS.get_name() == "Web":
		if OS.has_feature("web_android") or OS.has_feature("web_ios"):
			user_info["OS"] = "Web Mobile"
		elif OS.has_feature("web_windows"):
			user_info["OS"] = "Web Windows"
		elif OS.has_feature("web_macos"):
			user_info["OS"] = "Web Mac"
		else:
			user_info["OS"] = "Web Linux"
	else:
		user_info["OS"] = OS.get_name()
	
	if !developer_logs:
		Firebase.Auth.signup_succeeded.connect(_logged_in)
		Firebase.Auth.login_failed.connect(_login_failed)
		Firebase.Auth.login_anonymous()
	else:
		print("[CrabLogs] >> Developer mode activated, logs will be ommited from Firebase")
		push_warning("[CrabLogs] >> Developer mode activated, logs will be ommited from Firebase")
		_logged_in({"localid": "Developer"})
	
func _process(delta: float) -> void:
	time_elapsed += delta
	if in_stage:
		stage_time_elapsed += delta
	
	if Input.is_anything_pressed():
		if logged_AFK:
			log_player_return()
		logged_AFK = false
		last_input = time_elapsed
	
	if !logged_AFK and time_elapsed - last_input >= 300:
		logged_AFK = true
		log_player_quit(true)

func _login_failed(code, message: String):
	printerr("[CrabLogs] >> Err " + str(code) + ": " + message)
	push_error("[CrabLogs] >> Err " + str(code) + ": " + message)

func _logged_in(auth_info: Dictionary):
	print("[CrabLogs] >> Successful login for user " + auth_info["localid"])
	user_info.merge(auth_info)
	
	if !developer_logs:
		firestore_collection = Firebase.Firestore.collection('Logs')
	logged_in = true
	log_event("game_start", {"logged_in": true})
	
func get_device_type() -> String:
	return user_info["OS"]

func log_event(event_type: String, details: Dictionary):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		return
		
	# Add details to dict
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp": time_elapsed,
		"Log Type": event_type,
		"Version": version,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	data.merge(details)
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_stage_complete(weapon: String, crabs_remaining: int, sheckles_remaining: int, kills: int):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		# Reset stage statistics
		_reset_stage()
		return
		
	# Add stage completion data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "stage_end",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Duration": stage_time_elapsed,
		"Weapon": weapon,
		"Crabs Remaining": crabs_remaining,
		"Sheckles Remaining": sheckles_remaining,
		"Kills": kills,
		"Deaths": stage_deaths,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Reset stage statistics
	_reset_stage()
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_stage_restart():
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		# Start stage statistic collection
		return
	
	# Add stage start data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "stage_restart",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_stage_start(stage_id: String):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		# Start stage statistic collection
		curr_stage_id = stage_id
		in_stage = true
		return
	
	# Add stage start data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "stage_start",
		"Version": version,
		"Stage ID": stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Start stage statistic collection
	curr_stage_id = stage_id
	in_stage = true
	curr_tutorial_step = stage_id
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_player_death(enemy_id: String):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		# Increment stage deaths
		stage_deaths += 1
		return
	
	# Add player death data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "player_death",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Killed By" : enemy_id,
		"Duration": stage_time_elapsed,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Start stage statistic collection
	stage_deaths += 1
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_player_quit(afk: bool):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		return
	
	# Add player quit data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed - 300 if afk else time_elapsed,
		"Log Type": "player_quit",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")
	
func log_player_return():
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		return
	
	# Add player quit data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "player_return",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")
	
func log_tutorial_step(tutorial_part: String):
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		curr_tutorial_step = tutorial_part
		return
	
	# Add player tutorial data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "tutorial_step",
		"Version": version,
		"Tutorial Part": tutorial_part,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	curr_tutorial_step = tutorial_part
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")
	
func log_dialogue_complete():
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		return
	
	# Add player tutorial data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "dialogue_complete",
		"Version": version,
		"Tutorial Part": curr_tutorial_step,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func log_player_continue():
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		return
	
	# Add player continue data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "player_continue",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")
	
func log_force_quit():
	# Check for login
	if !logged_in:
		print("[CrabLogs] >> User not logged in, log nullified")
		push_warning("[CrabLogs] >> User not logged in, log nullified")
		
		return
	
	# Add player force quit data to dictionary
	var data: Dictionary = {
		"UID": user_info["localid"],
		"OS": user_info["OS"],
		"Timestamp" : time_elapsed,
		"Log Type": "player_force_quit",
		"Version": version,
		"Stage ID": curr_stage_id,
		"Difficulty Scaling": PlayerVariable.difficulty_scale,
		"No Dialogue Tutorial": PlayerVariable.no_dialogue
	}
	
	# Push log to firestore
	if !developer_logs:
		await firestore_collection.add("", data)
	print("[CrabLogs] >> Pushed data " + str(data) + " to logs")

func _reset_stage():
	in_stage = false
	stage_deaths = 0
	stage_time_elapsed = 0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await log_force_quit()
		get_tree().quit() # default behavior
