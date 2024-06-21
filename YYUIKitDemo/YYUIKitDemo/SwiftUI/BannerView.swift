//
//  BannerView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/3/5.
//

import SwiftUI
import YYUIKit

//@available(iOS 14.0, *)
struct BannerView: View {
    
    // 这个属性要求 iOS 14
    // @StateObject var dataModel: DataModel
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        
        Text(dataModel.name)
            .onTapGesture {
                dataModel.name = "试试就试试"
                print(Date.is24HourFormat)
            }
        
        Text("本页面展示了 YYUIkit 中提供的滚动分页视图的使用, 下面按钮分别展示具体功能")
        HStack {
            Text("1. 自定义 page content")
            Spacer()
        }
        
        XYPagingScrollViewSwiftUI()
            .frame(width: .width - 100, height: 200)
        
        HStack {
            Text("2. 一个屏幕宽度的 banner")
            Spacer()
        }
        
        XYPagingScrollViewSwiftUI()
            .frame(width: .width, height: 200)
        
        HStack {
            Text("3. 一个 200x80的 banner")
            Spacer()
        }
        XYPagingScrollViewSwiftUI()
            .frame(width: 200, height: 80)
        
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
        page.currentPageCallBack = { idx in
            Toast.make("current \(idx)")
        }
        return page
    }
    
    func updateUIView(_ uiView: YYUIKit.XYPagingScrollView, context: Context) {
//        page.customPages = [UIImageView(named: "banner1"), UIImageView(named: "banner2")]
    }
    
    typealias UIViewType = XYPagingScrollView
    
}

