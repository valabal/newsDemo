//
//  MasterViewController.swift
//  newsDemo
//
//  Created by Frans on 12/09/19.
//  Copyright © 2019 Frans. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var cat = ["entertaiment","general","health","science","sport","technology","business"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "News Demo Case";
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToList" {
            if let indexPath = tableView.indexPathForSelectedRow, indexPath.row > 0{
                let controller = segue.destination as! ListViewController
                controller.cat = cat[indexPath.row-1];
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cat.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "pickCell", for: indexPath)

        if(indexPath.row == 0){
            return cell;
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",for: indexPath)
            var lbl = cell.viewWithTag(1) as! UILabel
            let object = cat[indexPath.row-1] as! String
            lbl.text  = object
        }
        return cell
    }

   


}

