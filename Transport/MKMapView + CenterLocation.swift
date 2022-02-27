//
//  MKMapView + CenterLocation.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation
import MapKit

// Расширение для MKMapView с фиксированным масштабом карты
extension MKMapView {
    func centerLocation(location: CLLocation) {
        let span: MKCoordinateSpan = .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let cootdinateRegion = MKCoordinateRegion(center: location.coordinate, span: span)
        setRegion(cootdinateRegion, animated: true)
    }
}
