//
//  CoinCellModel.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import Foundation

class CoinCellModel{
    
    internal let imageBase:String = "https://www.cryptocompare.com/"
    let imagePath:String
    let coinName:String
    let coinSymbol:String
    let coinAlgo:String
    let totalSuppy:String
    
    init(coinName:String, coinSymbol:String, coinAlgo:String, totalSuppy:String, imagePath:String){
        
        self.coinName = coinName
        self.coinSymbol = coinSymbol
        self.coinAlgo = coinAlgo
        self.totalSuppy = totalSuppy
        self.imagePath = imagePath
        
    }
    
    func coinImage() -> String {
        return "\(self.imageBase)\(imagePath)"
    }
    
}
