import YYUIKit

class ABC {
    
    func testPickerView() {
        
        // 使用实例
        //                    let picker = XYPickerView()
        //                    picker.dataArray = [
        //                        XYPickerViewItem(title: "Option 1", code: "001"),
        //                        XYPickerViewItem(title: "Option 2", code: "002"),
        //                        XYPickerViewItem(title: "Option 3", code: "003")
        //                    ]
        //                    picker.showPicker { selectedItem in
        //                        print("Selected: \(selectedItem.title), Code: \(selectedItem.code)")
        //                    }
        
        // 直接使用类方法
        XYPickerView.showPicker { picker in
            picker.dataArray = [
                XYPickerViewItem(title: "Option 1", code: "001"),
                XYPickerViewItem(title: "Option 2", code: "002"),
                XYPickerViewItem(title: "Option 3", code: "003")
            ]
            picker.title = "Choose an Option"
            picker.defaultSelectedRow = 1
            picker.cancelTitle = "2"
            picker.cancelTitleColor = .red
            picker.toolBarBgColor = .yellow
            picker.pickerHeight = 500
        } completion: { selectedItem in
            print("Selected: \(selectedItem.title), Code: \(selectedItem.code)")
        }
    }
}
