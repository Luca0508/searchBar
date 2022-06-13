//
//  mainViewModel.swift
//  searchBar
//
//  Created by 蕭鈺蒖 on 2022/6/13.
//

import Foundation

class MainViewModel {
    
    // MARK: - Properties
    var list: [String] {
        didSet {
            MainDataModel.saveData(list: MainDataModel(list: list))
        }
    }
    
    static let shared =  MainViewModel()
    
    init() {
        if let dataModel = MainDataModel.loadData() {
            self.list = dataModel.list
        } else {
            self.list = []
        }
    }
    
    func getList() -> [String] {
        return list
    }
    
    func setList(data: [String]) {
        self.list = data
    }
    
    
}


