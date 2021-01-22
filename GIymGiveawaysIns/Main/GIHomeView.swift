//
//  GIHomeView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/19.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor

struct GIHomeView: View {
    @EnvironmentObject var coinManager: CoinManager
    @State private var isShowPickerView: Bool = false
    @State private var isShowHistoryView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 20)
                NavigationLink(
                    destination: GIGiveawayPrizeView()
                        .hideNavigationBar()
                        .environmentObject(CoinManager.default)
                        .environmentObject(DataManager.default),
                    isActive: $isShowPickerView,
                    label: {
                        pickView
                            .onTapGesture {
                                isShowPickerView = true
                            }
                    })
                 
                
                Spacer()
                
                NavigationLink(
                    destination: GIHistoryView()
                        .hideNavigationBar()
                        .environmentObject(HistoryManager.default),
                    isActive: $isShowPickerView,
                    label: {
                        historyView
                            .onTapGesture {
                                isShowHistoryView = true
                            }
                    })
                 
                Spacer()
                    
            }
        }
        
        
    }
    
}

extension GIHomeView {
    var pickView: some View {
        VStack {
            HStack {
                Text("Picker")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                HStack {
                    Image("home_coins_png")
                    Spacer()
                        .frame(width: 4)
                    Text("\(coinManager.coinCount)")
                        .font(Font.custom("Avenir-Heavy", size: 18))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                }
            }.frame(height: 50)
            Spacer()
                .frame(height: 0)
            ZStack {
                
                Image("home_picker_background_01")
                VStack {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        VStack {
                            
                            HStack {
                                Text("Giveaway Picker")
                                    .font(Font.custom("Avenir-Heavy", size: 20))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            HStack {
                                Text("Start Now!")
                                    .font(Font.custom("Avenir-Heavy", size: 20))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        Spacer()
                    }.frame(height: 60)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ZStack {
                            Image("home_button_background")
                                .frame(width: 97, height: 40, alignment: .center)
                            HStack {
                                Text("Next")
                                    .font(Font.custom("Avenir-Heavy", size: 16))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                Image("home_button_arrows")
                            }
                        }
                    }
                    
                    
                }
            }.shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            
        }
        .frame(width: 327, height: 272+50)
        
        
    }
    
    var historyView: some View {
        VStack {
            HStack {
                Text("History")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                
            }.frame(height: 50)
            ZStack {
                
                Image("home_history_background")
                VStack {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        VStack {
                            Text("Lottery history")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Spacer()
                    }.frame(height: 60)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ZStack {
                            Image("home_button_background")
                                .frame(width: 97, height: 40, alignment: .center)
                            HStack {
                                Text("View")
                                    .font(Font.custom("Avenir-Heavy", size: 16))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                Image("home_button_arrows")
                            }
                        }
                    }
                    
                    
                }
            }.shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            
        }
        .frame(width: 327, height: 135+50)
    }
    
    
}

struct GIHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GIHomeView()
            .environmentObject(CoinManager.default)
    }
}


