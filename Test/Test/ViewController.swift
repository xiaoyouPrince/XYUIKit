//
//  ViewController.swift
//  Test
//
//  Created by 渠晓友 on 2021/3/17.
//

import UIKit

class ViewController: UITableViewController {
    
    var dataArray =  [1,2,3,4]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = true
        
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "title: \(indexPath.row)"
        
        cell.showsReorderControl = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row % 2 == 0 {
            tableView.setEditing(true, animated: true)
//        }else{
//            tableView.setEditing(false, animated: true)
//        }
        
//        tableView.moveRow(at: indexPath, to: IndexPath(row: indexPath.row + 1, section: 0))
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("手动移动cell")
        
        
        print("\(sourceIndexPath)" + "移动到" + "\(destinationIndexPath)")
        print("需要同步操作数据源")
        
        // 拿到当前数据源进行排序
        var currentDataArray = self.dataArray
        currentDataArray.remove(at: sourceIndexPath.row)
        currentDataArray.insert(self.dataArray[sourceIndexPath.row], at: destinationIndexPath.row)
        
        
        
        print(self.dataArray)
        print(currentDataArray)
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
    }

}

