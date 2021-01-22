//
//  DataManager.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/20.
//

import Foundation
import SwifterSwift



class PrizeItem: Identifiable, ObservableObject {
    var id: Int = 0
    @Published var prizeContent: String = ""
    var color: String = ""
    init(id: Int, prizeContent: String, color: String) {
        self.id = id
        self.prizeContent = prizeContent
        self.color = color
        
    }
    
    init(dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.prizeContent = dict["prizeContent"] as? String ?? "Shose"
        self.color = dict["color"] as? String ?? "#FFFFFF"
        
    }
    
}

class WinnerSetItem: Identifiable, ObservableObject {
    var id: Int = 0
    var count: Int = 0
    var isPro: Bool = false
    init(id: Int, count: Int, isPro: Bool) {
        self.id = id
        self.count = count
        self.isPro = isPro
        
    }
    
}

class SubstitutesSetItem: Identifiable, ObservableObject {
    var id: Int = 0
    var count: Int = 0
    var isPro: Bool = false
    init(id: Int, count: Int, isPro: Bool) {
        self.id = id
        self.count = count
        self.isPro = isPro
        
    }
    
}

class TagsRequiredSetItem: Identifiable, ObservableObject {
    var id: Int = 0
    var count: Int = 0
    var isPro: Bool = false
    init(id: Int, count: Int, isPro: Bool) {
        self.id = id
        self.count = count
        self.isPro = isPro
        
    }
    
}

class DataManager: ObservableObject {
    
    @Published var prizeItemList: [PrizeItem] = []
    @Published var canAddNewPrize: Bool = true
    
    @Published var winnerSetItemList: [WinnerSetItem] = []
    @Published var substitutesSetItemList: [SubstitutesSetItem] = []
    @Published var tagsSetItemList: [TagsRequiredSetItem] = []
    
    var currentSelectPrize: String = ""
    
    var prizeStringList: [String] = []
    
    let k_customPrizeStringList: String = "customPrizeStringList"
    
    
    
    let colors = ["#DA73FF", "#73A9FF", "#FF7373", "#7376FF", "#DA73FF", "#FFAC73", "#DA73FF", "#73A9FF" , "#FF7373", "#7376FF", "#DA73FF", "#73A9FF" , "#FF7373", "#7376FF" ]
    
    
    static let `default` = DataManager()
    
    var buildinPrizeStrings: [String] = ["Shose", "Clother", "Watch", "TV", "iPhone12Pro", "Mac"]
    
    
    init() {
        
        fetchPrizeItems()
        loadGiveawaySetItems()
    }
 
    func fetchPrizeItems() {
        
        if UserDefaults.standard.object(forKey: k_customPrizeStringList) as? [String] == nil {
            UserDefaults.standard.setValue(buildinPrizeStrings, forKey: k_customPrizeStringList)
        }
        
        self.prizeStringList = UserDefaults.standard.object(forKey: k_customPrizeStringList) as? [String] ?? []
        
        var list: [PrizeItem] = []
        for (index, prizeStr) in self.prizeStringList.enumerated() {
            let color = colors[safe: index] ?? "#9873FF"
            let dict = ["id" : index, "prizeContent" : prizeStr, "color" : color] as [String : Any]
            let item = PrizeItem.init(dict: dict)
            list.append(item)
        }
        prizeItemList = list
        
        if prizeStringList.count < 11 {
            canAddNewPrize = true
        } else {
            canAddNewPrize = false
        }
        
    }
    
    func addNewCustomPrize(prize: String) {
        prizeStringList.append(prize)
        UserDefaults.standard.setValue(prizeStringList, forKey: k_customPrizeStringList)
        fetchPrizeItems()
    }
    
    func removeCustomPrize(prizeItem: PrizeItem) {
        prizeStringList.remove(at: prizeItem.id)
        UserDefaults.standard.setValue(prizeStringList, forKey: k_customPrizeStringList)
        fetchPrizeItems()
    }
    
    
    
}

extension DataManager {
    func loadGiveawaySetItems() {
        let winner1 = WinnerSetItem.init(id: 0, count: 1, isPro: false)
        let winner2 = WinnerSetItem.init(id: 1, count: 3, isPro: true)
        let winner3 = WinnerSetItem.init(id: 2, count: 5, isPro: true)
        winnerSetItemList = [winner1, winner2, winner3]
        
        let substitutes1 = SubstitutesSetItem.init(id: 0, count: 1, isPro: false)
        let substitutes2 = SubstitutesSetItem.init(id: 1, count: 3, isPro: false)
        let substitutes3 = SubstitutesSetItem.init(id: 2, count: 5, isPro: true)
        let substitutes4 = SubstitutesSetItem.init(id: 3, count: 8, isPro: true)
        let substitutes5 = SubstitutesSetItem.init(id: 4, count: 10, isPro: true)
        let substitutes6 = SubstitutesSetItem.init(id: 5, count: 12, isPro: true)
        substitutesSetItemList = [substitutes1, substitutes2, substitutes3, substitutes4, substitutes5, substitutes6]
        
        let tags1 = TagsRequiredSetItem.init(id: 0, count: 0, isPro: false)
        let tags2 = TagsRequiredSetItem.init(id: 1, count: 1, isPro: false)
        let tags3 = TagsRequiredSetItem.init(id: 2, count: 2, isPro: true)
        let tags4 = TagsRequiredSetItem.init(id: 3, count: 3, isPro: true)
        let tags5 = TagsRequiredSetItem.init(id: 4, count: 5, isPro: true)
        let tags6 = TagsRequiredSetItem.init(id: 5, count: 8, isPro: true)
        tagsSetItemList = [tags1, tags2, tags3, tags4, tags5, tags6]
        
    }
    
    
}
