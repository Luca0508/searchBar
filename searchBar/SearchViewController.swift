//
//  ViewController.swift
//  searchBar
//
//  Created by 蕭鈺蒖 on 2022/6/12.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private lazy var textField: UITextField = {
       return UITextField()
    }()
    
    private lazy var tableView: UITableView = {
        return UITableView()
    }()
    
    // MARK: - Properties
    lazy var filterCityList = TimeZone.knownTimeZoneIdentifiers
    
    var isSearching = false
    
    private lazy var viewModel: MainViewModel = {
        return MainViewModel.shared
    }()

    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.layer.cornerRadius = textField.bounds.height * 0.2
    }
    
}

extension SearchViewController {
    
    private func setupUI() {
        setupTextField()
        setupTableView()
        setupKeyboard()
        setEditing(!isSearching, animated: true)
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        textField.clipsToBounds = true
        textField.backgroundColor = .lightGray
        textField.textColor = .black
        textField.clearButtonMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: " Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VCTableViewCell.self, forCellReuseIdentifier: "\(VCTableViewCell.self)")
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(textField.snp.bottom).offset(30)
        }
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
       tapGesture.cancelsTouchesInView = false
       self.view.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Action Methods

extension SearchViewController {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text,
           searchText != "" {
            isSearching = true
            filterCityList = TimeZone.knownTimeZoneIdentifiers.filter({ city in
                city.localizedStandardContains(searchText)
            })
            
        } else {
            isSearching = false
            filterCityList = TimeZone.knownTimeZoneIdentifiers
        }
        tableView.setEditing(!isSearching, animated: true)
        tableView.reloadData()
    }
    
    @objc private func keyboardDismiss() {
        self.view.endEditing(true)
    }
}



extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterCityList.count
        }
        return viewModel.getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(VCTableViewCell.self)", for: indexPath) as? VCTableViewCell else { return UITableViewCell() }
        if isSearching {
            guard filterCityList.indices.contains(indexPath.row) else { return UITableViewCell() }
            cell.cityLabel.text = filterCityList[indexPath.row]
        } else {
            guard viewModel.getList().indices.contains(indexPath.row) else { return UITableViewCell() }
            cell.cityLabel.text = viewModel.getList()[indexPath.row]
        }
        
        cell.cityLabel.textColor = .white
        cell.backgroundColor = .black
        cell.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        
        
        return cell
    }
    
}


extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            guard filterCityList.indices.contains(indexPath.row) else { return }
            let city = filterCityList[indexPath.row]
            var list = viewModel.getList()
            list.append(city)
            viewModel.setList(data: list)
        }
       
        
        isSearching = false
        tableView.setEditing(!isSearching, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var list = viewModel.getList()
        let removeItem = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(removeItem, at: destinationIndexPath.row)
        viewModel.setList(data: list)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var list = viewModel.getList()
            list.remove(at: indexPath.row)
            viewModel.setList(data: list)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}

