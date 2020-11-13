//
//  SearchViewController.swift
//  OriginalApp
//
//  Created by 鈴木賀子 on 2020/08/17.
//  Copyright © 2020 Yoshiko. All rights reserved.
//


//update2~~~~~~~~
import SpriteKit
//import Magnetic


class SearchViewController: UIViewController {
    
    var tagSearchDelegate: Magnetic?

    
    @IBOutlet weak var magneticBubbleView: MagneticBubbleView! {
        didSet {
            tagSearchDelegate = magnetic
            magnetic.magneticDelegate = self
            magnetic.removeNodeOnLongPress = true
            #if DEBUG
            //            magneticBubbleView.showsFPS = true
            //            magneticBubbleView.showsDrawCount = true
            //            magneticBubbleView.showsQuadCount = true
            //            magneticBubbleView.showsPhysics = true
            #endif
        }
    }
    
    var magnetic: Magnetic {
        return magneticBubbleView.magnetic
    }
    
    override func viewDidLoad() {
        let bubbles = UIImage.names
        for (n, i) in bubbles.enumerated(){
            let color = UIColor.colors[n]
            //            let color = UIColor.colors.randomItem()
            let node = Node(text: i.capitalized, image: nil, color: color, radius: 40)
            node.scaleToFitContent = true
            node.selectedColor = UIColor.colors.randomItem()
//~~~~別
            node.physicsBody?.categoryBitMask = 0b0001
            node.physicsBody?.collisionBitMask = 0b0001
//            node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

            magnetic.addChild(node)
            
        }

    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //       ナビゲーションバーの背景色
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3648911119, green: 0.2378712296, blue: 0.1605188251, alpha: 1)
        //        ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            //        文字の色
            .foregroundColor: #colorLiteral(red: 0.3648911119, green: 0.2378712296, blue: 0.1605188251, alpha: 1)
        ]

    }

}

// MARK: - MagneticDelegate
extension SearchViewController: MagneticDelegate {

    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
        
        //TagSearchViewControllerへのモーダル遷移~~~~~~~
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tagSearchViewController = storyboard.instantiateViewController(withIdentifier: "TagSearchViewController") as! TagSearchViewController
        //tagSearchViewController.viewBackgroundColor = node.color
        tagSearchViewController.delegate = tagSearchDelegate
        
        tagSearchViewController.selectedNode = node
        tagSearchViewController.magnetic = magnetic
        tagSearchViewController.modalPresentationStyle = .overCurrentContext
        self.present(tagSearchViewController, animated: false, completion: nil)
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
//MagneticとSearchViewControllerとTagSearchViewController間で値を渡す時、うまく渡っていない可能性あり？
//categoryBitMaskだけ機能してない感じがある・・・
        for i in magnetic.children{
            i.physicsBody?.categoryBitMask = node.physicsBody!.categoryBitMask
            i.physicsBody?.collisionBitMask = node.physicsBody!.collisionBitMask

        }
    }
    
    func magnetic(_ magnetic: Magnetic, didRemove node: Node) {
        print("didRemove -> \(node)")
    }
    
}







// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}



//extension SearchViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomAnimator()
//    }
//    
//}
//
//class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 2.0
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        // アニメーションの挙動を記述
//    }
//}
