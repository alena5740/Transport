//
//  MapPresenter.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import Foundation

// Протокол исходящих событий от View
protocol MapViewOutputProtocol: AnyObject {
    func updateView()
}

// Протокол презентера экрана карты
protocol MapPresenterProtocol {
    func getTransportModel()
    var stopoverModel: UserLastChoiceModel { get }
    var transportModelArray: [TransportModel] { get }
}

// Презентер экрана карты
final class MapPresenter: MapPresenterProtocol {
    
    private let loadService: LoadServiceProtocol
    var stopoverModel: UserLastChoiceModel
    var transportModelArray: [TransportModel] = []
    
    weak var delegatPresenter: MapViewOutputProtocol?
    
    init(stopoverModel: UserLastChoiceModel, loadService: LoadServiceProtocol) {
        self.loadService = loadService
        self.stopoverModel = stopoverModel
    }
    
    func getTransportModel() {
        guard let id = stopoverModel.id else { return }
        loadService.loadStopoverInfo(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let transportRoute = model.routePath
                for i in transportRoute {
                    let model = TransportModel(transportType: i.type,
                                               transportNumbers: i.number,
                                               timeArrival: i.timeArrival.first)
                    self.transportModelArray.append(model)
                }
                self.delegatPresenter?.updateView()
            case .failure(_):
                print("Ошибка получения данных")
            }
        }
    }
}
