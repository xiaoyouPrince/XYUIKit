////
////  XYRefreshTableViewController.swift
////  SwiftLearn
////
////  Created by 渠晓友 on 2021/12/3.
////
//
///// 用来管理基本刷新功能
//
//import UIKit
//import SnapKit
////import MJRefresh
//
//protocol XYRefreshTableProtocol {
//
//    var theEmptyView: UIView { get }
//    var theTableView: UITableView { get }
//
//    /// 开始头部刷新
//    func startHeaderRefresh()
//    /// 开始尾部刷新
//    func startFooterRefresh()
//
//    /// 头部刷新回调
//    func headerRefreshHandler()
//    /// 尾部刷新回调
//    func footerRefreshHandler()
//
//    /// 停止刷新回调
//    func endRefresh()
//
//    /// 展示空页面, 以及空页面操作回调
//    func showEmpty(_ image: UIImage, _ descString: String?, _ callBack: (() -> ())?)
//    /// 移除空页面
//    func hideEmpty()
//}
//
//class XYRefreshEmptyView: UIView {
//
//    private var retryBtnCallBack: (()->())?
//
//    /// 用于定义 imageView 顶部高度
//    var imageTopMargin = 100 {
//        didSet {
//            imageView.snp.updateConstraints { make in
//                make.top.equalToSuperview().offset(imageTopMargin)
//            }
//        }
//    }
//
//    func setImage(image: UIImage, descStr: String? = nil, retryCallBack: (()->())?) {
//        imageView.image = image
//
//        if let _ = descStr {
//            descLabel.text = descStr
//        }
//
//        if let callBack = retryCallBack {
//            _ = retryBtn
//            retryBtnCallBack = callBack
//        }
//    }
//
//    lazy var imageView: UIImageView = {
//        let imageView = UIImageView()
//        addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(imageTopMargin)
//            make.centerX.equalToSuperview()
//        }
//        return imageView
//    }()
//
//    lazy var descLabel: UILabel = {
//        let descLabel = UILabel()
//        descLabel.textColor = UIColor(red: 0x05/CGFloat(0xFF), green: 0x0C/CGFloat(0xFF), blue: 0x1A/CGFloat(0xFF), alpha: 1.0)
//        descLabel.font = UIFont.systemFont(ofSize: 16)
//        descLabel.numberOfLines = 0
//        descLabel.textAlignment = .center
//        addSubview(descLabel)
//        descLabel.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(75)
//            make.right.equalToSuperview().offset(-75)
//            make.centerX.equalToSuperview()
//        }
//        return descLabel
//    }()
//
//    lazy var retryBtn: UIButton = {
//        let retryBtn = UIButton()
//        retryBtn.setTitle("重试", for: .normal)
//        retryBtn.setTitleColor(.white, for: .normal)
//        retryBtn.backgroundColor = UIColor(red: 0x58/CGFloat(0xFF), green: 0x7C/CGFloat(0xFF), blue: 0xF7/CGFloat(0xFF), alpha: 1.0)
//        retryBtn.addTarget(self, action: #selector(retryBtnClick), for: .touchUpInside)
//        retryBtn.layer.cornerRadius = 10
//        retryBtn.clipsToBounds = true
//        addSubview(retryBtn)
//        retryBtn.snp.makeConstraints { make in
//            make.top.equalTo(descLabel.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: 80, height: 40))
//        }
//        return retryBtn
//    }()
//
//    @objc func retryBtnClick() {
//        retryBtnCallBack?()
//    }
//}
//
//open class XYRefreshTableViewController: UITableViewController {
//
//    lazy var emptyView: UIView = {
//        let emptyView = XYRefreshEmptyView()
//        emptyView.backgroundColor = UIColor.white
//        tableView.addSubview(emptyView)
//        emptyView.snp.makeConstraints { make in
//            make.left.top.equalToSuperview()
//            make.size.equalTo(CGSize(width: view.bounds.width, height: view.bounds.height))
//        }
//        return emptyView
//    }(){
//        didSet {
//            tableView.addSubview(emptyView)
//            emptyView.snp.makeConstraints { make in
//                make.left.top.equalToSuperview()
//                make.size.equalTo(CGSize(width: view.bounds.width, height: view.bounds.height))
//            }
//        }
//    }
//
//
//    /// 设置自定义的请求头
//    /// - Parameters:
//    ///   - header: 自定义刷新头
//    ///   - refreshCallBack: 自定义刷新后回调函数
//    func setRefreshHeader(_ header: MJRefreshHeader? = nil) {
//        if header == nil {
//            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//                self.headerRefreshHandler()
//            })
//        }else{
//            tableView.mj_header = header
//        }
//    }
//
//    /// 设置自定义的请求尾
//    /// - Parameters:
//    ///   - footer: 自定义刷新尾部
//    ///   - refreshCallBack: 自定义刷新后回调函数
//    func setRefreshFooter(_ footer: MJRefreshFooter? = nil) {
//        if footer == nil {
//            tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//                self.footerRefreshHandler()
//            })
//        }else{
//            tableView.mj_footer = footer
//        }
//    }
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        setRefreshHeader()
//        setRefreshFooter()
//    }
//
//    open override func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }
//
//    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        50
//    }
//
//    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        var cell: UITableViewCell? = nil
//        if let cell_ = tableView.dequeueReusableCell(withIdentifier: "cellId") {
//            cell = cell_
//        }else{
//            let cell_ = UITableViewCell(style: .default, reuseIdentifier: "cellId")
//            cell = cell_
//        }
//
//        cell?.textLabel?.text = "第 \(indexPath.row) 个 cell"
//        return cell!
//    }
//}
//
//extension XYRefreshTableViewController: XYRefreshTableProtocol {
//
//    var theEmptyView: UIView {
//        return emptyView
//    }
//
//    var theTableView: UITableView {
//        return tableView
//    }
//}
//
//extension XYRefreshTableProtocol {
//
//    func hideEmpty() {
//        theEmptyView.isHidden = true
//        theTableView.isScrollEnabled = theEmptyView.isHidden
//    }
//
//    func startHeaderRefresh() {
//        theTableView.mj_header?.beginRefreshing()
//    }
//
//    func startFooterRefresh() {
//        theTableView.mj_footer?.beginRefreshing()
//    }
//
//    func headerRefreshHandler() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.endRefresh()
//        }
//    }
//
//    func footerRefreshHandler() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.endRefresh()
//        }
//    }
//
//    func endRefresh() {
//        theTableView.mj_header?.endRefreshing()
//        theTableView.mj_footer?.endRefreshing()
//    }
//
//    func showEmpty(_ image: UIImage, _ descString: String? = nil, _ callBack: (() -> ())? = nil) {
//
//        if let empty = theEmptyView as? XYRefreshEmptyView {
//            empty.setImage(image: image, descStr: descString, retryCallBack: callBack)
//        }
//        theTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//        theEmptyView.isHidden = false
//        theTableView.isScrollEnabled = theEmptyView.isHidden
//    }
//
//}
