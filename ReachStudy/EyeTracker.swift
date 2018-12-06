//
//  EyeTracker.swift
//  EyeTracking
//
//  Created by Franziska Lang on 01.11.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

protocol TrackerDelegate {
    func getView() -> UIView
}

class EyeTracker: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    
    static var instance: EyeTracker = EyeTracker()
    
    var sceneView: ARSCNView!
 
    let trackerView: UIView = {
        let frame = CGRect(x: -50, y: -50, width: 50, height: 50)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.red
        view.alpha = 0.5
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    let centerView: UIView = UIView()
    
    var faceNode: SCNNode = SCNNode()
    var leftEye: SCNNode = SCNNode()
    var rightEye: SCNNode = SCNNode()
    
    var targetLeftEye: SCNNode = SCNNode()
    var targetRightEye: SCNNode = SCNNode()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    var eyeLookAtPositionYs: [CGFloat] = []
    
    var positionOnScreen: CGPoint = CGPoint(x: -1, y: -1)
    
    //Physical Phone Size of iPhone X
    let physicalPhoneScreenSize = CGSize(width: 0.0623908297, height: 0.135096943231532)
    let phoneScreenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    var virtualPhoneNode: SCNNode = SCNNode()
    var virtualScreenNode: SCNNode = {
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        //screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        return SCNNode(geometry: screenGeometry)
    }()
    
    /*
     Delegate variable to the controller that should use the tracker
     Adds the tracker/cursor in the controlelr
     Should be set and removed in viewWillAppear and viewWillDisappear
     */
    static var delegate: TrackerDelegate? {
        willSet (value) {
            if let value = value {
                let configuration = ARFaceTrackingConfiguration()
                configuration.isLightEstimationEnabled = true
                EyeTracker.instance.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                value.getView().addSubview(EyeTracker.instance.trackerView)
                value.getView().addSubview(EyeTracker.instance.sceneView)
            } else {
                guard EyeTracker.delegate != nil else { return }
                EyeTracker.instance.sceneView.session.pause()
                EyeTracker.instance.sceneView.removeFromSuperview()
                EyeTracker.instance.trackerView.removeFromSuperview()
            }
        }
    }
    
    private override init() {
        super.init()
        
        guard ARFaceTrackingConfiguration.isSupported else { return }
        
        self.sceneView = ARSCNView()

        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.scene.rootNode.addChildNode(faceNode)
        sceneView.scene.rootNode.addChildNode(virtualPhoneNode)
        virtualPhoneNode.addChildNode(virtualScreenNode)
        
        faceNode.addChildNode(leftEye)
        faceNode.addChildNode(rightEye)
        leftEye.addChildNode(targetLeftEye)
        rightEye.addChildNode(targetRightEye)
        
        targetLeftEye.position.z = 2
        targetRightEye.position.z = 2
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        rightEye.simdTransform = anchor.rightEyeTransform
        leftEye.simdTransform = anchor.leftEyeTransform
        DispatchQueue.main.async {
            self.mapPositionOnScreen()
        }
    }
    
    
    private func mapPositionOnScreen() {
        
        let hitResultRightEye = self.virtualPhoneNode.hitTestWithSegment(from: self.targetRightEye.worldPosition, to: self.rightEye.worldPosition, options: nil)
        let hitResultLeftEye = self.virtualPhoneNode.hitTestWithSegment(from: self.targetLeftEye.worldPosition, to: self.leftEye.worldPosition, options: nil)
        
        guard let resultR = hitResultRightEye.first, let resultL = hitResultLeftEye.first else { return }
        
        
        let xR = self.calculateX(resultR.localCoordinates.x)
        let xL = self.calculateX(resultL.localCoordinates.x)
        
        let yR = self.calculateY(resultR.localCoordinates.y)
        let yL = self.calculateY(resultL.localCoordinates.y)
        
        let smoothThresholdNumber: Int = 10
        self.eyeLookAtPositionXs.append((xR + xL) / 2)
        self.eyeLookAtPositionYs.append(-(yR + yL) / 2)
        
        self.eyeLookAtPositionXs = Array(self.eyeLookAtPositionXs.suffix(smoothThresholdNumber))
        self.eyeLookAtPositionYs = Array(self.eyeLookAtPositionYs.suffix(smoothThresholdNumber))
        
        let x = self.eyeLookAtPositionXs.average! + self.phoneScreenSize.width / 2
        let y = self.eyeLookAtPositionYs.average! + self.phoneScreenSize.height / 2 
        
        positionOnScreen = CGPoint(x: x, y: y)
        trackerView.transform = CGAffineTransform(translationX: x, y: y)
    }
    
    static func getTrackerPosition() -> CGPoint {
        return EyeTracker.instance.positionOnScreen
    }
    
    private func calculateY(_ point: Float) -> CGFloat {
        //return CGFloat(point) / (self.phoneScreenSize.height / 2) * SCalibration.screenSize.height + 312
        return CGFloat(point) / (self.physicalPhoneScreenSize.height / 2) * self.phoneScreenSize.height + 312
    }
    
    private func calculateX(_ point: Float) -> CGFloat {
        //return CGFloat(point) / (self.phoneScreenSize.width / 2) * SCalibration.screenSize.width
        return CGFloat(point) / (self.physicalPhoneScreenSize.width / 2) * self.phoneScreenSize.width
    }
    
}
