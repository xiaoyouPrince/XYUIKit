//
//  TableViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2020/12/10.
//

import UIKit
import MJRefresh

class TableViewController: UITableViewController {
    
    var headerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.backgroundColor = UIColor.green
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.tableHeaderView = headerView
        headerView.backgroundColor = UIColor.red
        
        let header = RefreshHeader(refreshingBlock: {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tableView.mj_header?.endRefreshing()
//            }
        })
        self.tableView.mj_header = header
        
        let footer = MJRefreshBackGifFooter {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tableView.mj_footer?.endRefreshing()
            }
            print("---footer--")
            
            self.showErrorView(title: "ddd")
        }
        footer.setTitle("平时iiii", for: .idle)
        footer.setTitle("下拉----", for: .pulling)
        footer.setTitle("正在刷新", for: .refreshing)
        footer.setTitle("将要刷新", for: .willRefresh)
        footer.setTitle("no more data", for: .noMoreData)
        
        footer.stateLabel?.textColor = .red
        
        self.tableView.mj_footer = footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let height = arc4random()%200
        self.headerView.frame.size.height = CGFloat(height)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "indexPath = \(indexPath)"
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        headerView.frame.size.height = CGFloat(arc4random()%200)
//        tableView.reloadData()
//    }

}
