//
//  ViewController.swift
//  WDMT
//
//  Created by Robin Konijnendijk on 13/01/2024.
//

import UIKit
import SceneKit
import ARKit

class SceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 3 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
        }
        
        
        guard let location = touches.first?.location(in: sceneView) else {
            print("No location found")
            return
        }
        
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) else {
            print("No query found")
            return
        }
        
        guard let result = sceneView.session.raycast(query).first else {
            print("No result found")
            return
        }
        
        let dot = addDotNode(at: result)
        dot.transform = SCNMatrix4(result.worldTransform)
        
        sceneView.scene.rootNode.addChildNode(dot)
        
    }
    
    private func addDotNode(at result : ARRaycastResult) -> SCNNode{
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        
        dotMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(
        result.worldTransform.columns.3.x,
        result.worldTransform.columns.3.y,
        result.worldTransform.columns.3.z)
        
        dotNodes.append(dotNode)
    
        if dotNodes.count >= 3 {
            calculateDistances()
        }
        
        return dotNode
        
    }
    
    func calculateDistances() {
            let start = dotNodes[0].position
            let middle = dotNodes[1].position
            let end = dotNodes[2].position

        let widthDistance = distanceBetween(first: start, second: middle)
        let heightDistance = distanceBetween(first: middle, second: end)

            print("Width: \(widthDistance)")
            print("Height: \(heightDistance)")
        }

        func distanceBetween(first: SCNVector3, second: SCNVector3) -> Float {
            let distance = sqrt(
                pow(second.x - first.x, 2) +
                pow(second.y - first.y, 2) +
                pow(second.z - first.z, 2)
            )
            return distance * 100
        }
    
}
