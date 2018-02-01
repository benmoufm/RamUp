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
    weak var rampPlacerViewController: RampPlacerViewController!

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

        let pipe = Ramp.getPipe()
        Ramp.orientate(node: pipe)
        Ramp.startRotation(node: pipe)
        scene.rootNode.addChildNode(pipe)

        let pyramid = Ramp.getPyramid()
        Ramp.orientate(node: pyramid)
        Ramp.startRotation(node: pyramid)
        scene.rootNode.addChildNode(pyramid)

        let quarter = Ramp.getQuarter()
        Ramp.orientate(node: quarter)
        Ramp.startRotation(node: quarter)
        scene.rootNode.addChildNode(quarter)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: [:])
        if hitResults.count > 0 {
            let node = hitResults[0].node
            rampPlacerViewController.onRampSelected(node.name!)
        }
    }
}
