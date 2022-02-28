//
//  MapViewController.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import UIKit
import MapKit

// Контроллер с картой
final class MapViewController: UIViewController {
    
    var presenter: MapPresenterProtocol?
    
    private let mapView = MKMapView()
    private let point = MKPointAnnotation()
    private var coordinate = CLLocation()
    
    private let tranportInfoViewController = TransportInfoViewController()

    override func viewDidLoad() {
        setupCoordinate()
        setupMapView()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.centerLocation(location: coordinate)
        mapView.addAnnotation(point)
        mapView.frame = view.frame
    }
    
    private func setupCoordinate() {
        if let lat = presenter?.stopoverModel.lat, let lon = presenter?.stopoverModel.lon {
            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            coordinate = CLLocation(latitude: lat, longitude: lon)
        }
    }
}
