//
//  BannerView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/3/5.
//

import SwiftUI
import YYUIKit

struct BannerView: View {
    
    var body: some View {
        List {
            Text("本页面展示了 YYUIkit 中提供的滚动分页视图的使用, 下面按钮分别展示具体功能")
            
            Section {
                
                XYPagingScrollViewSwiftUI()
                    .frame(height: 200)
                
            } header: {
                Text("1. 自定义 page content")
            }
        }
    }
}

#Preview {
    BannerView()
}

struct XYPagingScrollViewSwiftUI: View, UIViewRepresentable {
    func makeUIView(context: Context) -> YYUIKit.XYPagingScrollView {
        let page = XYPagingScrollView()
        page.customPages = [UIImageView(named: "banner1"), UIImageView(named: "banner2")]
        return page
    }
    
    func updateUIView(_ uiView: YYUIKit.XYPagingScrollView, context: Context) {
//        page.customPages = [UIImageView(named: "banner1"), UIImageView(named: "banner2")]
    }
    
    typealias UIViewType = XYPagingScrollView
    
}

