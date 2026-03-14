//
//  Color.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct ColorTheme
{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}


@Observable
class CustomerViewModel {
    var customerData: String { "" }
}

@Observable
class MyNestedVM
{
    var customerData = ""
    
    init(customerData: String)
    {
        self.customerData = customerData
    }
}
struct MyNestedView: View {
    @State var customerVM: CustomerViewModel
    @State var myNestedVM: MyNestedVM

    init(customerVM: CustomerViewModel)
    {
        _myNestedVM = State(wrappedValue: MyNestedVM(customerData: customerVM.customerData))
    }
    
    var body: some View {
        
    }
}
//
//
//{"symbol":"BTCUSDT","priceChange":"1155.09000000","priceChangePercent":"1.643","weightedAvgPrice":"70126.78389433","prevClosePrice":"70283.71000000","lastPrice":"71438.80000000","lastQty":"0.00660000","bidPrice":"71438.79000000","bidQty":"2.09152000","askPrice":"71438.80000000","askQty":"0.20329000","openPrice":"70283.71000000","highPrice":"71759.60000000","lowPrice":"69205.91000000","volume":"23276.15119000","quoteVolume":"1632281624.39294490","openTime":1773275269013,"closeTime":1773361669013,"firstId":6095660539,"lastId":6100162398,"count":4501860}
//
//
//
//{"products":[{
//    "product_id":"BTC-USD",
//    "price":"70885.98",
//    "price_percentage_change_24h":"0.52748367948903",
//    "volume_24h":"12320.07272522",
//    "volume_percentage_change_24h":"26.69345393782928",
//    "base_increment":"0.00000001",
//    "quote_increment":"0.01",
//    "quote_min_size":"1",
//    "quote_max_size":"150000000",
//    "base_min_size":"0.00000001",
//    "base_max_size":"3400",
//    "base_name":"Bitcoin",
//    "quote_name":"US Dollar",
//    "watched":false,
//    "is_disabled":false,
//    "new":false,
//    "status":"online",
//    "cancel_only":false,
//    "limit_only":false,
//    "post_only":false,
//    "trading_disabled":false,
//    "auction_mode":false,
//    "product_type":"SPOT",
//    "quote_currency_id":"USD",
//    "base_currency_id":"BTC",
//    "fcm_trading_session_details":null,
//    "mid_market_price":"",
//    "alias":"",
//    "alias_to":["BTC-USDC"],
//    "base_display_symbol":"BTC",
//    "quote_display_symbol":"USD",
//    "view_only":false,
//    "price_increment":"0.01",
//    "display_name":"BTC-USD",
//    "product_venue":"CBE",
//    "approximate_quote_24h_volume":"873320428.8",
//    "new_at":"2023-01-01T00:00:00Z",
//    "market_cap":"",
//    "base_cbrn":"",
//    "quote_cbrn":"",
//    "product_cbrn":"",
//    "icon_color":"",
//    "icon_url":"",
//    "display_name_overwrite":"",
//    "is_alpha_testing":false,
//    "about_description":""
//},{
//    "product_id":"BTC-USDC",
//    "price":"70885.98",
//    "price_percentage_change_24h":"0.52748367948903",
//    "volume_24h":"12320.07272522",
//    "volume_percentage_change_24h":"26.69345393782928",
//    "base_increment":"0.00000001",
//    "quote_increment":"0.01",
//    "quote_min_size":"1",
//    "quote_max_size":"150000000",
//    "base_min_size":"0.00000001",
//    "base_max_size":"3400",
//    "base_name":"Bitcoin",
//    "quote_name":"USDC",
//    "watched":false,
//    "is_disabled":false,
//    "new":false,
//    "status":"online",
//    "cancel_only":false,
//    "limit_only":false,
//    "post_only":false,
//    "trading_disabled":false,
//    "auction_mode":false,
//    "product_type":"SPOT",
//    "quote_currency_id":"USDC",
//    "base_currency_id":"BTC",
//    "fcm_trading_session_details":null,
//    "mid_market_price":"",
//    "alias":"BTC-USD",
//    "alias_to":[],
//    "base_display_symbol":"BTC",
//    "quote_display_symbol":"USD",
//    "view_only":false,
//    "price_increment":"0.01",
//    "display_name":"BTC-USDC",
//    "product_venue":"CBE",
//    "approximate_quote_24h_volume":"873320428.8",
//    "new_at":"2023-01-01T00:00:00Z",
//    "market_cap":"",
//    "base_cbrn":"",
//    "quote_cbrn":"",
//    "product_cbrn":"",
//    "icon_color":"",
//    "icon_url":"",
//    "display_name_overwrite":"",
//    "is_alpha_testing":false,
//    "about_description":""
//}
//
//
//             {
//    "symbol":"BTCUSDT",
//    "priceChange":"376.89000000",
//    "priceChangePercent":"0.534",
//    "weightedAvgPrice":"71995.91898506",
//    "prevClosePrice":"70527.25000000",
//    "lastPrice":"70904.13000000",
//    "lastQty":"0.04097000",
//    "bidPrice":"70904.12000000",
//    "bidQty":"1.02333000",
//    "askPrice":"70904.13000000",
//    "askQty":"1.08817000",
//    "openPrice":"70527.24000000",
//    "highPrice":"73913.74000000",
//    "lowPrice":"70386.01000000",
//    "volume":"36002.29637000",
//    "quoteVolume":"2592018412.73050510",
//    "openTime":1773358513009,
//    "closeTime":1773444913009,
//    "firstId":6099880578,
//    "lastId":6105215859,
//    "count":5335282
//}
//
//            
