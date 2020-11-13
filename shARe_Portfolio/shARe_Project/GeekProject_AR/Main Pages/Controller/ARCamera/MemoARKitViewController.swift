//
//  MemoARKitViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/07/20.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import NCMB

protocol MemoARKitViewControllerDelegate{
    func endAddition()
}


class MemoARKitViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var saveExperienceButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var snapshotThumbnail: UIImageView!
    @IBOutlet weak var commandLabel: UILabel!
    
    
    
    
    
    var tapCount:Int = 1
    //var memoObject: SCNNode!
    var memoObjectAnchor: ARAnchor?
    let memoObjectAnchorName = "memoObject"
    var roomName: String?
    var argString1: String?
    var argString2: String?
    var argString3: String?
    var argString4: String?
    var locManager: CLLocationManager!
    var longitude: Double?
    var latitude: Double?
    
    
    var isMemoAdded = true
    var isObjectAdded = false
    var isAllAdded = false
    
    var memo: Memo!
    var room: Room!
    
    
    
    // URLからmapDataに変換
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: self.mapSaveURL)
    }
    
    //　ローカルに保存するURLの生成いな
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    // MARK: - AR session management
    
    var isRelocalizingMap = false
    
    // デフォルトの設定
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }
    
    
    // Lock the orientation of the app to the orientation in which it is launched
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commandLabel.text = "長押しでメモを追加してください"
        configureLighting()
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        locManager = CLLocationManager()
        locManager.delegate = self
        
        // 位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            case .denied:
                print("取得していません")
                break
            default:
                break
            }
        }
        
        addTapGestureToSceneView()
        tapARMemo()
        loadData()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        longitude = (locations.last?.coordinate.longitude)!
        latitude = (locations.last?.coordinate.latitude)!
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemoDetail" {
            let controller = segue.destination as! SetMemoDetailViewController
            controller.delegate = self as! SetMemoDetailDelegate
        }
    }
    
    
    func loadData(){
        guard let memo = memo else {
            print("memoの中身nilがある？")
            return
        }
        argString1 = memo.title
        argString2 = memo.createdUser.userName
        argString3 = memo.detail
        self.saveExperienceButton.isHidden = true
        self.commandLabel.isHidden = true
        isMemoAdded = true
        isObjectAdded = true
        let fileData = NCMBFile.file(withName: memo.fileName, data: nil) as! NCMBFile
        fileData.getDataInBackground({ (data, error) in
            if error != nil{
                print(error)
            }else {
                do {
                    let worldMapData = try fileData.getData()
                    guard let worldMap = self.unarchive(worldMapData: worldMapData)
                        else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
                    self.resetTrackingConfiguration(with: worldMap)
                    
                    // Display the snapshot image stored in the world map to aid user in relocalizing
                    if let snapshotData = worldMap.snapshotAnchor?.imageData, let snapshot = UIImage(data: snapshotData) {
                        self.snapshotThumbnail.image = snapshot
                    } else {
                        print("No snapshot image in world map")
                        print(worldMap.snapshotAnchor?.imageData)
                    }
                    
                    self.isRelocalizingMap = true
                    //virtualObjectAnchor = nil
                    print("読み込み完了")
                    self.isAllAdded = true
                } catch {
                    
                }
                
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTrackingConfiguration()
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    private func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    private func addTapGestureToSceneView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressedGesture(_:)))
        sceneView.addGestureRecognizer(longPress)
    }
    
    private func tapARMemo(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    
    //    @IBAction func addMemoBtn(){
    //        self.performSegue(withIdentifier: "toMemoDetail", sender: nil)
    //    }
    
    
    @objc func didLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        guard !isObjectAdded else { return }
        switch sender.state {
        case .began:
            print("longPress start")
        case .ended:
            if isRelocalizingMap && memoObjectAnchor == nil {
                return
            } else {
                self.isObjectAdded = true
                
                guard let hitTestResult = self.sceneView
                    .hitTest(sender.location(in: self.sceneView), types: [.featurePoint, .estimatedHorizontalPlane])
                    .first
                    else { print("ddd"); return }
                self.sceneView.session.add(anchor: ARAnchor(name: self.memoObjectAnchorName, transform: hitTestResult.worldTransform))
                //SetMemoPropertyViewControllerで作成・保存したメモプロパティをNCMBから読み込み・表示
                
            }
            
            // Remove exisitng anchor and add new anchor
            /*if let existingAnchor = virtualObjectAnchor {
             sceneView.session.remove(anchor: existingAnchor)
             }*/
            //virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: hitTestResult.worldTransform)
            print("longPress end")
        default:
            break
        }
        
    }
    
    //tap
    @objc func tapped(_ sender: UITapGestureRecognizer){
        guard isObjectAdded else{ return }
        switch sender.state {
        case .ended:
            
            if isRelocalizingMap && memoObjectAnchor == nil {
                return
            } else {
                
                guard let hitTestResult = self.sceneView
                    .hitTest(sender.location(in: self.sceneView), types: [.featurePoint, .estimatedHorizontalPlane])
                    .first
                    else { print("ddd2"); return }
                
                //SCNNode入れてるだけのコード
                //                self.sceneView.session.add(anchor: ARAnchor(name: self.memoObjectAnchorName, transform: hitTestResult.worldTransform))
                guard let node = self.sceneView.node(for: memoObjectAnchor!) else{return}
                node.childNode(withName: memoObjectAnchorName, recursively: true)
                node.rotation = SCNVector4(0, 1, 0, Double.pi)
                
                
            }
        default:
            break
        }
        
        
        
    }
    
    
    // セッションラベルの描写の更新
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        if isAllAdded{
            commandLabel.text = "メモを保存した位置にカメラを向けてください"
        }else if isMemoAdded {
            commandLabel.text = "長押ししてメモを配置して下さい"
        }else if isObjectAdded {
            commandLabel.text = "保存ボタンを押してください"
        } else {
            commandLabel.text = "＋ボタンを押してメモを追加してください"
        }
        
        snapshotThumbnail.isHidden = true
        switch (trackingState, frame.worldMappingStatus) {
            
            
        case (.normal, .mapped),
             (.normal, .extending):
            if isAllAdded {
                message = "メモを保存した位置にカメラを向けてください"
            } else if isObjectAdded {
                message = "保存ボタンを押してください"
            } else if isMemoAdded {
                message = "長押ししてメモを配置して下さい"
            } else {
                message = "＋ボタンを押してメモを追加してください"
            }
            
        case (.normal, _) where mapDataFromFile != nil && !isRelocalizingMap:
            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."
            
        case (.normal, _) where mapDataFromFile == nil:
            message = "Move around to map the environment."
            
        case (.limited(.relocalizing), _) where isRelocalizingMap:
            message = "Move your device to the location shown in the image."
            snapshotThumbnail.isHidden = false
            
        default:
            message = trackingState.localizedFeedback
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }
    
    private func generateMemoNode() -> SCNNode {
        let skScene = SKScene(size: CGSize(width: 200, height: 200))
        skScene.backgroundColor = UIColor.white
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 200), cornerRadius: 2)
        rectangle.fillColor = UIColor.cyan
        rectangle.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        rectangle.lineWidth = 1
        rectangle.alpha = 0.3
        
        //タイトル文字
        let labelNode_Title = SKLabelNode()
        labelNode_Title.text = self.argString1
        let systemFont1 = UIFont.systemFont(ofSize: 1, weight: UIFont.Weight.bold)
        //        labelNode_Title.fontSize = 15
        labelNode_Title.fontName = systemFont1.fontName
        labelNode_Title.fontSize = 20
        labelNode_Title.fontColor = .black
        labelNode_Title.alpha = 1
        labelNode_Title.position = CGPoint(x:55,y:30)
        labelNode_Title.xScale = 1.0
        labelNode_Title.yScale = -1.0
        
        //記入者
        let labelNode_Creator = SKLabelNode()
        labelNode_Creator.text = self.argString2
        let systemFont2 = UIFont.systemFont(ofSize: 1, weight: UIFont.Weight.bold)
        //        labelNode_Creator.fontSize = 15
        labelNode_Creator.fontName = systemFont2.fontName
        labelNode_Creator.fontSize = 20
        labelNode_Creator.fontColor = .black
        labelNode_Creator.position = CGPoint(x:140,y:30)
        labelNode_Creator.xScale = 1.0
        labelNode_Creator.yScale = -1.0
        
        //メモ内容
        let labelNode_Detail = SKLabelNode()
        labelNode_Detail.text = self.argString3
        let systemFont3 = UIFont.systemFont(ofSize: 1, weight: UIFont.Weight.bold)
        //        labelNode_Detail.fontSize = 20
        labelNode_Detail.fontName = systemFont3.fontName
        labelNode_Detail.fontSize = 15
        labelNode_Detail.fontColor = .black
        labelNode_Detail.position = CGPoint(x:100,y:100)
        labelNode_Detail.xScale = 1.0
        labelNode_Detail.yScale = -1.0
        
        
        //skSceneにrectangleを追加
        //rectangleに4つのlabelNode（メモ詳細）を追加
        skScene.addChild(rectangle)
        rectangle.addChild(labelNode_Title)
        rectangle.addChild(labelNode_Creator)
        rectangle.addChild(labelNode_Detail)
        
        //SetMemoPropertyViewControllerで入力した値をaddChildして表示
        
        let plane = SCNPlane(width: 0.2, height: 0.2)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        // virtualObject = {
        let node = SCNNode(geometry: plane)
        node.position.y += Float(plane.height / 2)
        node.position.x += Float(plane.width / 2)
        return node
    }
    
    
    func archive(worldMap: ARWorldMap, url: URL) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: url, options: [.atomic])
    }
    
    
    // URLからDataを取得
    private func retrieveWorldMapData(from url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Map data should already be verified to exist before Load button is enabled.")
            return nil
        }
    }
    
    // DataからARWorldMapを取得
    private func unarchive(worldMapData data: Data) -> ARWorldMap? {
        guard let unarchievedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data),
            let worldMap = unarchievedObject else { fatalError("No ARWorldMap in archive."); return nil }
        return worldMap
    }
    
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        sceneView.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
        isRelocalizingMap = false
        memoObjectAnchor = nil
        resetTrackingConfiguration()
    }
    
    
    
    //-----------------------------------------------------------------------------------------------
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    
    
    @IBAction func saveExperience(_ button: UIButton) {
        // 現状のwordldMapの取得
        self.sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { self.showAlert(title: "Can't get current world map", message: error!.localizedDescription); return }
            
            // Add a snapshot image indicating where the map was captured.
            guard let snapshotAnchor = SnapshotAnchor(capturing: self.sceneView)
                else { fatalError("Can't take snapshot") }
            //map.anchors.append(snapshotAnchor)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
                let fileName = Room.randomString(length: 12) + ".jpg"
                let file = NCMBFile.file(withName: fileName, data: data) as! NCMBFile
                
                file.saveInBackground({ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        let queryRoom = NCMBQuery(className: "Room")
                        guard let currentUser = NCMBUser.current() else { return }
                        //let uid = objRoom?.object(forKey: "userIds") as! [String]
                        
                        queryRoom?.findObjectsInBackground({ (results, error) in
                            let objMemo = NCMBObject(className: "Memo")
                            
                            objMemo?.setObject(currentUser, forKey: "createdUser")
                            //CurrentUserしか値が入らない。他のUserIdを追加することができていないため、共有されない
                            
                            for r in results as! [NCMBObject]{
                                let uid = r.object(forKey: "userIds")
                                objMemo?.setObject(uid, forKey: "shareUsers")
                            }
                            
                            objMemo?.setObject(self.argString1, forKey: "title")
                            objMemo?.setObject(self.argString3, forKey: "detail")
                            objMemo?.setObject(fileName, forKey: "fileName")
                            objMemo?.setObject(self.room.id, forKey: "roomId")
                            objMemo?.setObject(self.latitude, forKey: "latitude")
                            objMemo?.setObject(self.longitude, forKey: "longitude")
                            objMemo?.saveInBackground({ (error) in
                                if error != nil{
                                    print(error)
                                }else{
                                    print("保存完了")
                                    self.dismiss(animated: true, completion: nil)
                                    //                                    self.delegate?.endAddition()
                                }
                            })
                        })
                        
                    }
                })
                
            } catch {
                print("変換失敗")
            }
        }
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemoARKitViewController {
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    // AR周りでエラーが出たときの処理
    func session(_ session: ARSession, didFailWithError error: Error) {
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking(nil)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        if let worldMap = worldMap {
            configuration.initialWorldMap = worldMap
            //setLabel(text: "Found saved world map.")
        } else {
            DispatchQueue.main.async {
                self.commandLabel.isHidden = false
            }
        }
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.session.run(configuration, options: options)
    }
}

extension MemoARKitViewController: ARSKViewDelegate {
    // MARK: - ARSCNViewDelegate
    
    /// - Tag: RestoreVirtualContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor.name == memoObjectAnchorName
            else { return }
        //guard !(anchor is ARPlaneAnchor) else { return }
        // save the reference to the virtual object anchor when the anchor is added from relocalizing
        if memoObjectAnchor == nil {
            memoObjectAnchor = anchor
        }
        let memoNode = generateMemoNode()
        DispatchQueue.main.async {
            self.commandLabel.isHidden = true
            node.addChildNode(memoNode)
        }
    }
    
    //tap
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //
    //        var changedNode: Bool = false
    //        if changedNode == true{
    //            node.rotation = SCNVector4(0, 1, 0, 0.25 * Double.pi)
    //            changedNode = false
    //        }
    //
    //    }
    
}



extension MemoARKitViewController: SetMemoDetailDelegate {
    func endAddition(title: String, createdBy: String, text: String) {
        self.argString1 = title
        self.argString2 = createdBy
        self.argString3 = text
        self.isMemoAdded = true
    }
    

}

extension MemoARKitViewController: ARSessionDelegate, ARSCNViewDelegate {
    
    
    // MARK: - ARSessionDelegate
    // カメラのTrackingStateが変更されると呼ばれる
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // worldMappingStatusによって
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            if isMemoAdded {
                saveExperienceButton.isEnabled = true
                sceneView.isHidden = false
                //addTapGestureToSceneView()
            } else {
                saveExperienceButton.isEnabled = false
                sceneView.isHidden = true
            }
            
            
        default:
            saveExperienceButton.isEnabled = false
            sceneView.isHidden = true
            
        }
        statusLabel.text = """
        Mapping: \(frame.worldMappingStatus)
        Tracking: \(frame.camera.trackingState)
        """
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
}

