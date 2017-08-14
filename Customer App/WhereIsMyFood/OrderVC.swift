//
//  OrderVC.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 18/04/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit


class OrderVC: UIViewController {
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLbl: UILabel!
    
    var userLoction: MKPlacemark?
    var driverPin: MKPointAnnotation!
    var driverTimer: Timer?
    var orderTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //We don't need to show the user location because we are using the address provided
        self.mapView.showsUserLocation = false
        //Side Menu swipe
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderDetails()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if orderTimer != nil {
            orderTimer?.invalidate()
            orderTimer = nil
        }
    }
    
    //Get the last order of the user and show the order's details
    func getOrderDetails() {
        APIManager.shared.getLatestOrder { (json) in
            if json != JSON.null {
                guard let orderId = json["details"][0]["order_id"].string,
                    let statusName = json["status_name"].string else {
                        return
                }
                //Show order status and set the user address
                Helpers.userDefaults.set(orderId, forKey: "order_id")
                self.statusLbl.text = "Order Status".localized(category: "Order") + statusName
                let userAddress = User.shared.getAddress()
                self.getLocation(userAddress, "You".localized(category: "Order"), { (des) in
                        self.userLoction = des
                    })
                
                
                
                if statusName != "Delivered" {
                    self.setTimer()
                }
            }
        }
    }
    
    //Check every x Time if the driver took the order(you can set it in Constants.swift file
    func setTimer() {
        if orderTimer == nil {
                //if there is an acitve order start to track driver location
                self.orderTimer = Timer.scheduledTimer(
                    timeInterval: Config.ORDER_ACTIVE_TIMER_INTERVAL,
                    target: self,
                    selector: #selector(self.isActiveOrder),
                    userInfo: nil, repeats: true)
            
        }
    }
    
    
    func isActiveOrder() {
        APIManager.shared.getLatestOrder { (json) in
            //if there is not order(order complete) stop the timers
            if (json == JSON.null) {
                self.driverTimer?.invalidate()
                self.orderTimer?.invalidate()
                return
            }
        }

        
        APIManager.shared.isActiveOrder() { (json) in
            //check if the Driver chose the this user order
            //if not - delete the pin and don't update the driver loction anymore
            if (json == JSON.null) {
                if self.driverPin != nil {
                    self.mapView.removeAnnotation(self.driverPin)
                    self.driverPin = nil
                }
                if self.driverTimer != nil {
                    self.driverTimer?.invalidate()
                    self.driverTimer = nil
                }
                return
            }
            //if yes - show driver pin on map and start  updating driver loction every 60 seconds
            if (self.driverTimer == nil) {
                self.driverTimer = Timer.scheduledTimer(
                    timeInterval: Config.DRIVER_TIMER_INTERVAL,
                    target: self,
                    selector: #selector(self.getDriverLocation(_:)),
                    userInfo: nil, repeats: true)
            }
            
        }
    }
    
    //Get the Driver location and pin a map if not null
    func getDriverLocation(_ sender: AnyObject) {
        APIManager.shared.getDriverLocation { (json) in
            if let latitude = json[0]["latitude"].string, let longitude =  json[0]["longitude"].string {
                self.statusLbl.text = "ON  THE WAY".localized(category: "Order")
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude)!, longitude: CLLocationDegrees(longitude)!)
                // Create pin annotation for Driver
                if self.driverPin != nil {
                    self.driverPin.coordinate = coordinate
                } else {
                    self.driverPin = MKPointAnnotation()
                    self.driverPin.coordinate = coordinate
                    self.driverPin.title = "DRI".localized(category: "Order")
                    self.mapView.addAnnotation(self.driverPin)
                }
                // Reset zoom rect to cover 3 locations
                self.autoZoom()
            } else {
                if self.driverTimer != nil {
                    self.driverTimer?.invalidate()
                    self.driverTimer = nil
                    self.mapView.removeAnnotation(self.driverPin)
                }
            }
        }
    }
    
    func autoZoom() {
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    // #2 - Convert an address string to a location on the map
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            print(address)
            if (error != nil) {
                print("Error: ", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                self.mapView.addAnnotation(dropPin)
                let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }
}


extension OrderVC: MKMapViewDelegate {
    
    //Customise pin point with Image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "MyPin"
        
        var annotationView: MKAnnotationView?
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        } else {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView, let name = annotation.title! {
            switch name {
            case "DRI":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            case "You":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
            default:
                break
            }
        }
        return annotationView
    }
}

