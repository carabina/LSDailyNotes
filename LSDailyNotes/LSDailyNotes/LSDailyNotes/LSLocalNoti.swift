//
//  LSLocalNoti.swift
//  LSDailyNotes
//
//  Created by John_LS on 2016/12/30.
//  Copyright © 2016年 John_LS. All rights reserved.
//

import UIKit

/// 本地推送通知：UILocalNotification   IOS8.0 以后
class LSLocalNoti: NSObject {

}
//如果要使用推送通知，必须先在苹果的推送通知服务里注册你要使用哪几种类型的通知，就比如下面的一段代码就表示同时注册了提醒、标记和声音两种类型的通知(ios 8之前是不需要注册的)：
//1. 在appDelegate中func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool方法中注册通知
/// 注册通知
func ls_registerNoti()  {
    let uns = UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil)
    UIApplication.shared.registerUserNotificationSettings(uns)
}

///
/// 2.设置本地通知
///
/// - Parameter date: 通知提醒的时间
public func ls_setLocalNoti(date : NSDate) {
    
    //     获取所有本地通知
    //    let locals = UIApplication.shared.scheduledLocalNotifications
    ///取消所有本地通知
    UIApplication.shared.cancelAllLocalNotifications()
    
    
    // 初始化一个通知
    let localNoti = UILocalNotification.init()
    // 通知的触发时间，例如制定时间10秒后
    let fireDate = date.addingTimeInterval(+10)
    localNoti.fireDate = fireDate as Date
    // 设置时区
    localNoti.timeZone = NSTimeZone.default
    // 通知上显示的主题内容
    localNoti.alertBody = "您的预约快到时间了，注意哦"
    // 收到通知时播放的声音，默认消息声音
    localNoti.soundName = UILocalNotificationDefaultSoundName
    //待机界面的滑动动作提示
    localNoti.alertAction = "打开应用"
    // 应用程序图标右上角显示的消息数
    localNoti.applicationIconBadgeNumber = 0
    // 通知上绑定的其他信息，为键值对
    localNoti.userInfo = ["id": "1",  "name": "预约提醒"]
    
    // 添加通知到系统队列中，系统会在指定的时间触发
    UIApplication.shared.scheduleLocalNotification(localNoti)
    
    
}

//3. 通过通知上绑定的id来取消通知，其中id也是你在userInfo中存储的信息
func ls_deleteNoti(notiId : String) {
    guard let str_id : String = notiId else {
        return
    }
    
    if let locals = UIApplication.shared.scheduledLocalNotifications {
        for localNoti in locals {
            if let dict = localNoti.userInfo {
                
                if dict.keys.contains("id") && dict["id"] is String && (dict["id"] as! String) == str_id {
                    // 取消通知
                    UIApplication.shared.cancelLocalNotification(localNoti)
                }
            }
        }
    }
}
/// 接收本地通知
/// 在appdelegate中实现这个方法
///a.应用在正在运行(在前台或后台运行)，点击通知后触发appDelegate代理方法:在下面的注释的方法中处理通知
//func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//    ls_getLocalNoti(notification: notification)
//}

/// 处理本地通知的方法
///
/// - Parameter notification: 通知
func ls_getLocalNoti(notification: UILocalNotification?)  {
    // 获取通知上绑定的信息
    guard let dict = notification?.userInfo else {
        return
    }
    
    // 后面作相应处理...
}

///b.应用未运行，点击通知启动app，走appDelegate代理方法:didFinishLaunchingWithOptions在下面的注释的方法中处理通知
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//    // Override point for customization after application launch.
//    ///注册通知
//    ls_registerNoti()
//    
//    ///发起本地通知
//    ls_setLocalNoti(date:NSDate())
//    ///处理通知
//    ls_getLocalNoti(launchOptions:launchOptions)
//    return true
//}

/// 处理app关闭时点击通知启动
///
/// - Parameter launchOptions: 通知
func ls_getLocalNoti(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    ///处理通知
    if launchOptions != nil {
        
        if let localNotification = launchOptions![.location] as? UILocalNotification {
            if let dict = localNotification.userInfo {
                // 获取通知上绑定的信息后作相应处理...
            }
        }
    }
}




