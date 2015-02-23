//
//  ScheduleViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/22/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var events = []
    var sections = [Int:[[String:String]]]()
    var sortedEvents = []
    var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)
        
        var query = PFQuery(className:"Event")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                // The find succeeded. Set event objects and reload table
                self.events = objects as Array
                
                for object in objects {
                    
                    var event = [String:String]()
                    event["title"] = object["title"] as? String
                    event["time"] = object["time"] as? String
                    event["venue"] = object["venue"] as? String
                    
                    var day = object["day"] as Int
                    var eventsOnThisDay = self.sections[day]
                    
                    if eventsOnThisDay == nil {
                        NSLog("There were no events on this day")
                        eventsOnThisDay = [[String:String]]()
                        
                    }
                    eventsOnThisDay?.append(event)
                    self.sections[day] = eventsOnThisDay
                    NSLog("EOTD: %@", eventsOnThisDay!)
                }
                
                var unsortedDays = self.sections.keys
                var selector : Selector = "compare:"
                
                self.sortedEvents = sorted(unsortedDays, <)
                NSLog("Sections %d", self.sections.count)
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView Delegate & DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var events = sections[section]!
        NSLog("Events %d", events.count)
        return events.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Wednesday, March 4"
        } else if section == 1 {
            return "Thursday, March 5"
        } else if section == 2 {
            return "Friday, March 6"
        } else if section == 3 {
            return "Saturday, March 7"
        } else if section == 4 {
            return "Sunday, March 8"
        } else {
            return "Monday, March 9"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var events = sections[indexPath.section]!
        var event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as UITableViewCell
        
        let timeLabel = cell.viewWithTag(1) as UILabel
        timeLabel.text = event["time"]
        
        let titleLabel = cell.viewWithTag(2) as UILabel
        titleLabel.text = event["title"]
        
        let venueLabel = cell.viewWithTag(3) as UILabel
        venueLabel.text = event["venue"]

        return cell
    }
}

