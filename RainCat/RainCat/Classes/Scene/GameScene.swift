//
//  GameScene.swift
//  RainCat
//
//  Created by 田伟 on 2017/8/31.
//  Copyright © 2017年 田伟. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - 属性变量
    fileprivate var lastUpdateTime : TimeInterval = 0
    fileprivate var currentRainDropSpawnTime : TimeInterval = 0
    fileprivate var rainDropSpawnRate : TimeInterval = 0.5
    
    // 这个常量作为生成食物时的外边距————不让食物生成在离两侧特别近的位置
    fileprivate let foodEdgeMargin : CGFloat = 75.0
    
    // 雨滴的纹理
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    // 背景
    fileprivate let backgroundNode = BackgroundNode()
    
    // 初始化雨伞
    fileprivate let umbrellaNode = UmbrellaSprite.newInstance()
    
    // 🐱精灵
    fileprivate var catNode : CatSprite!
    
    // 食物精灵
    fileprivate var foodNode : FoodSprite!
    
    // MARK: - 系统回调函数
    override func sceneDidLoad() {
        self.lastUpdateTime = 0;
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        // 创建了一个和场景形状相同的边界，只不过我们将每个边都扩张了 100 个点。这相当于创建了一个缓冲区，使得元素在离开屏幕后才会被销毁。注意我们所使用的 edgeLoopFrom ，它创建了一个空白矩形，其边界可以和其它元素发生碰撞。
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
        
        // 将雨伞放置在屏幕中央
        umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)
        
        // 初始化🐱
        spawnCat()
        // 初始化食物
        spawnFood()
    }
    
    // 在渲染每个帧之前调用
    override func update(_ currentTime: TimeInterval) {
        
        // 如果尚未初始化_lastUpdateTime
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // 计算自上次更新以来的时间
        let dt = currentTime - self.lastUpdateTime
        
        // 更新计时器
        currentRainDropSpawnTime += dt
        
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        self.lastUpdateTime = currentTime
        
        // 通知雨伞进行更新
        umbrellaNode.update(deltaTime: dt)
        
        // 通知猫移动到食物
        catNode.update(deltaTime: dt, foodLocation: foodNode.position)
    }
}

// MARK: - 创建精灵
extension GameScene {
    // 随机产生雨滴
    fileprivate func spawnRaindrop(){
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        // 调用 truncatingRemainder 来确保坐标在屏幕范围
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        addChild(raindrop)
        
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        // 监听它与 FloorCategory 以及 WorldCategory 发生碰撞时的信息
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        // 雨滴图层在背景之上
        raindrop.zPosition = 2
        
        // 雨滴的密度从初始值1减半
        raindrop.physicsBody?.density = 0.5
    }
    
    // 产生————单独函数来初始化🐱精灵
    fileprivate func spawnCat() {
        // 如果场景中已经存在一个猫对象，那就从父类中移除它，以及他的所有操作，清除这个猫的SKPhysicsBody———— 这些操作会在猫调出世界的时候触发
        if let currentCat = catNode, children.contains(currentCat) {
            catNode.removeFromParent()
            catNode.removeAllActions()
            catNode.physicsBody = nil
        }
        
        // 创建🐱精灵
        catNode = CatSprite.newInstance()
        // 位置在伞下30px的地方
        catNode.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)
        addChild(catNode)
    }
    
    // 随机创建食物
    fileprivate func spawnFood() {
        
        // 同一时间只会生成一个食物
        if let currentFood = foodNode, children.contains(currentFood) {
            foodNode.removeFromParent()
            foodNode.removeAllActions()
            foodNode.physicsBody = nil
        }
        
        foodNode = FoodSprite.newInstance()
        var randomPosition : CGFloat = CGFloat(arc4random())
        // 调用 truncatingRemainder 来确保坐标在任意屏幕边界0~75的位置里面
        randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
        randomPosition += foodEdgeMargin
        foodNode.position = CGPoint(x: randomPosition, y: size.height)
        addChild(foodNode)
    }
}

// MARK: -SKPhysicsContactDelegate物理碰撞代理方法
extension GameScene {
    // 每当带有我们预先设置的 contactTestBitMasks 的物体碰撞发生时，这个方法就会被调用
    func didBegin(_ contact: SKPhysicsContact) {
        // 当一滴雨滴和任何其它对象的边缘发生碰撞后，我们会将其碰撞掩码（ collision bitmask ）清零
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        // 如果发生碰撞的物体中有食物，调用食物的处理
        if contact.bodyA.categoryBitMask == FoodCategroy || contact.bodyB.categoryBitMask == FoodCategroy {
            handleFoodHit(contact: contact)
//            return
        }
        
        // 如果发生碰撞的物体中有猫，就调用处理猫碰撞的行为
        if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
            handleCatCollision(contact: contact)
            return
        }
        
        // 雨滴不会再堆积在地面上了,移除这些结点
        if contact.bodyA.categoryBitMask == WorldCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
    
    // 处理猫的碰撞
    fileprivate func handleCatCollision(contact : SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == CatCategory {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case RainDropCategory:
            // 如果是雨滴在猫身上,在控制器中输出这个碰撞发生了
            catNode.hitByRain()
        case WorldCategory:
            // 如果是猫碰撞世界边缘，那就重新生成一个猫对象
            spawnCat()
        default:
            TWLog(message: "其他东西碰到🐱")
        }
    }
    
    // 处理食物的碰撞
    fileprivate func handleFoodHit(contact : SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        var foodBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == FoodCategroy {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case CatCategory:
            //TODO 增加得分
            TWLog(message: "猫吃掉食物")
            
            // 【fallthrough关键字】———— 会直接运行【紧跟的后一个】case或default语句，不论条件是否满足都会执行
            fallthrough
            
        case WorldCategory:
            
            // 食物碰到边界就被移除
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil
            foodBody.node?.removeAllActions()
            // 移除完旧的，创建一个新的
            spawnFood()
        default:
            TWLog(message: "其他东西碰到食物")
        }
    }
}


// MARK: -交互事件
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
}
