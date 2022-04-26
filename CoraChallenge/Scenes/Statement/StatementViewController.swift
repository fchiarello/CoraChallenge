//
//  StatementViewController.swift
//  CoraChallenge
//
//  Created by Fellipe Ricciardi Chiarello on 4/23/22.
//

import UIKit

protocol StatementViewControllerProtocol {
    
}

class StatementViewController: UIViewController, StatementViewControllerProtocol {
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.frame)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .coraBackgroundWhite
        return scroll
    }()
    
    lazy var statementTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .coraBackgroundWhite
        return tableView
    }()
    
    lazy var filtersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allButton, incomeButton, paymentsButton, scheduledButton,filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.heightAnchor.constraint(equalToConstant: 48).isActive =  true
        stackView.backgroundColor = .coraBackgroundWhite
        stackView.distribution = .equalSpacing
        stackView.contentMode = .center
        return stackView
    }()
    
    lazy var allButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tudo", for: .normal)
        button.setTitleColor(.coraPink, for: .normal)
        button.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 14)
        return button
    }()
    
    lazy var incomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Entrada", for: .normal)
        button.setTitleColor(UIColor.coraDarkGray, for: .normal)
        button.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 14)
        return button
    }()
    
    lazy var paymentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Saída", for: .normal)
        button.setTitleColor(UIColor.coraDarkGray, for: .normal)
        button.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 14)
        return button
    }()
    
    lazy var scheduledButton: UIButton = {
        let button = UIButton()
        button.setTitle("Futuro", for: .normal)
        button.setTitleColor(UIColor.coraDarkGray, for: .normal)
        button.titleLabel?.font = UIFont(name:"Avenir-Heavy", size: 14)
        return button
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
         let image = UIImage(named: "ic_eye-hidden")
         button.translatesAutoresizingMaskIntoConstraints = false
         button.imageView?.image = image
         return button
    }()
    
    var interactor: StatementInteractorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        viewCodeSetup()
        interactor?.fetchStatementData()
    }
    
    func setupTableview() {
        statementTableView.register(StatementTableViewCell.self, forCellReuseIdentifier: StatementTableViewCell.cellId)
        statementTableView.delegate = self
        statementTableView.dataSource = self
    }
}

extension StatementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let number = interactor?.dailyBalanceArray {
            return number.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = StatementHeaderSectionView()
        if let data = interactor?.dailyBalanceArray[section] {
            view.setupHeader(data: data)
        }
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.dailyBalanceArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statementTableView.dequeueReusableCell(withIdentifier: StatementTableViewCell.cellId, for: indexPath) as! StatementTableViewCell
        if let data = interactor?.model[indexPath.item] {
            cell.setupCell(model: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select cell at \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
}

extension StatementViewController: ViewCodeProtocol {
    func viewCodeHierarchySetup() {
        view.addSubview(scrollView)
        scrollView.addSubview(filtersStackView)
        scrollView.addSubview(statementTableView)
    }
    
    func viewCodeConstraintSetup() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filtersStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            filtersStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filtersStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
            statementTableView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor),
            statementTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            statementTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            statementTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func viewCodeAditionalSetup() {
        view.backgroundColor = .coraBackgroundWhite
    }
}
