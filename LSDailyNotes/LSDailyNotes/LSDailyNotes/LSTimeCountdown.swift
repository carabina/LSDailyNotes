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
    
    /**
     *  取消所有倒计时任务
     */
    func cancelAllTask() {
        pool.cancelAllOperations()
    }
    
    /**
     *  挂起所有倒计时任务
     */
    private func suspendAllTask() {
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
