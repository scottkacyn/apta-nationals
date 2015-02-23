//
//  MapViewController.swift
//  APTA Nationals
//
//  Created by Scott Kacyn on 2/22/15.
//  Copyright (c) 2015 New Coast Ventures. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locations = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = CLLocationCoordinate2D(latitude: 42.055281, longitude: -87.783166)
        mapView.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.5, 0.5)), animated: false)

        var query = PFQuery(className:"Location")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                // The find succeeded. Set location objects and reload annotations
                self.locations = objects
                self.reloadAnnotations()
                
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
    
    func annotationsToAdd () -> NSArray {
        
        var mutableAnnotations = NSMutableArray(capacity: locations.count)
        for location in locations {
            
            // Create a mutable array of annotations
            let locationName = location["title"] as String
            let locationAddress = location["address"] as String
            let point = location["coordinate"] as PFGeoPoint
            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            
            let annotation = MKPointAnnotation() as MKPointAnnotation
            annotation.setCoordinate(coordinate)
            annotation.title = locationName
            mutableAnnotations.addObject(annotation)
        }
        return mutableAnnotations
    }
    
    func reloadAnnotations () {
        // After a change in the map data, such as a filtering operation
        // or a refresh based on location, we need to reload the map annotations
        // such that only new pins are added and unnecessary pins are removed
        
        let before : NSMutableSet = NSMutableSet(array: mapView.annotations)
        let after  : NSSet = NSSet(array: self.annotationsToAdd())
        
        let toKeep : NSMutableSet = NSMutableSet(set: before)
        toKeep.intersectSet(after)
        
        let toAdd  : NSMutableSet = NSMutableSet(set: after)
        toAdd.minusSet(toKeep)
        
        let toRemove : NSMutableSet = NSMutableSet(set: before)
        toRemove.minusSet(after)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.addAnnotations(toAdd.allObjects)
            self.mapView.removeAnnotations(toRemove.allObjects)
        })
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
