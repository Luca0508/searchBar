//
//  MainDataModel.swift
//  searchBar
//
//  Created by 蕭鈺蒖 on 2022/6/13.
//

import Foundation

struct MainDataModel: Codable {
    var list: [String]
}

extension MainDataModel {
    static func saveData(list: MainDataModel) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(list) else { return }
        UserDefaults.standard.set(data, forKey: "list")
    }
    
    static func loadData() -> MainDataModel? {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "list") else {return nil}
        return try? decoder.decode(MainDataModel.self, from: data)
                
    }
}
