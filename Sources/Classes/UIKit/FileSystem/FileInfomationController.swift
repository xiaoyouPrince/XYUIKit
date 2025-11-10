//
//  FileInfomationController.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/21.
//

import UIKit
import AVKit
import QuickLook

class FileInfomationController: UITableViewController {
    
    var fileNode: FileNode?
    var fileNodes: [FileNode] = []
    
    private var rootFileNode: FileNode!
    private var topFileNode: FileNode!
    
    private var clickFileNode: FileNode?
    
    private var numLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fileNode == nil {
            fileNode = FileNode(path: FileSystem.sandBoxPath())
        }
        
        if let node = fileNode {
            rootFileNode = FileNode(actionNode: node.path, action: .root)
            topFileNode = FileNode(actionNode: node.path.topFilePath(), action: .top)
        }
        
        self.fileNodes = fileNode?.refreshNodes() ?? []
        navigationItem.title = fileNode?.name ?? ""
        if FileSystem.default.isPushOpened {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.create(named: "icon_back")?.xy_rotate(orientation: .leftMirrored ).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBack))
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.create(named: "icon_close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickBack))
        }
        let refreshItem = UIBarButtonItem.init(image: UIImage.create(named: "icon_refresh")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickRefresh))
        let deleteItem = UIBarButtonItem.init(image: UIImage.create(named: "icon_delete")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onClickDelete))
        navigationItem.rightBarButtonItems = [refreshItem, deleteItem]
        
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.register(FileActionCell.self, forCellReuseIdentifier: "action")
        tableView.register(FileInfomationCell.self, forCellReuseIdentifier: "display")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        return self.fileNodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "action", for: indexPath) as! FileActionCell
            if indexPath.row == 0 {
                cell.fileNode = rootFileNode
            } else {
                cell.fileNode = topFileNode
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "display", for: indexPath) as! FileInfomationCell
            let fileNode = self.fileNodes[indexPath.row]
            cell.fileNode = fileNode
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                navigationController?.popToRootViewController(animated: true)
                FileSystem.default.resetRootNode()
            } else {
                navigationController?.popViewController(animated: true)
                FileSystem.default.removeLastNode()
            }
        } else {
            let fileNode = self.fileNodes[indexPath.row]
            clickFileNode = fileNode
            if fileNode.isDir {
                
                FileSystem.default.add(new: fileNode)
                
                let vc = FileInfomationController()
                vc.fileNode = fileNode
                navigationController?.pushViewController(vc, animated: true)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
                
                switch fileNode.type {
                case .audio, .video:
                    let vc = AVPlayerViewController()
                    vc.player = AVPlayer.init(url: URL(fileURLWithPath: fileNode.path))
                    navigationController?.pushViewController(vc, animated: true)
                    return
                default:
                    if isTextEditable(fileNode.path) {
                        // 给用户一个选择：仅查看 (使用 QLPreviewController) 或 进入可编辑页
                        let ac = UIAlertController(title: "打开方式", message: "请选择查看或编辑方式", preferredStyle: .actionSheet)
                        ac.addAction(UIAlertAction(title: "只查看", style: .default, handler: { _ in
                            // 使用系统预览控制器做只读查看
                            let preview = QLPreviewController()
                            // clickFileNode 已在外层设置为当前 fileNode
                            preview.dataSource = self
                            self.navigationController?.pushViewController(preview, animated: true)
                        }))
                        ac.addAction(UIAlertAction(title: "查看并可编辑", style: .default, handler: { _ in
                            let editor = TextEditViewController(filePath: fileNode.path, fileName: fileNode.name)
                            self.navigationController?.pushViewController(editor, animated: true)
                        }))
                        ac.addAction(UIAlertAction(title: "取消", style: .cancel))
                        // iPad 安全展示
                        if let pop = ac.popoverPresentationController, let cell = tableView.cellForRow(at: indexPath) {
                            pop.sourceView = cell
                            pop.sourceRect = cell.bounds
                        }
                        present(ac, animated: true)
                        return
                    }
                    else {
                        let vc = QLPreviewController()
                        vc.dataSource = self
                        navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                }
                
            }
        }
    }
    
    private func isTextEditable(_ path: String) -> Bool {
        let allowed: Set<String> = [
            "txt","md","markdown","json","xml","plist","swift","m","mm","h",
            "strings","log","csv","html","htm","css","js","ts","sh","yaml","yml",
            "conf","ini","env"
        ]
        let ext = (path as NSString).pathExtension.lowercased()
        return allowed.contains(ext)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return "$PWD: \(fileNode!.path!)".heightOf(font: .systemFont(ofSize: 14), size: .init(width: .width - 20, height: 1000), lineSpacing: 4) + 14 + 20
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            if header == nil {
                header = UITableViewHeaderFooterView.init(reuseIdentifier: "header")
                header?.contentView.backgroundColor = .clear
                
                let numLabel = UILabel()
                self.numLabel = numLabel
                numLabel.font = UIFont.systemFont(ofSize: 14)
                numLabel.textColor = .black
                numLabel.numberOfLines = 0
                header?.contentView.addSubview(numLabel)
                numLabel.snp.makeConstraints { make in
                    make.center.equalTo(header!.contentView)
                    make.left.top.equalToSuperview().offset(10)
                }
            }
            var fileCount = 0
            var dirCount = 0
            for fileNode in fileNodes {
                if fileNode.isDir {
                    dirCount += 1
                } else {
                    fileCount += 1
                }
            }
            numLabel?.text = "$PWD: \(fileNode!.path!)" + "\n" + "files \(fileCount) | directorys \(dirCount)"
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let fileNode = fileNodes[indexPath.row]
        if fileNode.isDeletable() {
            return "删除"
        }
        return "无权限删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileNode = fileNodes[indexPath.row]
        guard fileNode.isDeletable() else { return }
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: fileNode.path))
            fileNodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        } catch {}
    }
}

extension FileInfomationController {
    @objc func onClickBack() {
        if FileSystem.default.isPushOpened {
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onClickRefresh() {
        guard let node = fileNode else {
            return
        }
        self.fileNodes = node.refreshNodes()
        self.tableView.reloadData()
    }
    
    @objc func onClickDelete() {
        if fileNodes.count == 0 {
            return
        }
        
        let alert = UIAlertController(title: "清空操作", message: "即将删除当前目录下的所有文件和文件夹", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) {_ in }
        let sure = UIAlertAction(title: "删除", style: .destructive) { _ in
            let fileManager = FileManager.default
            for fileNode in self.fileNodes {
                try? fileManager.removeItem(at: URL(fileURLWithPath: fileNode.path))
            }
            self.fileNodes = self.fileNode?.refreshNodes() ?? []
            self.tableView.reloadData()
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)
    }
}


extension FileInfomationController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        NSURL(fileURLWithPath: clickFileNode!.path)
    }
}

// MARK: - Lightweight text editor for text-like files
final class TextEditViewController: UIViewController {

    // MARK: - Inputs
    private var filePath: String
    private let fileName: String

    // MARK: - UI
    private let textView = UITextView()

    // MARK: - State
    private enum Mode { case viewing, editing }
    private var mode: Mode = .viewing { didSet { applyMode() } }
    private var originalText: String = ""   // 进入编辑前的文本，用于取消恢复

    // MARK: - Init
    init(filePath: String, fileName: String) {
        self.filePath = filePath
        self.fileName = fileName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .groupTableViewBackground
        }
        navigationItem.title = fileName

        // 初始右上角：编辑
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(editTapped))

        // 文本视图
        textView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            textView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        } else {
            // Fallback on earlier versions
            textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .interactive
        textView.isEditable = false // 默认只读
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadContent()
        // 初次应用模式（只读）
        applyMode()
    }

    // MARK: - Loading
    private func loadContent() {
        // UTF-8 优先，失败再自动识别
        if let utf8 = try? String(contentsOfFile: filePath, encoding: .utf8) {
            textView.text = utf8
        } else {
            var detected: String.Encoding = .utf8
            if let sys = try? String(contentsOfFile: filePath, usedEncoding: &detected) {
                textView.text = sys
            } else {
                textView.text = ""
            }
        }
    }

    // MARK: - Mode Handling
    private func applyMode() {
        switch mode {
        case .viewing:
            textView.isEditable = false
            textView.resignFirstResponder()

            // 右上角：编辑；左上角：无
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(editTapped))
            navigationItem.leftBarButtonItem = nil

        case .editing:
            // 记录原始文本，便于取消恢复
            originalText = textView.text

            textView.isEditable = true
            textView.becomeFirstResponder()

            // 右上角：保存；左上角：取消
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(saveTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(cancelTapped))
        }
    }

    // MARK: - Actions
    @objc private func editTapped() {
        // 如果文件不可写，这里也可以先提示/迁移到可写目录（你之前那段迁移逻辑可放到这里）
        mode = .editing
    }

    @objc private func saveTapped() {
        let text = textView.text ?? ""
        do {
            try text.write(toFile: filePath, atomically: true, encoding: .utf8)
            // 保存成功后回到只读模式
            mode = .viewing
            toast("已保存")
        } catch {
            alert(title: "保存失败", message: error.localizedDescription)
        }
    }

    @objc private func cancelTapped() {
        // 有改动才确认
        if textView.text != originalText {
            let ac = UIAlertController(title: "放弃更改？",
                                       message: "当前内容尚未保存。",
                                       preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "放弃修改", style: .destructive, handler: { _ in
                self.textView.text = self.originalText
                self.mode = .viewing
            }))
            ac.addAction(UIAlertAction(title: "继续编辑", style: .cancel))
            present(ac, animated: true)
        } else {
            mode = .viewing
        }
    }

    // MARK: - Helpers
    private func alert(title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "确定", style: .default))
        present(a, animated: true)
    }

    private func toast(_ message: String) {
        let a = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(a, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            a.dismiss(animated: true)
        }
    }
}
