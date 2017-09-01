//
//  ViewController.swift
//  RainCat
//
//  Created by 田伟 on 2017/9/1.
//  Copyright © 2017年 田伟. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    fileprivate var skView : SKView {
        return view as! SKView
    }
    
    fileprivate var gameScene : GameScene {
        return GameScene(size: view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        skView.presentScene(gameScene)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.ignoresSiblingOrder = true
        // 场景现在显示物理实体
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}

