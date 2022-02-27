//
//  StopoverAssembly.swift
//  Transport
//
//  Created by Алена on 27.02.2022.
//

import UIKit

// Сборщик модуля Stopover
final class StopoverAssembly {
    
    func presentStopoverViewController() -> UINavigationController {
        let assembly = MapAssembly()

        let stopoverViewController = StopoverViewController(assembly: assembly)
        let presenter = StopoverPresenter(loadService: LoadService())
        
        presenter.delegatPresenter = stopoverViewController
        stopoverViewController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: stopoverViewController)
        
        if let model = presenter.getUserLastChoiceModel() {
            let containerViewController = assembly.pushToMapViewController(userLastChoiceModel: model)
            navigationController.pushViewController(containerViewController, animated: true)
        }
        
        return navigationController
    }
}

