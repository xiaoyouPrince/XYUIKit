//
//  BannerView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/3/5.
//

import SwiftUI
import YYUIKit

@available(iOS 14.0, *)
struct BannerView: View {
    
//    @StateObject var dataModel: DataModel
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        
        Text(dataModel.name)
            .onTapGesture {
                dataModel.name = "试试就试试"
            }
        
        List {
            Text("本页面展示了 YYUIkit 中提供的滚动分页视图的使用, 下面按钮分别展示具体功能")
            
            Section {
                XYPagingScrollViewSwiftUI()
                    .frame(width: .width - 100, height: 200)
                
            } header: {
                Text("1. 自定义 page content")
            }
        }
        
        XYPagingScrollViewSwiftUI()
            .frame(width: .width, height: 200)
        
        Spacer()
    }
}

//#Preview {
//    BannerView()
//}

struct XYPagingScrollViewSwiftUI: View, UIViewRepresentable {
    func makeUIView(context: Context) -> YYUIKit.XYPagingScrollView {
        let page = XYPagingScrollView()
        page.customPages = [UIImageView(named: "banner1"), UIImageView(named: "banner2"), UIImageView(named: "banner2")]
        return page
    }
    
    func updateUIView(_ uiView: YYUIKit.XYPagingScrollView, context: Context) {
//        page.customPages = [UIImageView(named: "banner1"), UIImageView(named: "banner2")]
    }
    
    typealias UIViewType = XYPagingScrollView
    
}

