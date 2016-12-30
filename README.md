# LSDailyNotes
日常笔记记录一些小知识点


## 1、LSLocalNoti  本地通知
```
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
```

## 2、LSTimeCountdown 倒计时
```
//
//  LSTimeCountdown.swift
//  LSDailyNotes
//
//  Created by John_LS on 2016/12/30.
//  Copyright © 2016年 John_LS. All rights reserved.
//

/// 倒计时
import UIKit
/// 计时中回调
typealias timeCountingDownTaskBlock = (_ timeInterval: TimeInterval) -> Void
// 计时结束后回调
typealias timeFinishedBlock = (_ timeInterval: TimeInterval) -> Void
/// 日历计时中回调
typealias dateCountingDownTaskBlock = (_ date: String) -> Void
// 日历计时结束后回调
typealias dateFinishedBlock = (_ date: String) -> Void

private var share = LSTimeCountdown()
/// LSTimeCountdown是定时器管理类，是个单利，可以管理app中所有需要倒计时的task
class LSTimeCountdown: NSObject {
    // 单利
    static let shared : LSTimeCountdown = {
        let tool = LSTimeCountdown()
        return tool
    }()
    var pool: OperationQueue
    
    override init() {
        pool = OperationQueue()
        super.init()
    }
    
    
    /// 开始倒计时
    ///
    /// - Parameters:
    ///   - key: 如果倒计时管理器里具有相同的key，则直接开始回调
    ///   - timeInteval: 倒计时总时间
    ///   - countingDown: 倒计时时，会多次回调，提供当前秒数
    ///   - finished: 倒计时结束时调用，提供当前秒数，值恒为 0
    func ls_scheduledCountDownTime(key : String , timeInteval : TimeInterval ,countingDown : timeCountingDownTaskBlock? , finished : timeFinishedBlock?)  {
        var task: LSTimeCountDownTask?
        if ls_countdownTaskExist(key: key, task: task) {
            ///任务正在进行
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            if countingDown != nil {
                countingDown!((task?.leftTimeInterval) ?? 60)
            }
        } else {
            task = LSTimeCountDownTask()
            task?.leftTimeInterval = timeInteval
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            task?.name = key
            
            pool.addOperation(task!)
        }
    }

    /// 查询倒计时任务是否存在
    ///
    /// - Parameters:
    ///   - key: 任务key
    ///   - task: 任务
    /// - Returns: true - 存在， false - 不存在
    func ls_countdownTaskExist(key : String , task : LSTimeCountDownTask? ) -> Bool {
        var taskExits = false
        
        for (_, obj)  in pool.operations.enumerated() {
            let temptask = obj as! LSTimeCountDownTask
            if temptask.name == key {
                taskExits = true
                break
            }
        }
        return taskExits
    }
    
    /// 取消指定倒计时任务
    ///
    /// - Parameter key: 任务key
    func ls_cancelCountDwonTask(key: String)  {
        for (_, obj)  in pool.operations.enumerated() {
            let temptask = obj as! LSTimeCountDownTask
            if temptask.name == key {
                temptask.cancel()
                break
            }
        }
    }

    /// 取消所有倒计时任务
    func ls_cancelAllCountDwonTask() {
        pool.cancelAllOperations()
    }
    
    /// 挂起所有倒计时任务
    private func ls_suspendAllCountDwonTask() {
        pool.isSuspended = true
    }
}
extension LSTimeCountdown {
    /// 开始日历倒计时
    ///
    /// - Parameters:
    ///   - key: 关键字
    ///   - date: 如果倒计时管理器里具有相同的key，则直接开始回调
    ///   - countingDown: 倒计时时，会多次回调，提供当前秒数
    ///   - finished: 倒计时结束时调用，提供当前秒数，值恒为 0
    func ls_scheduledCountDownTime(key : String , date : Date , countingDown : dateCountingDownTaskBlock? , finished : dateFinishedBlock?) {
        
        ///目标日期的时间戳
        let toTime = date.timeIntervalSince1970
        ///当前时间戳
        let fromTime = Date().timeIntervalSince1970
        
        ls_scheduledCountDownTime(key: key, timeInteval: toTime-fromTime, countingDown: { (time) in
            let rest = ls_restDate(time: time)
            countingDown!(rest)
        }) { (time) in
            let rest = ls_restDate(time: time)
            finished!(rest)
        }
    }
    
}

/// LSTimeCountDownTask是具体的用来处理倒计时的NSOperation子类
final class LSTimeCountDownTask: Operation {
    var leftTimeInterval: TimeInterval = 0
    var countingDownBlcok: timeCountingDownTaskBlock?
    var finishedBlcok: timeFinishedBlock?
    
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        while leftTimeInterval > 0 {
            print("leftTimeInterval----\(leftTimeInterval)")
            
            if self.isCancelled {
                return
            }
            leftTimeInterval -= 1
            DispatchQueue.main.async(execute: {
                ///回到主线程
                if self.countingDownBlcok != nil {
                    self.countingDownBlcok!(self.leftTimeInterval)
                }
            })
            
            Thread.sleep(forTimeInterval: 1)
        }
        DispatchQueue.main.async(execute: {
            ///回到主线程
            if self.isCancelled {
                return
            }
            if self.finishedBlcok != nil {
                self.finishedBlcok!(0)
            }
        })
    }
}
/// 获取此时到指定时间的总秒数
///
/// - Parameter date: 指定时间
/// - Returns: 总秒数
func ls_restDate(time : TimeInterval) -> String {
    let total = Int(time)
    let day =  total/(24*60*60)
    var rest = total - day*24*60*60
    let hour = rest/(60*60)
    rest = rest - hour*60*60
    let min = rest/60
    let sec = rest%60
    let date = String.init(format: "%02d天 %02d:%02d:%02d", day,hour,min,sec)
    
    return date
}

```
使用方法
```
///开启倒计时
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "time", timeInteval: 60, countingDown: { (time) in
            print("还剩下"+"\(time)"+"秒")
        }) { (time) in
            print("结束了")
            //结束下面的倒计时
            LSTimeCountdown.shared.ls_cancelCountDwonTask(key: "aa")
        }
        
        ///开启另一个倒计时
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "aa", timeInteval: 120, countingDown: { (time) in
            print("还剩下"+"\(time)"+"秒")
        }) { (time) in
            print("结束了")
        }
        
        ///到指定日期倒计时
        let date = Date.init(timeInterval: 90112, since: Date())
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "date", date: date, countingDown: { (date) in
            print("还剩下"+"\(date)")
        }) { (date) in
            print("还剩下"+"\(date)")
        }
```
