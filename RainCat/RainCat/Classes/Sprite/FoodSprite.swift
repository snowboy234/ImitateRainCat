//
//  FoodSprite.swift
//  RainCat
//
//  Created by 田伟 on 2017/9/1.
//  Copyright © 2017年 田伟. All rights reserved.
//  食物精灵

import UIKit
import SpriteKit

class FoodSprite: SKSpriteNode {
    
    public static func newInstance() -> FoodSprite {
        let foodDish = FoodSprite(imageNamed: "food_dish")
        // 食物的物理实体设置为和食物精灵同样大小的矩形--因为食物精灵本身就是一个矩形
        foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
        foodDish.physicsBody?.categoryBitMask = FoodCategroy
        foodDish.physicsBody?.contactTestBitMask = WorldCategory | CatCategory | RainDropCategory
        // 将食物和猫的图层设置为相同的--这样他们不会重叠
        foodDish.zPosition = 5
        return foodDish
    }
    
}
