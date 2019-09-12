//
//  ArticlePickerViewController.swift
//  newsDemo
//
//  Created by Frans on 12/09/19.
//  Copyright © 2019 Frans. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PaginatedTableView

class ArticlePickerViewController: UIViewController , PaginatedTableViewDataSource,PaginatedTableViewDelegate, UISearchBarDelegate{

    
    var source:String!
    var sourceID:String!
    var news : [JSON] = []
    var loading = true
    
    var sText : String?
    @IBOutlet var searchBar : UISearchBar!
    
    @IBOutlet var tableView : PaginatedTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = source
        self.tableView.paginatedDelegate = self
        self.tableView.paginatedDataSource = self
        self.tableView.loadData(refresh: true)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToWebView" {
            if let indexPath = tableView.indexPathForSelectedRow , indexPath.row > 0{
                let controller = segue.destination as! DetailViewController
                controller.url = news[indexPath.row-1]["url"].stringValue
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pickCell", for: indexPath)
        
        if(indexPath.row == 0){
            var lbl = cell.viewWithTag(1) as! UILabel
            if(news.count == 0){
                if(loading == true){
                    lbl.text = "Loading..."
                }
                else{
                    lbl.text = "News is Empty"
                }
            }
            else{
                lbl.text = "Pick News"
            }
            return cell;
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell",for: indexPath)
            var lbl = cell.viewWithTag(1) as! UILabel
            var lbl2 = cell.viewWithTag(2) as! UILabel

            let object = news[indexPath.row-1]
            lbl.text  = object["title"].stringValue
            var temp = object["author"].stringValue
            if(temp.isEmpty){
                lbl2.text = ""
            }
            else{
              lbl2.text = "By: "+object["author"].stringValue
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        // Call your api here
        // Send true in onSuccess in case new data exists, sending false will disable pagination
        
        var url = "https://newsapi.org/v2/everything"
        let soruce = self.sourceID as! String
        
        var search = ""
        if let text = sText{
            search = text
        }

        if pageNumber == 1 { self.news = []}
        
        Alamofire.request(url, method: .get,parameters: ["sources":soruce,"q":search,"page":pageNumber,"apiKey":"585de698a1344357a7d00e75b016ee78"]).responseJSON { (response) in
            self.loading = false
        
            if response.result.value != nil {
                let json = JSON(response.result.value!)
                if let jso = json["articles"].array,jso.count > 0{
                    self.news.append(contentsOf: jso)
                    onSuccess?(true)
                }
                else{
                    onSuccess?(false)
                }
                self.tableView.reloadData()
            }
            else{
                onSuccess?(false)
            }
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        news = []
        loading = true
        let text = searchBar.text
        sText = text
        self.tableView.loadData(refresh: true)
    }
    
    
}
