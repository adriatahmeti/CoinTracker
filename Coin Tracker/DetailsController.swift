//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreData

class DetailsController: UIViewController {

    //selectedCoin deklaruar me poshte mbushet me te dhena nga
    //controlleri qe e thrret kete screen (Shiko ListaController.swift)
    var selectedCoin:CoinCellModel!
    var rezultati = false
    
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    
    
    //APIURL per te marre te dhenat te detajume per coin
    //shiko: https://www.cryptocompare.com/api/ per detaje
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let coins = NSFetchRequest<NSFetchRequestResult>(entityName: "Dataxc")
        coins.predicate = NSPredicate(format: "coinSymbol = %@", selectedCoin.coinSymbol)
        coins.returnsObjectsAsFaults = false
        
        do {
            let rezultati =  try context.fetch(coins)
            if rezultati.count > 0 {
                self.rezultati = true
            }
        } catch  {
            print("Gabim gjate fshirjes")
        }
        
        //brenda ketij funksioni, vendosja foton imgFotoja Outletit
        //duke perdorur AlamoFireImage dhe funksionin:
        //af_setImage(withURL:URL)
        //psh: imgFotoja.af_setImage(withURL: URL(string: selectedCoin.imagePath)!)
        //Te dhenat gjenerale per coin te mirren nga objeti selectedCoin
        
        imgFotoja.af_setImage(withURL: URL(string: selectedCoin.coinImage())!)
        lblCoinName.text = selectedCoin.coinName
        
        let params : [String:String] = ["fsyms" : selectedCoin.coinSymbol, "tsyms" : "BTC,USD,EUR"]
        getDetails(params: params)
        
        
        //Krijo nje dictionary params[String:String] per ta thirrur API-ne
        //parametrat qe duhet te jene ne kete params:
        //fsyms - Simboli i Coinit (merre nga selectedCoin.coinSymbol)
        //tsyms - llojet e parave qe na duhen: ""BTC,USD,EUR""
        
        //Thirr funksionin getDetails me parametrat me siper
        
    }

    func getDetails(params:[String:String]){
        
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (data) in
            if data.result.isSuccess {
                let coinJSON = try! JSON(data: data.result.value!)
                print(coinJSON)
                
                    let coin = CoinDetailsModel(marketCap: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["MKTCAP"].stringValue,
                                                hourHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["HIGH24HOUR"].stringValue,
                                                hourLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["LOW24HOUR"].stringValue,
                                                hourOpen: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["OPEN24HOUR"].stringValue,
                                                dayHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["HIGHDAY"].stringValue,
                                                dayLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["LOWDAY"].stringValue,
                                                dayOpen: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["OPENDAY"].stringValue,
                                                priceEUR: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["EUR"].stringValue,
                                                priceUSD: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["USD"].stringValue,
                                                priceBTC: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["BTC"].stringValue)
                    //print(coin)
                    self.updateUI(coin: coin)
                
            }
            
        }
        
    }
    
    func updateUI(coin:CoinDetailsModel){
        
        lblMarketCap.text = coin.marketCap
        lbl24OreHigh.text = coin.hourHigh
        lbl24OreLow.text = coin.hourLow
        lbl24OreOpen.text = coin.hourOpen
        lblDitaHigh.text = coin.dayHigh
        lblDitaLow.text = coin.dayLow
        lblDitaOpen.text = coin.dayOpen
        lblCmimiEUR.text = coin.priceEUR
        lblCmimiUSD.text = coin.priceUSD
        lblCmimiBTC.text = coin.priceBTC
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //IBAction mbylle - per butonin te gjitha qe mbyll ekranin
   
    @IBAction func buMbyllu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func ruajTeDhenat() {
//        
//    }
    
    @IBAction func buRuaj(_ sender: Any) {
        
        if rezultati == true {
            let alertController = UIAlertController (title: "CoinTracker", message: "Coin Egziston", preferredStyle: .alert)
            let alertAction = UIAlertAction(title:"OK",style: .default, handler:nil)
            alertController.addAction(alertAction)
            self.present(alertController,animated: true,completion: nil)
        } else {
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let coins = NSEntityDescription.insertNewObject(forEntityName: "Dataxc", into: context)
            
            coins.setValue(selectedCoin.coinName, forKey: "coinName")
            coins.setValue(selectedCoin.coinSymbol, forKey: "coinSymbol")
            coins.setValue(selectedCoin.coinAlgo, forKey: "coinAlgo")
            coins.setValue(selectedCoin.totalSuppy, forKey: "totalSuppy")
            coins.setValue(selectedCoin.imagePath, forKey: "imagePath")
            
            do {
                try context.save()
                rezultati = true
            } catch  {
                print("Gabim gjate ruajtjes")
            }
            
            let alertController = UIAlertController (title: "CoinTracker", message: "Ne rregull u ruajt me sukses", preferredStyle: .alert)
            let alertAction = UIAlertAction(title:"OK",style: .default, handler:nil)
            alertController.addAction(alertAction)
            self.present(alertController,animated: true,completion: nil)
            
        }
  
    }
    
    
}

