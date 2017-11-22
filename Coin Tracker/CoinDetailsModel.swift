//
//  CoinDetailsModel.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import Foundation

class CoinDetailsModel{
    
    let marketCap:String
    let hourHigh:String
    let hourLow:String
    let hourOpen:String
    let dayHigh:String
    let dayLow:String
    let dayOpen:String
    let priceEUR:String
    let priceUSD:String
    let priceBTC:String
    
    init(marketCap:String, hourHigh:String, hourLow:String, hourOpen:String, dayHigh:String, dayLow:String, dayOpen:String, priceEUR:String, priceUSD:String, priceBTC:String){
        self.marketCap = marketCap
        self.hourHigh = hourHigh
        self.hourLow = hourLow
        self.hourOpen = hourOpen
        self.dayHigh = dayHigh
        self.dayLow = dayLow
        self.dayOpen = dayOpen
        self.priceBTC = priceBTC
        self.priceEUR = priceEUR
        self.priceUSD = priceUSD
    }
    
    
    
}
