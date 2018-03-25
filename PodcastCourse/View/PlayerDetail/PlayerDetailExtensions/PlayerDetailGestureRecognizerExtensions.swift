//
//  PlayerDetailGestureRecognizerExtensions.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 24/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

extension PlayerDetailView{    
    func addGesturesRecognizer(){        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        mainStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss(_ gesture: UIPanGestureRecognizer){
        if gesture.state == .began{
            let translation = gesture.translation(in: self.superview)
            mainStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let translation = gesture.translation(in: self.superview)
                self.mainStackView.transform = .identity
                if(translation.y > 50){
                    UIApplication.getMainTabBar()?.minimizedPlayerDetailView()
                }
                
            }, completion: nil)
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){        
        if gesture.state == .changed{
            handlePanChanged(gesture)
        }else if gesture.state == .ended{
            handlePanEnded(gesture)
        }
    }
    
    func handlePanChanged(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.mainStackView.alpha = -translation.y / 200
    }
    
    func handlePanEnded(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.transform = .identity
            if(translation.y < -200 || velocity.y < -500){

                UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
            }else{
                self.mainStackView.alpha = 0
                self.miniPlayerView.alpha = 1
            }
        }, completion: nil)
    }
    
    @objc func handleTapMaximize(){
        UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
    }
}
