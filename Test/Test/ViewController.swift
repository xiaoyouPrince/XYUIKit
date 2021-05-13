//
//  ViewController.swift
//  Test
//
//  Created by 渠晓友 on 2021/3/17.
//

import UIKit

enum EEE {
    case a
}

class ViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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

}

