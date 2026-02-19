extends Button

func getDict(json_string):
	return JSON.parse_string(json_string)
	
func convertToBytes(json) -> PackedByteArray:
	return json.to_utf8_buffer()

func getJSONChecksumHex(json: PackedByteArray):
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(json)
	return ctx.finish()	

func readSaveFile():
	var saveFile = FileAccess.open("user://save.dat", FileAccess.READ)
	var checksumFile = FileAccess.open("user://save.checksum", FileAccess.READ)
	
	var string = saveFile.get_as_text()
	var checksum = checksumFile.get_as_text()
	
	checksum = checksum.hex_decode()
	string = string.hex_decode()
	
	if getJSONChecksumHex(string) != checksum:
		Dialogs.show_popup("Corrupted Save file!")
		return
	
	var json = getDict(string.get_string_from_utf8())
	
	Player.data.coins = json.get_or_add("coins", 5)
	Player.data.level = json.get_or_add("level", 1)
	Player.data.experience = json.get_or_add("exp", 0)
	Player.data.maxExp = json.get_or_add("maxExp", 100)
	Player.data.unlockedBalls = json.get_or_add("unlockedBalls", {})
	Player.data.shields = json.get_or_add("shields", [])
	Player.data.currentShield = json.get_or_add("currentShield", null)
	Player.data.showedMessageFor = json.get_or_add("showedMessageFor", [])
	Player.data.wins = json.get_or_add("wins", {})
	Player.data.tutorials = json.get_or_add("tutorials", [])
	Player.data.setDepositedElixirs(json.get_or_add("deposited", Player.data.getDepositedElixirs()))
	
	Dialogs.show_popup("Loaded save file")

func _pressed():
	readSaveFile()
