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
    
    
    @State var degress: Double = 720
    
    
    var body: some View {
        ZStack {
            Image(uiImage: ._22)
                .resizable()
                .mask(
                    Image(uiImage: .iconNoData)
                        .resizable()
                        .scaledToFit()
                )
                .frame(width:300, height: 300)
            
            Image(uiImage: ._23)
                .resizable()
                .mask(
                    Image(uiImage: .icSheet0)
                        .resizable()
                        .scaledToFit()
                )
                .frame(width:200, height: 200)
                
        }
        .rotation3DEffect(
            .degrees(degress),
            axis: (x: 0.0, y: 0.0, z: 1.0),
            perspective: 0.5
        )
        .animation(Animation.smooth(duration: 2), value: degress)
        .onTapGesture {
            degress += 720
        }
    }
    

}

#Preview {
    RandomDemoView()
}
