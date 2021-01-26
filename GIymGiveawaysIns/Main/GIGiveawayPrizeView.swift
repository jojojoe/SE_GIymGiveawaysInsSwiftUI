//
//  GIGiveawayPrizeView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/19.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor
import TextView


enum GIGiveawayPrizeView_AlertType {
    case purchaseAlert
    case inputDisenableAlert
    case deletePrizeAlert
    case coinNotEnoughAlert
    case inputNilPrizeAlert
}

struct GIGiveawayPrizeView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var dataManager: DataManager
    
    @State private var currentInputPrizeString: String = ""
    @State private var prizeTitleString: String = "Shose"
    @State private var willDeletePrizeItem: PrizeItem? = nil
    
    @State private var isShowInputView: Bool = false
    @State private var isShowPrizeDeleteBtn: Bool = false
    @State private var isShowNextLineView: Bool = false
    @State private var isShowCoinStoreView: Bool = false
    
    @State private var isEditingKeyboard: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var alertType: GIGiveawayPrizeView_AlertType = .purchaseAlert
    
    var body: some View {
        NavigationView {
            ZStack {
                bgView
                contentView
                if isShowInputView {
                    inputNewPrizeView
                }
            }.hideNavigationBar()
        }
        
        .alert(isPresented: $isShowAlert, content: {
            alert()
        })
        .sheet(isPresented: $isShowCoinStoreView, content: {
            GIStoreView()
                .navigationBarHidden(true)
                .environmentObject(CoinManager.default)
        })
    }
    
}





extension GIGiveawayPrizeView {
    func alert() -> Alert {
        if alertType == .purchaseAlert {
            return Alert(title: Text(""), message: Text("Add new prize will cost \(coinManager.coinCostCount) coins, will continue?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Ok"), action: {
                coinManager.costCoin(coin: coinManager.coinCostCount)
                dataManager.addNewCustomPrize(prize: currentInputPrizeString)
                prizeTitleString = currentInputPrizeString
                isShowInputView = false
                isEditingKeyboard = false
            }))
        } else if alertType == .inputDisenableAlert {
            return Alert(title: Text(""), message: Text("Add Prize to the upper limit, please delete the existing before adding."), dismissButton: .default(Text("OK")))
        } else if alertType == .deletePrizeAlert {
            return Alert(title: Text(""), message: Text("Are you sure you want to delete this prize"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Ok"), action: {
                if let willDeletePrizeItem_m = willDeletePrizeItem {
                    dataManager.removeCustomPrize(prizeItem: willDeletePrizeItem_m)
                }
            }))
        } else if alertType == .coinNotEnoughAlert {
            return Alert(title: Text("Coins shortage.Click and Jump to Store Page."), message: Text(""), primaryButton: .default(Text("OK"), action: {
                        isShowCoinStoreView = true
                    }), secondaryButton: .cancel(Text("Cancel")))
        } else if alertType == .inputNilPrizeAlert {
            return Alert(title: Text(""), message: Text("Please enter valid information."), dismissButton: .default(Text("OK")))
        } else {
            return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
        }
    }
}

extension GIGiveawayPrizeView {
    var bgView: some View {
        VStack {
            Image("background_01")
            Spacer()
        }
    }
    
    var contentView: some View {
        VStack {
            HStack {
                Button(action: {
                    mode.dismiss()
                }, label: {
                    Image("history_back")
                }).frame(width: 64, height: 44, alignment: .center)
                Spacer()
            }.frame(height: 44)
            
            Text("What are the prizes ? ? ?")
                .font(Font.custom("Avenir-Medium", size: 21))
                .foregroundColor(Color(DynamicColor(hexString: "#1E0375")))
            Image("gift_png")
            HStack {
                Text(prizeTitleString)
                    .font(Font.custom("Avenir-Medium", size: 21))
                    .foregroundColor(Color(DynamicColor(hexString: "#6545CA")))
                
                Image("refresh_button")
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        prizeTitleString = dataManager.prizeStringList.randomElement() ?? "Shose"
                    }
            }
            
            NavigationLink(
                destination: GIGiveawayLinkView()
                    .hideNavigationBar()
                    .environmentObject(CoinManager.default)
                    .environmentObject(DataManager.default)
                    .environmentObject(UserModelRequest.default)
                ,
                isActive: $isShowNextLineView,
                label: {
                    Button(action: {
                        dataManager.currentSelectPrize = prizeTitleString
                        isShowNextLineView = true
                    }, label: {
                        ZStack {
                            Image("next_button_background")
                            Text("Next")
                                .font(Font.custom("Avenir-Heavy", size: 18))
                                .foregroundColor(.white)
                        }
                    })
                })
            
            
            Spacer()
                .frame(height: 60)
            prizeContentView
                .frame(width: 328, height: 190, alignment: .center)
                .cornerRadius(16)
                .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            
            Spacer()
        }
    }
    
    var prizeContentView: some View {
        ZStack {
            Color(.white)
            QGridVer(dataManager.prizeItemList,
                     columns: Int(3),
                     vSpacing: 8,
                     hSpacing: 8,
                     vPadding: 10,
                     hPadding: 8) {
                
                prizeCell(prizeItem: $0)
                
            }
            
             
            addPrizeBtn
                .onTapGesture {
                    currentInputPrizeString = ""
                    if dataManager.canAddNewPrize {
                        if coinManager.coinCount >= coinManager.coinCostCount {
                            isShowInputView = true
                            isEditingKeyboard = true
                        } else {
                            alertType = .coinNotEnoughAlert
                            isShowAlert = true
                        }
                    } else {
                        alertType = .inputDisenableAlert
                        isShowAlert = true
                    }
                }
        }
        
    }
    
    var addPrizeBtn: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Image("add_button_background")
                            .opacity(dataManager.canAddNewPrize ? 1 : 0.3)
                            
                        HStack {
                            Spacer()
                            Text("Add to")
                                .font(Font.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                            VStack {
                                Spacer()
                                    .frame(height: 4)
                                ZStack {
                                    Color(DynamicColor(hexString: "#FFE845"))
                                        .cornerRadius(7.5)
                                    Text("PRO")
                                        .font(Font.custom("Avenir-Heavy", size: 10))
                                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                }.frame(width: 36, height: 15, alignment: .center)
                                Spacer()
                            }
                            Spacer()
                                .frame(width: 6)
                        }
                    }.offset(x: 0, y: -4)
                }.frame(width: 126, height: 42)
            }
        }

    }
    
    func prizeCell(prizeItem: PrizeItem) -> some View {
        ZStack {
            Color(DynamicColor(hexString: prizeItem.color))
                .frame(width: 96, height: 28, alignment: .center)
                .cornerRadius(14)
            HStack {
                Spacer()
                    .width(6)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 8, height: 8, alignment: .center)
                Text(prizeItem.prizeContent)
                    .font(Font.custom("Avenir-Heavy", size: 14))
                    .foregroundColor(.white)
                
                Spacer()
                    
            }
            if prizeItem.id >= 6 {
                VStack {
                    HStack {
                        Spacer()
                        Image("delete_button")
                            .onTapGesture {
                                willDeletePrizeItem = prizeItem
                                alertType = .deletePrizeAlert
                                isShowAlert = true
                                
                            }
                    }
                    Spacer()
                }
            }
            
        }
        .frame(width: 96, height: 36, alignment: .center)
        .onTapGesture {
            prizeTitleString = prizeItem.prizeContent
        }
        
    }
}

extension GIGiveawayPrizeView {
    var inputNewPrizeView: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.8))
            VStack {
                Spacer()
                    .frame(height: 50)
                HStack {
                    Button(action: {
                        isShowInputView = false
                        isEditingKeyboard = false
                    }, label: {
                        Image("cloes_buttton")
                    }).frame(width: 64, height: 44, alignment: .center)
                    Spacer()
                    Button(action: {
                        if currentInputPrizeString.count >= 1 {
                            isShowInputView = false
                            alertType = .purchaseAlert
                            isShowAlert = true
                        } else {
                            alertType = .inputNilPrizeAlert
                            isShowAlert = true
                        }
                        
                    }, label: {
                        Image("affrim_button")
                    }).frame(width: 64, height: 44, alignment: .center)
                }
                Spacer()
                ZStack {
                    Color(.white)
                        .cornerRadius(12)
                        
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        TextView(
                            text: $currentInputPrizeString,
                            isEditing: $isEditingKeyboard,
                            placeholder: "Put in your prize...",
                            textColor: #colorLiteral(red: 0.3490196078, green: 0.2156862745, blue: 0.7764705882, alpha: 1), placeholderColor: Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.3)),
                            backgroundColor: (DynamicColor(hexString: "#FFFFFF"))
                        )
                        .cornerRadius(12)
                        Spacer()
                            .frame(width: 20)
                    }
                    
                }.frame(width: 320, height: 38, alignment: .center)
                
                Spacer()
            }
        }
    }
}


struct GIGiveawayPrizeView_Previews: PreviewProvider {
    static var previews: some View {
        GIGiveawayPrizeView()
            .environmentObject(CoinManager.default)
            .environmentObject(DataManager.default)
    }
}



