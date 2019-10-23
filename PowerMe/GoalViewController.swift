//
//  GoalViewController.swift
//  PowerMe
//
//  Created by Yaroslav Spirin on 23/10/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ImageCollectionViewCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.goalImageView.image = UIImage(named: cardImages[indexPath.row])
        cell.goalImageName = cardImages[indexPath.row]
        cell.storyImageName = storyImages[cell.goalImageName!]
    
        cell.goalImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        
        cell.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedCell = tapGestureRecognizer.view as! ImageCollectionViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailedGoalViewController") as? DetailedGoalViewController else {
            return
        }
        
        controller.storyImageName = storyImages[tappedCell.goalImageName!]
        controller.goalImageName = tappedCell.goalImageName
        controller.goalName = goalNames[tappedCell.goalImageName!]
        
        if tappedCell.goalImageName == "custom_goal" {
            let previousLast = cardImages.last ?? ""
            cardImages.removeLast()
            cardImages.append(newCardImage)
            cardImages.append(previousLast)
            collectionView.reloadData()
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    var cardImages = ["lose_weight", "stop_smoking", "start_reading", "learn_language", "custom_goal"]
    var storyImages = ["lose_weight" : "weight_story",
                      "stop_smoking" : "smoking_story",
                      "start_reading" : "read_story",
                      "learn_language" : "language_story",
                      "custom_goal" : "my_goal",
                      "my_goal" : "my_goal"
    ]
    
    var goalNames = [
        "lose_weight" : "Потерять вес",
        "stop_smoking" : "Бросить курить",
        "start_reading" : "Больше читать",
        "learn_language" : "Выучить новый язык",
        "custom_goal" : "Добавить цель",
        "my_goal" : "Моя цель №1"
    ]
    
    let newCardImage = "my_goal"

    @IBOutlet weak var collectionView: UICollectionView!
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}
