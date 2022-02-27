//
//  CollectionViewCell.swift
//  Transport
//
//  Created by Алена on 25.02.2022.
//

import UIKit

// Ячейка с информацией о транспорте
final class CollectionViewCell: UICollectionViewCell {
    
    private let transportNumber = UILabel()
    private let timeArrival = UILabel()
    private let iconTrasportType = UIImageView()
        
    static let reuseIdentifier = "CollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIconTrasportType()
        setupTransportNumber()
        setupTimeArrival()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupIconTrasportType() {
        contentView.addSubview(iconTrasportType)
        makeConstraintsIconTrasportType()
    }
    
    private func makeConstraintsIconTrasportType() {
        iconTrasportType.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconTrasportType.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 21),
            iconTrasportType.widthAnchor
                .constraint(equalToConstant: 24),
            iconTrasportType.heightAnchor
                .constraint(equalToConstant: 24)
        ])
    }
    
    private func setupTransportNumber() {
        contentView.addSubview(transportNumber)
        transportNumber.numberOfLines = 0
        transportNumber.textColor = .black
        makeConstraintsTransportNumber()
    }
    
    private func makeConstraintsTransportNumber() {
        transportNumber.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            transportNumber.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            transportNumber.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 32),
            transportNumber.widthAnchor
                .constraint(equalToConstant: self.bounds.width - 32),
            transportNumber.heightAnchor
                .constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTimeArrival() {
        contentView.addSubview(timeArrival)
        timeArrival.font = UIFont.systemFont(ofSize: 14, weight: .light)
        timeArrival.textColor = .black
        makeConstraintsTimeArrival()
    }
    
    private func makeConstraintsTimeArrival() {
        timeArrival.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timeArrival.topAnchor
                .constraint(equalTo: transportNumber.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(model: TransportModel) {
        if let icon = model.transportType {
            iconTrasportType.image = UIImage(named: "\(icon).png")
        }
        transportNumber.text = model.transportNumbers
        timeArrival.text = model.timeArrival
    }
}
