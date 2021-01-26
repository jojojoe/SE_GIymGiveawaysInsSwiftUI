//
//  GIGiveawaySetView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor

enum GIGiveawaySetView_AlertType {
    case coinNotEnough
}

struct GIGiveawaySetView: View {
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userModelManager: UserModelRequest
    
//    @State var edges: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]? = nil
//    @State var user: UserInfoModel.Graphql.User? = nil
    
    @State private var isShowGiveawayResultView = false
    
    @State private var currentWinnerItem: WinnerSetItem? = DataManager.default.winnerSetItemList.first
    @State private var currentSubstitutesItem: SubstitutesSetItem? = DataManager.default.substitutesSetItemList.first
    @State private var currentTagsItem: TagsRequiredSetItem? = DataManager.default.tagsSetItemList.first
    
    @State private var winnersCustomCount: Int = 0
    @State private var substitutesCustomCount: Int = 0
    @State private var tagsCustomCount: Int = 0
    
    
    @State private var isShowWinnersCustomView = false
    @State private var isShowSubstitutesCustomView = false
    @State private var isShowTagsCustomView = false

    @State private var isShowResultView: Bool = false
    @State private var isShowPurchaseView: Bool = false
    
    @State private var isShowAlert: Bool = false
    @State private var alertType: GIGiveawaySetView_AlertType = .coinNotEnough
    
    @State private var isShowCoinStoreView: Bool = false
    
    var maxCount: Int = 20
    
    var body: some View {
        ZStack {
            bgView
            contentView
            if isShowWinnersCustomView {
                winnersCustomView
            }
            if isShowSubstitutesCustomView {
                substitutesCustomView
            }
            if isShowTagsCustomView {
                tagsCustomView
            }
            if isShowPurchaseView {
                purchasePopView
            }
        }.alert(isPresented: $isShowAlert, content: {
            alert()
        })
        .sheet(isPresented: $isShowCoinStoreView, content: {
            GIStoreView()
                .navigationBarHidden(true)
                .environmentObject(CoinManager.default)
        })
    }
    
    func alert() -> Alert {
        if alertType == .coinNotEnough {
            return Alert(title: Text("Coins shortage.Click and Jump to Store Page."), message: Text(""), primaryButton: .default(Text("OK"), action: {
                        isShowCoinStoreView = true
                    }), secondaryButton: .cancel(Text("Cancel")))
        } else {
            return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
        }
        
    }
    
}

extension GIGiveawaySetView {
    var bgView: some View {
        VStack {
            Image("background_03")
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
            
            Text("Number of")
                .font(Font.custom("Avenir-Heavy", size: 22))
                .foregroundColor(Color(DynamicColor(hexString: "#260C7A")))
            Spacer()
            
            winnersSelectView
            substituteSelectView
            tagRequiredSelectView
            Spacer()
            
            bottomBtn
        }
    }
}

// Winners
extension GIGiveawaySetView {
    var winnersSelectView: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 30)
                Text("Winners")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Text("\(currentWinnerItem?.count ?? 1)")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                
                Spacer()
                Text("Custmize")
                    .font(Font.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.5)))
                    .onTapGesture {
                        //TODO: TAP winner custom
                        isShowWinnersCustomView = true
                    }
                Image("custmize_button_png")
                    .frame(width: 34, height: 34, alignment: .center)
                    .onTapGesture {
                        //TODO: TAP winner custom
                        isShowWinnersCustomView = true
                    }
                Spacer()
                    .frame(width: 24)
            }
            Spacer()
                .frame(height: 1)
            QGridHor(dataManager.winnerSetItemList,
                     columns: Int(1),
                     vSpacing: 15,
                     hSpacing: 15,
                     vPadding: 10,
                     hPadding: 28) {
                winnerSetCell(item: $0)
                    .frame(width: 68, height: 68, alignment: .center)
                    .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 2)
                    
            }.frame(width: UIScreen.main.bounds.width, height: 88)
            
            
            
        }.frame(width: UIScreen.main.bounds.width, height: 120, alignment: .center)
    }
    
    
    func winnerSetCell(item: WinnerSetItem) -> some View {
         
        ZStack {
            if let currentWinnertItem_m = currentWinnerItem, currentWinnertItem_m.count == item.count {

                LinearGradient(gradient: Gradient(colors: [Color(DynamicColor(hexString: "#9E86E0")), Color(DynamicColor(hexString: "#8056FC"))]),
                                             startPoint: .top,
                                             endPoint: .bottom)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))

            } else {

                Color(.white)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#CEC3EE")))

            }
            
            if item.isPro {
                VStack {
                    HStack {
                        Spacer()
                        Image("number_coins")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    Spacer()
                }
            }
        }
        .onTapGesture {
            currentWinnerItem = item
            winnersCustomCount = currentWinnerItem?.count ?? winnersCustomCount
        }
    }
    
    var winnersCustomView: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.82))
            ZStack {
                Color(.white)
                VStack {
                    Spacer()
                        .frame(height: 18)
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowWinnersCustomView = false
                        }, label: {
                            Image("cloes_buttton")
                                .colorMultiply(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 30, height: 30, alignment: .center)
                        })
                        Spacer()
                            .frame(width: 20)
                    }
                    
                    Text("Number of Winners")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                    Spacer()
                        .frame(height: 40)
                    HStack {
                        Button(action: {
                            if winnersCustomCount > 0 {
                                winnersCustomCount -= 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("-")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                             
                            
                        })
                        .cornerRadius([.topLeft, .bottomLeft], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        ZStack {
                            Color(.white)
                                .frame(width: 80, height: 40, alignment: .center)
                            Text("\(winnersCustomCount)")
                                .font(Font.custom("Avenir-Heavy", size: 35))
                                .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 80, height: 40, alignment: .center)
                        }
                        
                            .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        Button(action: {
                            if winnersCustomCount < 20 {
                                winnersCustomCount += 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("+")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                        })
                        .cornerRadius([.topRight, .bottomRight], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                    }
                    Spacer()
                        .frame(height: 50)
                    Button(action: {
                        //TODO: custom winners ok
                        let customWinnersItem = WinnerSetItem.init(id: 100000, count: winnersCustomCount, isPro: true)
                        currentWinnerItem = customWinnersItem
                        isShowWinnersCustomView = false
                    }, label: {
                        ZStack {
                            Image("number_ok_button")
                            Text("OK")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                            VStack {
                                Spacer().frame(height: 8)
                                HStack {
                                    Spacer()
                                    Image("number_coins")
                                    Spacer().frame(width: 8)
                                }
                                Spacer()
                            }
                        }
                    }).frame(width: 180, height: 42, alignment: .center)
                    Spacer()
                        
                }
            }.frame(width: 308, height: 324, alignment: .center)
            .cornerRadius(16)
            
            
        }
    }
    
    
    
}

// Substitute
extension GIGiveawaySetView {
    var substituteSelectView: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 30)
                Text("Substitutes ")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Text("\(currentSubstitutesItem?.count ?? 1)")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                
                Spacer()
                Text("Custmize")
                    .font(Font.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.5)))
                    .onTapGesture {
                        //TODO: TAP substitutes custom
                        isShowSubstitutesCustomView = true
                    }
                Image("custmize_button_png")
                    .frame(width: 34, height: 34, alignment: .center)
                    .onTapGesture {
                        //TODO: TAP substitutes custom
                        isShowSubstitutesCustomView = true
                    }
                Spacer()
                    .frame(width: 24)
            }
            Spacer()
                .frame(height: 1)
            QGridHor(dataManager.substitutesSetItemList,
                     columns: Int(1),
                     vSpacing: 15,
                     hSpacing: 15,
                     vPadding: 10,
                     hPadding: 28) {
                substituteSetCell(item: $0)
                    .frame(width: 68, height: 68, alignment: .center)
                    .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 2)
                    
            }.frame(width: UIScreen.main.bounds.width, height: 88)
            
        }.frame(width: UIScreen.main.bounds.width, height: 120, alignment: .center)
    }
    
    func substituteSetCell(item: SubstitutesSetItem) -> some View {
         
        ZStack {
            if let currentSubstitutesItem_m = currentSubstitutesItem, currentSubstitutesItem_m.count == item.count {

                LinearGradient(gradient: Gradient(colors: [Color(DynamicColor(hexString: "#9E86E0")), Color(DynamicColor(hexString: "#8056FC"))]),
                                             startPoint: .top,
                                             endPoint: .bottom)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))

            } else {

                Color(.white)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#CEC3EE")))

            }
            
            if item.isPro {
                VStack {
                    HStack {
                        Spacer()
                        Image("number_coins")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    Spacer()
                }
            }
        }
        .onTapGesture {
            currentSubstitutesItem = item
            substitutesCustomCount = currentSubstitutesItem?.count ?? substitutesCustomCount
        }
        
    }
    
    var substitutesCustomView: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.82))
            ZStack {
                Color(.white)
                VStack {
                    Spacer()
                        .frame(height: 18)
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowSubstitutesCustomView = false
                        }, label: {
                            Image("cloes_buttton")
                                .colorMultiply(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 30, height: 30, alignment: .center)
                        })
                        Spacer()
                            .frame(width: 20)
                    }
                    
                    Text("Number of Substitutes")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                    Spacer()
                        .frame(height: 40)
                    HStack {
                        Button(action: {
                            if substitutesCustomCount > 0 {
                                substitutesCustomCount -= 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("-")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                             
                            
                        })
                        .cornerRadius([.topLeft, .bottomLeft], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        ZStack {
                            Color(.white)
                                .frame(width: 80, height: 40, alignment: .center)
                            Text("\(substitutesCustomCount)")
                                .font(Font.custom("Avenir-Heavy", size: 35))
                                .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 80, height: 40, alignment: .center)
                        }
                        
                            .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        Button(action: {
                            if substitutesCustomCount < 20 {
                                substitutesCustomCount += 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("+")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                        })
                        .cornerRadius([.topRight, .bottomRight], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                    }
                    Spacer()
                        .frame(height: 50)
                    Button(action: {
                        //TODO: custom winners ok
                        let customSubstitutesItem = SubstitutesSetItem.init(id: 100000, count: substitutesCustomCount, isPro: true)
                        currentSubstitutesItem = customSubstitutesItem
                        isShowSubstitutesCustomView = false
                    }, label: {
                        ZStack {
                            Image("number_ok_button")
                            Text("OK")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                            VStack {
                                Spacer().frame(height: 8)
                                HStack {
                                    Spacer()
                                    Image("number_coins")
                                    Spacer().frame(width: 8)
                                }
                                Spacer()
                            }
                        }
                    }).frame(width: 180, height: 42, alignment: .center)
                    Spacer()
                        
                }
            }.frame(width: 308, height: 324, alignment: .center)
            .cornerRadius(16)
            
            
        }
    }
    
}

// TagRequired
extension GIGiveawaySetView {
    var tagRequiredSelectView: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 30)
                Text("Tags Required ")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Text("\(currentTagsItem?.count ?? 1)")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                
                Spacer()
                Text("Custmize")
                    .font(Font.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.5)))
                    .onTapGesture {
                        //TODO: TAP tagRequiredSet custom
                        isShowTagsCustomView = true
                    }
                Image("custmize_button_png")
                    .frame(width: 34, height: 34, alignment: .center)
                    .onTapGesture {
                        //TODO: TAP tagRequiredSet custom
                        isShowTagsCustomView = true
                    }
                Spacer()
                    .frame(width: 24)
            }
            Spacer()
                .frame(height: 1)
            QGridHor(dataManager.tagsSetItemList,
                     columns: Int(1),
                     vSpacing: 15,
                     hSpacing: 15,
                     vPadding: 10,
                     hPadding: 28) {
                tagRequiredSetCell(item: $0)
                    .frame(width: 68, height: 68, alignment: .center)
                    .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 2)
                    
            }.frame(width: UIScreen.main.bounds.width, height: 88)
            
            
            
        }.frame(width: UIScreen.main.bounds.width, height: 120, alignment: .center)
    }
    
    func tagRequiredSetCell(item: TagsRequiredSetItem) -> some View {
         
        ZStack {
            if let currentTagsItem_m = currentTagsItem, currentTagsItem_m.count == item.count {

                LinearGradient(gradient: Gradient(colors: [Color(DynamicColor(hexString: "#9E86E0")), Color(DynamicColor(hexString: "#8056FC"))]),
                                             startPoint: .top,
                                             endPoint: .bottom)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Image("tag_png")
                    .frame(width: 44, height: 44, alignment: .center)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))

            } else {

                Color(.white)
                    .frame(width: 56, height: 56, alignment: .center)
                    .cornerRadius(10)
                Text("\(item.count)")
                    .font(Font.custom("Avenir-Heavy", size: 24))
                    .foregroundColor(Color(DynamicColor(hexString: "#CEC3EE")))

            }
            
            if item.isPro {
                VStack {
                    HStack {
                        Spacer()
                        Image("number_coins")
                            .resizable()
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    Spacer()
                }
            }
        }
        .onTapGesture {
            currentTagsItem = item
            tagsCustomCount = currentTagsItem?.count ?? tagsCustomCount
        }
        
    }
    
    var tagsCustomView: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.82))
            ZStack {
                Color(.white)
                VStack {
                    Spacer()
                        .frame(height: 18)
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowTagsCustomView = false
                        }, label: {
                            Image("cloes_buttton")
                                .colorMultiply(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 30, height: 30, alignment: .center)
                        })
                        Spacer()
                            .frame(width: 20)
                    }
                    
                    Text("Number of TagsRequired")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                    Spacer()
                        .frame(height: 40)
                    HStack {
                        Button(action: {
                            if tagsCustomCount > 0 {
                                tagsCustomCount -= 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("-")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                             
                            
                        })
                        .cornerRadius([.topLeft, .bottomLeft], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        ZStack {
                            Color(.white)
                                .frame(width: 80, height: 40, alignment: .center)
                            Text("\(tagsCustomCount)")
                                .font(Font.custom("Avenir-Heavy", size: 35))
                                .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 80, height: 40, alignment: .center)
                        }
                        
                            .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                        Spacer()
                            .frame(width: 0)
                        Button(action: {
                            if tagsCustomCount < 20 {
                                tagsCustomCount += 1
                            }
                            
                        }, label: {
                            ZStack {
                                Color(.white)
                                Text("+")
                                    .font(Font.custom("Avenir-Heavy", size: 38))
                                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                            }.frame(width: 80, height: 40, alignment: .center)
                        })
                        .cornerRadius([.topRight, .bottomRight], 20)
                        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
                    }
                    Spacer()
                        .frame(height: 50)
                    Button(action: {
                        //TODO: custom winners ok
                        let customTagsItem = TagsRequiredSetItem.init(id: 100000, count: tagsCustomCount, isPro: true)
                        currentTagsItem = customTagsItem
                        isShowTagsCustomView = false
                    }, label: {
                        ZStack {
                            Image("number_ok_button")
                            Text("OK")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                            VStack {
                                Spacer().frame(height: 8)
                                HStack {
                                    Spacer()
                                    Image("number_coins")
                                    Spacer().frame(width: 8)
                                }
                                Spacer()
                            }
                        }
                    }).frame(width: 180, height: 42, alignment: .center)
                    Spacer()
                        
                }
            }.frame(width: 308, height: 324, alignment: .center)
            .cornerRadius(16)
            
            
        }
    }
}


extension GIGiveawaySetView {
    var purchasePopView: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.82))
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Color(.white)
                VStack {
                    Spacer()
                        .frame(height: 18)
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowPurchaseView = false
                        }, label: {
                            Image("cloes_buttton")
                                .colorMultiply(Color(DynamicColor(hexString: "#5937C6")))
                                .frame(width: 30, height: 30, alignment: .center)
                        })
                        Spacer()
                            .frame(width: 20)
                    }
                    Image("store_coins_02")
                    Spacer()
                        .frame(height: 32)
                    Text("Cost \(coinManager.coinCostCount) coins")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                    Spacer()
                        .frame(height: 42)
                    Button(action: {
                        //TODO: purchase ok
                        
                        isShowPurchaseView = false
                        
                        if coinManager.coinCount >= coinManager.coinCostCount {
                            coinManager.costCoin(coin: coinManager.coinCostCount)
                            userModelManager.filterWinnersAndSubstitutes(winnerCount: currentWinnerItem?.count ?? 1, substitutesCount: currentSubstitutesItem?.count ?? 1, tagsCount: currentTagsItem?.count ?? 0)
                            isShowResultView = true
                        } else {
                            alertType = .coinNotEnough
                            isShowAlert = true
                        }
                        
                    }, label: {
                        ZStack {
                            Image("number_ok_button")
                            Text("OK")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                            
                        }
                    }).frame(width: 180, height: 42, alignment: .center)
                    Spacer()
                }
            }.frame(width: 308, height: 324, alignment: .center)
            .cornerRadius(16)
            
            
        }
    }
}
extension GIGiveawaySetView {
    var isPro: Bool {
        if let winnerItem = currentWinnerItem, let substitutesItem = currentSubstitutesItem, let tagsItem = currentTagsItem {
            if winnerItem.isPro || substitutesItem.isPro || tagsItem.isPro {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    var bottomBtn: some View {
        NavigationLink(
            destination: GIGiveawayResultView()
                .hideNavigationBar()
                .environmentObject(CoinManager.default)
                .environmentObject(DataManager.default)
                .environmentObject(UserModelRequest.default),
            isActive: $isShowResultView,
            label: {
                Button(action: {
                    //TODO: Start Giveaway
                    if isPro {
                        isShowPurchaseView = true
                    } else {
                        userModelManager.filterWinnersAndSubstitutes(winnerCount: currentWinnerItem?.count ?? 1, substitutesCount: currentSubstitutesItem?.count ?? 1, tagsCount: currentTagsItem?.count ?? 0)
                        isShowResultView = true
                    }
                    
                }, label: {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color(DynamicColor(hexString: "#9E86E0")), Color(DynamicColor(hexString: "#8056FC"))]),
                                                     startPoint: .top,
                                                     endPoint: .bottom)
                        
                        Text("Start Giveaway")
                            .font(Font.custom("Avenir-Heavy", size: 20))
                            .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                    }
                }).frame(width: UIScreen.main.bounds.width, height: 42, alignment: .center)
                .cornerRadius([.topLeft, .topRight], 16)
            })
        
    }
}


struct GIGiveawaySetView_Previews: PreviewProvider {
    static var previews: some View {
        GIGiveawaySetView()
            .environmentObject(CoinManager.default)
            .environmentObject(DataManager.default)
            .environmentObject(UserModelRequest.default)
    }
}


