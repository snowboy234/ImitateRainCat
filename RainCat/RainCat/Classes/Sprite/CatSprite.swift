//
//  CatSprite.swift
//  RainCat
//
//  Created by 田伟 on 2017/9/1.
//  Copyright © 2017年 田伟. All rights reserved.
//

import UIKit
import SpriteKit

class CatSprite: SKSpriteNode {
    
    // 包含两个纹理的数组
    private let walkFrames = [SKTexture(imageNamed: "cat_one"),
                              SKTexture(imageNamed: "cat_two")]
    
    // 步行动画的标志key
    private let walkingActionKey = "action_walking"
    
    // 定义🐱的移动速度
    private let movementSpeed : CGFloat = 100
    
    // 已经被眩晕2s———— 设置为0的话，猫在生成的一瞬间就会被眩晕，所以重新设置为2
    private var timeSinceLastHit : TimeInterval = 2
    // 会被眩晕2s
    private let maxFlailTime : TimeInterval = 2
    
    //MARK:- 创建静态函数
    public static func newInstance() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        catSprite.zPosition = 5
        // 创建圆形的SKPhysicsBody  
        catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
        
        // categoryBitMask ———— 类别掩码：将决定猫的身体是哪个SKPhysicsBody
        catSprite.physicsBody?.categoryBitMask = CatCategory
        // contactTestBitMask ———— 碰撞掩码
        catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory
        
        return catSprite
    }
    
    // 让🐱朝着食物的位置移动
    public func update(deltaTime : TimeInterval, foodLocation : CGPoint) {
        
        timeSinceLastHit += deltaTime
        
        // 如果猫在过去的2秒内没有被打中，继续朝食物前进
        if timeSinceLastHit >= maxFlailTime {
            // 运行步行动画序列
            if action(forKey: walkingActionKey) == nil {
                let walkingAction = SKAction.repeatForever(
                    SKAction.animate(with: walkFrames,
                                     timePerFrame: 0.1, // 每帧持续的时间
                        resize: false,     // 是否需要调整SKSpriteNode的大小
                        restore: false)     // 当动画结束时，精灵是否需要重置到它的初始状态
                )
                run(walkingAction, withKey: walkingActionKey)
            }
            
            if foodLocation.x < position.x {
                // 食物在🐱左边
                position.x -= movementSpeed * CGFloat(deltaTime)
                // xScale决定猫的宽度：这里可以让猫翻转，面朝左
                xScale = -1
            } else {
                // 食物在🐱右边
                position.x += movementSpeed * CGFloat(deltaTime)
                // 默认为1，面朝右
                xScale = 1
            }
        }
    }
    
    // 被雨击中
    public func hitByRain() {
        // 重设变量
        timeSinceLastHit = 0
        // 移除步行动画
        removeAction(forKey: walkingActionKey)
    }
}
