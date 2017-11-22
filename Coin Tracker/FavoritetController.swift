//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/13/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage
import SwiftyJSON

//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var infos = [CoinCellModel]()
    var selectedcoin:CoinCellModel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.infos.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        type.lblEmri.text = self.infos[indexPath.row].coinName
        type.lblTotali.text = self.infos[indexPath.row].totalSuppy
        type.lblSymboli.text = self.infos[indexPath.row].coinSymbol
        type.lblAlgoritmi.text = self.infos[indexPath.row].coinAlgo
        type.imgFotoja.af_setImage(withURL: URL(string: self.infos[indexPath.row].coinImage())!)
        
        
        
        return type
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            fshijtedhenat(coinSymbol: infos[indexPath.row].coinSymbol)
            infos.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cs  = infos[indexPath.row]
        selectedcoin = cs
        performSegue(withIdentifier: "shfaqDetajet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shfaqDetajet"{
            let detailcontroller = segue.destination as! DetailsController
            detailcontroller.selectedCoin = self.selectedcoin
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let coins = NSEntityDescription.insertNewObject(forEntityName: "Dataxc", into: context)
        
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Dataxc")
        request.returnsObjectsAsFaults = false
        
        do {
            let rezultati =   try context.fetch(request)
            for elementi in rezultati as! [NSManagedObject]{
                
                if   let username  = elementi.value(forKey: "coinName") as? String{
                    
                    self.infos.append(CoinCellModel(coinName: (elementi.value(forKey: "coinName") as? String)!, coinSymbol: (elementi.value(forKey: "coinSymbol") as? String)!, coinAlgo: (elementi.value(forKey: "coinAlgo") as? String)!, totalSuppy: (elementi.value(forKey: "totalSuppy") as? String)!, imagePath: (elementi.value(forKey: "imagePath") as? String)!))
                }
                
            }
        } catch  {
            print("Gabim gjate leximit")
        }
        

        //Lexo nga CoreData te dhenat dhe ruaj me nje varg
        //qe duhet deklaruar mbi funksionin UIViewController
        
    }
    
    func fshijtedhenat (coinSymbol:String){
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let coins = NSFetchRequest<NSFetchRequestResult>(entityName: "Dataxc")
        coins.predicate = NSPredicate(format: "coinSymbol = %@", coinSymbol)
        coins.returnsObjectsAsFaults = false
        
        do {
            
            let rezultati =  try context.fetch(coins)
            for elementi in rezultati as! [NSManagedObject] {
                context.delete(elementi)
                
                do {
                    try context.save()
                    }
                catch {
                    print ("Gabim gjate leximit")
                }
                
                
            }
        } catch  {
            print("Gabim gjate fshirjes")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buDismis(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
