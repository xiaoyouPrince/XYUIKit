//
//  RandomDemoView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2025/6/25.
//

/*
 这是一个随机辅助写 Demo 页面, 比如开发过程中快速写个小原型
 这个随时写,随时删
 */

import SwiftUI
import YYUIKit

struct RandomDemoView: View {
    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    
                }
        }
    }
    

}

#Preview {
    RandomDemoView()
}

import SwiftUI

struct ContentView2: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    // 所有数据
    private let allItems = Array(0..<25)

    // 分割插入点（比如在第 10 个 cell 后插入整行 cell）
    private let insertIndex = 10

    // 控制是否展示整行 cell
    @State private var showFullWidthCell = true

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // 第一段 LazyVGrid（0 到 insertIndex - 1）
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(allItems.prefix(insertIndex), id: \.self) { item in
                        GridItemCell(number: item)
                    }
                }

                // 中间插入整行 cell
                if showFullWidthCell {
                    FullWidthCell {
                        withAnimation {
                            showFullWidthCell = false
                        }
                    }
                }

                // 第二段 LazyVGrid（insertIndex 到末尾）
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(allItems.suffix(from: insertIndex), id: \.self) { item in
                        GridItemCell(number: item)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - 普通 Cell
struct GridItemCell: View {
    let number: Int

    var body: some View {
        Text("\(number)")
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

// MARK: - 整行 Cell
struct FullWidthCell: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text("🔥 Tap to Remove Full Width Cell")
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(8)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    ContentView2()
}
