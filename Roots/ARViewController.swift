//
//  ARViewController.swift
//  Roots
//
//  Created by Mustafa Yusuf on 09/04/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLighting()
        addPlant()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addPaperPlane(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let paperPlaneScene = SCNScene(named: "paperPlane.scn"), let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "paperPlane", recursively: true) else { return }
        paperPlaneNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addPlant(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let PlantScene = SCNScene(named: "Bush1.dae") else { return }
        let PlantNode = SCNNode()
        let PlantSceneChildNodes = PlantScene.rootNode.childNodes
        for childNode in PlantSceneChildNodes {
            PlantNode.addChildNode(childNode)
        }
        PlantNode.position = SCNVector3(x, y, z)
        PlantNode.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(PlantNode)
    }
    
}

