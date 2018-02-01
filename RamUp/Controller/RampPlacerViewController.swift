//
//  ViewController.swift
//  RamUp
//
//  Created by Mélodie Benmouffek on 31/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerViewController: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {
    //MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var moveUpButton: UIButton!
    @IBOutlet weak var moveDownButton: UIButton!

    //MARK: - Variables
    var selectedRampName: String?
    var selectedRamp: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)

        let gestureRecognizerRotateButton = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressGesture(_:))
        )
        let gestureRecognizerMoveUpButton = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressGesture(_:))
        )
        let gestureRecognizerMoveDownButton = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressGesture(_:))
        )
        gestureRecognizerRotateButton.minimumPressDuration = 0.1
        gestureRecognizerMoveUpButton.minimumPressDuration = 0.1
        gestureRecognizerMoveDownButton.minimumPressDuration = 0.1
        rotateButton.addGestureRecognizer(gestureRecognizerRotateButton)
        moveUpButton.addGestureRecognizer(gestureRecognizerMoveUpButton)
        moveDownButton.addGestureRecognizer(gestureRecognizerMoveDownButton)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(hitPosition)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    //MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func onRampSelected(_ rampName: String) {
        selectedRampName = rampName
    }

    func placeRamp(_ position: SCNVector3) {
        if let rampName = selectedRampName {
            controlsStackView.isHidden = false
            let ramp = Ramp.getRamp(forName: rampName)
            selectedRamp = ramp
            ramp.position = position
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    }

    @objc func onLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if let ramp = selectedRamp {
            if gesture.state == .ended {
                ramp.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateButton {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if gesture.view === moveUpButton {
                    let moveUp = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(moveUp)
                } else if gesture.view === moveDownButton {
                    let moveDown = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(moveDown)
                }
            }
        }
    }

    //MARK: - Actions
    @IBAction func rampButtonPressed(_ sender: UIButton) {
        let rampPickerViewController = RampPickerViewController(size: CGSize(width: 250, height: 500))
        rampPickerViewController.rampPlacerViewController = self
        rampPickerViewController.modalPresentationStyle = .popover
        rampPickerViewController.popoverPresentationController?.delegate = self
        present(rampPickerViewController, animated: true, completion: nil)
        rampPickerViewController.popoverPresentationController?.sourceView = sender
        rampPickerViewController.popoverPresentationController?.sourceRect = sender.bounds
    }

    @IBAction func removeButtonPressed(_ sender: Any) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
        }
    }
}
