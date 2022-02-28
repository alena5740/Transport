//
//  StopoverViewController.swift
//  Transport
//
//  Created by Алена on 24.02.2022.
//

import UIKit

// Контроллер для отображения списка остановок
final class StopoverViewController: UIViewController {
    
    var presenter: StopoverPresenterProtocol?
    private var assembly: MapAssemblyProtocol?
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(assembly: MapAssemblyProtocol) {
        self.assembly = assembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        setupTableView()
        showSpinner()
        presenter?.getData()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "Остановки"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = .white
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        makeConstraintsTableView()
    }
    
    private func makeConstraintsTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showSpinner() {
        view.addSubview(spinner)
        
        spinner.center = view.center
        
        spinner.backgroundColor = .white
        spinner.color = .gray
        
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StopoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.arrayModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                 for: indexPath) as? TableViewCell
        
        if let model = presenter?.arrayModel[indexPath.row] {
            cell?.configure(model: model)
        }
    
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = presenter?.arrayModel[indexPath.row] else { return }
        presenter?.saveLastChoice(stopoverModel: model)
        
        guard let userLastChoiceModel = presenter?.getUserLastChoiceModel() else { return }
        
        if let mapViewController =
            assembly?.pushToMapViewController(userLastChoiceModel: userLastChoiceModel) {
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
}

// MARK: - ViewOutputProtocol
extension StopoverViewController: StopoverViewOutputProtocol {
    func updateView() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
}

