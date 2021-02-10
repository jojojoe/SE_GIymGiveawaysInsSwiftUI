//
//  GIMainView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import SwiftUIX
import UIKit
import DynamicColor

struct GIMainView: View {
    @EnvironmentObject var splashManager: FCSplashViewManager
    // he /*
    @EnvironmentObject var hlexManager: HLExManager
    // he */
    
    @State private var isShowHomeView = true
    @State private var isShowStoreView = false
    @State private var isShowSettingView = false
    
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    VStack {
                        contentView()
                        
                        Spacer().frame(height: 0, alignment: .center)
                        ZStack {
                            Color(.white)
                                .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: -2)
                                .frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                                
                            bottomBar.frame(width: UIScreen.main.bounds.width, height: 64, alignment: .center)
                                .cornerRadius(20)
                        }
                        
                    }
                    
                    VStack {
                        Spacer()
                        // he /*
                        if hlexManager.permissionStatus {
                            hlexBtn
                        }
                        Spacer()
                            .frame(height: 74)
                        // he */
                    }
                    
                    FCSplashView()
                        .navigationBarHidden(true)
                        .frame(width: UIScreen.main.bounds.size.width)

                        .environmentObject(splashManager)
                        .hidden(splashManager.isShowSplash)
                }.navigationBarHidden(true)
            }
        }
    }
}

// he /*
extension GIMainView {
    var hlexBtn: some View {
        HStack {
            //
            Button(action: {
                hlexManager.permissionAction()
            }) {
                Image("\("li")ke_btn")
            }
            
        }
        .frame(width: 327 ,height: 56, alignment: .center)
    }
}
// he */


extension GIMainView {
    func contentView() -> some View {
        GeometryReader { geo in
            ZStack {
                 
                if isShowHomeView {
                    VStack {
                        GIHomeView()
                            .environmentObject(CoinManager.default)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        
                    }
                    
                    
                }
                if isShowSettingView {
                    GISettingView()
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
                if isShowStoreView {
                    GIStoreView()
                        .environmentObject(CoinManager.default)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
                 
            }
            
        }
        
    }
    
    
    
}

extension GIMainView {
    var bottomBar: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                ZStack {
                    
                    Image("home_button_01")
                        
                        .hidden(isShowHomeView)
                        .onTapGesture {
                            isShowHomeView = true
                            isShowStoreView = false
                            isShowSettingView = false
                        }
                    Image("home_button_png")
                        .hidden(!isShowHomeView)
                }.frame(width: 44, height: 44, alignment: .center)
                Spacer()
                ZStack {
                    Image("store_button_01")
                        .hidden(isShowStoreView)
                        .onTapGesture {
                            isShowHomeView = false
                            isShowStoreView = true
                            isShowSettingView = false
                        }
                    Image("store_button_")
                        .hidden(!isShowStoreView)
                }.frame(width: 44, height: 44, alignment: .center)
                Spacer()
                ZStack {
                    Image("setting_button_01")
                        .hidden(isShowSettingView)
                        .onTapGesture {
                            isShowHomeView = false
                            isShowStoreView = false
                            isShowSettingView = true
                        }
                    Image("setting_button_")
                        .hidden(!isShowSettingView)
                }.frame(width: 44, height: 44, alignment: .center)
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }

    }
    
    var bottomBtn: some View {
        ZStack {
            
        }
    }
    
    
}

struct GIMainView_Previews: PreviewProvider {
    static var previews: some View {
        GIMainView()
    }
}







