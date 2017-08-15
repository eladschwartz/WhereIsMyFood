//
//  DeliveryVC.swift
//  WhereIsMyFood-Driver
//
//  Created by elad schwartz on 25/07/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit


class DeliveryVC: UIViewController {
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var floorApartLbl: UILabel!
    
    var locationManager: CLLocationManager!
    var lastLocation: CLLocationCoordinate2D?
    var orderAddress = ""
    var customerName = ""
    var floorapart = ""
    var orderId = ""
    var customerPhone = ""
    
    var tray = [JSON]()
    var destination: MKPlacemark?
    var driverPin: MKPointAnnotation!
    var myRoute : MKRoute!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        customerNameLbl.text = customerName
        addressLbl.text = orderAddress
        floorApartLbl.text = floorapart
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //locationManager.distanceFilter = 500
            locationManager.requestWhenInUseAuthorization()
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        }
        
        // Running the updating location process
        timer = Timer.scheduledTimer(
            timeInterval: Config.DRIVER_TIMER_INTERVAL,
            target: self,
            selector: #selector(self.updateLocation),
            userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCustomerLocation()
    }
    
    
    func updateLocation() {
        if let lastlocation = self.lastLocation {
            APIManager.shared.updateLocation(location: lastlocation) { (json) in
            }
        }
        
    }
    
    //Add route from driver to customer
    func showRoute() {
        let directionsRequest = MKDirectionsRequest()
        //Get customer and driver locations
        guard let longitude = self.lastLocation?.longitude,
            let latitude = self.lastLocation?.latitude else {
                return
        }
        let driver = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude,longitude), addressDictionary: nil)
        directionsRequest.source = MKMapItem(placemark: driver)
        if let dest = self.destination {
            directionsRequest.destination = MKMapItem(placemark:  dest)
        }
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            if error == nil {
                self.myRoute = response!.routes[0] as MKRoute
                self.mapView.add(self.myRoute.polyline)
            }
        })
    }
    
    
    func getCustomerLocation () {
        let to = self.orderAddress
        self.getLocation(to, "CUS", { (des) in
            self.destination = des
            self.autoZoom()
            self.showRoute()
        })
    }
    
    //Zoom between two potins
    func autoZoom() {
        var zoomRect = MKMapRectNull
        for annotation in self.mapView.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
        self.mapView.setVisibleMapRect(insetRect, animated: true)
    }
    
    
    @IBAction func completeBtnTapped(_ sender: Any) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            APIManager.shared.compeleteOrder(id: self.orderId, completionHandler: { (json) in
                // Stop updating driver location
                self.timer.invalidate()
                self.locationManager.stopUpdatingLocation()
                
                // Redirect driver to the Ready Orders View
                self.performSegue(withIdentifier: "unwindToOrders", sender: self)
                
            })
        }
        
        let alertView = UIAlertController(title: "Complete Order", message: "Are you sure?", preferredStyle: .alert)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    
   
    
    @IBAction func callCustomer(_ sender: Any) {
        let phoneString = "telprompt://\(self.customerPhone)"
        guard let number = URL(string: phoneString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
}

extension DeliveryVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: myRoute.polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    
    
    //Convert an address string to a location on the map
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
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }
    
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
            case "CUS":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
            default:
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            }
        }
        return annotationView
    }
}


extension DeliveryVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.lastLocation = location.coordinate
        //Create Pin for Driver
        
        if driverPin != nil {
            driverPin.coordinate = self.lastLocation!
        } else {
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.lastLocation!
            self.mapView.addAnnotation(driverPin)
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


