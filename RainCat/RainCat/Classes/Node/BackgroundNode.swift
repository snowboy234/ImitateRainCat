//
//  BackgroundNode.swift
//  RainCat
//
//  Created by 田伟 on 2017/8/31.
//  Copyright © 2017年 田伟. All rights reserved.
//  所有的节点类都从该类派生。它不绘制任何东西

import UIKit
import SpriteKit

class BackgroundNode: SKNode {
    public func setup(size : CGSize) {
        let yPos : CGFloat = size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        // 添加了一个 SKPhysicsBody[物理实体]实例：这个物理实体（ physics body ）会告诉我们的场景（ scene ），其定义的区域（目前只有一条线），能够和其它的物理实体和 物理世界（ physics world ）[12] 进行交互
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        // 地面的弹性
        physicsBody?.restitution = 0.3
        
        // 地面物理实体设置为可触碰的。
        // 为了达到这个目的，将 RainDropCategory 添加到地面元素的 contactTestBitMask 中。如此一来，当我们将这些元素加入 GameScene 中时，我们就能在二者（雨滴和地面）接触时收到回调了。
        // categoryBitMask这个属性将帮助我们区分互相发生接触的对象
        physicsBody?.categoryBitMask = FloorCategory
        physicsBody?.contactTestBitMask = RainDropCategory
        
        
        // 添加背景颜色
        let skyNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: size))
        skyNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
        skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = 0
        
        let groundSize = CGSize(width: size.width, height: size.height * 0.35)
        let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
        groundNode.fillColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = 1
        
        addChild(skyNode)
        addChild(groundNode)
    }
}
