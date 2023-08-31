//
//  ViewController.swift
//  iOSSelectionBox
//
//  Created by Angelos Staboulis on 30/8/23.
//

import UIKit
import CoreImage
class ViewController: UIViewController {
    
    @IBOutlet var sourceImageView: UIImageView!
    
    @IBOutlet var destImageView: UIImageView!
    
    let drawView = UIView()
    
    var startPoint:CGPoint!
    
    var draggedPoint:CGPoint!
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupViewController()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        startPoint = touches.first!.location(in: view)
        
        destImageView.image = UIImage()
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        draggedPoint = touches.first!.location(in: view)
        
        drawSelection(startPoint: startPoint , draggedPoint: draggedPoint)
        
        
    }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawView.isHidden = true
        
        destImageView.image = getCroppedImage()
    }
   
    
    
}
extension ViewController{
    func setupViewController(){
        drawView.layer.borderWidth = 15
        drawView.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        drawView.isHidden = true
        view.addSubview(drawView)
        self.navigationItem.title = "iOSSelectionBox"
    }
    
    func drawSelection(startPoint:CGPoint,draggedPoint:CGPoint){
        
        let rect = CGRect(x: min(startPoint.x,draggedPoint.x), y: min(startPoint.y,draggedPoint.y), width: abs(startPoint.x - draggedPoint.x), height: abs(startPoint.y - draggedPoint.y))
        
        drawView.frame = rect
        
        drawView.isHidden = false
    }
    
    func getCroppedImage() -> UIImage {
        let rect = view.convert(drawView.frame, to: sourceImageView)
        let imageSize = sourceImageView.image?.size
        let ratio = (sourceImageView.frame.size.width / (imageSize?.width)!)
        let zoomedRect = CGRect(x: rect.origin.x / ratio, y: rect.origin.y / ratio, width: rect.size.width / ratio, height: (rect.size.height / ratio))
        let croppedImage = cropImage(image: sourceImageView.image!, toRect: zoomedRect)
        return croppedImage;
    }
    
    private func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage {
        let imageRef = image.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: imageRef!)
        return croppedImage
    }
}
