//
//  ListaController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

//Duhet te jete conform protocoleve per tabele
class ListaController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //Krijo IBOutlet tableView nga View
    //Krijo nje varg qe mban te dhena te tipit CoinCellModel
    //Krijo nje variable slectedCoin te tipit CoinCellModel!
    //kjo perdoret per tja derguar Controllerit "DetailsController"
    //me poshte, kur ndodh kalimi nga screen ne screen (prepare for segue)
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    
    //var coin:[CoinCellModel] = []
    var selectedCoin:CoinCellModel?
    var tedhenat = [CoinCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //regjistro delegate dhe datasource per tableview
        //regjistro custom cell qe eshte krijuar me NIB name dhe
        //reuse identifier
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        //Thirr funksionin getDataFromAPI()
        getDataFromAPI()
    }
    
    //Funksioni getDataFromAPI()
    //Perdor alamofire per te thirre APIURL dhe ruan te dhenat
    //ne listen vargun me CoinCellModel
    //Si perfundim, thrret tableView.reloadData()
    func getDataFromAPI(){
        Alamofire.request(APIURL).responseData { (data) in
                if data.result.isSuccess {
                    let itemJSON = try! JSON(data: data.result.value!)
                    //print(data)
                    for ( key, coinJSON):(String, JSON) in itemJSON["Data"] {
                        self.tedhenat.append(CoinCellModel(coinName: coinJSON["CoinName"].stringValue, coinSymbol: coinJSON["Name"].stringValue, coinAlgo: coinJSON["Algorithm"].stringValue, totalSuppy: coinJSON["TotalCoinSupply"].stringValue, imagePath: coinJSON["ImageUrl"].stringValue))
                }
            }
            return self.tableView.reloadData()
        }
    }

    //Shkruaj dy funksionet e tabeles ketu
    //cellforrowat indexpath dhe numberofrowsinsection
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tedhenat.count
        
    }
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSeguew(withIdentifier: "EmriILidhjes", sender, self)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coin = tedhenat[indexPath.row]
        selectedCoin = coin
        
        performSegue(withIdentifier: "shfaqDetajet", sender: self)
        
    }
    
//    override func performSegue(withIdentifier identifier: "shfaqDetajet", sender: self) {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = self.tedhenat[indexPath.row].coinName
        cell.lblSymboli.text = self.tedhenat[indexPath.row].coinSymbol
        cell.lblAlgoritmi.text = self.tedhenat[indexPath.row].coinAlgo
        cell.lblTotali.text = self.tedhenat[indexPath.row].totalSuppy
        cell.imgFotoja.af_setImage(withURL: URL(string: self.tedhenat[indexPath.row].coinImage())!)
        
        return cell
    }
    
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSeguew(withIdentifier: "EmriILidhjes", sender, self)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shfaqDetajet" {
            let detailController = segue.destination as! DetailsController
            detailController.selectedCoin = self.selectedCoin
        }
    }
    
    
    //Beje override funksionin prepare(for segue...)
    //nese identifier eshte emri i lidhjes ne Storyboard.
    //controllerit tjeter ja vendosim si selectedCoin, coinin
    //qe e kemi ruajtur me siper

   

}
