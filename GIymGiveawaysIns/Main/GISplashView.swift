//
//  GISplashView.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/22.
//

import Foundation
import SwiftUI
import DynamicColor
import SwiftUIX

struct SplashItem: Identifiable {
    var id: Int
    var imgName: String
    var title: String
    var content: String
    
}

struct FCSplashView: View {
    
    @EnvironmentObject var splashManager: FCSplashViewManager
    
    @State private var tabSelectIndex: Int = 0
    @State var isShow1: Bool = true
    @State var isShow2: Bool = false
    @State var isShow3: Bool = false
    
    var pageNumber = 3
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(DynamicColor(hexString: "#8056FC")), Color(DynamicColor(hexString: "#AC8DFF"))]),
                                         startPoint: .top,
                                         endPoint: .bottom)
            VStack {
                topContentView
//                Spacer()
//                    .frame(height: 38)
                pageControlView
                bottomBtn
                Spacer()
                    .frame(height: 40)
            }
        }

    }

    
    
    
}

extension FCSplashView {
    var bottomBtnTitle: String {
        if tabSelectIndex == pageNumber - 1 {
            return "Let's Go!"
        } else {
            return "Next"
        }
    }
}

extension FCSplashView {
    
    
    var topContentView: some View {
        VStack {
            
            
            ZStack {
                if tabSelectIndex == 0 {
                    contentSplashView(imgName: splashList[0].imgName, title: splashList[0].title, content: splashList[0].content).tag(splashList[0].id)
                        //                        .offset(x: 0, y: 20)
                        .scaleEffect(self.isShow1 ? 1:0.2)
                        .transition(.opacity)
                        .animation(.easeInOut)
                        .onAppear {
                            withAnimation{
                                self.isShow1 = true
                            }
                        }
                }
                
                if tabSelectIndex == 1 {
                    contentSplashView(imgName: splashList[1].imgName, title: splashList[1].title, content: splashList[1].content).tag(splashList[1].id)
                        //                        .offset(x: 0, y: 20)
                        .scaleEffect(self.isShow2 ? 1:0.2)
                        .transition(.opacity)
                        .animation(.easeInOut)
                        .onAppear {
                            withAnimation{
                                self.isShow2 = true
                            }
                        }
                }
                
                if tabSelectIndex == 2 {
                    contentSplashView(imgName: splashList[2].imgName, title: splashList[2].title, content: splashList[2].content).tag(splashList[2].id)
                        //                        .offset(x: 0, y: 20)
                        .scaleEffect(self.isShow3 ? 1:0.2)
                        .transition(.opacity)
                        .animation(.easeInOut)
                        .onAppear {
                            withAnimation{
                                self.isShow3 = true
                            }
                        }
                }
                
                
            }
            
            
//            if #available(iOS 14.0, *) {
//                TabView(selection: $tabSelectIndex,
//                        content:  {
//
//                            contentSplashView(imgName: splashList[0].imgName, title: splashList[0].title, content: splashList[0].content).tag(splashList[0].id)
//                                //                        .offset(x: 0, y: 20)
//                                .scaleEffect(self.isShow1 ? 1:0.2)
//                                .transition(.opacity)
//                                .animation(.easeInOut)
//                                .onAppear {
//                                    withAnimation{
//                                        self.isShow1 = true
//                                    }
//                                }
//
//                            contentSplashView(imgName: splashList[1].imgName, title: splashList[1].title, content: splashList[1].content).tag(splashList[1].id)
//                                //                        .offset(x: 0, y: 20)
//                                .scaleEffect(self.isShow2 ? 1:0.2)
//                                .transition(.opacity)
//                                .animation(.easeInOut)
//                                .onAppear {
//                                    withAnimation{
//                                        self.isShow2 = true
//                                    }
//                                }
//
//                            contentSplashView(imgName: splashList[2].imgName, title: splashList[2].title, content: splashList[2].content).tag(splashList[2].id)
//                                //                        .offset(x: 0, y: 20)
//                                .scaleEffect(self.isShow3 ? 1:0.2)
//                                .transition(.opacity)
//                                .animation(.easeInOut)
//                                .onAppear {
//                                    withAnimation{
//                                        self.isShow3 = true
//                                    }
//                                }
//
//                        })
//                    .animation(.easeInOut)
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                    .onChange(of: tabSelectIndex) { (tabSelectIndex) in
//                        if tabSelectIndex == 0 {
//                            withAnimation{
//                                self.isShow1 = true
//                                self.isShow2 = false
//                                self.isShow3 = false
//                            }
//                        } else if tabSelectIndex == 1 {
//                            withAnimation{
//                                self.isShow2 = true
//                                self.isShow1 = false
//                                self.isShow3 = false
//                            }
//                        } else if tabSelectIndex == 2 {
//                            withAnimation{
//                                self.isShow3 = true
//                                self.isShow2 = false
//                                self.isShow1 = false
//                            }
//                        }
//                    }
//            } else {
//
//
//
//            }
            
            
        }
        
        
        
    }
    
    var pageControlView: some View {
        
        PageControl(current: tabSelectIndex, numberOfPages: pageNumber, currentPageIndicatorTintColor:DynamicColor(hexString: "#FFFFFF"), pageIndicatorTintColor: UIColor.init(hexString: "#FFFFFF").withAlphaComponent(0.3))
            .frame(height: 50)
            
    }
    
    var bottomBtn: some View {
        Button(action: {
            bottomBtnClick()
        }, label: {
            ZStack {
                Color(.white)
                    .frame(width: 242, height: 42, alignment: .center)
                    .cornerRadius(10)
                Text(bottomBtnTitle)
                    .font(Font.custom("Avenir-Heavy", size: 18))
                    .foregroundColor(Color(DynamicColor(hexString: "#5937C6")))
            }
            
        })
    }
    
}






extension FCSplashView {
    
    var splashList: [SplashItem] {
        let item1 = SplashItem.init(id: 0, imgName: "guide_pages_background_01", title: "", content: "Let's customize the prize for the lottery!")
        let item2 = SplashItem.init(id: 1, imgName: "guide_pages_background_02", title: "", content: "Number of gift picker winners!")
        let item3 = SplashItem.init(id: 2, imgName: "guide_pages_background_03", title: "", content: "Randomizing the luckiest one!")
        return [item1, item2, item3]
        
    }
     
    func contentSplashView(imgName: String, title: String, content: String) -> some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                    
                Image(imgName)
                    
                    .resizable()
                    .frame(width: abs(geo.size.width - (40 * 2)),
                           height: abs(geo.size.width - (40 * 2)) * (618.0 / 586.0),
                           alignment: .center)
                Spacer()
                    .frame(height: 55)
                Text(title)
                    .font(Font.custom("Avenir-Black", size: 24))
                    .foregroundColor(.white)
                Spacer()
                    .frame(height: 15)
                Text( content)
                    .font(Font.custom("Avenir-Black", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(DynamicColor(hexString: "#FFFFFF")))
                    .padding(EdgeInsets(top: 10, leading: 40, bottom: 20, trailing: 40))
                    
                Spacer()

            }.width(geo.size.width)
        }
        
    }

}

extension FCSplashView {
    func bottomBtnClick() {
        if tabSelectIndex == (pageNumber - 1) {
            splashManager.loadHasSplash()
        } else {
            tabSelectIndex += 1
        }
        
    }
    
    
}

struct FCSplashView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FCSplashView()
//                .environmentObject(FCSplashViewManager.default)
        }
    }
}
 
