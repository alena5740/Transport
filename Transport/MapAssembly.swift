//
//  MapAssembly.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import UIKit

// Протокол сборщика модуля Map
protocol MapAssemblyProtocol: AnyObject {
    func pushToMapViewController(userLastChoiceModel: UserLastChoiceModel) -> UIViewController
}

// Сборщик модуля Map
final class MapAssembly: MapAssemblyProtocol {
    
    func pushToMapViewController(userLastChoiceModel: UserLastChoiceModel) -> UIViewController {
        let presenter = MapPresenter(stopoverModel: userLastChoiceModel, loadService: LoadService())
        let mapViewController = MapViewController()
        let transportInfoViewController = TransportInfoViewController()
        
        mapViewController.presenter = presenter
        transportInfoViewController.presenter = presenter
        presenter.delegatePresenter = transportInfoViewController
        
        let viewController = ContainerViewController(
            contentViewController: mapViewController,
            bottomSheetViewController: transportInfoViewController
        )
        return viewController
    }
}
