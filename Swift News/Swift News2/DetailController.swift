//
//  DetailController.swift
//  Swift News2
//
//  Created by 師岡誠太 on 2015/09/09.
//  Copyright (c) 2015年 Seita Morooka. All rights reserved.
//

import UIKit
import Social

class DetailController: UIViewController {
    var entry = NSDictionary()
    
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBAction func Twitter(sender: AnyObject) {
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                var controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                let link = entry["link"] as! String
                let url = NSURL(string: link)
                controller.addURL(url)
                
                let title = entry["title"] as! String
                controller.setInitialText(title)
                
                presentViewController(controller, animated: true, completion: {})
            }
        }
    
    
    @IBAction func Facebook(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            let link = entry["link"] as! String
            let url = NSURL(string: link)
            controller.addURL(url)
            
            let title = entry["title"] as! String
            controller.setInitialText(title)
            
            presentViewController(controller, animated: true, completion: {})
        }
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var url = NSURL(string: self.entry["link"] as! String)!
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)

    }
}
