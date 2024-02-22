//
//  FileSystem.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/22.
//

import UIKit

public class FileSystem: NSObject {
    
    public static  let `default` = FileSystem()
    internal var rootNode: FileNode?
    private(set) var isPushOpened = false
    
    public func open(dir path: String = FileSystem.sandBoxPath()) {
        let window = UIApplication.shared.windows.first!
        if let root = window.rootViewController {
            let rootNode = FileNode(path: path)
            FileSystem.default.rootNode = rootNode
            let navi = createRootFileController(node: rootNode)
            root.present(navi, animated: true, completion: nil)
            isPushOpened = false
        }
    }
    
    public func pushOpen(navigationVC: UINavigationController , dirpath: String = FileSystem.sandBoxPath()) {
        let rootNode = FileNode(path: dirpath)
        FileSystem.default.rootNode = rootNode
        let vc = FileInfomationController()
        vc.fileNode = rootNode
        navigationVC.pushViewController(vc, animated: true)
        isPushOpened = true
    }
    
    public func openRecently(dir path: String = FileSystem.sandBoxPath()) {
        guard let rootNode = rootNode else {
            open(dir: path)
            return
        }
        
        let navi = createRootFileController(node: FileNode(path: rootNode.path))
        var node: FileNode? = rootNode
        var vcs: [UIViewController] = []
        while node != nil {
            let vc = FileInfomationController()
            vc.fileNode = FileNode(path: node!.path)
            vcs.append(vc)
            node = node?.next
        }
        navi.setViewControllers(vcs, animated: true)
        
        let window = UIApplication.shared.windows.first!
        if let root = window.rootViewController {
            root.present(navi, animated: true, completion: nil)
            isPushOpened = true
        }
    }
    
    private func createRootFileController(node: FileNode) -> UINavigationController {
        let vc = FileInfomationController()
        vc.fileNode = node
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        return navi
    }
}

extension FileSystem {
    public static func mainBundlePath() -> String {
        Bundle.main.bundlePath
    }
    
    public static func sandBoxPath() -> String {
        NSHomeDirectory()
    }
    
    public static func documentPath() -> String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    public static func libraryPath() -> String {
        NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
    }
    
    public static func cachePath() -> String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    public static func tempPath() -> String {
        NSTemporaryDirectory()
    }
}


extension FileSystem {
    func add(new node: FileNode) {
        var _node = FileSystem.default.rootNode
        while _node?.next != nil {
            _node = _node?.next
        }
        _node?.next = node
    }
    
    func removeLastNode() {
        var _node = FileSystem.default.rootNode
        while _node?.next?.next != nil {
            _node = _node?.next
        }
        if _node?.next != nil {
            _node?.next = nil
        }
    }
    
    func resetRootNode() {
        FileSystem.default.rootNode?.next = nil
    }
}


