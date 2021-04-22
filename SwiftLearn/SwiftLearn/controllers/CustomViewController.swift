//
//  CustomViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/22.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let tip = TipView(tip: "Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22")
        self.view.addSubview(tip)
//        tip.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 40)
        
        tip.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }

}
