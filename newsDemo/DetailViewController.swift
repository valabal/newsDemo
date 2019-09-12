//
//  DetailViewController.swift
//  newsDemo
//
//  Created by Frans on 12/09/19.
//  Copyright © 2019 Frans. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

    var url:String!
    
    @IBOutlet var lbl:UILabel!
    
    @IBOutlet var webView : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let object = URL(string: url)!
        webView.loadRequest(URLRequest(url: object))
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        lbl.isHidden = true
    }
    


}

