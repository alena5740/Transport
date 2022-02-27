//
//  StopoverPresenter.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import UIKit

// Протокол исходящих событий от View модуля Stopover
protocol StopoverViewOutputProtocol: AnyObject {
    func updateView()
}

// Протокол презентера модуля Stopover
protocol StopoverPresenterProtocol: AnyObject {
    func getData()
    func saveLastChoice(stopoverModel: StopoverModel)
    func getUserLastChoiceModel() -> UserLastChoiceModel?
    var arrayModel: [StopoverModel] { get }
}

// Презентер модуля Stopover
final class StopoverPresenter: StopoverPresenterProtocol {
    
    private let loadService: LoadServiceProtocol
    private let coreDataManager = CoreDataManager()
    var arrayModel: [StopoverModel] = []

    weak var delegatPresenter: StopoverViewOutputProtocol?
    
    init(loadService: LoadServiceProtocol) {
        self.loadService = loadService
    }
    
    func getData() {
        loadService.loadStopover { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let model = model.data
                for i in model {
                    let stopoverName = StopoverModel(id: i.id,
                                                     lat: i.lat,
                                                     lon: i.lon,
                                                     stopoverName: i.name)
                    self.arrayModel.append(stopoverName)
                }
                self.delegatPresenter?.updateView()
            case .failure(_):
                print("Ошибка получения данных")
            }
        }
    }
    
    func saveLastChoice(stopoverModel: StopoverModel) {
        coreDataManager.saveLastChoice(stopoverModel: stopoverModel)
    }
    
    func getUserLastChoiceModel() -> UserLastChoiceModel? {
        coreDataManager.getUserLastChoiceModel()
    }
}
