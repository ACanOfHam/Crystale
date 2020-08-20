extends Node

var script_url = "res://ItemDatabase/Item_db.json"
var WorkPath = "res://Items/"

func LoadData(url):
	var file = File.new()
	if url == null: 
		return null
	if !file.file_exists(url): 
		return null
	file.open(url,File.READ)
	var data = {}
	data = parse_json(file.get_as_text())
	file.close()
	return data

func GetItemByID(ItermName):
	var itemData = {}
	itemData = LoadData(script_url)	
	if itemData == null:
		print("Item " + ItermName + " does not exist")
		return null
	
	itemData[ItermName]["name"] = ItermName
	return itemData[ItermName]

func SmartTextureLoad(ItmID):
		ItmID["texture"] = load(WorkPath+ItmID["texture"])
		return ItmID["texture"]
