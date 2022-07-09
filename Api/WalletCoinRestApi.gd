extends Node


var Wallet : Dictionary = {}
var AccessToken_ : String

var Host : String = "http://127.0.0.1"
var Port : int = 5000


export var Price_NotificationLabel : String = "";
export var AuthUser_NotificationLabel : String = "";
export var Transaction_NotificationLabel : String = "";
export var ListGame_NotificationLabel : String = "";
export var PayToPlay_NotificationLabel : String = "";
export var DonateGame_NotificationLabel : String = "";



# Get the price of WalletCoin

func GetPrice():
	var Http : HTTPRequest = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_get_price_request_completed")
	
	
	
	# Create the request
	
	var RequestPath = "/api/price/"
	var Response = Http.request("%s:%s%s" % [Host, str(Port), RequestPath], [], false, HTTPClient.METHOD_GET)



# Login to your account

func AuthUser(AccessToken : String):
	AccessToken_ = AccessToken
	
	
	var Http : HTTPRequest = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_auth_request_completed")
	
	
	
	# Create the request
	
	var RequestPath = "/api/auth/"
	var RequestBody = {"AccessToken": AccessToken}
	
	var Response = Http.request("%s:%s%s" % [Host, str(Port), RequestPath], [], false, HTTPClient.METHOD_POST, to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", AuthUser_NotificationLabel)



# Login to your wallet

func AuthWallet(AccessToken : String):
	var Http : HTTPRequest = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_auth_request_completed")
	
	
	
	# Create the request
	
	var RequestPath = "/api/wallet/connect/"
	var RequestBody = {"AccessToken": AccessToken}
	
	var Response = Http.request("%s:%s%s" % [Host, str(Port), RequestPath], [], false, HTTPClient.METHOD_POST, to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", AuthUser_NotificationLabel)



# Send some WalletCoins to someone using you access token

func Transaction(AccessToken : String, WalletAddress : String, Amount : float):
	var Http : HTTPRequest = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_transaction_request_completed")
	
	
	
	# Create the request
	
	var RequestPath = "/api/transaction/"
	var RequestBody = {
	"AccessToken": AccessToken,
	"WalletAddress": WalletAddress,
	"Amount": Amount
	}
	
	var Response = Http.request("%s:%s%s" % [Host, str(Port), RequestPath], [], false, HTTPClient.METHOD_POST ,to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", Transaction_NotificationLabel)



# List your game to WalletCoin

func ListGame(Game : String, Website : String, Description : String, Creator : String, Stocks : int):
	var Http = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_list_game_request_completed")
	
	
	
	# Create a request
	
	var RequestPath = "/api/createGame/"
	var RequestBody = {
		"Name": Game,
		"Store": Website,
		"Stocks": {
			"ForSell": 0,
			"Owned": Stocks,
			"Total": Stocks
		},
		"Playings": 0,
		"Value": float(0.00000000), # 0.00000000 WalletCoins
		"Creator": Creator
	}
	
	var Response = Http.request("%s:%s%s", [Host, Port, RequestPath], false, HTTPClient.METHOD_POST, to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", PayToPlay_NotificationLabel)



# Pay a game

func PayToPlay(Game : String, AccessToken : String, Amount : float):
	var Http = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_pay_to_play_request_completed")
	
	
	
	# Create a request
	
	var RequestPath = "/api/payToPlay/"
	var RequestBody = {
		"Game": Game,
		"AccessToken": AccessToken,
		"Amount": Amount
	}
	
	var Response = Http.request("%s:%s%s", [Host, Port, RequestPath], false, HTTPClient.METHOD_POST, to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", PayToPlay_NotificationLabel)



# Donate a game

func DonateGame(Game : String, AccessToken : String, Amount : float):
	var Http = HTTPRequest.new()
	get_parent().add_child(Http)
	Http.connect("request_completed", self, "_on_donation_request_completed")
	
	
	
	# Create a request
	
	var RequestPath = "/api/donateGame/"
	var RequestBody = {
		"Game": Game,
		"AccessToken": AccessToken,
		"Amount": Amount
	}
	
	var Response = Http.request("%s:%s%s", [Host, Port, RequestPath], false, HTTPClient.METHOD_POST, to_json(RequestBody))
	SendMessage("Connecting to WalletCoin Server... Please wait...", DonateGame_NotificationLabel)



# Some functions

func SendMessage(Message : String, LabelPath : String):
	get_parent().get_node(LabelPath).set_text(Message)



# Complete the request to get the price of WalletCoin

func _on_get_price_request_completed(result, response_code, headers, body):
	var ResponseBody = JSON.parse(body.get_string_from_utf8()).result as Dictionary
	Session.CurrencyPrice = ResponseBody.result["Price"]["EUR"]



# Complete authentication request

func _on_auth_request_completed(result, response_code, headers, body):
	var ResponseBody = JSON.parse(body.get_string_from_utf8()).result as Dictionary
	
	
	if response_code == 200:
		SendMessage("Login Successful!", AuthUser_NotificationLabel)
		
		
		# Define the data of wallet
		Session.NewSession({
			"Username": ResponseBody["result"]["Username"],
			"WalletAddress": ResponseBody["result"]["WalletAddress"],
			"Balance": ResponseBody["result"]["Balance"]
		})
	
	
	if response_code == 500:
		SendMessage(str(ResponseBody.result.error), AuthUser_NotificationLabel)
	
	
	# If access token didnt found in Accounts, search it in Wallets.
	
	AuthWallet(AccessToken_)
	AccessToken_ = ""



# Complete authentication request

func _on_auth_wallet_request_completed(result, response_code, headers, body):
	var ResponseBody = JSON.parse(body.get_string_from_utf8()).result as Dictionary
	
	
	if response_code == 200:
		SendMessage("Login Successful!", AuthUser_NotificationLabel)
		
		
		# Define the data of wallet
		Session.NewSession({
			"WalletAddress": ResponseBody["result"]["Address"],
			"Balance": ResponseBody["result"]["Balance"]
		})
	
	
	if response_code == 404 or response_code == 500:
		SendMessage(str(ResponseBody.result.error), AuthUser_NotificationLabel)



# Complete transaction request

func _on_transaction_request_completed(result, response_code, headers, body):
	var ResponseBody = JSON.parse(body.get_string_from_utf8()).result as Dictionary
	
	
	if response_code == 200: SendMessage(str(ResponseBody.result), Transaction_NotificationLabel)
	if response_code == 404: SendMessage(str(ResponseBody.result.error), Transaction_NotificationLabel)



# Complete list game request

func _on_list_game_request_completed(result, response_code, headers, body):
	var ResponseBody = JSON.parse(body.get_string_from_utf8()).result as Dictionary
	
	
	if response_code == 200: SendMessage(str(ResponseBody.result), ListGame_NotificationLabel)
	if response_code == 404: SendMessage(str(ResponseBody.result.error), ListGame_NotificationLabel)



# Complete pay to play request

func _on_pay_to_play_request_completed(result, response_code, headers, body):
	var Response = JSON.parse(body.get_string_from_ascii()).result as Dictionary
	SendMessage(Response.Message, PayToPlay_NotificationLabel)



# Complete donation request

func _on_donation_request_completed(result, response_code, headers, body):
	var Response = JSON.parse(body.get_string_from_ascii()).result as Dictionary
	SendMessage(Response.Message, DonateGame_NotificationLabel)
