extends Control


onready var FirstPage : Control = get_node("Background/FirstPage")
onready var SecondPage : Control = get_node("Background/SecondPage")

onready var WalletCoinREST : Node = get_node("WalletCoinAPI")


var GameName : String
var GameDescription : String
var GameOwner : String
var GameStocks : int



func _ready():
	FirstPage.set_visible(true)



func _on_Submit_pressed():
	ContinueListing()



func _on_Cancel_pressed():
	get_tree().quit()



func _on_ConnectGame_pressed():
	WalletCoinREST.ListGame(GameName, "", GameDescription, GameOwner, GameStocks)



func _on_CancelConnection_pressed():
	# Move " ListGame_NotificationLabel " in " WalletCoinAPI " node, from
	# " Background/SecondPage/Notification " to " Background/FirstPage/Form/Notification "
	
	WalletCoinREST.ListGame_NotificationLabel = "Background/FirstPage/Form/Notification"
	
	
	# Open the first page again
	
	for Page in [FirstPage, SecondPage]:
		if Page != FirstPage:
			Page.set_visible(false)
		else:
			Page.set_visible(true)



func ContinueListing():
	var Game = FirstPage.get_node("Form/GameName") as LineEdit
	var Owner = FirstPage.get_node("Form/OwnersUsername") as LineEdit
	var Description = FirstPage.get_node("Form/GameDescription") as TextEdit
	var Stocks = FirstPage.get_node("Form/StocksAmount") as LineEdit
	
	var Notification = FirstPage.get_node("Form/Notification") as Label
	
	
	
	if Game.text.empty() or Owner.text.empty() or Description.text.empty() or Stocks.text.empty():
		Notification.set_text("Please fill in all fields!")
	
	else:
		CompleteListing(Game, Owner, Description, Stocks)



func CompleteListing(Game : String, Owner : String, Description : String, Stocks : int):
	var GameText = SecondPage.get_node("GameName") as Label
	var DescriptionText = SecondPage.get_node("GameDescription") as RichTextLabel
	var StocksText = SecondPage.get_node("StocksAmount") as Label
	
	
	for Page in [FirstPage, SecondPage]:
		if Page != SecondPage:
			Page.set_visible(false)
		else:
			Page.set_visible(true)
	
	
	GameText.set_text(Game)
	DescriptionText.set_text(Description)
	StocksText.set_text(Stocks)
	
	
	GameName = Game
	GameOwner = Owner
	GameDescription = Description
	
	
	# Now move " ListGame_NotificationLabel " in " WalletCoinAPI " node, from
	# " Background/FirstPage/Form/Notification " to " Background/SecondPage/Notification "
	
	WalletCoinREST.ListGame_NotificationLabel = "Background/SecondPage/Notification"
