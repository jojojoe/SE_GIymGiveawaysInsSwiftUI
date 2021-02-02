//
//  GIStoreView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor
import ToastUI


struct GIStoreView: View {
    
    @EnvironmentObject var coinManager: CoinManager
    @State var presentingToast_load = false
    @State var presentingToast_success = false
    @State var presentingToast_fail = false
    @State var presentingToast_fail_message = ""
    
    var body: some View {
        ZStack {
            bgView
                .edgesIgnoringSafeArea(.all)
            contentView
        }
    }
    
}

extension GIStoreView {
    var bgView: some View {
        VStack {
            Image("store_background")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width, height: (237.0/375.0) * UIScreen.main.bounds.size.width)
            Spacer()
        }
    }
    
    var contentView: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            titleView
            HStack {
                
                Spacer()
                HStack {
                    Image("home_coins_png")
                    Spacer()
                        .frame(width: 4)
                    Text("\(coinManager.coinCount)")
                        .font(Font.custom("Avenir-Heavy", size: 22))
                        .foregroundColor(.white)
                }
                Spacer()
                    .frame(width: 25)
            }.frame(height: 24)
            Spacer()
                .frame(height: 0)
            storeCoinView
//            Spacer()
        }
    }
    
    var titleView: some View {
        ZStack {
            Color(.white)
                .cornerRadius(16)
                .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            Text("Store")
                .font(Font.custom("Avenir-Heavy", size: 20))
                .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
        }.frame(width: 164, height: 42, alignment: .center)
    }
    
    var storeCoinView: some View {
        
     
        QGridVer(coinManager.coinIpaItemList,
                 columns: Int(2),
                 vSpacing: 15,
                 hSpacing: 15,
                 vPadding: 10,
                 hPadding: 28) {
            storeCell(storeItem: $0)
                .frame(width: 180, height: 160)
                
        }.shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            
        
    }
    
}

extension GIStoreView {
    func storeCell(storeItem: StoreItem) -> some View {
        contentBtnsView(storeItem: storeItem)
    }
    
    func contentBtnsView( storeItem: StoreItem) -> some View {
        Button(action: {
            clickAction(storeItem: storeItem)
        }) {
            ZStack {
                VStack {
                    Image("store_background_png")
                        .cornerRadius(12)
                        
                    Spacer()
                        .frame(height: 18)
                    
                }
                VStack {
                    Image("store_coins_02")
                    Text("X \(storeItem.coin)")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                        .frame(height: 10)
                    ZStack {
                        Image("store_button_png")
                        Text(storeItem.price)
                            .font(Font.custom("Avenir-Heavy", size: 16))
                            .foregroundColor(.white)
                    }
                }.offset(x: 0, y: 10.0)
            }
        }
        .toast(isPresented: $presentingToast_load, content: {
            ToastView("Loading...") {
                // EmptyView()
            } background: {
                // EmptyView()
            }.toastViewStyle(IndefiniteProgressToastViewStyle())
            
        })
        .alert(isPresented: $presentingToast_success, content: {
            Alert(title: Text("Success"), message: Text(""), dismissButton: .default(Text("OK")))
        })
        .alert(isPresented: $presentingToast_fail, content: {
            Alert(title: Text("Error"), message: Text(presentingToast_fail_message), dismissButton: .default(Text("OK")))
        })
        
        
    }
    
    
    func clickAction(storeItem: StoreItem) {
        presentingToast_load = true
        debugPrint("iapid = \(storeItem.iapId)")
        CoinManager.default.purchaseIapId(iap: storeItem.iapId) { (success, errorString) in
            presentingToast_load = false
            if success {
                CoinManager.default.addCoin(coin: storeItem.coin)
                presentingToast_success = true
            } else {
                presentingToast_fail = true
                presentingToast_fail_message = errorString ?? ""
            }
        }
        
    }
     
    
    
}


struct GIStoreView_Previews: PreviewProvider {
    static var previews: some View {
        GIStoreView()
            .environmentObject(CoinManager.default)
    }
}


