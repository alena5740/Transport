//
//  TransportInfoViewController.swift
//  Transport
//
//  Created by Алена on 26.02.2022.
//

import UIKit

// Контроллер для отображения информации о транспорте на конкретной остановке
final class TransportInfoViewController: UIViewController {
    
    var presenter: MapPresenterProtocol?
    
    private let stopoverIcon = UIImageView()
    private let stopoverName = UILabel()
    
    private let transportCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 80)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        setupView()
        transportCollectionView.delegate = self
        transportCollectionView.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        setupStopoverIcon()
        setupStopoverName()
        setupTransportСollectionView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
    }
    
    private func setupStopoverIcon() {
        view.addSubview(stopoverIcon)
        stopoverIcon.image = UIImage(named: "stopover.png")
        stopoverIcon.frame = CGRect(x: 16, y: 26, width: 60, height: 60)
    }
    
    private func setupStopoverName() {
        view.addSubview(stopoverName)
        stopoverName.textColor = .black
        stopoverName.numberOfLines = 0
        stopoverName.frame = CGRect(x: 92, y: 16, width: view.frame.width - 108, height: 80)
    }
    
    private func setupTransportСollectionView() {
        view.addSubview(transportCollectionView)
        transportCollectionView.frame = CGRect(x: 16, y: 126, width: view.frame.width - 32, height: 80)
    }
    
    func viewConfigure(stopoverName: String) {
        self.stopoverName.text = stopoverName
        if stopoverName.count > 50 {
            self.stopoverName.font = UIFont.boldSystemFont(ofSize: 18)
        } else {
            self.stopoverName.font = UIFont.boldSystemFont(ofSize: 21)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TransportInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let count = presenter?.transportModelArray.count
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.reuseIdentifier,
            for: indexPath) as? CollectionViewCell
        if let model = presenter?.transportModelArray[indexPath.row] {
            cell?.configure(model: model)
        }
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - ViewOutputProtocol
extension TransportInfoViewController: MapViewOutputProtocol {
    func updateView() {
        if let stopoverName = presenter?.stopoverModel.stopoverName {
            viewConfigure(stopoverName: stopoverName)
        }
        transportCollectionView.reloadData()
    }
}
