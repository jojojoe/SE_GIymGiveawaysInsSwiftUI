//
//  GIHistoryView.swift
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


struct GIHistoryView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var historyManager: HistoryManager
    
    var body: some View {
        
        ZStack {
            
            contentView
        }
        
    }
    
}

extension GIHistoryView {
     
    
    var contentView: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        mode.dismiss()
                    }, label: {
                        Image("history_back")
                            .frame(width: 64, height: 44, alignment: .center)
                    }).frame(width: 64, height: 44, alignment: .center)
                    Spacer()
                    
                }.frame(height: 44)
                Text("History")
                    .font(Font.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                
            }
            if historyManager.historyList.count == 0 {
                Spacer()
                Text("No lottery data available")
                    .font(Font.custom("Avenir-Heavy", size: 14))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                    .frame(height: 80)
                Spacer()
            } else {
                ScrollView(.vertical) {
                    Color(.white)
                    
                    VStack(spacing: 0) {
                        //
                        
                        ForEach(0..<(historyManager.historyList.count)) { index in
                            historyCell(item: historyManager.historyList[index])
                        }.padding(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
            }
            
            
            
            
        }
    }
    
    func historyCell(item: HistoryItem?) -> some View {
        ZStack {
            Image("history_background")
                .frame(width: 340, height: 82, alignment: .center)
            HStack {
                Spacer()
                    .frame(width: 20)
                if let urlStr = item?.postUrl, let url = URL(string: urlStr) {
                    userIconImageView(url: url)
                        .mask(Color(.black).cornerRadius(8).frame(width: 66, height: 66))
                        .frame(width: 66, height: 66, alignment: .center)
                } else {
                    Image("post_png")
                        .resizable()
                        .frame(width: 64, height: 64, alignment: .center)
                    
                }
                Spacer()
                    .frame(width: 10)
                VStack {
                    Spacer()
                    HStack {
                        Text("Winners")
                            .font(Font.custom("Avenir-Heavy", size: 12))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        Text("\(item?.winners.count ?? 0)")
                            .font(Font.custom("Avenir-Heavy", size: 12))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 4)
                    HStack {
                        Text("Substitutees")
                            .font(Font.custom("Avenir-Heavy", size: 12))
                            .foregroundColor(Color(DynamicColor(hexString: "#AEA2D5")))
                        Text("\(item?.substitutes.count ?? 0)")
                            .font(Font.custom("Avenir-Heavy", size: 12))
                            .foregroundColor(Color(DynamicColor(hexString: "#AEA2D5")))
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
                    
                
                Text("Prize:\(item?.prize ?? "")")
                    .font(Font.custom("Avenir-Heavy", size: 14))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                Spacer()
                    .frame(width: 30)
                
            }.frame(width: 340, height: 100, alignment: .center)
            
        }
        .frame(width: 340, height: 110, alignment: .center)
        .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 4, x: 0.0, y: 0.0)
        
    }
    
    func userIconImageView(url: URL) -> some View {
//        var url = URL(string: urlStr)
        
//        url = URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ftu.maomaogougou.cn%2Fpicture%2F2016%2F05%2F604fe235f063f67d9eea94add4765602.jpg&refer=http%3A%2F%2Ftu.maomaogougou.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1613878546&t=f00f5e5f6f4fa9201bcb956b445bdceb")
        
        return URLImage(url: url,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
    }
    
}




struct GIHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        GIHistoryView()
            .environmentObject(HistoryManager.default)
            
    }
}




