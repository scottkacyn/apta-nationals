//
//  InfoDetailViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/23/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString = ""
        switch (number) {
        case 0:
            urlString = "http://www.marriott.com/meeting-event-hotels/group-corporate-travel/groupCorp.mi?resLinkData=2015%20APTA%20NATIONAL^CHINB`APTAPTA`99.00`USD`false`3/4/15`3/8/15`2/13/15&app=resvlink&stop_mobi=yes"
        case 1:
            urlString = "http://www.platformtennis.org/about_us/Sponsorship.htm"
        case 2:
            urlString = "http://themarchtomarch.org/"
        case 3:
            urlString = "http://www.newcoastventures.com"
        default:
            urlString = "http://www.marriott.com/meeting-event-hotels/group-corporate-travel/groupCorp.mi?resLinkData=2015%20APTA%20NATIONAL^CHINB`APTAPTA`99.00`USD`false`3/4/15`3/8/15`2/13/15&app=resvlink&stop_mobi=yes"
        }
        
        // Encode the string
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let url = NSURL(string: urlString)
        var req = NSURLRequest(URL:url!)
        self.webView.loadRequest(req)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
