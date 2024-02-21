extends Node

var background_image_lookup = {
	"0": "briefing.vga/000/004.png", # Briefing Room wall
	"1": "briefing.vga/000/005.png", # Briefing Room crowd


	"2" : "recroom.vga/001/000.png", # Bar window
	"3" : "recroom.vga/001/001.png", # Bar seat left
	"4" : "recroom.vga/001/002.png", # Bar seat right
}

var forground_image_lookup = {
	"0" : "briefing.vga/000/000.png", #
	"1" : "briefing.vga/000/000.png", # Full Briefing Room
	"2" : "briefing.vga/000/002.png", # Map (Note: combined with briefing.vga/001/001.png on the left)
	"3" : "briefing.vga/000/001.png", # Zoom from commander to map
	"4" : "briefing.vga/000/001.png", # Rendered Map (without border) with the actual mission infos
	"5" : "briefing.vga/000/001.png", # Full Briefing Room, pilots standing up

	"20" : "talking.vga/000/000.png", # Commander
	"21" : "talking.vga/001/000.png", # Spirit
	"25" : "talking.vga/005/000.png", # Angel
	"26" : "talking.vga/006/000.png", # Paladin
	"30" : "talking.vga/010/000.png", # Shotglass
}


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

func convert_vega_campaign():
	const src_file = "res://asset_importer/wc1_xml2json/output/briefing.000.json"
	const assets_dir = "res://Assets/"
	const dst_dir = assets_dir+ "VegaCampaign/"

	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		var conversation_blocks = json_as_dict["ConversationBlocks"]
		var funaral_dialogs = conversation_blocks[0]["Conversations"]
		var colonel_office = conversation_blocks[1]["Conversations"][0]
		var medal_ceremony = conversation_blocks[2]["Conversations"][0]
		
		var funeral_dialogs_resource: FuneralDialogs = convert_funeral_dialogs(funaral_dialogs)
		ResourceSaver.save(funeral_dialogs_resource, dst_dir + "FuneralDialogs.tres")

		var promotion_dialogs_resource: PromotionDialogs = convert_promotion_dialogs(colonel_office, medal_ceremony)
		ResourceSaver.save(promotion_dialogs_resource, dst_dir + "PromotionDialogs.tres")

		for i in range(3,len(conversation_blocks)):
			var season = mission_index_mapping[i - 3]["season"]
			var mission = mission_index_mapping[i - 3]["mission"]
			var season_dir = dst_dir + "Season" + str(season) + "/"
			dir.make_dir_recursive(season_dir)

			var mission_dialogs = conversation_blocks[i]["Conversations"]
			var mission_resource: MissionDialogs = convert_mission_dialogs(mission_dialogs)
			ResourceSaver.save(mission_resource, season_dir + "MissionDialogs" + str(mission) + ".tres")

	else:
		print("Failed to open file: " + src_file)
		
func convert_funeral_dialogs(funaral_dialogs: Array) -> FuneralDialogs:
	var result = FuneralDialogs.new()
	result.player_funeral_end = convert_to_dialog_properties(funaral_dialogs[0])
	result.player_funeral_start_early_game = convert_to_dialog_properties(funaral_dialogs[1])
	result.player_funeral_start_middle_game = convert_to_dialog_properties(funaral_dialogs[2])
	result.player_funeral_start_winning_game = convert_to_dialog_properties(funaral_dialogs[3])
	result.player_funeral_start_losing_game = convert_to_dialog_properties(funaral_dialogs[4])
	result.wingman_funeral_goodbye = convert_to_dialog_properties(funaral_dialogs[5])
	result.wingman_funeral_start = convert_to_dialog_properties(funaral_dialogs[6])

	return result

func convert_promotion_dialogs(colonel_office:Dictionary, medal_ceremony:Dictionary) -> PromotionDialogs:
	var result = PromotionDialogs.new()
	result.colonel_office = convert_to_dialog_properties(colonel_office)
	result.medal_ceremony = convert_to_dialog_properties(medal_ceremony)

	return result


func convert_mission_dialogs(mission_dialogs: Array) -> MissionDialogs:
	var result = MissionDialogs.new()
	result.briefing = convert_to_dialog_properties(mission_dialogs[0])
	result.debriefing = convert_to_dialog_properties(mission_dialogs[1])
	result.bar_shotglass = convert_to_dialog_properties(mission_dialogs[2])
	result.bar_left_pilot = convert_to_dialog_properties(mission_dialogs[3])
	result.bar_right_pilot = convert_to_dialog_properties(mission_dialogs[4])

	return result
	

func convert_to_dialog_properties(conversation: Dictionary) -> Array[DialogProperties]:
	var result: Array[DialogProperties] = []
	var dialog_settings_dict = conversation["DialogSettings"]
	var dialogs_dict = conversation["Dialogs"]
	for i in range(len(dialog_settings_dict)):
		var dialog_properties = DialogProperties.new()
		dialog_properties.background = dialog_settings_dict[i]["Background"]
		dialog_properties.foreground = dialog_settings_dict[i]["Foreground"]
		dialog_properties.delay = dialog_settings_dict[i]["Delay"]
		dialog_properties.text_color = dialog_settings_dict[i]["TextColor"]
		if i < len(dialogs_dict):
			dialog_properties.commands.append_array(dialogs_dict[i]["Commands"])
			dialog_properties.facial_expressions.append_array(dialogs_dict[i]["FacialExpressions"])
			dialog_properties.lip_sync_text = dialogs_dict[i]["LipSyncText"]
			dialog_properties.text = dialogs_dict[i]["Text"]	
		result.append(dialog_properties)

	return result


func _on_pressed() -> void:
	convert_vega_campaign()
