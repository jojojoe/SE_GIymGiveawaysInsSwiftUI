//
//  SplashManager.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/22.
//

import Foundation

class FCSplashViewManager: ObservableObject {
   
   var k_checkSpalshStatus: String = "k_checkSpalshStatus"
   
   @Published var isShowSplash: Bool
   
   static let `default` = FCSplashViewManager()
   
   init() {
       if let hasSplash = UserDefaults.standard.object(forKey: k_checkSpalshStatus) as? Bool, hasSplash == true {
           isShowSplash = true
       } else {
           isShowSplash = false
       }
   }
   
   func loadHasSplash() {
       UserDefaults.standard.setValue(true, forKey: k_checkSpalshStatus)
       isShowSplash = true
   }
   
}
