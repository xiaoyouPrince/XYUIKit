//
//  ListViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/12/3.
//

import UIKit
import MJRefresh

enum DemoType {
    case demo(name: String)
}

class ListViewController: XYRefreshTableViewController {
    
    var dataArray = [
        "启动头部刷新",
        "尾部刷新",
        "展示空页面 - 图",
        "展示空页面 - 图 + 描述",
        "展示空页面 - 图 + 描述 + 重试按钮",
        "自定义 header 并启动刷新",
        "自定义 footer 并启动刷新",
        "自定义空页面 (error页面)"
    ]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            startHeaderRefresh()
        case 1:
            startFooterRefresh()
        case 2:
            showEmpty(UIImage(named: "icon_no_data")!)
        case 3:
            showEmpty(UIImage(named: "icon_no_data")!, "我是默认的那个提示你没有新消息的那个文案~")
        case 4:
            showEmpty(UIImage(named: "icon_no_data")!, "我是默认的那个提示你没有新消息的那个文案~"){
                UILabel.xy_showTip("点击了重试")
                self.startHeaderRefresh()
                self.hideEmpty()
            }
        case 5:
            setRefreshHeader(RefreshHeader(refreshingBlock: {
                UILabel.xy_showTip("启动了下拉刷新")
                self.headerRefreshHandler()
            }))
            startHeaderRefresh()
        case 6:
            
            let footer = MJRefreshBackGifFooter {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.tableView.mj_footer?.endRefreshing()
                }
                UILabel.xy_showTip("启动了上拉刷新")
            }
            footer.setTitle("平时iiii", for: .idle)
            footer.setTitle("下拉----", for: .pulling)
            footer.setTitle("正在刷新", for: .refreshing)
            footer.setTitle("将要刷新", for: .willRefresh)
            footer.setTitle("no more data", for: .noMoreData)
            footer.stateLabel?.textColor = .red
            setRefreshFooter(footer)
            
            startFooterRefresh()
        case 7:
            
            let btn = UIButton()
            btn.setTitle("按钮自定义为空页面", for: .normal)
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            emptyView = btn
            
            showEmpty(UIImage())
        default:
            break
        }
    }
    
    @objc func btnClick() {
        hideEmpty()
    }
}
