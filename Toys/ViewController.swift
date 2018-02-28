//
//  ViewController.swift
//  Toys
//
//  Created by Vinícius Cano Santos on 27/02/2018.
//  Copyright © 2018 Vinícius Cano Santos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //Instancia uma esfera
    var sphere = SCNNode(geometry: SCNSphere(radius: 0.01))
    
    var ballSelected = false
    var ctSelected = false
    var boxSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/toys.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        let miraMaterial = SCNMaterial()
        miraMaterial.diffuse.contents = UIColor.black
        
        //Aplica material a esfera
        sphere.geometry?.firstMaterial = miraMaterial
        
        //Adiciona esfera na scene
        scene.rootNode.addChildNode(sphere)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let centerPoint = sceneView.pointOfView else {
            return
        }
        
        // transform matrix
        let cameraTransform = centerPoint.transform
        // the orietantion
        let cameraOrientation = SCNVector3(x: -cameraTransform.m31, y: -cameraTransform.m32, z: -cameraTransform.m33)
        // the location of the camera
        let cameraLocation = SCNVector3(x: cameraTransform.m41, y: cameraTransform.m42, z: cameraTransform.m43)
        // x1+x2, y1+y2, z1+z2
        let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y, cameraLocation.z + cameraOrientation.z)
        
        sphere.position = cameraPosition
        
//        // Propriedas de luz
//        guard let currentFrame = sceneView.session.currentFrame,
//            let lightEstimate = currentFrame.lightEstimate else {
//                return
//        }
//
//        let neutralIntensity: CGFloat = 1000
//        let ambientIntensity = min(lightEstimate.ambientIntensity,
//                                   neutralIntensity)
//        let blendFactor = 1 - ambientIntensity / neutralIntensity
//
//        for node in sceneView.scene.rootNode.childNodes {
////            if let ball = node as? SKSpriteNode {
////                ball.color = .black
////                ball.colorBlendFactor = blendFactor
////
////            }
//            if node.name == "ball"{
//
//                let miraMaterial = SCNMaterial()
//                miraMaterial.diffuse.contents = UIColor.white
//                sphere.geometry?.firstMaterial = miraMateria
//            }
//        }
    
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        print("hitResults = ", hitResults)
        print("")
        if let result = hitResults.first {
            handleTouchFor(node: result.node)
        }
    }
    
    func handleTouchFor(node: SCNNode) {
        if node.name == "ball" {
            print("Ball Touched")
            ballSelected = true
            ctSelected = false
        }else if node.name == "ct"{
            print("CT Touched")
            ballSelected = false
            ctSelected = true
        }else if node.name == "box"{
            print("Box Touched")
            if(ballSelected){
                sceneView.scene.rootNode.childNode(withName: "ball", recursively: true)?.removeFromParentNode()
            }else if(ctSelected){
                sceneView.scene.rootNode.childNode(withName: "ct", recursively: true)?.removeFromParentNode()
            }
        }
    }
    
}
