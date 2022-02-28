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
    func showError(title: String)
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
    
    weak var delegatePresenter: MapViewOutputProtocol?
    
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
                if transportRoute.isEmpty {
                    self.delegatePresenter?.updateView()
                    self.delegatePresenter?.showError(title: "Ошибка... Данные не пришли :(")
                    return
                }
                for i in transportRoute {
                    let model = TransportModel(transportType: i.type,
                                               transportNumbers: i.number,
                                               timeArrival: i.timeArrival.first)
                    self.transportModelArray.append(model)
                }
                self.delegatePresenter?.updateView()
            case .failure(_):
                DispatchQueue.main.async {
                    self.delegatePresenter?.updateView()
                    self.delegatePresenter?.showError(title: "Ошибка... Что-то пошло не так :(")
                }
            }
        }
    }
}
