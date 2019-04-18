//
//  MLSettingsViewController.swift
//  MLChess
//
//  Created by Philipp Schunker on 18.04.19.
//  Copyright © 2019 Philipp Schunker. All rights reserved.
//

import UIKit
import PSUIKitUtils

class MLSettingsViewController: PSViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.setupUI()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(MLSegmentedCollectionViewCell.self, forCellWithReuseIdentifier: MLSegmentedCollectionViewCell.self.description())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        //self.collectionView.reloadData()
    }
    
    func setupUI() -> Void {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.alwaysBounceVertical = true
        
        self.view.addSubview(self.collectionView)
        
        let views: [UIView] = [self.collectionView]
        self.view.addVisualConstraints(visualFormat: "H:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        self.view.addVisualConstraints(visualFormat: "V:|[v1]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        if indexPath.item == 0 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            let arr = ["Test1","Test2"]
            segmentedControllCell.items = arr
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.gameTypeChanged(control:)), for: UIControl.Event.touchUpInside)
            return segmentedControllCell
        }
        
        fatalError("exception")
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 62)
    }
    
    @objc func gameTypeChanged(control: UISegmentedControl) -> Void {
        print(control)
    }

}
