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
        self.collectionView.register(MLSwitchCollectionViewCell.self, forCellWithReuseIdentifier: MLSwitchCollectionViewCell.self.description())
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
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        if indexPath.item == 0 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            //segmentedControllCell.separatorActive = false
            segmentedControllCell.items = ["AI vs AI","User vs AI"]
            //segmentedControllCell.isSelected = true
            segmentedControllCell.selectedIndex = 0
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.gameTypeChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 1 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            //segmentedControllCell.separatorActive = false
            segmentedControllCell.items = ["White","Black"]
            segmentedControllCell.selectedIndex = 0
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.userColorChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 2 {
            let switchCell: MLSwitchCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSwitchCollectionViewCell.self.description(), for: indexPath) as! MLSwitchCollectionViewCell
            switchCell.label.text = "Simulationmode"
            switchCell.uiswitch.isOn = UserDefaults.standard.bool(forKey: "simulationMode")
            switchCell.uiswitch.addTarget(self, action: #selector(setSimulationMode(control:)), for: UIControl.Event.valueChanged)
            
            return switchCell
        }
        
        if indexPath.item == 3 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            //segmentedControllCell.separatorActive = false
            segmentedControllCell.items = ["WDepth 20","WDepth 40","WDepth 60","WTerminal"]
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.whiteDepthChanged(control:)), for: UIControl.Event.valueChanged)
            
            let value = MLChessSimulationDepth(rawValue: UserDefaults.standard.integer(forKey: "whiteSimulationDepth"))
            
            if value == MLChessSimulationDepth.Short {
                segmentedControllCell.selectedIndex = 0
            } else if value == MLChessSimulationDepth.Medium {
                segmentedControllCell.selectedIndex = 1
            } else if value == MLChessSimulationDepth.Long {
                segmentedControllCell.selectedIndex = 2
            } else {
                segmentedControllCell.selectedIndex = 3
            }
            
            return segmentedControllCell
        }
        
        if indexPath.item == 4 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            //segmentedControllCell.separatorActive = false
            segmentedControllCell.items = ["BDepth 20","BDepth 40","BDepth 60","BTerminal"]
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.blackDepthChanged(control:)), for: UIControl.Event.valueChanged)
            
            let value = MLChessSimulationDepth(rawValue: UserDefaults.standard.integer(forKey: "blackSimulationDepth"))
            
            if value == MLChessSimulationDepth.Short {
                segmentedControllCell.selectedIndex = 0
            } else if value == MLChessSimulationDepth.Medium {
                segmentedControllCell.selectedIndex = 1
            } else if value == MLChessSimulationDepth.Long {
                segmentedControllCell.selectedIndex = 2
            } else {
                segmentedControllCell.selectedIndex = 3
            }
            
            return segmentedControllCell
        }
        
        fatalError("exception")
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 44)
    }
    
    @objc func gameTypeChanged(control: UISegmentedControl) -> Void {
        print(control)
    }
    
    @objc func userColorChanged(control: UISegmentedControl) -> Void {
        print(control)
    }
    
    @objc func setSimulationMode(control: UISwitch) -> Void {
        print(control.isOn)
        UserDefaults.standard.set(control.isOn, forKey: "simulationMode")
    }
    
    @objc func whiteDepthChanged(control: UISegmentedControl) -> Void {
        //print(control)
        //print(control.selectedSegmentIndex)
        let value: MLChessSimulationDepth!
        
        if control.selectedSegmentIndex == 0 {
            value = MLChessSimulationDepth.Short
        } else if control.selectedSegmentIndex == 1 {
            value = MLChessSimulationDepth.Medium
        } else if control.selectedSegmentIndex == 2 {
            value = MLChessSimulationDepth.Long
        } else {
            value = MLChessSimulationDepth.Terminal
        }
        
        UserDefaults.standard.set(value.rawValue, forKey: "whiteSimulationDepth")
    }
    
    @objc func blackDepthChanged(control: UISegmentedControl) -> Void {
        print(control)
        //print(control.selectedSegmentIndex)
        let value: MLChessSimulationDepth!
        
        if control.selectedSegmentIndex == 0 {
            value = MLChessSimulationDepth.Short
        } else if control.selectedSegmentIndex == 1 {
            value = MLChessSimulationDepth.Medium
        } else if control.selectedSegmentIndex == 2 {
            value = MLChessSimulationDepth.Long
        } else {
            value = MLChessSimulationDepth.Terminal
        }
        
        UserDefaults.standard.set(value.rawValue, forKey: "blackSimulationDepth")
    }

}
