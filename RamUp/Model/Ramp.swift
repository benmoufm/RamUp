//
//  Ramp.swift
//  RamUp
//
//  Created by Mélodie Benmouffek on 01/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import SceneKit

class Ramp {
    class func getPipe() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pipe.scn")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        node?.position = SCNVector3Make(-1, 0.7, -1)
        return node!
    }

    class func getPyramid() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pyramid.scn")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.45, -1)
        return node!
    }

    class func getQuarter() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/quarter.scn")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        return node!
    }

    class func orientate(node: SCNNode) {
        let orientate = SCNAction.rotateBy(x: -CGFloat(Double.pi)/2, y: 0, z: 0, duration: 0)
        node.runAction(orientate)
    }

    class func startRotation(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
