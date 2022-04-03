//
//  MailViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/9.
//
//  发送邮件的一个VC


import XYInfomationSection
import MessageUI

class MailViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
//        xy_buildUI(dataArr: dataArr())
        self.setContentWithData(dataArr(), itemConfig:{(item) in
            item.titleKey = "SwiftLearn.\(item.titleKey)"
            item.titleWidthRate = 0.5
        } , sectionConfig: nil, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
            print(cell.model.title)
            
            
            
            if index == 0  {
                
            }else if index == 1{
                
            }
        }
    }
}

extension MailViewController{
    
    func dataArr() -> [Any] {
        let result: [[[String: Any]]] = [
            [
                [
                    "title": "openUrl 的方式",
                    "titleKey": "",
                    "value": "内建方法",
                    "type": 1
                ],
                [
                    "title": "MessageUI框架",
                    "titleKey": "",
                    "value": "MessageUI",
                    "type": 1
                ]
            ]
        ]
        
//        let a = [
//            [
//                "title": "自定义 loading",
//                "titleKey": "UIViewController",
//                "value": "去设置",
//                "type": 1
//            ]
//        ]
//        result.append(a)
        return result
    }
}


// 使用系统框架
/*
 MFMailComposeViewController（原生）——使用模态跳转出邮件发送界面。具体实现如下：
 1） 项目需要导入MessageUI.framework框架
 2） 在对应类里导入头文件：#import <MessageUI/MessageUI.h>
 3） 对应的类遵从代理：MFMailComposeViewControllerDelegate
 */
extension MailViewController: MFMailComposeViewControllerDelegate {
    
    func testCanMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}

// 直接 open url 的方式发，会调用系统的 mail app - 真机才能调用成功
extension MailViewController {
    func sendMailForMailApp(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        //创建可变的地址字符串对象
//        NSMutableString *mailUrl = [[NSMutableString alloc] init];
//        //添加收件人,如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为","
//        NSString *recipients = @"sparkle_ds@163.com";
//        [mailUrl appendFormat:@"mailto:%@?", recipients];
//        //添加抄送人
//        NSString *ccRecipients = @"1622849369@qq.com";
//        [mailUrl appendFormat:@"&cc=%@", ccRecipients];
//        //添加密送人
//        NSString *bccRecipients = @"15690725786@163.com";
//        [mailUrl appendFormat:@"&bcc=%@", bccRecipients];
//        //添加邮件主题
//        [mailUrl appendFormat:@"&subject=%@",@"设置邮件主题"];
//        //添加邮件内容
//        [mailUrl appendString:@"&body=<b>Hello</b> World!"];
//        //跳转到系统邮件App发送邮件
//        NSString *emailPath = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailPath] options:@{} completionHandler:nil];
        
        
        var mailUrl = ""
        
        let recipients = "sparkle_ds@163.com"
        mailUrl.append("mailto:\(recipients)")
        
        let ccRecipients = "1622849369@qq.com"
        mailUrl.append("&cc=\(ccRecipients)")
    
        let bccRecipients = "15690725786@163.com"
        mailUrl.append("&bcc=\(bccRecipients)")
        
        let subject = "我是邮件主题"
        mailUrl.append("&subject=\(subject)")
        
        let body = "<b>Hello</b> World!"
        mailUrl.append("&body=\(body)")
        
        guard let url = mailUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else { return }
        
//        let url = "https://mail.google.com/mail/u/0/?fs=1&tf=cm&source=mailto&to=sparkle_ds@163.com%26cc%3D1622849369@qq.com%26bcc%3D15690725786@163.com%26subject%3D%E6%88%91%E6%98%AF%E9%82%AE%E4%BB%B6%E4%B8%BB%E9%A2%98%26body%3D%3Cb%3EHello%3C/b%3E+World!"
        
        UIApplication.shared.open(URL(string: url)!, options: [:]) { (success) in
            if success {
                print("success")
            }else{
                print("fail")
            }
        }
    }
}
