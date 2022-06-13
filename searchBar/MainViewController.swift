//
//  MainViewController.swift
//  searchBar
//
//  Created by 蕭鈺蒖 on 2022/6/13.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    
    private lazy var label: UILabel = {
        return UILabel()
    }()
    
    private lazy var button: UIButton = {
        return UIButton()
    }()
    
    private lazy var viewModel: MainViewModel = {
        return MainViewModel.shared
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assignLabelValue()
    }
    
}

extension MainViewController {
    private func setupUI() {
        setupLabel()
        setupButton()
    }
    
    private func setupLabel() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        label.sizeToFit()
        label.textColor = .purple
    }
    
    private func setupButton() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        button.setTitle("EDIT", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    private func assignLabelValue() {
        label.text = "\(viewModel.getList())"
    }
    
    @objc private func tapButton() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
