//
//  ListViewController.swift
//  newsDemo
//
//  Created by Frans on 12/09/19.
//  Copyright © 2019 Frans. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var cat:String!
    var sources : [JSON] = []
    var loading = true
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = cat
        loadNews()
  
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToNews" {
            if let indexPath = tableView.indexPathForSelectedRow , indexPath.row > 0{
                let controller = segue.destination as! ArticlePickerViewController
                controller.source = sources[indexPath.row-1]["name"].stringValue;
                controller.sourceID = sources[indexPath.row-1]["id"].stringValue;
            }
        }
    }

    func loadNews(){
        
        var url = "https://newsapi.org/v2/sources"
        let category = self.cat as! String
        Alamofire.request(url, method: .get,parameters: ["category":category,"apiKey":"585de698a1344357a7d00e75b016ee78"]).responseJSON { (response) in
           self.loading = false
            if response.result.value != nil {
               let json = JSON(response.result.value!)
                if let source = json["sources"].array{
                    self.sources = source
                    self.tableView.reloadData()
                }
            }
        }
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pickCell", for: indexPath)
        
        if(indexPath.row == 0){
            var lbl = cell.viewWithTag(1) as! UILabel
            if(sources.count == 0){
                if(loading == true){
                   lbl.text = "Loading..."
                }
                else{
                   lbl.text = "Source is Empty"
                }
            }
            else{
                lbl.text = "Pick Sources"
            }
            return cell;
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell",for: indexPath)
            var lbl = cell.viewWithTag(1) as! UILabel
            let object = sources[indexPath.row-1]
            lbl.text  = object["name"].stringValue
        }
        return cell
    }

    
    
}
