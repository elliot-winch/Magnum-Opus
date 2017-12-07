//
//  GameViewController.swift
//  MagnumOpus
//
//  Created by Nina Demirjian on 11/14/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    required init?(coder aDecoder: NSCoder) {
        GameViewController._instance = nil
        super.init(coder: aDecoder)
    }
    
    private static var _instance : GameViewController?
    private static var _playerOneName : String?
    private static var _playerTwoName : String?
    
    class var instance : GameViewController
    {
        return _instance!
    }
    
    class var playerOneName : String
    {
        get{
            return _playerOneName!
        }
        set(newPlayerOneName){
            _playerOneName = newPlayerOneName
        }
    }
    
    class var playerTwoName : String
    {get{
        return _playerTwoName!
        }
        set(newPlayerTwoName){
            _playerTwoName = newPlayerTwoName
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController._instance = self
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'newMenu.sks'
            if let scene = SKScene(fileNamed: "newMenu"){
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
