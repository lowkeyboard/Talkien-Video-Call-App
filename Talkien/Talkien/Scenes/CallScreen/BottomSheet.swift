//
//  BottomSheet.swift
//  Talkien
//
//  Created by cagla copuroglu on 18.12.2021.
//
import UIKit

class BottomSheetViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        
        self.modalPresentationStyle = .pageSheet
      
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        let imageName = "peer-to-peer" //64
        let imageName = "wifi-connection" //256
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)

        imageView.frame = CGRect(x: UIScreen.main.bounds.size.width*0.4,
                                 y: UIScreen.main.bounds.size.height*0.2,
                                 width: 256, height: 256)
        
        view.addSubview(imageView)

        
    }
    
    

    
}
