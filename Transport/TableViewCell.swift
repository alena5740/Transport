//
//  TableViewCell.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import UIKit

// Ячейка с названием остановки
final class TableViewCell: UITableViewCell {
    
    private let stopoverName = UILabel()
    
    static let reuseIdentifier = "TableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        self.selectionStyle = .none
        setupStopoverName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraintsStopoverName() {
        stopoverName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stopoverName.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 8),
            stopoverName.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stopoverName.rightAnchor
                .constraint(equalTo: contentView.rightAnchor, constant: -16),
            stopoverName.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupStopoverName() {
        contentView.addSubview(stopoverName)
        stopoverName.textColor = .black
        makeConstraintsStopoverName()
    }
    
    func configure(model: StopoverModel) {
        stopoverName.text = model.stopoverName
    }
}
