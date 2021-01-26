//
//  GIGiveawayResultView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor
import URLImage
import SwifterSwift

struct GIGiveawayResultView: View {
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userModelManager: UserModelRequest
 
    
    
    @State private var isShowWinnerType: Bool = true
    @State private var isShowSubstitutesType: Bool = false
    
    var body: some View {
        ZStack {
            bgView
            contentView
        }
        
        
    }
    
}

extension GIGiveawayResultView {
    var bgView: some View {
        VStack {
            Image("background_04")
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
            Spacer()
                .frame(height: 180)
            
            HStack {
                Spacer()
                ZStack {
                    Text("Winners")
                        .font(Font.custom("Avenir-Heavy", size: 22))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        .hidden(!isShowWinnerType)
                    Button(action: {
                        isShowWinnerType = true
                        isShowSubstitutesType = false
                    }, label: {
                        Text("Winners")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.2)))
                    })
                    .hidden(isShowWinnerType)
                }
                Spacer()
                ZStack {
                    Text("Substitutes ")
                        .font(Font.custom("Avenir-Heavy", size: 22))
                        .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        .hidden(!isShowSubstitutesType)
                    Button(action: {
                        isShowWinnerType = false
                        isShowSubstitutesType = true
                    }, label: {
                        Text("Substitutes ")
                            .font(Font.custom("Avenir-Heavy", size: 22))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.2)))
                    })
                    .hidden(isShowSubstitutesType)
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: 40, alignment: .center)
            ZStack {
                if isShowWinnerType {
                    winnerContentView
                }
                if isShowSubstitutesType {
                    substitutesContentView
                }
            }
            
            Spacer()
        }
    }
}

extension GIGiveawayResultView {
    var winnerContentView: some View {
        ScrollView(.vertical) {
            Color(.white)
            
            VStack(spacing: 0) {
                //userModelManager.winner?.count ?? 6
                ForEach(0..<(userModelManager.winner?.count ?? 0)) { index in
                    resultCell(item: userModelManager.winner?[index])
//
                    
                }.padding(5)
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
        
    }
 
    func resultCell(item: UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?) -> some View {
        ZStack {
            Image("history_background")
                .frame(width: 340, height: 90, alignment: .center)
            HStack {
                Spacer()
                    .frame(width: 20)
                if let _ = item?.node?.owner?.profilePicUrl {
                    userIconImageView(item: item)
                        .mask(Circle().fill(Color.black).frame(width: 64, height: 64))
                        .frame(width: 64, height: 64, alignment: .center)
                } else {
                    Image("user_png")
                        .resizable()
                        .frame(width: 64, height: 64, alignment: .center)
//                    userIconImageView(item: item)
//                        .mask(Circle().fill(Color.black).frame(width: 64, height: 64))
//                        .frame(width: 64, height: 64, alignment: .center)
                }
                Spacer()
                    .frame(width: 20)
                Text("\(item?.node?.owner?.username ?? "?")")
                    .font(Font.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                Text("Prize:\(dataManager.currentSelectPrize)")
                    .font(Font.custom("Avenir-Heavy", size: 14))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                    .frame(width: 30)
                
            }.frame(width: 340, height: 100, alignment: .center)
            
        }
        .frame(width: 340, height: 100, alignment: .center)
        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
        
    }
    
    func userIconImageView(item: UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?) -> some View {
        var url = item?.node?.owner?.profilePicUrl
        
//        url = URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ftu.maomaogougou.cn%2Fpicture%2F2016%2F05%2F604fe235f063f67d9eea94add4765602.jpg&refer=http%3A%2F%2Ftu.maomaogougou.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1613878546&t=f00f5e5f6f4fa9201bcb956b445bdceb")
        
        return URLImage(url: url!,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
    }
    
}

extension GIGiveawayResultView {
    var substitutesContentView: some View {
        ScrollView(.vertical) {
            Color(.white)
            
            VStack(spacing: 0) {
//
                ForEach(0..<(userModelManager.substitutes?.count ?? 0)) { index in
                    resultCell(item: userModelManager.substitutes?[index])
//
                }.padding(5)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
   
    }
}


struct GIGiveawayResultView_Previews: PreviewProvider {
    static var previews: some View {
        GIGiveawayResultView()
            .environmentObject(CoinManager.default)
            .environmentObject(DataManager.default)
            .environmentObject(UserModelRequest.default)
        
    }
}


