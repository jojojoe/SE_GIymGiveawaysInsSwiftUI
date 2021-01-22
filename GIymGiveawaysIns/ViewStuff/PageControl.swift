//
//  PageControl.swift
//  FCymFunnyCreatorSU
//
//  Created by JOJO on 2021/1/7.
//

import Foundation
import SwiftUI
import UIKit

struct PageControl : UIViewRepresentable{
    
    var current = 0
    var numberOfPages = 1
    var currentPageIndicatorTintColor = UIColor.black
    var pageIndicatorTintColor = UIColor.gray
    
    func makeUIView(context: UIViewRepresentableContext<PageControl>) -> UIPageControl {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        page.numberOfPages = numberOfPages
        page.pageIndicatorTintColor = pageIndicatorTintColor
        return page
    }
    func updateUIView(_ uiView: UIPageControl, context: UIViewRepresentableContext<PageControl>) {
        uiView.currentPage = current
        
    }
    
    
    
}
