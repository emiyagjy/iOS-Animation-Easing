//
//  ViewController.swift
//  AnimationEasing
//
//  Created by GujyHy on 2018/1/22.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var secLayer:CALayer = CALayer()
    
    func radiansToDegrees(radians:CGFloat) -> CGFloat{
       return (radians) * 180.0 / CGFloat(Double.pi)
    }
    func degreesToRadians(angle:CGFloat) -> CGFloat{
        return (angle) / 180.0 * CGFloat(Double.pi)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 用缓冲动画实现【菜单】出现的效果
        self.createCubicAnimation()
        
        //  用缓冲动画 实现 时钟秒针摆动的效果
        // self.createClockAnimation()
        
        // 创建关键帧 缓冲动画
        // self.createKeyframeAnimation()
    }
    
    // 用CubicEaseOut  函数创建缓冲效果
    func createCubicAnimation() {
        
        let backView             = UIView(frame: self.view.bounds)
        backView.backgroundColor = .black
        backView.alpha           = 0
        self.view.addSubview(backView)
        UIView.animate(withDuration: 1, animations: {
            backView.alpha = 0.3
        })
        let imageView = UIImageView(frame: CGRect(x: 320, y: 0, width: 320, height: 568))
        imageView.image = UIImage(named:"pic.PNG")
        self.view.addSubview(imageView)
        
        // 创建缓冲动画
        let keyframeAnim      = CAKeyframeAnimation(keyPath: "position")
        keyframeAnim.duration = 1
        keyframeAnim.values   = YXEasing.calculateFrame(from: imageView.center,
                                                        to: CGPoint(x:self.view.center.x + 100,y:self.view.center.y),
                                                        func: CubicEaseOut,
                                                        frameCount: 1 * 30)
        
        imageView.center = CGPoint(x:self.view.center.x + 100,y:self.view.center.y)
        imageView.layer.add(keyframeAnim, forKey: nil)
    }
    
    // 用easeOutBounce 函数创建碰撞效果
    
    
    // 用缓冲动画 实现 时钟秒针摆动的效果  （弹簧动画的效果）
    func createClockAnimation() {
        
        // 创建一个表盘
        let showView = UIView(frame: CGRect(x: 0, y: 0,
                                            width:  300,
                                            height: 300))
        showView.center              = self.view.center
        showView.layer.borderColor   = UIColor.red.cgColor
        showView.layer.cornerRadius  = 150
        showView.layer.borderWidth   = 1
        self.view.addSubview(showView)
        
        // 创建一个秒针
        self.secLayer.anchorPoint     = CGPoint(x: 0, y: 0) //  默认锚点是（0.5，0.5）
        self.secLayer.frame           = CGRect(x: 150, y: 150, width: 1, height: 150)
        self.secLayer.backgroundColor = UIColor.black.cgColor
        showView.layer.addSublayer(self.secLayer)
        
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector:#selector(timeEvent) ,
                             userInfo: nil,
                             repeats: true)
        
    }
    var i = 1
    @objc func timeEvent() {
        
        let oldValue = self.degreesToRadians(angle: CGFloat(360/60) * CGFloat(i))
        i = i + 1
  
        let newValue = self.degreesToRadians(angle: CGFloat(360/60) * CGFloat(i))
        // 360/60 = 每个刻度的角度， 1秒钟的时间间隔
        
        let keyframeAnimation  = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        keyframeAnimation.duration = 0.5 //  肯定要比1秒小，才能看到动画
        keyframeAnimation.values   = YXEasing.calculateFrame(fromValue: oldValue,
                                                             toValue: newValue,
                                                             func:ElasticEaseOut,
                                                             frameCount: Int(0.5 * 30))
        self.secLayer.transform = CATransform3DMakeRotation(newValue, 0, 0, 1)
        // 绕着z轴转动了newValue
        self.secLayer.add(keyframeAnimation, forKey: nil)
        
    }
    
    
    // 创建关键帧 缓冲动画
    func createKeyframeAnimation() {
        let showView                 = UIView(frame: CGRect(x: 0, y: 0,
                                                            width: 100,
                                                            height: 100));
        showView.backgroundColor     = .red
        showView.layer.cornerRadius  = 50
        showView.layer.masksToBounds = true
        self.view.addSubview(showView)
        
        let easingValues = YXEasing.calculateFrame(from: showView.center,
                                                   to: CGPoint(x:200,y:200),
                                                   func: BounceEaseInOut,
                                                   frameCount: 30 * 4) // 帧数
        let keyframeAnimation  = CAKeyframeAnimation(keyPath: "position")
        keyframeAnimation.duration = 4
        keyframeAnimation.values   = easingValues
        
        showView.center = CGPoint(x: 200, y: 200) // 动画结束的值
        showView.layer.add(keyframeAnimation, forKey: nil)
    }
 


}

