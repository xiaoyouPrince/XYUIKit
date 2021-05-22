//
//  XYCustomTimePickerViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/21.
//

import UIKit

class CustomDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var theTimeArr : [String] = []
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let dataDict = getDataDictionary() as NSDictionary
        let dayArr = dataDict.allKeys
        
        let currentRow = pickerView.selectedRow(inComponent: 0)
        
        var currentDayTitle = dayArr[currentRow]
        if currentRow == 0 { // 当天
            // let currentDayTitle = dayArr[currentRow]
            // 因为 dict.allkeys 是无序的所以不能直接选用上面方法
            
            var monStr = "\(getCurrentMonth())"
            if monStr.count < 2 {
                monStr = "0".appending(monStr)
            }
            
            var dayStr = "\(getCurrentDay())"
            if dayStr.count < 2 {
                dayStr = "0".appending(dayStr)
            }
            currentDayTitle = "\(monStr)月\(dayStr)日(今天)"
        }
        
        theTimeArr = dataDict[currentDayTitle] as! [String]
        
        if component == 0 {
            return dayArr.count
        }else{
            return theTimeArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            return monthDayTitles[row]
        }else{
            return theTimeArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 200
        }else{
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if component == 0 {
            let dataDict = getDataDictionary() as NSDictionary
            let dayArr = dataDict.allKeys
            let currentDayTitleRow = pickerView.selectedRow(inComponent: 0)
            let currentDayTitle = dayArr[currentDayTitleRow]
            theTimeArr = dataDict[currentDayTitle] as! [String]
            
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        
        
        let title1_row = pickerView.selectedRow(inComponent: 0)
        let title2_row = pickerView.selectedRow(inComponent: 1)
        
        let title1 = pickerView.delegate?.pickerView?(pickerView, titleForRow: title1_row, forComponent: 0)
//        print("点击了 - 日期 = \(title1)")
        
        let title2 = pickerView.delegate?.pickerView?(pickerView, titleForRow: title2_row, forComponent: 1)
//        print("点击了 - 时间 = \(title2)")
        
        
        // creat time
        guard let monthTitle = title1 as NSString? else {
            return
        }
        guard let timeTitle = title2 as NSString? else {
            return
        }
        
        let mon = monthTitle.substring(with: NSRange.init(location: 0, length: 2))
        let day = monthTitle.substring(with: NSRange.init(location: 3, length: 2))
        let hour = timeTitle.substring(with: NSRange.init(location: 0, length: 2))
        let minute = timeTitle.substring(with: NSRange.init(location: 3, length: 2))
        
        let resultString = "\(mon):\(day) \(hour):\(minute)"
        print("选中月日时分 = \(resultString)")
        
        // 如果选中月份 < 当前月份则跨年
//        var realYear = mon
//        var realMonth = mon
//        var realDay = mon
//        if mon.toInt() < getCurrentMonth() {
//
//        }
        
        
        let dft = DateFormatter()
        dft.dateFormat = "yyyy:MM:dd HH:mm"
        if let resultDate = dft.date(from: "\(getCurrentYear()):\(resultString)") {
            self.date = resultDate
        }
        // 保存自己时间
        print("创建的date = \(self.date)")
    }
    
    private func getCurrentYear() -> Int{
        let calender = Calendar.current
        let currentDate = Date()
        return calender.component(.year, from: currentDate)
    }
    
    private func getCurrentMonth() -> Int{
        let calender = Calendar.current
        let currentDate = Date()
        return calender.component(.month, from: currentDate)
    }
    
    private func getCurrentDay() -> Int{
        let calender = Calendar.current
        let currentDate = Date()
        return calender.component(.day, from: currentDate)
    }
    
    private func getCurrentHour() -> Int{
        let calender = Calendar.current
        let currentDate = Date()
        return calender.component(.hour, from: currentDate)
    }
    
    private func getCurrentMinute() -> Int{
        let calender = Calendar.current
        let currentDate = Date()
        return calender.component(.minute, from: currentDate)
    }
    
    private func getCurrentDayTimeCount() -> Int {
        // 时间组: 当天日期时间之后的【整点/半点】 如此刻 10:10 则时间从 10:30 开始到 24:00
        let calender = Calendar.current
        let currentDate = Date()
        let currentHour = calender.component(.hour, from: currentDate)
        let currentMinute = calender.component(.minute, from: currentDate)
        
        var count = (24 - currentHour) * 2
        if currentMinute >= 30 {
            count -= 2
        }else{
            count -= 1
        }
        
        return count
    }
    
    
    // 总数据，需要优化调用
    func getDataDictionary() -> [String : [String]] {
        
        var resultDict: [String : [String]] = [:]
        
        var monthDayTitles: [String] = []
        // 天数
        let dayCount = Int(maximumDate.timeIntervalSinceNow / 24 / 3600)
        for index in 0..<dayCount {
            
            // 日期- 处理
            let calender = Calendar.current
            let currentDate = Date() + (TimeInterval)(index * 24 * 3600)
            let month = calender.component(.month, from: currentDate)
            let day = calender.component(.day, from: currentDate)
            var month_day_title = "\(month)月\(day)日"
            
            if index == 0 { // 今天
                month_day_title.append("(今天)")
            }
            if index == 1 { // 明天
                month_day_title.append("(明天)")
            }
            if index == 2 { // 后天
                month_day_title.append("(后天)")
            }
            // 日期数组
            
            var monthDayTitle = month_day_title as NSString
            
            
            if monthDayTitle.range(of: "月").location == 1 {
                monthDayTitle = "0\(monthDayTitle)" as NSString
            }
            
            if monthDayTitle.range(of: "日").location == 4 {
                let monthDayTitle__: NSMutableString  = NSMutableString(string: monthDayTitle)
                monthDayTitle__.insert("0", at: 3)
                monthDayTitles.append(monthDayTitle__ as String)
            }else{
                monthDayTitles.append(monthDayTitle as String)
            }
        }
        
        // 此时 monthDay 格式为 MM:dd
        for monthDay in monthDayTitles {
            // 每天的时间数据
            var timeArray : [String] = []
            if monthDay == monthDayTitles.first { // 第一天，即当天,计算当天数据
                
                let currentDayCount = getCurrentDayTimeCount()
                // 有一种特殊情况，如 当前时间：23:40 ,当天是没有时间的，特殊处理为 24:00
                if currentDayCount == 0 {
                    timeArray.append("24:00")
                }
                
                for index in 0..<currentDayCount {
                    
                    let currentHour = getCurrentHour()
                    let currentMinute = getCurrentMinute()
                    
                    
                    if currentDayCount % 2 == 0 { // 偶数个，说明是从 【 (currentHour + 1 ):00 】 开始
                        let startHour = currentHour + 1
                        let startMinute = "00"
                        var resultHour = 0
                        var resultMinute = ""
                        
                        resultHour = index/2 + startHour
                        resultMinute = ((index % 2) == 1) ? "30" : "00"
                        let resultHourMinuteTitle = "\(resultHour):\(resultMinute)" as NSString
                        if resultHourMinuteTitle.range(of: ":").location == 1 {
                            timeArray.append("0\(resultHourMinuteTitle)")
                        }else{
                            timeArray.append(resultHourMinuteTitle as String)
                        }
                        
                    }else{ // 奇数个，说明是从 【 currentHour:30 】 开始
                        
                        // 第 0 个特殊，去掉. egg: 当前时间为 00:10 应该有 47 个。 从 00:30 开始
                        if index == 0 { continue }
                        
                        let startHour = currentHour
                        let startMinute = "30"
                        var resultHour = 0
                        var resultMinute = ""
                        
                        resultHour = index/2 + startHour
                        resultMinute = ((index % 2) == 1) ? "30" : "00"
                        let resultHourMinuteTitle = "\(resultHour):\(resultMinute)" as NSString
                        if resultHourMinuteTitle.range(of: ":").location == 1 {
                            timeArray.append("0\(resultHourMinuteTitle)")
                        }else{
                            timeArray.append(resultHourMinuteTitle as String)
                        }
                    }
                }
                
            }else{
                // 非当天 - 半小时间隔，有48个时间点
                for index in 0..<48 {
                    
                    var startHour = 0
                    var startMinute = "00"
                    var resultHour = 0
                    var resultMinute = ""
                    var hourMinuteTitle = "0\(startHour):\(startMinute)"
                    if index == 0 { // 第0组特殊处理
                        timeArray.append(hourMinuteTitle)
                        continue
                    }else{
                        resultHour = index/2 + startHour
                        resultMinute = ((index % 2) == 1) ? "30" : "00"
                    }
                    let resultHourMinuteTitle = "\(resultHour):\(resultMinute)" as NSString
                    if resultHourMinuteTitle.range(of: ":").location == 1 {
                        timeArray.append("0\(resultHourMinuteTitle)")
                    }else{
                        timeArray.append(resultHourMinuteTitle as String)
                    }
                }
            }
            
            resultDict[monthDay] = timeArray
        }
        
        return resultDict
    }
    lazy var dataDict: [String: [String]] = getDataDictionary()
    
    var monthDayTitles: [String] {
        get {
            
            var result: [String] = []
            
            // 天数
            let dayCount = Int(maximumDate.timeIntervalSinceNow / 24 / 3600)
            for index in 0..<dayCount {

                // 日期- 处理
                let calender = Calendar.current
                let currentDate = Date() + (TimeInterval)(index * 24 * 3600)
                let month = calender.component(.month, from: currentDate)
                let day = calender.component(.day, from: currentDate)
                var month_day_title = "\(month)月\(day)日"

                if index == 0 { // 今天
                    month_day_title.append("(今天)")
                }
                if index == 1 { // 明天
                    month_day_title.append("(明天)")
                }
                if index == 2 { // 后天
                    month_day_title.append("(后天)")
                }
                // 日期数组

                var monthDayTitle = month_day_title as NSString


                if monthDayTitle.range(of: "月").location == 1 {
                    monthDayTitle = "0\(monthDayTitle)" as NSString
                }

                if monthDayTitle.range(of: "日").location == 4 {

                    let monthDayTitle__: NSMutableString  = NSMutableString(string: monthDayTitle)
                    monthDayTitle__.insert("0", at: 3)
                    result.append(monthDayTitle__ as String)
                }else{
                    result.append(monthDayTitle as String)
                }
            }
            
            return result
        }
    }
    
    open var date: Date?
    open var minimumDate = Date()
    open var maximumDate = Date() + 360*24*3600
    {
        didSet (oldValue) { // 最大60天
            if oldValue < Date() + 60*24*3600 {
                maximumDate = Date() + 60*24*3600
            }
        }
    }
    
    var picker = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
        self.frame = picker.bounds
        
        // 默认选中 第二天10:00
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.picker.selectRow(1, inComponent: 0, animated: true)
            // 调用一次picker选中某行的代理函数，刷新数据
            self.pickerView(self.picker, didSelectRow: 1, inComponent: 0)
            self.picker.selectRow(20, inComponent: 1, animated: true) // 规律为 2n, n代表要选择的时间
            self.pickerView(self.picker, didSelectRow: 20, inComponent: 1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("时间选择器被释放--")
    }
}

class XYCustomTimePickerViewController: UIViewController {
    
    // 取消回调
    open var cancelBlock: (() -> ())?
    
    private var datePicker = CustomDatePicker()
    private var bgView = UIView()
    
    
    open override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{
            .custom
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bgView)
        bgView.addSubview(datePicker)
        bgView.backgroundColor = .white

        datePicker.frame.origin.x = (view.bounds.size.width - datePicker.bounds.size.width)/2
        bgView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: datePicker.bounds.size.height)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(okBtnClick))
        view.addGestureRecognizer(tap)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    
    @objc func okBtnClick(){
        end()
    }
}

// 动画
extension XYCustomTimePickerViewController {
    
    func start() {
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.bgView.transform = CGAffineTransform(translationX: 0, y: -self.bgView.bounds.height)
        }
    }
    
    func end() {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
            self.bgView.transform = .identity
        } completion: { (success) in
            self.dismiss(animated: false) {
                self.cancelBlock?()
            }
        }
    }
}
