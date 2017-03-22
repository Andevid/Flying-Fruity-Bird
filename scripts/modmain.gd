
extends Node


var current_scene
var next_scene
var current_scene_path = null

var admob = null
var admob_banner_id = "ca-app-pub"
var admob_iad_id = "ca-app-pub"
var admob_video_id = "ca-app-pub"

var gpgs = null

var player_name = ""
var top_highscore_name = "-"

var top_highscore = 0


func _ready():
	initAds()
	initGpgs()
	signInGpgs()
	
	loadIAD()
	

#========================== ADMOB ============================
func initAds():
	if (Globals.has_singleton("AdmobMod")):
		admob = Globals.get_singleton("AdmobMod")
		#You can call admob.init_admob_test or admob.init_admob_real
		#If the second argument is true, the banner ad will be at the top of the screen
		#Function prototype init_admob_test(final String app_id, boolean isTop)
		
		admob.init_admob_test(get_instance_ID(), admob_banner_id, admob_iad_id, admob_video_id, false)
		
		#admob.init_admob_real(get_instance_ID(), admob_banner_id, admob_iad_id, admob_video_id, false)

func loadIAD():
	if (admob != null):
		admob.loadInterstitial()

func showBanner():
	if (admob != null):
		admob.show_banner()
	
	
func hideBanner():
	if (admob != null):
		admob.hide_banner()
		

func showIAD():
	if (admob != null):
		admob.show_interstitial()


#===================== Video Reward ================================
func loadRewardedVideo():
	if (admob != null):
		admob.loadRewardedVideo()

func showRewardedVideo():
	print("show video reward!")
	
	if (admob != null):
		admob.showRewardedVideo()
		
func _video_onRewarded(type, amount):
	print("modmain:reward: " + str(amount))
	main.fruit_count += amount
	main.updateVideoRewarded()
	
	#showPopupReward
	#var current = get_tree().get_root().get_child( get_tree().get_root().get_child_count() -1 )
	#current.add_child()
	#get_tree().get_current_scene().add_child(rewardPopup)
	

#===================== GPGS ================================
func initGpgs():
	if (Globals.has_singleton("GPGSMod")):
		gpgs = Globals.get_singleton("GPGSMod")
		gpgs.init(get_instance_ID())

func signInGpgs():
	if (gpgs != null):
		gpgs.signIn()
		print("signIn progress....")

#callback gpgs on login connected
func _on_gpgs_is_logged_in(login, playerName):
	print("callback:user is login: " + str(login))
	player_name = playerName

func signOutGpgs():
	if (gpgs != null):
		gpgs.signOut()

func getPlayerName():
	var name1 = "Player 1"

	if (player_name):
		return player_name
	else:
		return name1

func unlockAchievement(id):
	if (gpgs != null):
		gpgs.unlockAchy(id)

func submitLeaderboard(val):
	#print("send leaderboard: " + str(val))
	if (gpgs != null):
		gpgs.leaderboardSubmit("lb_id", val)

#callback gpgs on submit leaderboard
func _on_gpgs_leaderboard_submitted_ok(id):
	#print("leaderboard_submitted_ok = " + id)
	pass

func showAchievement():
	if (gpgs != null):
		gpgs.showAchyList()

func showLeaderboard():
	if (gpgs != null):
		gpgs.showLeaderList("LB_id")

func getLeaderboardTopScore():
	if (gpgs != null):
		gpgs.getLeaderboardTopScore("LB_id")

#_on_leaderboard_get_value", new Object[]{scoreValue, id}

#callback on gpgs top highscore update
func _on_leaderboard_top_score(name, score_value, id):
	top_highscore_name = name.left(13)
	top_highscore = score_value

#_on_leaderboard_top_score_error(id)


#-------------------- Utility ----------
func shareImage(title, img_path):
	title = "Let's Jump with Fruity Bird!"

	if (gpgs != null):
		gpgs.shareImage(title, img_path)

