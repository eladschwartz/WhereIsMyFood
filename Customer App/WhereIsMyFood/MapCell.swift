//
//  MapCell.swift
//  WhereIsMyFood
//
//  Created by elad schwartz on 30/05/2017.
//  Copyright © 2017 elad schwartz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var deliveryNotesLbl: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationManager?.delegate = self
      
    }

}

extension MapCell: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
}
