extends Button

func parseIntoJSON():
	return JSON.stringify({
		"coins": Player.data.coins,
		"level": Player.data.level,
		"exp": Player.data.experience,
		"maxExp": Player.data.maxExp,
		"showedMessageFor": Player.data.showedMessageFor,
		"shields": Player.data.shields,
		"currentShield": Player.data.currentShield,
		"unlockedBalls": Player.data.unlockedBalls,
		"tutorials": Player.data.tutorials,
		"wins": Player.data.wins,
		"elixir": Player.data.elixir,
		"deposited": Player.data.getDepositedElixirs(),
	})
	
func convertToBytes(json) -> PackedByteArray:
	return json.to_utf8_buffer()
	
func getJSONChecksumHex(json: PackedByteArray):
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(json)
	return ctx.finish().hex_encode()

func writeJsonAndChecksum(json: String, checksum: String):
	var bytes = convertToBytes(json)
	var encodedJSon = bytes.hex_encode()
	var file := FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_string(encodedJSon)
	file.close()
	
	var checksumFile := FileAccess.open("user://save.checksum", FileAccess.WRITE)
	checksumFile.store_string(checksum)
	checksumFile.close()
	
	Dialogs.show_popup("Saved data")

func _pressed():
	var json = parseIntoJSON()
	var checksume = getJSONChecksumHex(convertToBytes(json))
	writeJsonAndChecksum(json, checksume)
