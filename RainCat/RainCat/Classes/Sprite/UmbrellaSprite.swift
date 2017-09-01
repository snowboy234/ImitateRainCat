//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by 田伟 on 2017/8/31.
//  Copyright © 2017年 田伟. All rights reserved.
//  绘制纹理精灵的节点

import UIKit
import SpriteKit

class UmbrellaSprite: SKSpriteNode {
    
    // 加入了 destination 变量（保存对象移动的终点位置）；
    private var destination : CGPoint!
    // 加入了 setDestination(destination:) 方法来缓冲雨伞的移动
    private let easing : CGFloat = 0.1
    
    
    public static func newInstance() -> UmbrellaSprite{
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        
        // 构造一个 CGPath 来初始化 SKPhysicsBody,添加一个自定的物理实体
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
        path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))
        
        umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        // 将雨伞的物理状态设置为非动态，这样它就不会受重力影响了
        umbrella.physicsBody?.isDynamic = false
        umbrella.physicsBody?.restitution = 0.9
        
        return umbrella
    }
    
    // 方法将会在我们进行刷新操作之前直接对 position 属性进行赋值
    public func updatePosition(point : CGPoint) {
        position = point
        destination = point
    }
    // 方法仅更新 destination 属性的值
    public func setDestination(destination : CGPoint) {
        self.destination = destination
    }
    // 方法中添加了计算我们所需要向终点方向移动多少距离的逻辑
    public func update(deltaTime : TimeInterval) {
        /*
         在计算出对象需要移动的方向和距离后， easing 属性将每个坐标轴上所需移动的距离乘以 10% ，作为实际移动距离。这样做的话，雨伞就不会瞬间到达新的位置了，当雨伞离目标位置较远时，其移动速度会较快，而当它接近终点附近，它的速度便会逐渐减低。如果距离终点距离不足一个点，我们就直接移动到终点。我们这样做是因为缓冲机制（easing function）的存在会使终点附近的移动非常缓慢。不用反复地计算、更新并每次将雨伞移动一小段距离，我们只需要简单地设置好终点位置就可以了。
         */
        let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
        
        if(distance > 1) {
            let directionX = (destination.x - position.x)
            let directionY = (destination.y - position.y)
            // 代码中 easing 只是一个 factor 属性
            position.x += directionX * easing
            position.y += directionY * easing
        } else {
            position = destination;
        }
    }
}
