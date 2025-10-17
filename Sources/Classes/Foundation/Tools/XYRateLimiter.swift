//
//  XYRateLimiter.swift
//  YYUIKit
//
//  Created by will on 2025/5/14.
//
/*
 一个简单的调用频率控制器， 以自然天（yyyy-MM-dd）为时间单位
 可以控制当天最大执行次数(单位: 次 : Int) 和 每两次任务之间的执行间隔(单位: 秒 : Timeinterval)
 */

import Foundation

public class XYRateLimiter {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let lastExecutionTimestampKeyPrefix = "rateLimiter_"
    private let executionCountKeyPrefix = "rateLimiter_"
    private let lastExecutionDayKeyPrefix = "rateLimiter_"

    /// 尝试执行一个操作，并根据事件名和设定的规则进行频率限制。
    ///
    /// - Parameters:
    ///   - eventName: 标识不同事件的名称。
    ///   - maxExecutionsPerDay: 当天该事件最大允许执行的次数 (X)。
    ///   - minIntervalInSeconds: 该事件两次执行之间的最小间隔时间（单位：秒）(Y)。
    ///   - action: 如果满足执行条件，则要执行的闭包。
    /// - Returns: 如果操作被执行则返回 `true`，否则返回 `false`。
    public func attemptExecution(
        forEvent eventName: String,
        maxExecutionsPerDay x: Int,
        minIntervalInSeconds y: TimeInterval,
        action: () -> Void
    ) -> Bool {
        let now = Date()
        let todayString = XYRateLimiter.dateFormatter.string(from: now)

        let lastExecutionTimestampKey = "\(lastExecutionTimestampKeyPrefix)\(eventName)_lastExecutionTimestamp"
        let executionCountKey = "\(executionCountKeyPrefix)\(eventName)_executionCount"
        let lastExecutionDayKey = "\(lastExecutionDayKeyPrefix)\(eventName)_lastExecutionDay"

        let defaults = UserDefaults.standard
        let storedLastExecutionTimestamp = defaults.double(forKey: lastExecutionTimestampKey)
        var storedExecutionCount = defaults.integer(forKey: executionCountKey)
        let storedLastExecutionDayString = defaults.string(forKey: lastExecutionDayKey)

        if let lastDay = storedLastExecutionDayString, lastDay == todayString {
            // 仍然是同一天
        } else {
            print("事件 '\(eventName)' 进入新的一天 (\(todayString))，重置执行次数。")
            storedExecutionCount = 0
        }

        if storedExecutionCount >= x {
            print("事件 '\(eventName)' 在日期 \(todayString): 已达到每日最大执行次数 \(x) 次。")
            return false
        }

        if storedLastExecutionTimestamp > 0 {
            let lastExecutionDate = Date(timeIntervalSince1970: storedLastExecutionTimestamp)
            let timeSinceLastExecution = now.timeIntervalSince(lastExecutionDate)

            if timeSinceLastExecution < y {
                print("事件 '\(eventName)' 执行过于频繁。请再等待 \(String(format: "%.1f", y - timeSinceLastExecution)) 秒。")
                return false
            }
        }

        action()
        print("事件 '\(eventName)' 已执行。当前时间: \(DateFormatter.localizedString(from: now, dateStyle: .medium, timeStyle: .long))")

        storedExecutionCount += 1
        defaults.set(now.timeIntervalSince1970, forKey: lastExecutionTimestampKey)
        defaults.set(storedExecutionCount, forKey: executionCountKey)
        defaults.set(todayString, forKey: lastExecutionDayKey)
        defaults.synchronize()

        print("事件 '\(eventName)' 在日期 \(todayString): 当前执行次数 \(storedExecutionCount)。")
        return true
    }

    /// 用于测试目的，重置所有存储的与特定事件相关的频率限制数据
    public func resetRateLimitData(forEvent eventName: String) {
        let lastExecutionTimestampKey = "\(lastExecutionTimestampKeyPrefix)\(eventName)_lastExecutionTimestamp"
        let executionCountKey = "\(executionCountKeyPrefix)\(eventName)_executionCount"
        let lastExecutionDayKey = "\(lastExecutionDayKeyPrefix)\(eventName)_lastExecutionDay"

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: lastExecutionTimestampKey)
        defaults.removeObject(forKey: executionCountKey)
        defaults.removeObject(forKey: lastExecutionDayKey)
        defaults.synchronize()
        print("事件 '\(eventName)' 的频率限制数据已重置。")
    }

    /// 用于测试目的，重置所有存储的频率限制数据
    public func resetAllRateLimitData() {
        let defaults = UserDefaults.standard
        let keysToRemove = defaults.dictionaryRepresentation().keys.filter {
            $0.hasPrefix(lastExecutionTimestampKeyPrefix) ||
            $0.hasPrefix(executionCountKeyPrefix) ||
            $0.hasPrefix(lastExecutionDayKeyPrefix)
        }
        for key in keysToRemove {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
        print("所有频率限制数据已重置。")
    }
}

/*
// --- 如何使用 (拓展后的示例) ---

func taskA() {
    print("✅ 任务 A 正在执行...")
}

func taskB() {
    print("🚀 任务 B 正在执行...")
}

let limiter = RateLimiter()

// 设置不同事件的限制规则
let maxPerDayA = 2
let intervalSecondsA: TimeInterval = 5 // 任务 A 每天最多 2 次，间隔 5 秒

let maxPerDayB = 5
let intervalSecondsB: TimeInterval = 2 // 任务 B 每天最多 5 次，间隔 2 秒

// 为了可重复测试，每次开始前重置相关数据
// limiter.resetRateLimitData(forEvent: "taskA")
// limiter.resetRateLimitData(forEvent: "taskB")
limiter.resetAllRateLimitData() // 或者重置所有

func simulateCall(eventName: String, description: String, maxPerDay: Int, interval: TimeInterval, action: () -> Void) {
    print("\n--- 尝试调用事件 '\(eventName)': \(description) @ \(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)) ---")
    if limiter.attemptExecution(forEvent: eventName, maxExecutionsPerDay: maxPerDay, minIntervalInSeconds: interval, action: action) {
        print("👍 调用事件 '\(eventName)' 成功: \(description)")
    } else {
        print("🚫 调用事件 '\(eventName)' 失败: \(description) (受频率限制)")
    }
}

print("当前日期是: \(DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none))")
print("任务 A 规则：每天最多 \(maxPerDayA) 次，间隔至少 \(intervalSecondsA) 秒。")
print("任务 B 规则：每天最多 \(maxPerDayB) 次，间隔至少 \(intervalSecondsB) 秒。")

// --- 测试任务 A ---
simulateCall(eventName: "taskA", description: "任务 A 首次调用", maxPerDay: maxPerDayA, interval: intervalSecondsA, action: taskA)
simulateCall(eventName: "taskA", description: "任务 A 立即再次调用", maxPerDay: maxPerDayA, interval: intervalSecondsA, action: taskA)

print("\n⏳ 请等待大约 \(Int(intervalSecondsA) + 1) 秒后再次尝试任务 A...")
DispatchQueue.main.asyncAfter(deadline: .now() + intervalSecondsA + 1) {
    simulateCall(eventName: "taskA", description: "任务 A 等待后的第二次有效调用", maxPerDay: maxPerDayA, interval: intervalSecondsA, action: taskA)
    simulateCall(eventName: "taskA", description: "任务 A 尝试第三次调用 (应因超限失败)", maxPerDay: maxPerDayA, interval: intervalSecondsA, action: taskA)
}

// --- 测试任务 B (与任务 A 的限制相互独立) ---
simulateCall(eventName: "taskB", description: "任务 B 首次调用", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)
simulateCall(eventName: "taskB", description: "任务 B 第二次调用", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)
simulateCall(eventName: "taskB", description: "任务 B 第三次调用", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)

print("\n⏳ 请等待大约 \(Int(intervalSecondsB) + 1) 秒后再次尝试任务 B...")
DispatchQueue.main.asyncAfter(deadline: .now() + intervalSecondsB + 1) {
    simulateCall(eventName: "taskB", description: "任务 B 等待后的第四次有效调用", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)
    simulateCall(eventName: "taskB", description: "任务 B 第五次调用", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)
    simulateCall(eventName: "taskB", description: "任务 B 尝试第六次调用 (应因超限失败)", maxPerDay: maxPerDayB, interval: intervalSecondsB, action: taskB)
}

// --- 测试跨天逻辑 (需要手动修改设备日期或 UserDefaults 中的日期) ---
// (与之前的测试跨天逻辑类似，但现在是针对特定的事件名)
*/

