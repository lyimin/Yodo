//
//  YodPrint.swift
//  Yod
//
//  Created by eamon on 2018/4/10.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit

public func YodError<T>(_ messsage: T) {
    YodLog(messsage, type: .error)
}

public func YodDebug<T>(_ messsage: T) {
    YodLog(messsage, type: .debug)
}

public func YodWarning<T>(_ message: T) {
    YodLog(message, type: .warning)
}

public enum YodLogType {
    
    case debug
    case error
    case warning
    
    var desc: String! {
        switch self {
        case .debug:
            return "[debug]"
        case .error:
            return "[error]"
        case .warning:
            return "[warning]"
        }
    }
}

public func YodLog<T>(_ messsage: T, type: YodLogType = .debug, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\n \(type.desc)\(fileName):(\(lineNum))  -  \(messsage)")
    #endif
}

