//
//  File.swift
//  Dome2
//
//  Created by 田伟 on 2017/8/18.
//  Copyright © 2017年 田伟. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

// 运用了 移位运算符[16] 来为不同物理实体的 categoryBitMasks[17] 设置不同的唯一值。0x1 << 1 是十六进制的 1 ，0x1 << 2 是十六进制的 2 ，0x1 << 3 是十六进制的 4 ，后续的值依此类推，为前一个值的两倍。
let WorldCategory    : UInt32 = 0x1 << 1
let RainDropCategory : UInt32 = 0x1 << 2
let FloorCategory    : UInt32 = 0x1 << 3
let CatCategory      : UInt32 = 0x1 << 4
let FoodCategroy     : UInt32 = 0x1 << 5



func TWScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func TWScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func TWRandomColor() -> SKColor {
    return UIColor(red: CGFloat(CGFloat(arc4random() % 256) / 255.0), green: CGFloat(CGFloat(arc4random() % 256) / 255.0), blue: CGFloat(CGFloat(arc4random() % 256) / 255.0), alpha: 1.0)
}

func TWLog<message>(message : message, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):[\(funcName)](\(lineNum)行)-(\(message))")
    #endif
}




