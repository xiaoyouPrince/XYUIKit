//
//  TimePickerView.swift
//  YYUIKitDemo
//
//  Created by will on 2025/6/9.
//

import Foundation
import UIKit

class TimePickerView: UIView {
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    private let hours = Array(0...23).map { String(format: "%02d", $0) }
    private let minutes = Array(0...59).map { String(format: "%02d", $0) }
    
    var onTimeSelected: ((String) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setCurrentTime()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setCurrentTime()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        
        // Toolbar setup
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        // PickerView setup
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Add subviews
        addSubview(toolbar)
        addSubview(pickerView)
        
        // Layout
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),
            
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Button action
        doneButton.target = self
        doneButton.action = #selector(doneButtonTapped)
    }
    
    private func setCurrentTime() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date())
        
        if let hour = components.hour, let minute = components.minute {
            pickerView.selectRow(hour, inComponent: 0, animated: false)
            pickerView.selectRow(minute, inComponent: 1, animated: false)
        }
    }
    
    // MARK: - Public Methods
    func setSelectedTime(hour: Int, minute: Int) {
        guard hour >= 0 && hour < hours.count && minute >= 0 && minute < minutes.count else {
            return
        }
        pickerView.selectRow(hour, inComponent: 0, animated: true)
        pickerView.selectRow(minute, inComponent: 1, animated: true)
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        let timeString = "\(selectedHour):\(selectedMinute)"
        onTimeSelected?(timeString)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension TimePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 两列：小时和分钟
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? hours.count : minutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? hours[row] : minutes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80 // 每列的宽度
    }
}
