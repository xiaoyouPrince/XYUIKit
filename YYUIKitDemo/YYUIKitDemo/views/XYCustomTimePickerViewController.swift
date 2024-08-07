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
        
        let dataDict = self.dataDict as NSDictionary
        let dayArr = self.monthDayTitles
        
        let currentRow = pickerView.selectedRow(inComponent: 0)
        let currentDayTitle = dayArr[currentRow]
        
        theTimeArr = dataDict[currentDayTitle] as! [String]
        
        if component == 0 {
            return dayArr.count
        }else{
            return theTimeArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            return self.monthDayTitles[row]
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
            let dataDict = self.dataDict as NSDictionary
            let dayArr = self.monthDayTitles
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
        var realYear = getCurrentYear()
        if Int(mon)! < getCurrentMonth() {
            realYear += 1
        }
        
        
        let dft = DateFormatter()
        dft.dateFormat = "yyyy:MM:dd HH:mm"
        if let resultDate = dft.date(from: "\(realYear):\(resultString)") {
            self.date = resultDate
        }
        // 保存自己时间
        print("创建的date = \(String(describing: self.date))")
    }
    
    private func isTheSameDay(d1: Date, d2: Date) -> Bool {
        let currentCalender = Calendar.current
        
        let d1Y = currentCalender.component(.year, from: d1)
        let d1M = currentCalender.component(.month, from: d1)
        let d1D = currentCalender.component(.day, from: d1)
        
        let d2Y = currentCalender.component(.year, from: d2)
        let d2M = currentCalender.component(.month, from: d2)
        let d2D = currentCalender.component(.day, from: d2)
         
        if d1Y == d2Y && d1M == d2M && d1D == d2D {
            return true
        }else{
            return false
        }
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
    
    
    // 总数据，使用 dataDict, 只创建一次
    private func getDataDictionary() -> [String : [String]] {
        
        var resultDict: [String : [String]] = [:]
        
        let monthDayTitles: [String] = self.monthDayTitles
        
        // 此时 monthDay 格式为 MM:dd
        for monthDay in monthDayTitles {
            // 每天的时间数据
            var timeArray : [String] = []
            if monthDay == monthDayTitles.first, isTheSameDay(d1: minimumDate, d2: Date()) { // 第一天，即当天,计算当天数据
                
                let currentDayCount = getCurrentDayTimeCount()
                for index in 0..<currentDayCount {
                    
                    let currentYear = getCurrentYear()
                    let currentMonthStr = getCurrentMonth() >= 10 ? "\(getCurrentMonth())" : "0\(getCurrentMonth())"
                    let currentDayStr = getCurrentDay() >= 10 ? "\(getCurrentDay())" : "0\(getCurrentDay())"
                    let lastTimeStemp = "\(currentMonthStr):\(currentDayStr) 23:30"
                    
                    let dft = DateFormatter()
                    dft.dateFormat = "yyyy:MM:dd HH:mm"
                    if let lastDate = dft.date(from: "\(currentYear):\(lastTimeStemp)") {
                        let currentDate = lastDate - TimeInterval((currentDayCount - 1 - index) * 30 * 60)
                        let fmt_ = DateFormatter()
                        fmt_.dateFormat = "HH:mm"
                        let currentTimeTitle = fmt_.string(from: currentDate)
                        timeArray.append(currentTimeTitle)
                    }
                }
                
            }else{
                // 非当天 - 半小时间隔，有48个时间点
                for index in 0..<48 {
                    
                    let startHour = 0
                    let startMinute = "00"
                    var resultHour = 0
                    var resultMinute = ""
                    let hourMinuteTitle = "0\(startHour):\(startMinute)"
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
    lazy var monthDayTitles: [String] = getMonthDayTitles()
    
    // 不直接用 dataDict.allKeys 是因为其返回的数组顺序错乱
    private func getMonthDayTitles() -> [String] {
        
        var monthDayTitles: [String] = []
        
        func weekdayHZ(_ wkd: Int) -> String{ // 周数转为汉字
            if wkd == 1 { return "周日" }
            if wkd == 2 { return "周一" }
            if wkd == 3 { return "周二" }
            if wkd == 4 { return "周三" }
            if wkd == 5 { return "周四" }
            if wkd == 6 { return "周五" }
            if wkd == 7 { return "周六" }
            return ""
        }
        
        // 天数
        var dayCount = Int(maximumDate.timeIntervalSince1970 / 24 / 3600) - Int(minimumDate.timeIntervalSince1970 / 24 / 3600)
        if dayCount <= 1 {
            dayCount = 60 // 最小给60天
        }
        for index in 0..<dayCount {
            
            // 日期- 处理
            let calender = Calendar.current
            let currentDate = minimumDate + (TimeInterval)(index * 24 * 3600)
            let month = calender.component(.month, from: currentDate)
            let day = calender.component(.day, from: currentDate)
            let weekday = calender.component(.weekday, from: currentDate)
            var month_day_title = "\(month)月\(day)日"
            
            if isTheSameDay(d1: currentDate, d2: Date()) { // 今天
                month_day_title.append("(今天)")
            }else
            if isTheSameDay(d1: currentDate, d2: Date() + 1 * 24 * 3600) { // 明天
                month_day_title.append("(明天)")
            }else
            if isTheSameDay(d1: currentDate, d2: Date() + 2 * 24 * 3600) { // 后天
                month_day_title.append("(后天)")
            }else{
                month_day_title.append("(\(weekdayHZ(weekday)))")
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
        
        return monthDayTitles
    }
    
    open var date: Date?
    open var minimumDate = Date() {
        didSet{
            // 如果设置的最小时间为 23：30 之后，直接将最小时间设置为次日 00：00
            if Calendar.current.component(.hour, from: minimumDate) == 23, Calendar.current.component(.minute, from: minimumDate) >= 30 {
                minimumDate = minimumDate + 30 * 60 // 直接加 30 分钟即可
            }
        }
    }
    open var maximumDate = Date() + 60*24*3600
    open var chooseDate : Date?
    
    var picker = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
        self.frame = picker.bounds
        
        // 默认选中第一行
        self.picker.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(self.picker, didSelectRow: 0, inComponent: 0)
        self.picker.selectRow(0, inComponent: 1, animated: true)
        self.pickerView(self.picker, didSelectRow: 0, inComponent: 1)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let chooseDate_ = self.chooseDate, chooseDate_ > self.minimumDate, chooseDate_ < self.maximumDate {
                
                let clander = Calendar.current
                // 月 日 时 分
                let mon = clander.component(.month, from: chooseDate_)
                let day = clander.component(.day, from: chooseDate_)
                let hour = clander.component(.hour, from: chooseDate_)
                let min = clander.component(.minute, from: chooseDate_)
                
                if min == 0 || min == 30 {
                    
                    var monthStr = "\(mon)"
                    var dayStr = "\(day)"
                    var hourStr = "\(hour)"
                    var minuteStr = "\(min)"
                    
                    if mon < 10 {
                        monthStr = "0\(mon)"
                    }
                    if day < 10 {
                        dayStr = "0\(day)"
                    }
                    if hour < 10 {
                        hourStr = "0\(hour)"
                    }
                    if min < 10 {
                        minuteStr = "0\(min)"
                    }
                    
                    let monDayTitle = "\(monthStr)月\(dayStr)日"
                    let hourMinTitle = "\(hourStr):\(minuteStr)"
                     
                    // 计算当前 日期行
                    var dayRow = -1
                    for dayTitle in self.monthDayTitles {
                        dayRow += 1
                        if dayTitle.contains(monDayTitle) {
                            break
                        }
                    }
                    
                    self.picker.selectRow(dayRow, inComponent: 0, animated: true)
                    self.pickerView(self.picker, didSelectRow: dayRow, inComponent: 0)
                    
                    // 计算当前 时间行
                    var timeRow = -1
                    for timeTitle in self.theTimeArr {
                        timeRow += 1
                        if timeTitle.contains(hourMinTitle) {
                            break
                        }
                    }
                    
                    self.picker.selectRow(timeRow, inComponent: 1, animated: true)
                    self.pickerView(self.picker, didSelectRow: timeRow, inComponent: 1)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XYCustomTimePickerViewController: UIViewController {
    
    // 取消回调
    open var cancelBlock: ((_ choosenDate: Date) -> ())?
    open var minDate = Date()
    open var maxDate = Date() + 14 * 24 * 3600
    open var chooseDate = Date()
    
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
        
        // 测试，指定时间参数
//        datePicker.minimumDate = Date() + 3 * 24 * 3600
//        datePicker.maximumDate = Date() + 10 * 24 * 3600
//        datePicker.minimumDate = Date(timeIntervalSince1970: 1622390400)
//        datePicker.maximumDate = Date(timeIntervalSince1970: 1623684600)
//        datePicker.chooseDate = Date(timeIntervalSince1970: 1622367041)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.chooseDate = chooseDate
        
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
                self.cancelBlock?(self.datePicker.date!)
            }
        }
    }
}
