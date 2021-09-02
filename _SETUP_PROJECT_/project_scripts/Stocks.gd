extends Control





var rng = RandomNumberGenerator.new()
var mu = 1
var n = 50
var dt = 0.1
var x0 = 100
var rand = rand_seed(1)
var sigma:Array
var x
var value = 500
var values:Array
var t = 0
var trend = 0
var STOCKS:Array


var FOUND_ICON = preload("res://Textures/Menu/fish_found.png")
var NOT_FOUND_ICON = preload("res://Textures/Menu/fish_not_found.png")
var selected_stock
onready  var parent = get_parent()

onready  var stocklist = $TabContainer / Stocks
onready  var partlist = $TabContainer / Parts
onready  var fishlist = $TabContainer / Fish
onready  var asset_label = $VBoxContainer / ColorRect / VBoxContainer / Asset_Label
onready  var money_label = $VBoxContainer / ColorRect / VBoxContainer / Money_Label
onready  var stock_label = $VBoxContainer / ColorRect2 / VBoxContainer / Stock_Value











func _ready():
	$"VBoxContainer/ColorRect/TextureRect".texture = $"../Viewport".get_texture()
	$VBoxContainer / ColorRect2 / VBoxContainer / BuyHBox / Buy_Button.connect("pressed", self, "_on_Buy_Button_pressed", [1])
	$VBoxContainer / ColorRect2 / VBoxContainer / BuyHBox / Buy_2.connect("pressed", self, "_on_Buy_Button_pressed", [2])
	$VBoxContainer / ColorRect2 / VBoxContainer / BuyHBox / Buy_5.connect("pressed", self, "_on_Buy_Button_pressed", [5])
	$VBoxContainer / ColorRect2 / VBoxContainer / BuyHBox / Buy_10.connect("pressed", self, "_on_Buy_Button_pressed", [10])
	$VBoxContainer / ColorRect2 / VBoxContainer / BuyHBox / Buy_100.connect("pressed", self, "_on_Buy_Button_pressed", [100])
	$VBoxContainer / ColorRect2 / VBoxContainer / SellHBox / Sell_Button.connect("pressed", self, "_on_Sell_Button_pressed", [1])
	$VBoxContainer / ColorRect2 / VBoxContainer / SellHBox / Sell_2.connect("pressed", self, "_on_Sell_Button_pressed", [2])
	$VBoxContainer / ColorRect2 / VBoxContainer / SellHBox / Sell_5.connect("pressed", self, "_on_Sell_Button_pressed", [5])
	$VBoxContainer / ColorRect2 / VBoxContainer / SellHBox / Sell_10.connect("pressed", self, "_on_Sell_Button_pressed", [10])
	$VBoxContainer / ColorRect2 / VBoxContainer / SellHBox / Sell_100.connect("pressed", self, "_on_Sell_Button_pressed", [100])
	$VBoxContainer / ColorRect / VBoxContainer / Money_Label.text = str("$", Global.money)
	STOCKS = Global.STOCKS.stocks
	selected_stock = Global.STOCKS.stocks[0]
	for stock in STOCKS:
		if stock.asset_type == "equity":
			stocklist.add_item(stock.ticker)
		if stock.asset_type == "part":
			partlist.add_item(stock.ticker)
		if stock.asset_type == "fish":
			fishlist.add_item(stock.ticker)
	
func _physics_process(delta):
	
		

	t += 1
	
	if parent.visible and visible:
		update()
	if fmod(t, 5) != 0 or not visible or not parent.visible:
			return 
	var asset_value = 0
	var stock_index = 0
	var last_type = "equity"
	for stock in STOCKS:
		if stock.asset_type != last_type:
			stock_index = 0
		
			
		
		
		var color = Color(1, 0.8, 0.8)
		var ticker = stock.ticker
		if stock.last_price <= stock.price:
			color = Color(0.8, 1, 0.8)
		if stock.asset_type == "equity":
			stocklist.set_item_custom_fg_color(stock_index, color)
		if stock.asset_type == "part":
			partlist.set_item_custom_fg_color(stock_index, color)
		if stock.asset_type == "fish":
			if Global.STOCKS.FISH_FOUND.find(stock.ticker) == - 1:
				pass
			fishlist.set_item_custom_fg_color(stock_index, color)
		var difference = stepify((stock.price - stock.last_price), 0.1)
		var dif_string = "(" + str(stock.owned) + ") " + ticker
		
		if difference > 0:
			dif_string += " "
		if difference == 0:
			dif_string += "   "
		elif fmod(difference, 1) == 0:
			dif_string += "  "
		dif_string += str(difference)
		if stock.owned:
			dif_string += " $" + str(round(stock.owned * stock.price))
		if stock.asset_type == "equity":
			if stocklist.get_item_text(stock_index).find(stock.ticker) != - 1:
				stocklist.set_item_text(stock_index, dif_string)
				stocklist.update()
		if stock.asset_type == "part":
			if partlist.get_item_text(stock_index).find(stock.ticker) != - 1:
				partlist.set_item_text(stock_index, dif_string)
				if Global.STOCKS.ORGANS_FOUND.find(stock.s_name) == - 1:
					partlist.set_item_icon(stock_index, NOT_FOUND_ICON)
				else :
					partlist.set_item_icon(stock_index, FOUND_ICON)
				partlist.update()
		if stock.asset_type == "fish":
			if fishlist.get_item_text(stock_index).find(stock.ticker) != - 1:
				fishlist.set_item_text(stock_index, dif_string)
				if Global.STOCKS.FISH_FOUND.find(stock.ticker) == - 1:
					fishlist.set_item_icon(stock_index, NOT_FOUND_ICON)
				else :
					fishlist.set_item_icon(stock_index, FOUND_ICON)
				fishlist.update()
		asset_value += stock.price * stock.owned
		last_type = stock.asset_type
		stock_index += 1
	asset_label.text = str("Total holdings: $", stepify(asset_value, 0.01))
	
	
	values = selected_stock.values
	var description = selected_stock.description
	var s_name = selected_stock.s_name
	if Global.STOCKS.FISH_FOUND.find(selected_stock.ticker) == - 1 and selected_stock.asset_type == "fish":
		description = "???"
		s_name = "???"
	if Global.STOCKS.ORGANS_FOUND.find(selected_stock.s_name) == - 1 and selected_stock.asset_type == "part":
		description = "???"
		s_name = "???"
	stock_label.text = str(description, "\n(", selected_stock.owned, ")", s_name, "\nPrice: $", selected_stock.price, " ", stepify((selected_stock.price - selected_stock.starting_price) / abs(selected_stock.starting_price) * 100, 0.01), "%\nMKC: $", (selected_stock.price * selected_stock.issued_shares))
	money_label.text = str("Cash: $", Global.money)
	
		
	
func _draw():
	var x_min = rect_size.x / 2
	var x_max = $VBoxContainer / ColorRect.rect_global_position.x + $VBoxContainer / ColorRect.rect_size.x
	var x_value = x_min
	var last_x = x_min
	for v in range(2, values.size() - 1):
		var y_value = 0
		var l_y_value = 0
		if values[v] > 0:
			y_value = - (values[v] - values.min()) / (values.max() - values.min() + 0.0001) * 100
			l_y_value = - (values[v - 1] - values.min()) / (values.max() - values.min() + 0.0001) * 100
		var lv = clamp(v - 1, 0, 100)
		
		var color = Color(0, 1, 0)
		if values[v] < values[v - 1] or values[v] == 0:
			color = Color(1, 0, 0)
		
		draw_line(Vector2(last_x, 200 + l_y_value), Vector2(x_value, 200 + y_value), color)
		last_x = x_value
		x_value += x_min / 100





func _on_Stock_List_item_activated(index):
	pass


func _on_Stock_List_item_selected(index):
	for stock in STOCKS:
		
		if stock.asset_type == "equity" and $TabContainer.current_tab == 0:
			if stocklist.get_item_text(index).find(stock.ticker) != - 1:
				for i in $"../Viewport/Fish".FISH:
					i.hide()
				for i in $"../Viewport/Organs".ORG:
					i.hide()
				selected_stock = stock

		if stock.asset_type == "part" and $TabContainer.current_tab == 1:
			if partlist.get_item_text(index).find(stock.ticker) != - 1:
				for i in $"../Viewport/Fish".FISH:
					i.hide()
				for i in $"../Viewport/Organs".ORG:
					i.hide()
				selected_stock = stock
				if Global.STOCKS.ORGANS_FOUND.find(stock.s_name) != - 1:
					$"../Viewport/Organs".ORG[index].show()
		
		if stock.asset_type == "fish" and $TabContainer.current_tab == 2:
			if fishlist.get_item_text(index).find(stock.ticker) != - 1:
				for i in $"../Viewport/Fish".FISH:
					
					i.hide()
				for i in $"../Viewport/Organs".ORG:
					i.hide()
				if Global.STOCKS.FISH_FOUND.find(stock.ticker) != - 1:
					
					$"../Viewport/Fish".FISH[index].show()
				selected_stock = stock

	


func _on_Buy_Button_pressed(amount):
	if Global.money > selected_stock.price * amount and selected_stock.price > 0.9:
		Global.money -= selected_stock.price * amount
		selected_stock.owned += amount
		$VBoxContainer / ColorRect / VBoxContainer / Money_Label.text = str("$", Global.money)
		Global.save_game()
		Global.STOCKS.save_stocks("user://stocks.save")


func _on_Sell_Button_pressed(amount):
	if selected_stock.owned >= amount:
		selected_stock.owned -= amount
		Global.money += selected_stock.price * amount
		$VBoxContainer / ColorRect / VBoxContainer / Money_Label.text = str("$", Global.money)
		Global.save_game()
		Global.STOCKS.save_stocks("user://stocks.save")
