extends Node


var Session : Dictionary = \
{
	"Username": "" or null,
	"WalletAddress": "",
	"Balance": 0.00000000
}

var CurrencyPrice : float



func NewSession(Data : Dictionary):
	Session = Data



func GetSession() -> Dictionary:
	return Session
