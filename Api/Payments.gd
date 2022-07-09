extends Control


onready var AmountTextEdit : LineEdit = get_node("Background/Payment/Amount")
onready var AccessTokenTextEdit : LineEdit = get_node("Background/Payment/AccessToken")
onready var Notification : Label = get_node("Background/Payment/Notification")

onready var WalletCoin : Node = get_node("WalletCoinAPI")


export var Amount : float = 0.005 # Define an amount of your choice
export var Recipient : String = "" # Choose a recipient wallet



func _ready():
	AmountTextEdit.set_text(str(Amount))



func _on_PayNow_pressed():
	if AccessTokenTextEdit.text.empty():
		Notification.set_text("Give an access token!")
	else:
		CompletePayment(AccessTokenTextEdit.text, Amount)



func CompletePayment(AccessToken : String, Amount_ : float):
	WalletCoin.Transaction(AccessToken, Recipient, Amount)



func _on_CancelPayment_pressed():
	get_tree().quit()
