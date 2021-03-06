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
    
    var testModeSwitch: UISwitch!
    var simulationModeSwitch: UISwitch!
    
    var userColorSegmentedControl: UISegmentedControl!
    var whiteStrategySegmentedControl: UISegmentedControl!
    var blackStrategySegmentedControl: UISegmentedControl!
    
    var whiteCalcDurationSlider: UISlider!
    var whiteMinimumValueLabel: UILabel!
    var whiteMaximumValueLabel: UILabel!
    
    var blackCalcDurationSlider: UISlider!
    var blackMinimumValueLabel: UILabel!
    var blackMaximumValueLabel: UILabel!
    
    var whiteStateEvaluationSegmentedControl: UISegmentedControl!
    var blackStateEvaluationSegmentedControl: UISegmentedControl!
    
    var explorationCoefficientSlider: UISlider!
    var explorationCoefficientValueLabel: UILabel!
    var explorationCoefficientMaximumValueLabel: UILabel!
    
    var whiteRolloutPolicySegmentedControl: UISegmentedControl!
    var blackRolloutPolicySegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.setupUI()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(MLSegmentedCollectionViewCell.self, forCellWithReuseIdentifier: MLSegmentedCollectionViewCell.self.description())
        self.collectionView.register(MLSwitchCollectionViewCell.self, forCellWithReuseIdentifier: MLSwitchCollectionViewCell.self.description())
        self.collectionView.register(MLSliderCollectionViewCell.self, forCellWithReuseIdentifier: MLSliderCollectionViewCell.self.description())
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
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        
        if indexPath.item == 0 {
            let switchCell: MLSwitchCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSwitchCollectionViewCell.self.description(), for: indexPath) as! MLSwitchCollectionViewCell
            self.testModeSwitch = UISwitch()
            switchCell.uiswitch = self.testModeSwitch
            switchCell.label.text = "Test Mode"
            switchCell.uiswitch.isOn = UserDefaults.standard.bool(forKey: "testMode")
            switchCell.uiswitch.addTarget(self, action: #selector(setTestMode(control:)), for: UIControl.Event.valueChanged)
            
            return switchCell
        }
        
        if indexPath.item == 1 {
            let switchCell: MLSwitchCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSwitchCollectionViewCell.self.description(), for: indexPath) as! MLSwitchCollectionViewCell
            self.simulationModeSwitch = UISwitch()
            switchCell.uiswitch = self.simulationModeSwitch
            switchCell.label.text = "Simulation Mode"   //Learning Mode
            switchCell.uiswitch.isOn = UserDefaults.standard.bool(forKey: "simulationMode")
            switchCell.uiswitch.addTarget(self, action: #selector(setSimulationMode(control:)), for: UIControl.Event.valueChanged)
            
            return switchCell
        }
        
        /*
        if indexPath.item == 1 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            //segmentedControllCell.separatorActive = false
            segmentedControllCell.items = ["AI vs AI","User vs AI"]
            //segmentedControllCell.isSelected = true
            segmentedControllCell.selectedIndex = 0
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.gameTypeChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        } */
        
        if indexPath.item == 2 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            self.userColorSegmentedControl = UISegmentedControl(items: ["White","Black"])
            segmentedControllCell.segmentedControl = self.userColorSegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["White","Black"]
            var sindex = UserDefaults.standard.integer(forKey: "userColor")
            if sindex == 1 {
                sindex = 0
            } else if sindex == -1 {
                sindex = 1
            }
            segmentedControllCell.selectedIndex = sindex
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.userColorChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 3 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.whiteStrategySegmentedControl = UISegmentedControl(items: ["White Numerator","White Denominator"])
            segmentedControllCell.segmentedControl = self.whiteStrategySegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["White Numerator","White Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "whiteStrategy")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.strategyChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 4 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.blackStrategySegmentedControl = UISegmentedControl(items: ["Black Numerator","Black Denominator"])
            segmentedControllCell.segmentedControl = self.blackStrategySegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["Black Numerator","Black Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "blackStrategy")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.strategyChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 5 {
            let sliderCell: MLSliderCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSliderCollectionViewCell.self.description(), for: indexPath) as! MLSliderCollectionViewCell
            
            self.whiteCalcDurationSlider = UISlider()
            sliderCell.slider = self.whiteCalcDurationSlider
            
            //sliderCell.slider.isContinuous = false
            sliderCell.slider.minimumValue = 30
            sliderCell.slider.maximumValue = 600
            sliderCell.slider.value = Float(UserDefaults.standard.integer(forKey: "whiteCalcDuration"))
            
            self.whiteMinimumValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 72, height: 22))
            var str = "White "
            str += String(30)
            self.whiteMinimumValueLabel.text = str
            
            self.whiteMaximumValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 22))
            self.whiteMaximumValueLabel.text = String(600)
            
            sliderCell.slider.minimumValueImage = UIImage.imageWithLabel(label: self.whiteMinimumValueLabel)
            sliderCell.slider.maximumValueImage = UIImage.imageWithLabel(label: self.whiteMaximumValueLabel)
            
            sliderCell.slider.addTarget(self, action: #selector(setCalcDuration(control:)), for: UIControl.Event.valueChanged)
            
            return sliderCell
        }
        
        if indexPath.item == 6 {
            let sliderCell: MLSliderCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSliderCollectionViewCell.self.description(), for: indexPath) as! MLSliderCollectionViewCell
            
            self.blackCalcDurationSlider = UISlider()
            sliderCell.slider = self.blackCalcDurationSlider
            
            //sliderCell.slider.isContinuous = false
            sliderCell.slider.minimumValue = 30
            sliderCell.slider.maximumValue = 600
            sliderCell.slider.value = Float(UserDefaults.standard.integer(forKey: "blackCalcDuration"))
            
            self.blackMinimumValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 72, height: 22))
            var str = "Black "
            str += String(30)
            self.blackMinimumValueLabel.text = str
            
            self.blackMaximumValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 22))
            self.blackMaximumValueLabel.text = String(600)
            
            sliderCell.slider.minimumValueImage = UIImage.imageWithLabel(label: self.blackMinimumValueLabel)
            sliderCell.slider.maximumValueImage = UIImage.imageWithLabel(label: self.blackMaximumValueLabel)
            
            sliderCell.slider.addTarget(self, action: #selector(setCalcDuration(control:)), for: UIControl.Event.valueChanged)
            
            return sliderCell
        }
        
        if indexPath.item == 7 {
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
        
        if indexPath.item == 8 {
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
        
        if indexPath.item == 9 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.whiteStateEvaluationSegmentedControl = UISegmentedControl(items: ["White Win","White Pawn Units","White Neural Net"])
            segmentedControllCell.segmentedControl = self.whiteStateEvaluationSegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["Black Numerator","Black Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "whiteStateEvaluation")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.stateEvaluationChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 10 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.blackStateEvaluationSegmentedControl = UISegmentedControl(items: ["Black Win","Black Pawn Units","Black Neural Net"])
            segmentedControllCell.segmentedControl = self.blackStateEvaluationSegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["Black Numerator","Black Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "blackStateEvaluation")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.stateEvaluationChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 11 {
            let sliderCell: MLSliderCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSliderCollectionViewCell.self.description(), for: indexPath) as! MLSliderCollectionViewCell
            
            self.explorationCoefficientSlider = UISlider()
            sliderCell.slider = self.explorationCoefficientSlider
            
            //sliderCell.slider.isContinuous = false
            sliderCell.slider.minimumValue = 1
            sliderCell.slider.maximumValue = 2
            sliderCell.slider.value = Float(UserDefaults.standard.float(forKey: "mctsExplorationCoefficient"))
            
            self.explorationCoefficientValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 72, height: 22))
            var str = "Exp "
            str += String(sliderCell.slider.minimumValue)
            self.explorationCoefficientValueLabel.text = str
            
            self.explorationCoefficientMaximumValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 22))
            self.explorationCoefficientMaximumValueLabel.text = String(sliderCell.slider.maximumValue)
            
            sliderCell.slider.minimumValueImage = UIImage.imageWithLabel(label: self.explorationCoefficientValueLabel)
            sliderCell.slider.maximumValueImage = UIImage.imageWithLabel(label: self.explorationCoefficientMaximumValueLabel)
            
            sliderCell.slider.addTarget(self, action: #selector(setExpCoDuration(control:)), for: UIControl.Event.valueChanged)
            
            return sliderCell
        }
        
        if indexPath.item == 12 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.whiteRolloutPolicySegmentedControl = UISegmentedControl(items: ["White Random","White Neural Net"])
            segmentedControllCell.segmentedControl = self.whiteRolloutPolicySegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["Black Numerator","Black Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "whiteRolloutPolicy")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.rolloutPolicyChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        if indexPath.item == 13 {
            let segmentedControllCell: MLSegmentedCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MLSegmentedCollectionViewCell.self.description(), for: indexPath) as! MLSegmentedCollectionViewCell
            
            self.blackRolloutPolicySegmentedControl = UISegmentedControl(items: ["Black Random","Black Neural Net"])
            segmentedControllCell.segmentedControl = self.blackRolloutPolicySegmentedControl
            //segmentedControllCell.separatorActive = false
            //segmentedControllCell.items = ["Black Numerator","Black Denominator"]
            segmentedControllCell.selectedIndex = UserDefaults.standard.integer(forKey: "blackRolloutPolicy")
            segmentedControllCell.segmentedControl.addTarget(self, action: #selector(self.rolloutPolicyChanged(control:)), for: UIControl.Event.valueChanged)
            
            return segmentedControllCell
        }
        
        fatalError("exception")
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 44)
    }
    
    @objc func setTestMode(control: UISwitch) -> Void {
        print(control.isOn)
        UserDefaults.standard.set(control.isOn, forKey: "testMode")
    }
    
    @objc func setSimulationMode(control: UISwitch) -> Void {
        print(control.isOn)
        UserDefaults.standard.set(control.isOn, forKey: "simulationMode")
        
        if control.isOn {
            //deactivate SegmentedControls
            self.userColorSegmentedControl.setEnabled(false, forSegmentAt: 0)
            self.userColorSegmentedControl.setEnabled(false, forSegmentAt: 1)
            return
        }
        
        self.userColorSegmentedControl.setEnabled(true, forSegmentAt: 0)
        self.userColorSegmentedControl.setEnabled(true, forSegmentAt: 1)
        
        var sindex = UserDefaults.standard.integer(forKey: "userColor")
        if sindex == 1 {
            sindex = 0
        } else if sindex == -1 {
            sindex = 1
        }
        
        self.userColorSegmentedControl.selectedSegmentIndex = sindex
    }
    
    @objc func gameTypeChanged(control: UISegmentedControl) -> Void {
        print(control)
    }
    
    @objc func userColorChanged(control: UISegmentedControl) -> Void {
        print(control)
        
        var value = MLPieceColor.white
        let key = "userColor"
        
        if control.selectedSegmentIndex == 0 {
            value = MLPieceColor.white
        } else if control.selectedSegmentIndex == 1 {
            value = MLPieceColor.black
        }
        
        print(key,value)
        
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    @objc func strategyChanged(control: UISegmentedControl) -> Void {
        //print(control)
        var value: MLChessStrategy! = MLChessStrategy.Denominator
        var key = "whiteStrategy"
        
        if control === self.whiteStrategySegmentedControl {
            key = "whiteStrategy"
        }
        
        if control === self.blackStrategySegmentedControl {
            key = "blackStrategy"
        }
        
        if control.selectedSegmentIndex == 0 {
            value = MLChessStrategy.Numerator
        } else if control.selectedSegmentIndex == 1 {
            value = MLChessStrategy.Denominator
        }
        
        print(key,value)
        
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    @objc func stateEvaluationChanged(control: UISegmentedControl) -> Void {
        //print(control)
        var value: MLChessStateEvaluation! = MLChessStateEvaluation.Win
        var key = "whiteStateEvaluation"
        
        if control === self.whiteStateEvaluationSegmentedControl {
            key = "whiteStateEvaluation"
        }
        
        if control === self.blackStateEvaluationSegmentedControl {
            key = "blackStateEvaluation"
        }
        
        if control.selectedSegmentIndex == 0 {
            value = MLChessStateEvaluation.Win
        } else if control.selectedSegmentIndex == 1 {
            value = MLChessStateEvaluation.PawnUnits
        } else if control.selectedSegmentIndex == 2 {
            value = MLChessStateEvaluation.NeuralNet
        }
        
        print(key,value)
        
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    @objc func rolloutPolicyChanged(control: UISegmentedControl) -> Void {
        //print(control)
        var value: MLChessRolloutPolicy! = MLChessRolloutPolicy.Random
        var key = "whiteRolloutPolicy"
        
        if control === self.whiteRolloutPolicySegmentedControl {
            key = "whiteRolloutPolicy"
        }
        
        if control === self.blackRolloutPolicySegmentedControl {
            key = "blackRolloutPolicy"
        }
        
        if control.selectedSegmentIndex == 0 {
            value = MLChessRolloutPolicy.Random
        } else if control.selectedSegmentIndex == 1 {
            value = MLChessRolloutPolicy.NeuralNet
        }
        
        print(key,value)
        
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    /*
    func setBlackCalcDuration(control: UISlider) -> Void {
        print(control)
        UserDefaults.standard.set(Int(control.value), forKey: "blackCalcDuration")
    }
    */
    
    @objc func setCalcDuration(control: UISlider) -> Void {
        //print(control)
        if control === self.whiteCalcDurationSlider {
            //print("white")
            UserDefaults.standard.set(Int(control.value), forKey: "whiteCalcDuration")
            let value = UserDefaults.standard.value(forKey: "whiteCalcDuration") as! Int
            self.whiteMaximumValueLabel.text = String(value)
            self.whiteCalcDurationSlider.maximumValueImage = UIImage.imageWithLabel(label: self.whiteMaximumValueLabel)
            
            print(value)
        }
        
        if control === self.blackCalcDurationSlider {
            //print("black")
            UserDefaults.standard.set(Int(control.value), forKey: "blackCalcDuration")
            let value = UserDefaults.standard.value(forKey: "blackCalcDuration") as! Int
            self.blackMaximumValueLabel.text = String(value)
            self.blackCalcDurationSlider.maximumValueImage = UIImage.imageWithLabel(label: self.blackMaximumValueLabel)
            
            print(value)
        }
    }
    
    @objc func setExpCoDuration(control: UISlider) -> Void {
        UserDefaults.standard.set(control.value, forKey: "mctsExplorationCoefficient")
        
        let value = Float(round(UserDefaults.standard.float(forKey: "mctsExplorationCoefficient")*100)/100)
        //let value = Float(round(control.value*100)/100)
        self.explorationCoefficientMaximumValueLabel.text = String(value)
        self.explorationCoefficientSlider.maximumValueImage = UIImage.imageWithLabel(label: self.explorationCoefficientMaximumValueLabel)
        //UserDefaults.standard.set(value, forKey: "mctsExplorationCoefficient")
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
