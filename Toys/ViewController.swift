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
    
    // Flags
    var ballSelected = false
    var ctSelected = false
    
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
        
        changeBallPhysicsBody()
        changeCTPhysicsBody()
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        print("hitResults = ", hitResults)
        if let result = hitResults.first {
            handleTouchFor(node: result.node)
        }
    }
    
    func handleTouchFor(node: SCNNode) {
        let nodeMaterial = SCNMaterial()
        if node.name == "ball" {
            print("Ball Touched")
            ballSelected = true
            ctSelected = false
            //Faz o node emitir "luz"
            nodeMaterial.emission.contents = UIColor.yellow
            //Aplica material ao node
            node.geometry?.firstMaterial = nodeMaterial
        }else if node.name == "ct"{
            print("CT Touched")
            ballSelected = false
            ctSelected = true
            //Faz o node emitir "luz"
            nodeMaterial.emission.contents = UIColor.yellow
            //Aplica material ao node
            node.geometry?.firstMaterial = nodeMaterial
        }else if node.name == "box"{
            print("Box Touched")
            if(ballSelected){
                sceneView.scene.rootNode.childNode(withName: "ball", recursively: true)?.removeFromParentNode()
            }else if(ctSelected){
                sceneView.scene.rootNode.childNode(withName: "ct", recursively: true)?.removeFromParentNode()
            }
        }
    }
    
    func changeBallPhysicsBody(){
        sceneView.scene.rootNode.childNode(withName: "ball", recursively: false)?.physicsBody?.physicsShape = SCNPhysicsShape(geometry: SCNSphere(radius: 5.0), options: nil)
    }
    
    func changeCTPhysicsBody(){
        sceneView.scene.rootNode.childNode(withName: "ct", recursively: false)?.physicsBody?.physicsShape = SCNPhysicsShape(geometry: SCNBox(width: 5.0, height: 20.0, length: 0.1, chamferRadius: 0.0), options: nil)
    }
    
}
