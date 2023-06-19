//
//  PlayDataTimePickerController.swift
//  Pro
//
//  Created by 渠晓友 on 2023/2/7.
//

import UIKit
import XYUIKit

/*
 时间参数规则：
 方法名： showPlayTimeAlert:callBack:
 start:     Int      ---  开始时间，默认为 0， 即从 0:00 开始
 end:       Int      ---  结束时间，默认为 23， 即到 23:x0 结束(23点之后根据时间间隔计算最大值)
 interval:  Int      ---  时间间隔，必须为 60 的约数，比如 1: 只有整点一个间隔，2：30分钟间隔，3: 20 分钟间隔 4: 15分钟间隔，5: 12 分钟间隔 以此类推
 tags:      [String] ---  要展示标签的时间，如 10:30，端上会根据 interval 校验是否合法，匹配的时间则打推荐标签
 choosed:   String   ---  回显展示的标签时间，如 10:30，端上会根据 interval 校验是否合法，匹配则展示当前选中，反之默认选中第一个
 
 
 日期参数规则：
 方法名： showPlayDateAlert:callBack:
 start:     Int      ---  开始时间，秒级时间戳，精确到日即可，默认为 0， 即从当前的日期开始
 end:       Int      ---  结束时间，秒级时间戳，精确到日即可，默认为 14， 即展示14天
 choosed:   Int      ---  回显展示的标签日期，秒级时间戳，精确到日即可，默认为 0， 即选中第一个日期
 
 
 回调：
 回调均为 map
 如：日期返回： {"result": "1675061397"} //单位 s
    时间返回： {"result": "10:30"}
 */

struct DataSource_Date {
    var start       : TimeInterval = Date().timeIntervalSince1970
    var end         : TimeInterval = Date().timeIntervalSince1970 + (14 * 24 * 3600)
    var choosed     : TimeInterval = 0
}

struct DataSource_Time {
    var start       : Int = 0
    var end         : Int = 23
    var interval    : Int = 1
    var tags        : [String] = []
    var choosed     : String = ""
}

class PlayDataTimePickerController: UIViewController {
    typealias CallBack = ([String: Any])->()
    private var callback: CallBack?
    private var pickerTitle: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(self.classForCoder)-deinit")
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{.custom}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissContent()
    }
    
    func showPlayTimeAlert(params: [String: Any], callback: ((Any)->Void)?) {
        debugPrint("params = \(params)")
        
        var date = DataSource_Time()
        if let start = params["start"] as? Int {
            date.start = start
        }
        if let end = params["end"] as? Int {
            date.end = end
        }
        if let choosed = params["choosed"] as? String {
            date.choosed = choosed
        }
        if let interval = params["interval"] as? Int {
            date.interval = interval
        }
        if let tags = params["tags"] as? [String] {
            date.tags = tags
        }
                
        setup(title: "播出时间", callback: callback) {
            self.contentView.reloadTime(date)
        }
    }
    
    func showPlayDateAlert(params: [String: Any], callback: ((Any)->Void)?) {
        debugPrint("params = \(params)")
        
        var date = DataSource_Date()
        if let start = params["start"] as? Double {
            date.start = start
        }
        if let end = params["end"] as? Double {
            date.end = end
        }
        if let choosed = params["choosed"] as? Double {
            date.choosed = choosed
        }
        
        setup(title: "播出日期", callback: callback) {
            contentView.reloadDate(date)
        }
    }
    
    func setup(title: String, callback: CallBack?, completed: ()->()) {
        self.pickerTitle = title
        self.callback = callback
        completed()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationInterval) {
            self.showContent()
        }
        
    }
    
    lazy var contentView: PickerContentView = {
        let a = PickerContentView(title: self.pickerTitle ?? ""){[weak self] index in
            //Toast.make("点击了 \(index)")
            self?.dismissContent()
            
            if let result = self?.contentView.resultStr {
                let resultDict = ["result": result]
                self?.callback?(resultDict)
                //Toast.make("选择结果 \(resultDict)")
            }
        }
        a.frame = .init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 300)
        a.backgroundColor = .white
        return a
    }()
}

// animation
extension PlayDataTimePickerController {
    
    var animationInterval : TimeInterval {
        UINavigationController.hideShowBarDuration
    }
    
    func showContent(){
        view.addSubview(contentView)
        
        UIView.animate(withDuration: animationInterval) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.frame.size.height)
        }
    }
    
    @objc func dismissContent() {
        UIView.animate(withDuration: animationInterval) {
            self.view.backgroundColor = UIColor.clear
            self.contentView.frame.origin.y += self.contentView.frame.size.height
            self.contentView.transform = .identity
        } completion: { success in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

class PickerHeaderView: UIView {
    
    typealias CallBack = (Int)->()
    private let leftBtn = UIButton()
    private let rightBtn = UIButton()
    private let titleLabel = UILabel()
    private var callback: CallBack?
    
    init(title: String, callBack:CallBack?) {
        super.init(frame: .zero)
        self.callback = callBack
        
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(titleLabel)
        
        leftBtn.setTitleColor(.gray, for: .normal)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        rightBtn.setTitleColor(.blue, for: .normal)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = title
        
        leftBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        rightBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnClick(sender: UIButton){
        callback?(sender == leftBtn ? 0 : 1)
    }
}

class PickerContentView: UIControl {
    
    typealias CallBack = (Int)->()
    private var title: String
    private var callback: CallBack?
    private lazy var header = PickerHeaderView(title: self.title) {[weak self] index in
        self?.callback?(index)
    }
    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    var dataArray: [PickerCellModel] = []
    private var selectedModel: PickerCellModel? = nil
    var resultStr: String {
        selectedModel?.resultStr ?? dataArray.first?.resultStr ?? ""
    }
    
    init(title: String, callback: CallBack?) {
        self.title = title
        self.callback = callback
        super.init(frame: .zero)
        
        corner(radius: 16)
        layer.maskedCorners = CACornerMask.init(rawValue: CACornerMask.layerMinXMinYCorner.rawValue + CACornerMask.layerMaxXMinYCorner.rawValue)
        
        addSubview(header)
        addSubview(picker)
        
        header.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        picker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadDate(_ date: DataSource_Date) {
        dataArray.removeAll()
        let count = Int((date.end - date.start)/86400)
        
        print("count - \(count)")
        print("count = \(date.start.getDiffDay(with: date.end))")
        
        var choosedRow = 0
        for i in 0..<count {
            let currentInterval = (date.start + Double(i * 86400))
            let title_result = currentInterval.getMonDayWeekStr()
            let title = title_result.0
            let resultStr = title_result.1
            dataArray.append(PickerCellModel(title: title, resultStr: resultStr))
            
            if currentInterval.isSameDay(date.choosed) {
                choosedRow = i
            }
        }
        
        picker.reloadAllComponents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.picker.selectRow(choosedRow, inComponent: 0, animated: true)
        }
    }
    
    func reloadTime(_ date: DataSource_Time) {
        dataArray.removeAll()
        let hourCount = (date.end - date.start)
        var choosedRow = 0
        for i in 0...hourCount {
            if (60 % date.interval) == 0 {
                for index in 0...date.interval {
                    var hour = "\(date.start + i)"
                    var min = "\((60/date.interval) * index)"
                    if min == "60" { continue }
                    if hour.count == 1 {
                        hour = "0" + hour
                    }
                    if min.count == 1 {
                        min = "0" + min
                    }
                    
                    let title = hour + ":" + min
                    dataArray.append(PickerCellModel(title: title, resultStr: title))
                }
            }else{
                // defalut just hour
                let hour = "\(date.start + i)"
                let min = "00"
                let title = hour + ":" + min
                dataArray.append(PickerCellModel(title: title, resultStr: title))
            }
        }
        
        dataArray = dataArray.map { model -> PickerCellModel in
            if date.tags.contains(model.title) {
                var result = PickerCellModel(title: model.title, resultStr: model.resultStr)
                result.recommand = true
                return result
            }
            return model
        }
        
        for (i, item) in dataArray.enumerated() {
            if item.title == date.choosed {
                choosedRow = i
            }
        }
        
        picker.reloadAllComponents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.picker.selectRow(choosedRow, inComponent: 0, animated: true)
        }
    }
}

extension TimeInterval {
    func getMonDayWeekStr() -> (String, String) {
        let month_int = Calendar.current.component(.month, from: Date.init(timeIntervalSince1970: self))
        let day_int = Calendar.current.component(.day, from: Date.init(timeIntervalSince1970: self))
        let weekday = Calendar.current.component(.weekday, from: Date.init(timeIntervalSince1970: self))
        
        let month = month_int < 10 ? "0\(month_int)" : "\(month_int)"
        let day = day_int < 10 ? "0\(day_int)" : "\(day_int)"
        
        if month == "01" && day == "01" {
            let year = Calendar.current.component(.year, from: Date.init(timeIntervalSince1970: self))
            let title = "\(year)年\(month)月\(day)日 \(getTailStr(with: weekday))"
            let resultStr = "\(Int(self))"
            return (title, resultStr)
        }else
        {
            let title = "\(month)月\(day)日 \(getTailStr(with: weekday))"
            let resultStr = "\(Int(self))"
            return (title, resultStr)
        }
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(Date.init(timeIntervalSince1970: self))
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(Date.init(timeIntervalSince1970: self))
    }
    
    var isDayAfterTomorrow: Bool {
        Calendar.current.isDate(Date() + 86400 * 2, inSameDayAs: Date.init(timeIntervalSince1970: self))
    }
    
    func isSameDay(_ interval: TimeInterval) -> Bool {
        Calendar.current.isDate(Date.init(timeIntervalSince1970: interval), inSameDayAs: Date.init(timeIntervalSince1970: self))
    }
    
    func getTailStr(with wkd: Int) -> String {
        func getHZ(wkd: Int) -> String {
            if wkd == 1 { return "周日"}
            if wkd == 2 { return "周一"}
            if wkd == 3 { return "周二"}
            if wkd == 4 { return "周三"}
            if wkd == 5 { return "周四"}
            if wkd == 6 { return "周五"}
            if wkd == 7 { return "周六"}
            return ""
        }
        
        if isToday {
            return "今天"
        }else
        if isTomorrow {
            return "明天"
        }else
        if isDayAfterTomorrow {
            return "后天"
        }else
        {
            return "\(getHZ(wkd: wkd))"
        }
    }
    
    func getDiffDay(with time: TimeInterval) -> Int {
        Calendar.current.dateComponents([.day], from: Date.init(timeIntervalSince1970: self), to: Date.init(timeIntervalSince1970: time)).day ?? 0
    }
}

extension PickerContentView: UIPickerViewDataSource, UIPickerViewDelegate {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let a = PickerCell(model: dataArray[row])
        //a.backgroundColor = .random
        return a
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedModel = dataArray[row]
        //Toast.make("didSelectRow: \(resultStr)")
    }
    
}

struct PickerCellModel {
    let title: String
    var recommand: Bool = false
    let resultStr: String
}

class PickerCell: UIView {
    
    private var label = UILabel()
    private var recommandLabel = UILabel()
    
    init(model: PickerCellModel) {
        super.init(frame: .zero)
        
        addSubview(label)
        addSubview(recommandLabel)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        recommandLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 16))
        }
        
        label.text = model.title
        recommandLabel.text = "推荐"
        recommandLabel.backgroundColor = .red
        recommandLabel.font = UIFont.boldSystemFont(ofSize: 10)
        recommandLabel.textColor = .white
        recommandLabel.textAlignment = .center
        recommandLabel.corner(radius: 8)
        recommandLabel.isHidden = !model.recommand
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


