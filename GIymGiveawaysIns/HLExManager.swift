//
//  HLExManager.swift
//  FCymFunnyCreatorSU
//
//  Created by JOJO on 2021/1/15.
//

import Foundation
import UIKit
class HLExManager: ObservableObject {
    @Published var permissionStatus: Bool
    
    static let `default` = HLExManager()
    
    init() {
        permissionStatus = false
        HightLigtingHelper.default.delegate = self
    }
    
    func permissionAction() {
        HightLigtingHelper.default.present()
    }
    
}

extension HLExManager: HightLigtingHelperDelegate {
    func open() -> UIButton? {
        
        return nil
    }
    
    func open(isO: Bool) -> Void {
        permissionStatus = isO
    }
    
    func preparePopupKKAd(placeId: String?, placeName: String?) {
        
    }

    
    func showAd(type: Int, userId: String?, source: String?, complete: @escaping ((Bool, Bool, Bool) -> Void)) {
        var adType:String = ""
        switch type {
        case 0:
            adType = "KKAd"
        case 1:
            adType = "interstitial Ad"
        case 2:
            adType = "reward Video Ad"
        default:
            break
        }
        
        HLAlert.message("\(adType)广告已展示") { (s) in
             complete(s,false,false)
        }
    }
}


