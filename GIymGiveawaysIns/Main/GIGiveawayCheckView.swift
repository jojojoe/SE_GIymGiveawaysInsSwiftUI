//
//  GIGiveawayCheckView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor

struct GIGiveawayCheckView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userModelManager: UserModelRequest
    
    
//    @State var edges: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]? = nil
//    @State var user: UserInfoModel.Graphql.User? = nil
    
    @State private var isShowGiveawaySetView = false
    
    var body: some View {
        ZStack {
            bgView
            contentView
            
        }
        
    }
    
}

extension GIGiveawayCheckView {
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
            Image("home_picker_background_01")
                .resizable()
                .frame(width: 234, height: 234, alignment: .center)
                .mask(Color(.black).frame(width: 234, height: 234, alignment: .center).cornerRadius(20))
            Spacer()
                .frame(height: 40)
            HStack {
                Spacer()
                HStack {
                    Image("like_icon_png")
                    Text("1234")
                        .font(Font.custom("Avenir-Heavy", size: 14))
                        .foregroundColor(Color(DynamicColor(hexString: "#17025A")))
                }
                Spacer()
                HStack {
                    Image("comment_icon")
                    Text("1234")
                        .font(Font.custom("Avenir-Heavy", size: 14))
                        .foregroundColor(Color(DynamicColor(hexString: "#17025A")))
                }
                Spacer()
            }
            Spacer()
                .frame(height: 40)
            Text("Is this post ?")
                .font(Font.custom("Avenir-Heavy", size: 22))
                .foregroundColor(Color(DynamicColor(hexString: "#260C7A")))
            Spacer()
                .frame(height: 40)
            Button(action: {
                isShowGiveawaySetView = true
            }, label: {
                ZStack {
                    Image("contiune_button_png")
                    Text("Contiune")
                        .font(Font.custom("Avenir-Heavy", size: 20))
                        .foregroundColor(.white)
                }
            })
            Spacer()
        }
    }
}






struct GIGiveawayCheckView_Previews: PreviewProvider {
    static var previews: some View {
        GIGiveawayCheckView()
            .environmentObject(CoinManager.default)
            .environmentObject(DataManager.default)
    }
}




