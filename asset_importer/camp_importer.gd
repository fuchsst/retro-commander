extends Node


#  1 Enyo (2 missions)  W = McAuliffe  L = Gateway
#  2 McAuliffe (3 missions) W = Gimle  L = Brimstone
#  3 Gateway (3 missions) W = Brimstone  L= Cheng Du
#  4 Gimle (3 missions) W = Dakota  L = Brimstone
#  5 Brimstone (3 missions) W = Dakota  L = Port Hedland
#  6 Cheng Du (3 missions) W = Brimstone  L = Port Hedland
#  7 Dakota (3 missions) W = Kurasawa  L = Rostov
#  8 Port Hedland (3 missions)  W = Rostov  L = Hubble’s Star
#  9 Kurasawa (3 missions)  W = Venice   L= Rostov
# 10 Rostov (3 missions)  W = Venice   L = Hell’s Kitchen
# 11 Hubble’s Star (3 missions)   W = Rostov   L = Hell’s Kitchen
# 12 Venice (4 missions) You win
# 13 Hell’s Kitchen (4 missions) You lose

const mission_index_mapping = [
	{ "season": 1, "mission": 0 },
	{ "season": 1, "mission": 1 },
	{ "season": 2, "mission": 0 },
	{ "season": 2, "mission": 1 },
	{ "season": 2, "mission": 2 },
	{ "season": 3, "mission": 0 },
	{ "season": 3, "mission": 1 },
	{ "season": 3, "mission": 2 },
	{ "season": 4, "mission": 0 },
	{ "season": 4, "mission": 1 },
	{ "season": 4, "mission": 2 },
	{ "season": 5, "mission": 0 },
	{ "season": 5, "mission": 1 },
	{ "season": 5, "mission": 2 },
	{ "season": 6, "mission": 0 },
	{ "season": 6, "mission": 1 },
	{ "season": 6, "mission": 2 },
	{ "season": 7, "mission": 0 },
	{ "season": 7, "mission": 1 },
	{ "season": 7, "mission": 2 },
	{ "season": 8, "mission": 0 },
	{ "season": 8, "mission": 1 },
	{ "season": 8, "mission": 2 },
	{ "season": 9, "mission": 0 },
	{ "season": 9, "mission": 1 },
	{ "season": 9, "mission": 2 },
	{ "season": 10, "mission": 0 },
	{ "season": 10, "mission": 1 },
	{ "season": 10, "mission": 2 },
	{ "season": 11, "mission": 0 },
	{ "season": 11, "mission": 1 },
	{ "season": 11, "mission": 2 },
	{ "season": 12, "mission": 0 },
	{ "season": 12, "mission": 1 },
	{ "season": 12, "mission": 2 },
	{ "season": 12, "mission": 3 },
	{ "season": 13, "mission": 0 },
	{ "season": 13, "mission": 1 },
	{ "season": 13, "mission": 2 },
	{ "season": 13, "mission": 3 },
]

func convert_vega_campaign_camp_file():
	const src_file = "res://asset_importer/wc1_xml2json/output/camp.000.json"
	const assets_dir = "res://Assets/"
	const dst_dir = assets_dir+ "VegaCampaign/"
	
	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		var stellar_backgrounds = json_as_dict["StellarBackgrounds"]
		for i in range(len(stellar_backgrounds)):
			if stellar_backgrounds[i]["Image"] != -1:
				var stellar_background_properties = StellarBackgroundProperties.new()
				stellar_background_properties.image = stellar_backgrounds[i]["Image"]
				stellar_background_properties.rotation = Vector3(stellar_backgrounds[i]["Rotation"]["x"], stellar_backgrounds[i]["Rotation"]["y"], stellar_backgrounds[i]["Rotation"]["z"])

				var season = floor(i / 4)+1
				var mission = i - ((season-1)*4)
				var season_dir = dst_dir + "Season" + str(season) + "/"
				dir.make_dir_recursive(season_dir)
				ResourceSaver.save(stellar_background_properties, season_dir + "StellarBackground" + str(mission) + ".tres")
		
		var series_branches = json_as_dict["SeriesBranch"]
		for branch_idx in range(len(series_branches)):
			var branch = series_branches[branch_idx]
			var series_branch_properties = SeriesBranchProperties.new()
			series_branch_properties.cutscene = branch["Cutscene"]
			series_branch_properties.failure_series = branch["FailureSeries"]
			series_branch_properties.failure_ship = branch["FailureShip"]
			series_branch_properties.missions_active = branch["MissionsActive"]
			series_branch_properties.success_score = branch["SuccessScore"]
			series_branch_properties.success_series = branch["SuccessSeries"]
			series_branch_properties.success_ship = branch["SuccessShip"]
			series_branch_properties.wingman = branch["Wingman"]

			var season_dir = dst_dir + "Season" + str(branch_idx+1) + "/"
			dir.make_dir_recursive(season_dir)
			ResourceSaver.save(series_branch_properties, season_dir + "BranchProperties.tres")

			for mission_idx in range(len(branch["MissionScorings"])):
				var mission = branch["MissionScorings"][mission_idx]
				if mission["FlightPathScoring"].any(func(score): return score != 0):
					var mission_scoring_properties = MissionScoringProperties.new()
					mission_scoring_properties.flight_path_scoring.assign(mission["FlightPathScoring"] as Array[int])
						
					mission_scoring_properties.medal = mission["Medal"]
					mission_scoring_properties.medal_score = mission["MedalScore"]
					ResourceSaver.save(mission_scoring_properties, season_dir + "MissionScorings" + str(mission_idx) + ".tres")

		var bar_seatings = json_as_dict["BarSeating"]
		for i in range(len(bar_seatings)):
			var seating_conf = BarSeatingProperties.new()
			seating_conf.left_pilot_id = bar_seatings[i]["LeftSeat"] + 21 # adapt to match index used for character (e.g. dialog foregrounds)
			seating_conf.right_pilot_id = bar_seatings[i]["RightSeat"] + 21
			if seating_conf.left_pilot_id != seating_conf.right_pilot_id: # both the same == both 0 == no mission
				var season = floor(i / 4)+1
				var mission = i - ((season-1)*4)
				var season_dir = dst_dir + "Season" + str(season) + "/"
				dir.make_dir_recursive(season_dir)
				ResourceSaver.save(seating_conf, season_dir + "BarSeating" + str(mission) + ".tres")


	else:
		print("Failed to open file: " + src_file)
		

func _on_pressed() -> void:
	convert_vega_campaign_camp_file()
	
