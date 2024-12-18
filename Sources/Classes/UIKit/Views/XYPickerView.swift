//
//  XYPickerView.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/12/18.
//


import UIKit

// MARK: - PickerViewItem
@objc public class XYPickerViewItem: NSObject {
    @objc public var title: String
    @objc public var code: String

    @objc public init(title: String, code: String) {
        self.title = title
        self.code = code
    }

    @objc public static func model(with dict: [String: Any]) -> XYPickerViewItem {
        let title = dict["title"] as? String ?? ""
        let code = dict["code"] as? String ?? ""
        return XYPickerViewItem(title: title, code: code)
    }
}

// MARK: - PickerView
@objc public class XYPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Properties
    @objc public var toolBarBgColor: UIColor? {
        didSet { toolBar.backgroundColor = toolBarBgColor }
    }
    @objc public var title: String? {
        didSet { titleLabel.text = title }
    }
    @objc public var titleColor: UIColor? {
        didSet { titleLabel.textColor = titleColor }
    }
    @objc public var cancelTitle: String? {
        didSet { cancelButton.setTitle(cancelTitle, for: .normal) }
    }
    @objc public var cancelTitleColor: UIColor? {
        didSet { cancelButton.setTitleColor(cancelTitleColor, for: .normal) }
    }
    @objc public var doneTitle: String? {
        didSet { doneButton.setTitle(doneTitle, for: .normal) }
    }
    @objc public var doneTitleColor: UIColor? {
        didSet { doneButton.setTitleColor(doneTitleColor, for: .normal) }
    }
    @objc public var pickerBgColor: UIColor? {
        didSet { pickerView.backgroundColor = pickerBgColor }
    }

    @objc public var dataArray: [XYPickerViewItem] = [] {
        didSet { pickerView.reloadAllComponents() }
    }
    @objc public var defaultSelectedRow: Int = 0
    @objc public var pickerHeight: CGFloat = -1

    private let pickerView = UIPickerView()
    private let toolBar = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let animationDuration: TimeInterval = 0.25
    private var selectedRow: Int = 0
    private var coverBtn = UIButton(type: .system)
    private var contentView = UIView()

    private var doneBlock: ((XYPickerViewItem) -> Void)?

    // MARK: - Initialization
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    @objc public static func picker() -> XYPickerView {
        return XYPickerView()
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear

        // PickerView setup
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white

        // ToolBar setup
        toolBar.backgroundColor = .lightGray
        addSubview(toolBar)

        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        toolBar.addSubview(cancelButton)

        // Done Button
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        toolBar.addSubview(doneButton)

        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        toolBar.addSubview(titleLabel)
        
        // Cover Btn
        coverBtn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        // Content View
        contentView.addSubview(toolBar)
        contentView.addSubview(pickerView)
        addSubview(coverBtn)
        addSubview(contentView)
    }
    
    private var toolBarHeight: CGFloat { 44 }
    private var pickerHeight_: CGFloat { max(pickerHeight, 230) }
    private var contentHeight: CGFloat { toolBarHeight + pickerHeight_ }

    func layoutSubview() {
        super.layoutSubviews()

        coverBtn.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - contentHeight)
        
        toolBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: toolBarHeight)
        pickerView.frame = CGRect(x: 0, y: toolBarHeight, width: frame.width, height: pickerHeight_)
        contentView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight)

        cancelButton.frame = CGRect(x: 15, y: 0, width: 60, height: toolBarHeight)
        doneButton.frame = CGRect(x: frame.width - 75, y: 0, width: 60, height: toolBarHeight)
        titleLabel.frame = CGRect(x: 90, y: 0, width: frame.width - 180, height: toolBarHeight)
    }

    // MARK: - Show & Dismiss
    @objc public func showPicker(completion: @escaping (XYPickerViewItem) -> Void) {
        guard !dataArray.isEmpty else {
            fatalError("XYPickerView's dataArray cannot be empty.")
        }

        if let window = UIApplication.shared.windows.first {
            window.addSubview(self)
            frame = UIScreen.main.bounds
            layoutSubview()
        } else {
            fatalError("can not find key window")
        }
        
        pickerView.selectRow(defaultSelectedRow, inComponent: 0, animated: false)
        selectedRow = defaultSelectedRow
        doneBlock = completion

        UIView.animate(withDuration: animationDuration) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.contentView.transform = .init(translationX: 0, y: -self.contentHeight)
        }
    }
    
    @objc public static func showPicker(_ config: (_ picker: XYPickerView) -> Void, completion: @escaping (XYPickerViewItem) -> Void) {
        let picker = XYPickerView.picker()
        config(picker)
        picker.showPicker(completion: completion)
    }

    @objc private func cancelButtonTapped() {
        dismissPicker()
    }

    @objc private func doneButtonTapped() {
        if let doneBlock = doneBlock {
            doneBlock(dataArray[selectedRow])
        }
        dismissPicker()
    }

    private func dismissPicker() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.backgroundColor = .clear
            self.contentView.transform = .identity
        }) { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - UIPickerViewDataSource & Delegate
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row].title
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
