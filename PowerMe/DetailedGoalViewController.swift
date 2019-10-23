//
//  DetailedGoalViewController.swift
//  PowerMe
//
//  Created by Yaroslav Spirin on 23/10/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit

class DetailedGoalViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    private static let instagramURLScheme = "instagram-stories://share"
    var storyImageName: String?
    var goalImageName: String?
    var goalName: String?
    @IBOutlet weak var goalimageView: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    
    public static func share(snapshot: UIImage, controller: UIViewController) {
        let shareOptionMenuController = UIAlertController(title: "Share",
                                                          message: nil,
                                                          preferredStyle: .actionSheet)
        
        let shareInStoryAction = UIAlertAction(title: "Instagram story",
                                               style: .default) { (action) in
            guard let url = URL(string: DetailedGoalViewController.instagramURLScheme) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                guard let imageData = snapshot.pngData() else {
                    return
                }
                
                let pasteBoardItems = [
                    ["com.instagram.sharedSticker.stickerImage" : imageData]
                ]
                
                if #available(iOS 10.0, *) {
                    UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
                } else {
                    UIPasteboard.general.items = pasteBoardItems
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let vc = UIAlertController(title: "Instagram not installed",
                                           message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                vc.addAction(cancelAction)
                controller.present(vc, animated: true, completion: nil)
            }
        }
        
        let shareInDialog = UIAlertAction(title: "Поделиться", style: .default) { (action) in
            let activityVC = UIActivityViewController(activityItems: [snapshot, "Мои достижения за сегодня"], applicationActivities: [])
            controller.present(activityVC, animated: true)
        }
            
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        shareOptionMenuController.addAction(shareInStoryAction)
        shareOptionMenuController.addAction(shareInDialog)
        shareOptionMenuController.addAction(cancelAction)
        
        controller.present(shareOptionMenuController, animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        DetailedGoalViewController.share(snapshot:  goalimageView.image!, controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalimageView.image = UIImage(named: goalImageName!)
        goalLabel.text = goalName
    }
}
