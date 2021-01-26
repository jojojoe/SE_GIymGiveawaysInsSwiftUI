//
//  GIGiveawayLinkView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor
import TextView
import ToastUI


enum GIGiveawayLinkView_AlertType {
    case linkError
    case requestError
    
}

struct GIGiveawayLinkView: View {
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userModelManager: UserModelRequest
    
    
    @State private var isShowAlert: Bool = false
    //
    @State private var currentInputLinkString: String = ""
    @State private var isEditing = false
    @State private var isShowToast = false
    @State private var alertType: GIGiveawayLinkView_AlertType = .linkError
    @State private var isShowUrlPostCheckView = false
//    @State private var edges: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]? = nil
//    @State private var user: UserInfoModel.Graphql.User? = nil
    
    var once: Once = Once()
    
    
    var body: some View {
        ZStack {
            bgView
            contentView
        }
        .onAppear(perform: {
            once.run {
                
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                isEditing = true
                currentInputLinkString = UserModelRequest.default.readPasteboard()
            }
            
        })
        .alert(isPresented: $isShowAlert, content: {
            alert()
        })
        .toast(isPresented: $isShowToast, content: {
            
            ToastView("Loading...") {
                // EmptyView()
            } background: {
                // EmptyView()
            }.toastViewStyle(IndefiniteProgressToastViewStyle())
        })
    }
    
    func alert() -> Alert {
        if alertType == .linkError {
            return Alert(title: Text(""), message: Text("Please enter a valid link."), dismissButton: .default(Text("OK")))
        } else if alertType == .requestError {
            return Alert(title: Text(""), message: Text("Request error, try again later."), dismissButton: .default(Text("OK")))
        } else {
            return Alert(title: Text(""), message: Text("Please enter a valid link."), dismissButton: .default(Text("OK")))
        }
        
    }
     
    
}

extension GIGiveawayLinkView {
    var bgView: some View {
        VStack {
            Image("background_png")
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
            
            Text("Giveaway Picker")
                .font(Font.custom("Avenir-Heavy", size: 26))
                .foregroundColor(Color(DynamicColor(hexString: "#1E0375")))
            Text("Ster now !")
                .font(Font.custom("Avenir-Medium", size: 21))
                .foregroundColor(Color(DynamicColor(hexString: "#1E0375")))
            Spacer()
                .frame(height: 80)
            
            ZStack {
                Color(.white)
                    .cornerRadius(12)
                    .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
                HStack {
                    Spacer()
                        .frame(width: 20)
                    TextView(
                        text: $currentInputLinkString,
                        isEditing: $isEditing,
                        placeholder: "Please Input Your Instagram Post URL",
                        textColor: #colorLiteral(red: 0.3490196078, green: 0.2156862745, blue: 0.7764705882, alpha: 1), placeholderColor: Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.3)),
                        backgroundColor: (DynamicColor(hexString: "#FFFFFF"))
                    )
                    .cornerRadius(12)
                    Spacer()
                        .frame(width: 20)
                }
                
            }.frame(width: 320, height: 38, alignment: .center)
            
            Spacer()
                .frame(height: 50)
            
            
            NavigationLink(
                destination: GIGiveawayCheckView()
                    .hideNavigationBar()
                    .environmentObject(CoinManager.default)
                    .environmentObject(DataManager.default)
                    .environmentObject(UserModelRequest.default),
                isActive: $isShowUrlPostCheckView,
                label: {
                    Button(action: {
                        //TODO: check url link
                        if !(currentInputLinkString.contains("https://www.in\("stag")ram.com/p/") ) &&
                            !(currentInputLinkString.contains("/?igshid=") ) {
                            isShowAlert = true
                        } else {
                            
                            isShowToast = true
                            userModelManager.request(urlstr: currentInputLinkString) { (success, edges, user) in
                                isShowToast = false
                                if success {
        //                            self.edges = edges
        //                            self.user = user
                                    isShowUrlPostCheckView = true
                                } else {
                                    alertType = .requestError
                                    isShowAlert = true
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                        isShowToast = false
                                    }
                                }
                            }
                        }
                        
                    }, label: {
                        ZStack {
                            Image("contiune_button_png")
                            Text("Find Post")
                                .font(Font.custom("Avenir-Heavy", size: 20))
                                .foregroundColor(.white)
                        }
                    })
                })
            
            
            Spacer()
                .frame(height: 60)
            
            
            Spacer()
        }
    }
}

 

struct GIGiveawayLinkView_Previews: PreviewProvider {
    static var previews: some View {
        GIGiveawayLinkView()
            .environmentObject(CoinManager.default)
            .environmentObject(DataManager.default)
    }
}
