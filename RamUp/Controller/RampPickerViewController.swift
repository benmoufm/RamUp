//
//  RampPickerViewController.swift
//  RamUp
//
//  Created by Mélodie Benmouffek on 31/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerViewController: UIViewController {

    //MARK: - Variables
    var sceneView: SCNView!
    var size: CGSize!

    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        preferredContentSize = size

        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene

        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera

        let orientate = SCNAction.rotateBy(x: -CGFloat(Double.pi)/2, y: 0, z: 0, duration: 0)

        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))

        var obj = SCNScene(named: "art.scnassets/pipe.scn")
        var node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.runAction(orientate)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        node?.position = SCNVector3Make(-1, 0.7, -1)
        scene.rootNode.addChildNode(node!)

        obj = SCNScene(named: "art.scnassets/pyramid.scn")
        node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)
        node?.runAction(orientate)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.45, -1)
        scene.rootNode.addChildNode(node!)

        obj = SCNScene(named: "art.scnassets/quarter.scn")
        node = obj?.rootNode.childNode(withName: "quarter", recursively: true)
        node?.runAction(orientate)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        scene.rootNode.addChildNode(node!)
    }
}
