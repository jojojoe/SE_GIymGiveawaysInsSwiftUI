//
//  ContentView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import SwiftUI
import DynamicColor

class Item: Identifiable, ObservableObject {
    var id: Int = 0
    var iapId: String = ""
    
    init(id: Int, iapId: String) {
        self.id = id
        self.iapId = iapId
    }
}

struct ContentView: View {
    
    
    
     func itemList() -> [Item] {
        let item0 = Item(id: 0, iapId: "0")
        let item1 = Item(id: 1, iapId: "1")
        let item2 = Item(id: 2, iapId: "2")
        let item3 = Item(id: 3, iapId: "3")
        let item4 = Item(id: 4, iapId: "4")
        let item5 = Item(id: 5, iapId: "5")
        let item6 = Item(id: 5, iapId: "6")
        return [item0, item1, item2, item3, item4, item5, item6]
    }
    
    var body: some View {
        VStack {
            GIMainView()
                .environmentObject(FCSplashViewManager.default)
            
//            FCSplashView()
//            Text("test")
//            prizeCell(prizeItem: DataManager.default.prizeItemList.first!)
                
//            GIGiveawaySetView()
//                .environmentObject(CoinManager.default)
//                .environmentObject(DataManager.default)
//
//            GIGiveawayResultView()
//                .environmentObject(CoinManager.default)
//                .environmentObject(DataManager.default)
            
        }
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
