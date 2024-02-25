class_name SaveGame
extends Resource

const SAVEGAME_BLOCK_SIZE = 828

static func serialize_savegame(savename:String, game_state: GameState) -> PackedByteArray:
	# Parse game structures into outd
	var outd = PackedByteArray()

	var savename_bytes = savename.to_utf8_buffer()
	savename_bytes.resize(18)
	outd.append_array(savename_bytes)

	for p in game_state.pilots:
		var pilot_name_bytes = p.pilot_name.to_utf8_buffer()
		pilot_name_bytes.resize(14)
		var callsign_bytes = p.callsign.to_utf8_buffer()
		callsign_bytes.resize(14)
		outd.append_array(pilot_name_bytes)
		outd.append_array(callsign_bytes)
		outd.append_array(PackedByteArray([0, 0]))  # unknown
		outd.append_array(_to_little_endian(p.rank, 2))
		outd.append_array(_to_little_endian(p.missions, 2))
		outd.append_array(_to_little_endian(p.kills, 2))

		outd.append_array(PackedByteArray([0, 0]))  # unknown

	outd.append_array(_to_little_endian(0x429A0000, 4))

	var medals = game_state.player.medals
	outd.append(medals.bronzestars)
	outd.append(medals.silverstars)
	outd.append(medals.goldstars)
	outd.append(medals.goldsun)
	outd.append(medals.pewter)
	
	outd.append(medals.ribbon_acad)
	outd.append(medals.ribbon_flts)
	outd.append(medals.ribbon_vega)
	outd.append(medals.ribbon_horn)
	outd.append(medals.ribbon_rpir)
	outd.append(medals.ribbon_scim)
	outd.append(medals.ribbon_rapt)
	outd.append(medals.ribbon_ace)
	outd.append(medals.ribbon_acea)
	outd.append(medals.ribbon_5m)
	outd.append(medals.ribbon_10m)
	outd.append(medals.ribbon_15m)
	
	outd.append(game_state.mission_i)
	outd.append(game_state.series_i)
	outd.append_array([0, 0, 0, 0, 0, 0, 0, 0, 0])

	for p in game_state.pilots:
		outd.append_array(_to_little_endian(p.died_in, 2))

	for a in game_state.aces:
		outd.append(a.died_in)

	outd.append_array(_to_little_endian(game_state.date, 2))
	outd.append_array(_to_little_endian(game_state.year, 2))

	return outd
	
static func deserialize_savegame(savegame_bytes:PackedByteArray) -> GameState:
	var loaded_game_state = GameState.new()

	const PILOT_DATA_BLOCK_SIZE=38
	const PILOT_DATA_BLOCK_COUNT=9 # 8 wingman + player at the end
	const PILOT_DATA_OFFSET=18
	const PILOT_DATA_TOTAL_SIZE=PILOT_DATA_BLOCK_SIZE*PILOT_DATA_BLOCK_COUNT
	
	var pilot_data = savegame_bytes.slice(PILOT_DATA_OFFSET, PILOT_DATA_OFFSET+PILOT_DATA_TOTAL_SIZE)
	var pilots: Array[PackedByteArray] = []
	var num_wingman=PILOT_DATA_BLOCK_COUNT-1
	loaded_game_state.pilots.resize(PILOT_DATA_BLOCK_COUNT)

	for i in range(PILOT_DATA_BLOCK_COUNT):
		pilots.append(pilot_data.slice(i*PILOT_DATA_BLOCK_SIZE, (i+1) * PILOT_DATA_BLOCK_SIZE))
	
	loaded_game_state.pilots.clear()

	for i in range(pilots.size()):
		var p = pilots[i]
		var name_end_index = p.find(0)
		var name = p.slice(0, name_end_index).get_string_from_ascii()
		
		var callsign_end_index = p.slice(14, 28).find(0)
		var callsign = p.slice(14, 14 + callsign_end_index).get_string_from_ascii()
		var rank = Pilot.Rank.values()[_little_endian_to_int(p.slice(30, 32))]
		var missions = _little_endian_to_int(p.slice(32, 34))
		var kills = _little_endian_to_int(p.slice(34, 36))
		
		if (i<num_wingman):
			loaded_game_state.pilots.append(Pilot.new(callsign, name,  rank, -1, kills, missions))
		else:
			loaded_game_state.player = Player.new(callsign,
			name,
			rank,
			-1,
			kills,
			missions)
		
	var player_data = savegame_bytes.slice(364, 381)
	loaded_game_state.player.medals.bronze_stars = player_data[0]
	loaded_game_state.player.medals.silver_stars = player_data[1]
	loaded_game_state.player.medals.gold_stars = player_data[2]
	loaded_game_state.player.medals.gold_sun = player_data[3]
	loaded_game_state.player.medals.pewter = player_data[4]
	loaded_game_state.player.medals.ribbon_acad = player_data[5]
	loaded_game_state.player.medals.ribbon_flts = player_data[6]
	loaded_game_state.player.medals.ribbon_vega = player_data[7]
	loaded_game_state.player.medals.ribbon_horn = player_data[8]
	loaded_game_state.player.medals.ribbon_rpir = player_data[9]
	loaded_game_state.player.medals.ribbon_scim = player_data[10]
	loaded_game_state.player.medals.ribbon_rapt = player_data[11]
	loaded_game_state.player.medals.ribbon_ace = player_data[12]
	loaded_game_state.player.medals.ribbon_acea = player_data[13]
	loaded_game_state.player.medals.ribbon_5m = player_data[14]
	loaded_game_state.player.medals.ribbon_10m = player_data[15]
	loaded_game_state.player.medals.ribbon_15m = player_data[16]

	loaded_game_state.mission = savegame_bytes[381]
	loaded_game_state.series = savegame_bytes[382]

	var pilot_states = savegame_bytes.slice(392, 408)
	for i in range(8):
		loaded_game_state.pilots[i].pilot_status = _little_endian_to_int(pilot_states.slice(i * 2, (i + 1) * 2))

	var ace_states = savegame_bytes.slice(408, 412)
	const NUM_ACES=4
	# "Bhurak Starkiller", "Dakhath Deathstroke", "Khajja the Fang", "Bakhtosh Redclaw")]
	for i in range(NUM_ACES):
		loaded_game_state.ace_states[i] = ace_states[i]

	loaded_game_state.date = _little_endian_to_int(savegame_bytes.slice(412, 414))
	loaded_game_state.year = _little_endian_to_int(savegame_bytes.slice(414, 416))
	loaded_game_state.promotion_points = _little_endian_to_int(savegame_bytes.slice(420, 422))
	loaded_game_state.victory_points = _little_endian_to_int(savegame_bytes.slice(424, 426))

	const MISSION_DATA_BLOCK_SIZE=100
	const MISSION_DATA_BLOCK_COUNT=4
	const MISSION_DATA_OFFSET=428
	const MISSION_DATA_TOTAL_SIZE=MISSION_DATA_BLOCK_SIZE*MISSION_DATA_BLOCK_COUNT
	var mission_data = savegame_bytes.slice(MISSION_DATA_OFFSET, MISSION_DATA_OFFSET+MISSION_DATA_TOTAL_SIZE)
	var missions = Array()
	for i in range(MISSION_DATA_BLOCK_COUNT):
		var mission_block_data=mission_data.slice(i*MISSION_DATA_BLOCK_SIZE, (i+1) *MISSION_DATA_BLOCK_SIZE)
		missions.append(mission_block_data)

	for m in missions:
		#var nav_data = [m.slice(i, i + 25) for i in range(0, m.size(), 25)]
		#loaded_game_state.mission_data.append(nav_data.duplicate())
		pass
		
	return loaded_game_state

static func _to_little_endian(value, bytes_length):
	var ba = PackedByteArray()
	var val = value
	for i in range(bytes_length):
		ba.append(val & 0xFF)
		val >>= 8
	return ba

static func _little_endian_to_int(byte_array):
	var value = 0
	for i in range(byte_array.size()):
		value |= byte_array[i] << (i * 8)
	return value
