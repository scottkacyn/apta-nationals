//
//  DrawViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/22/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit
import WebKit

class DrawViewController: UIViewController {
    
    @IBOutlet weak var mensDrawBtn: UIButton!
    @IBOutlet weak var womensDrawBtn: UIButton!
    @IBOutlet weak var drawView: UIWebView!

    var webView: WKWebView?
    var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Draw")
        query.getObjectInBackgroundWithId("34kE7hb0gO") {
            (draw: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var urlString = draw["url"] as String
                var url = NSURL(string:urlString)!
                var req = NSURLRequest(URL:url)
                self.drawView.loadRequest(req)
            } else {
                UIAlertView(title: "An Error Occurred", message: "We weren't able to load the draw. Please try again later.", delegate: self, cancelButtonTitle: "OK").show()
            }
        }
        
        mensDrawBtn.selected = true
        womensDrawBtn.selected = false
        
        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mensDrawBtnDidPress(sender: AnyObject) {
        
        mensDrawBtn.selected = true
        womensDrawBtn.selected = false
        var query = PFQuery(className:"Draw")
        query.getObjectInBackgroundWithId("34kE7hb0gO") {
            (draw: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var urlString = draw["url"] as String
                var url = NSURL(string:urlString)!
                var req = NSURLRequest(URL:url)
                self.drawView.loadRequest(req)
            } else {
                UIAlertView(title: "An Error Occurred", message: "We weren't able to load the draw. Please try again later.", delegate: self, cancelButtonTitle: "OK").show()
            }
        }
    }

    @IBAction func womensDrawBtnDidPress(sender: AnyObject) {
        
        womensDrawBtn.selected = true
        mensDrawBtn.selected = false
        var query = PFQuery(className:"Draw")
        query.getObjectInBackgroundWithId("90qUTIcSp0") {
            (draw: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var urlString = draw["url"] as String
                var url = NSURL(string:urlString)!
                var req = NSURLRequest(URL:url)
                self.drawView.loadRequest(req)
            } else {
                UIAlertView(title: "An Error Occurred", message: "We weren't able to load the draw. Please try again later.", delegate: self, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    // MARK: - UIWebView Delegate Methods
    
}

