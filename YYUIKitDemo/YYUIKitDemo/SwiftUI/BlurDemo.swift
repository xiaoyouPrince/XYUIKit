//
//  BlurDemo.swift
//  YYUIKitDemo
//
//  Created by will on 2025/4/1.
//

import SwiftUI
import YYUIKit

struct BlurDemo: View {
    var body: some View {
        
        ZStack {
            Image(uiImage: .bgImage2)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .blur(radius: 20)
                .frame(height: 200)
            
            BlurDemoView()
        }
        .frame(height: 200)
        .clipped()
    }
}

#Preview {
    BlurDemo()
}

struct BlurDemoView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let rlt = UIView()
        rlt.setGradient(withType: .top2bottom, size: .init(width: .width, height: 200), gradientColors: [UIColor.white, UIColor.white.withAlphaComponent(0.8), UIColor.white])
        
        return rlt
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
