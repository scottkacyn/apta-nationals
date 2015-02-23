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
    var logo: UIImageView!
    var locations = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the Braxton Hop Eagle logo to the nav bar
        logo = UIImageView(frame: CGRect(x: self.view.frame.width/2-40, y: 0, width: 80, height: 40))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.image = UIImage(named: "logo.png")
        navigationController?.navigationBar.addSubview(logo)
        
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "ReuseIdentifier"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Green
            
            var rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            pinView!.rightCalloutAccessoryView = rightButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var query = PFQuery(className:"Location")
        query.whereKey("title", equalTo:view.annotation.title)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                
                let location = object
                let address = location["address"] as String
                let city = location["city"] as String
                let state = location["state"] as String
                let zip = location["zip"] as String
                let fullAddress = String(format: "%@ %@, %@ %@", address, city, state, zip)
                
                let escapedAddress = fullAddress.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let url = NSURL(string: NSString(format: "http://maps.google.com/maps?saddr=Current+Location&daddr=%@&directionsmode=driving", escapedAddress!))!
                
                if (UIApplication.sharedApplication().canOpenURL(url)) {
                    UIApplication.sharedApplication().openURL(url)
                } else {
                    UIAlertView(title: "Not Supported!", message: "Directions are not supported on your device", delegate: self, cancelButtonTitle: "OK").show()
                }
                
            } else {
                UIAlertView(title: "Something went wrong", message: "We weren't able to get directions at this time. Please try again later.", delegate: self, cancelButtonTitle: "OK").show()
            }
        }
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
