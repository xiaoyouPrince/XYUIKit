//
//  FileNode.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/22.
//

import UIKit

private let imageExt = ["jpg", "jpeg", "png", "webp"]
private let videoExt = ["mov", "avi", "mpg", "vob", "mkv", "rm", "rmvb", "mp4", "m4v"]
private let audioExt = ["pcm","wav", "aac", "mp3", "ogg"]

public class FileNode: NSObject {
    
    var next: FileNode?
    public private(set) var path: String!
    public private(set) var name: String!
    public private(set) var isDir: Bool!
    public private(set) var type: FileType!
    public private(set) var size: UInt64!
    private var attribute: [FileAttributeKey: Any]!
    public private(set) var nodes: [FileNode] = []
    
    convenience public init(path: String) {
        self.init(path: path, node: .file, action: .none)
    }
    
    convenience public init(actionNode path: String, action: ActionType) {
        self.init(path: path, node: .action, action: action)
    }
    
    private init(path: String, node: NodeType, action: ActionType) {
        self.path = path
        
        if node == .action {
            if action == .root {
                self.name = "/"
            } else if action == .top {
                self.name = ".."
            } else {
                self.name = ""
            }
            self.isDir = true
            self.type = .dir
            self.size = 0
            self.attribute = [:]
            super.init()
            return
        }
        
        let URL = URL(string: path)
        let extname = URL?.pathExtension.lowercased() ?? ""
        
        let fileManager = FileManager.default
        self.name = fileManager.displayName(atPath: path)
        
        if let attribute = try? fileManager.attributesOfItem(atPath: path) {
            self.attribute = attribute
            if let type = attribute[FileAttributeKey.type] as? FileAttributeType {
                if type == FileAttributeType.typeDirectory {
                    self.isDir = true
                    self.type = .dir
                } else {
                    self.isDir = false
                    if imageExt.contains(extname) {
                        self.type = .image
                    } else if videoExt.contains(extname) {
                        self.type = .video
                    } else if audioExt.contains(extname) {
                        self.type = .audio
                    } else {
                        self.type = .file
                    }
                }
            } else {
                self.isDir = false
                self.type = .unknown
            }
            if let size = attribute[FileAttributeKey.size] as? UInt64 {
                self.size = size
            } else {
                self.size = 0
            }
        } else {
            self.attribute = [:]
            self.size = 0
            self.isDir = false
            self.type = .unknown
        }
        super.init()
        
        self.nodes = refreshNodes()
    }
}

extension FileNode {
    public enum FileType {
        case unknown
        case dir
        case image
        case video
        case audio
        case file
    }
    
    public enum NodeType {
        case file
        case action
    }
    
    public enum ActionType {
        case none
        case root
        case top
    }
}



extension FileNode {
    
    func subItemsAndTotalSize() -> String {
        if isDir {
            return "\(nodes.count) items, " + fileSize()
        } else {
            return fileSize() + imagePixelSize()
        }
    }
    
    func imagePixelSize() -> String {
        if type == .image {
            if let path = path,
               let data = FileManager.default.contents(atPath: path),
               let image = UIImage(data: data) {
                let sizeInPoints = image.size
                let scale = image.scale
                let widthInPixels: Int = Int(sizeInPoints.width * scale)
                let heightInPixels: Int = Int(sizeInPoints.height * scale)
                return ", \(widthInPixels)x\(heightInPixels)"
            }
        }
        return ""
    }
    
    func fileSize() -> String {
        var size = self.size!
        if size < 1024 {
            return "\(size)B"
        }
        size /= 1024
        if size < 1024 {
            return "\(size)KB"
        }
        size /= 1024
        if size < 1024 {
            return "\(size)M"
        } else {
            return "\(size/1024)G"
        }
    }
    
    func refreshNodes() -> [FileNode] {
        if path.count == 0 {
            return []
        }
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
            var nodes: [FileNode] = []
            for content in contents {
                let fullPath = "\(path!)/\(content)"
                let node = FileNode(path: fullPath)
                nodes.append(node)
            }
            return nodes
        } else {
            return []
        }
    }
    
    func getShowIcon() -> UIImage? {
        switch self.type {
        case .dir:
            return UIImage.create(named: "icon_dir")
        case .image:
            if let path = path,
               let data = FileManager.default.contents(atPath: path),
               let image = UIImage(data: data) {
               return image
            }
            return UIImage.create(named: "icon_image")
        case .video:
            return UIImage.create(named: "icon_video")
        case .audio:
            return UIImage.create(named: "icon_audio")
        default:
            return UIImage.create(named: "icon_file")
        }
    }
    
    func isWritable() -> Bool {
        FileManager.default.isWritableFile(atPath: self.path)
    }
    
    func isReadable() -> Bool {
        FileManager.default.isReadableFile(atPath: self.path)
    }
    
    func isExecutable() -> Bool {
        FileManager.default.isExecutableFile(atPath: self.path)
    }
    
    func isDeletable() -> Bool {
        FileManager.default.isDeletableFile(atPath: self.path)
    }
    
    func createDate() -> Date? {
        attribute[FileAttributeKey.creationDate] as? Date
    }
}

extension String {
    // ~/Desktop/ijinfeng/Box
    // return ~/Desktop/ijinfeng
    func topFilePath() -> String {
        if let URL = URL(string: self) {
            return URL.deletingLastPathComponent().absoluteString
        } else {
            return self
        }
    }
}

extension UIImage {
    static func create(named: String) -> UIImage? {
        let anyClass = FileSystem.self
        let boxBundle = Bundle.init(for: anyClass)
        let targetBundle = Bundle.init(path: boxBundle.path(forResource: "XYUIKit", ofType: "bundle") ?? "")
        var image: UIImage? = targetBundle == nil ? nil : UIImage.init(named: named, in: targetBundle!, compatibleWith: nil)
        if image == nil {
            image = UIImage(named: named)
        }
        if image == nil {// 兼容 SPM 读取图片
            image = ResourceLoader.image(named: named)
        }
        
        return image?.scaleToSize(.init(width: 20, height: 20))
    }
}

import UIKit

public class ResourceLoader {
    // 获取图片资源
    public static func image(named name: String) -> UIImage? {
        let bundle = Bundle.module
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
