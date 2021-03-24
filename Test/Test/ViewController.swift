//
//  ViewController.swift
//  Test
//
//  Created by 渠晓友 on 2021/3/17.
//

import UIKit

class ViewController: UITableViewController {
    
    let tableHeaderView: UIView = {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        header.backgroundColor = UIColor.lightGray
        
        let title = UILabel()
        title.text = "rpo 入口，点击进入"
        title.sizeToFit()
        header.addSubview(title)
        title.center = header.center
        
        header.isUserInteractionEnabled = true
        return header
    }()
    
    @objc func headerTap(){
        print("---")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTap))
//        tableHeaderView.addGestureRecognizer(tap)
        
        print("页面加载完成 -- ")
        
        var set: Set<String> = Set()
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Model/ZLMessageDetailCandidateModel.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/Config/ZLCellLayoutConfig.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+Notification.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+Notification.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Api/ZLNewMessageDetailApi.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Controller/ZLMessageDetailController+TopEvent.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageList/Api/ZLNewMessageListApi.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Model/ZLMessageDetailCandidateModel.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageList/Controller/ZLNewMessageListViewController.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/Config/ZLCellLayoutConfig.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/ZPSessionController+topEvent.m")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLNIMComponent/ZLNIMComponent/Classes/MessageDetail/Api/ZLNewMessageDetailApi.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/View/ZLMessagePhoneCard.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/ZPSessionController.m")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/Api/IMSessionDetailAPIManager.swift")
        set.insert("/Users/quxiaoyou/Documents/Zhaopin/ios-b-app-xg-newFeature/Component/BusinessComponent/ZLIMComponent/ZLIMComponent/Classes/MessageDetail/ZPSessionController+topEvent.m")
//        set.insert("Podfile")
        print(set)
        
        for str in set {
            let url = URL(string:str)!
            print(url.lastPathComponent)
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "title: \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tableHeaderView != nil {
            tableView.tableHeaderView = nil
        }else
        {
            tableView.tableHeaderView = tableHeaderView
        }
    }

}



// 软电话修改的代码文件
/*
 1  ZLNewMessageDetailApi.swift
 1  ZLMessageDetailController+TopEvent.swift
 1  ZPSessionController+topEvent.m
 1  ZLMessagePhoneCard.swift
 1  ZLMessageDetailController+Notification.swift
 1  ZLMessageDetailCandidateModel.swift
 1  ZLCellLayoutConfig.swift
 1  ZPSessionController.m
 1  ZLNewMessageListApi.swift
 1  IMSessionDetailAPIManager.swift
 
 1  Podfile
 */

