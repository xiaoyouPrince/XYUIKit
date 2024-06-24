//
//  KeyboardMonitor&InPutBar.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/13.
//

import SwiftUI
import YYUIKit

struct KeyboardMonitor_InPutBar: View {
    
    @State private var text: String = ""
    var kbInputView: KBTopInputView = KBTopInputView()

    var body: some View {
        VStack {
            Spacer()
            
            Text(text)
                .border(.black)
            Text("点我输入内容")
                .onTapGesture {
                    kbInputView.show()
                    _ = kbInputView.becomeFirstResponder()
                    kbInputView.textChangeCallback = {
                        text = $0
                    }
                }
        }
    }
}

#Preview {
    KeyboardMonitor_InPutBar()
}
