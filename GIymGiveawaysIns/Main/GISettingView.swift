//
//  GISettingView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/18.
//

import Foundation
import SwiftUI
import UIKit
import DynamicColor
import SwiftUIX
import MessageUI

var privateUrlString = "http://chubby-blood.surge.sh/Facial_Privacy_Policy.htm"
var termsUrlString = "http://chubby-blood.surge.sh/Terms_of_use.htm"
var feedbackString = "qrcodeslike@hotmail.com"
var AppName = "Avatar Monster"




struct GISettingView: View {
    @State private var showMailSheet = false
    
    
    var body: some View {
        ZStack {
            bgView
            contentView
        }
        .sheet(isPresented: self.$showMailSheet) {
            MailView(isShowing: self.$showMailSheet,
                     resultHandler: {
                        value in
                        switch value {
                        case .success(let result):
                            switch result {
                            case .cancelled:
                                print("cancelled")
                            case .failed:
                                print("failed")
                            case .saved:
                                print("saved")
                            default:
                                print("sent")
                            }
                        case .failure(let error):
                            print("error: \(error.localizedDescription)")
                        }
            },
                     subject: "Feedback",
                     toRecipients: [feedbackString],
                     
                     
                     messageBody: feedbackMessageBody(),
                     isHtml: false,
                     attachments: nil)
            .safe()
            /*
             [("Sample file content".data(using: .utf8)!,
                            "Text",
                            "sample.txt")]
             */
        }
    }
    
}

extension GISettingView {
    var bgView: some View {
        VStack {
            Image("setting_background")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width, height: (237.0/375.0) * UIScreen.main.bounds.size.width)
            Spacer()
        }
    }
    
    var contentView: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            settingView
            Spacer()
                .frame(height: 20)
            buttonView
            
            Spacer()
        }
    }
    
    var settingView: some View {
        ZStack {
            Color(.white)
                .cornerRadius(16)
                .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            Text("Setting")
                .font(Font.custom("Avenir-Heavy", size: 20))
                .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
        }.frame(width: 164, height: 42, alignment: .center)
    }
    
    var buttonView: some View {
        ZStack {
            Color(.white)
                .frame(width: 327, height: 190, alignment: .center)
                .cornerRadius(16)
                .shadow(color: Color(DynamicColor(hexString: "#451CC8").withAlphaComponent(0.15)), radius: 18, x: 0.0, y: 2)
            VStack {
                // feedback
                Button(action: {
                    
                }, label: {
                    HStack {
                        Spacer()
                            .frame(width: 24)
                        Text("Feedback")
                            .font(Font.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        Spacer()
                    }
                })
                .frame(width: 327, height: 60, alignment: .center)
                Spacer()
                    .frame(height: 0)
                Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.2)).frame(width: 327, height: 0.5, alignment: .center)
                Spacer()
                    .frame(height: 0)
                // privacy
                Button(action: {
                    if let url = URL.init(string: privateUrlString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }, label: {
                    HStack {
                        Spacer()
                            .frame(width: 24)
                        Text("Privacy Policy")
                            .font(Font.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        Spacer()
                    }
                })
                .frame(width: 327, height: 60, alignment: .center)
                Spacer()
                    .frame(height: 0)
                Color(DynamicColor(hexString: "#5937C6").withAlphaComponent(0.2)).frame(width: 327, height: 0.5, alignment: .center)
                Spacer()
                    .frame(height: 0)
                // term of
                Button(action: {
                    if let url = URL.init(string: termsUrlString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }, label: {
                    HStack {
                        Spacer()
                            .frame(width: 24)
                        Text("Term of use")
                            .font(Font.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
                        Spacer()
                    }
                })
                .frame(width: 327, height: 60, alignment: .center)
            }
        }
    }
}

extension GISettingView {
    func feedbackMessageBody() -> String {
        let systemVersion = UIDevice.current.systemVersion
        let infoDic = Bundle.main.infoDictionary
        // 获取App的版本号
        let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
        // 获取App的名称
        let appName = "\(AppName)"
        
        return "\n\n\nSystem Version：\(systemVersion)\n App Name：\(appName)\n App Version：\(appVersion ?? "1.0")"
    }
    
}
struct GISettingView_Previews: PreviewProvider {
    static var previews: some View {
        GISettingView()
//            .environmentObject(CoinManager.default)
    }
}
