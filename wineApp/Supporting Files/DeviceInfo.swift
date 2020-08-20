//
//  DeviceInfo.swift
//  wineApp
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfo {
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func versionIdentifier() -> String{
        return UIDevice.current.systemVersion
    }
    
    static func getTotalStorageMemory() -> String{
        // capacity
        return UIDevice.current.totalDiskSpaceInGB
    }

    static func getUsedStorageMemory() -> String{
        // used
        return UIDevice.current.usedDiskSpaceInGB
    }

    static func geFreeStorageMemory() -> String{
        // used
        return "abc"
//        return UIDevice.current.freeDiskSpaceInBytes/(1000000000)
    }
    
    static func getApplicationMemory() -> String {
        //
        var applicationMemory: String = ""
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            applicationMemory = "Memory used in bytes: \(taskInfo.resident_size)"
        }
        else {
            applicationMemory = "Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
        }
        return applicationMemory
    }
    
    static func buldEmailBody() -> String {
        let swVersion = Bundle.main.versionAndBuildPretty
        var emailBody = NSLocalizedString("emailBody", comment: "email Body")
        
        let usedStorage = getUsedStorageMemory()
        let totalStorage = getTotalStorageMemory()
        emailBody = emailBody.replacingOccurrences(of: "%1", with: modelIdentifier())
        emailBody = emailBody.replacingOccurrences(of: "%2", with: versionIdentifier())
        emailBody = emailBody.replacingOccurrences(of: "%3", with: swVersion)
        emailBody = emailBody.replacingOccurrences(of: "%4", with: usedStorage)
        emailBody = emailBody.replacingOccurrences(of: "%5", with: totalStorage)

        return emailBody
        
    }
}

extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }

    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
       return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }

    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }

    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }

    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }

    var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
//                return space ?? 0
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }

}
