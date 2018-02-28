//
//  SettingViewController.swift
//  DroPick
//
//  Created by y-okada on 2017/02/23.
//  Copyright © 2017年 dhythm. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIToolbarDelegate, UITextFieldDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var leftBtn: UIBarButtonItem!
    private var rightBtn: UIBarButtonItem!
    private var toolBarBtn: UIBarButtonItem!
    
    let tWidth: CGFloat   = 200
    let tHeight: CGFloat  = 30
    let pHeight: CGFloat  = 150 // 約5個表示
    let tbHeight: CGFloat = 40

    private var l_fee: UILabel!
    private var l_passenger: UILabel!
    private var l_range: UILabel!
    private var l_freeword: UILabel!

    private var fee: UITextField!
    private var passenger: UITextField!
    private var range: UITextField!
    private var freeword: UITextField!
    
    private var pickerToolBar: UIToolbar!

    private var picker: UIPickerView!
    private let pValues: NSArray = ["１人乗り","２人乗り","３人乗り","４人乗り","５人乗り","６人乗り","７人乗り","８人乗り","９人乗り"]
    private let rValues: NSArray = ["100m","200m","300m","400m","500m","600m","700m","800m","900m","1000m"]
    
    var dataList: NSArray = []
    var tagValue: Int!
    
    var posX: CGFloat!
    var posY: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:240/255,green:248/255,blue:255/255,alpha:1)
        
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height

        
        // navigation view
        self.title = "検索条件"
        
        leftBtn  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SettingViewController.onClickButton(sender:)))
        rightBtn = UIBarButtonItem(title:"完了",style:.plain, target: self, action: #selector(SettingViewController.onClickButton(sender:)))
        
        leftBtn.tag  = 1
        rightBtn.tag = 2
        
        self.navigationItem.leftBarButtonItem  = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        
        posX = (self.view.bounds.width - tWidth)/2
        posY = (self.view.bounds.height - tHeight)/2 - 160

        l_fee       = UILabel(frame: CGRect(x:posX,y:posY + tHeight*0,width:self.view.bounds.width,height:tbHeight))
        l_passenger = UILabel(frame: CGRect(x:posX,y:posY + tHeight*2,width:self.view.bounds.width,height:tbHeight))
        l_range     = UILabel(frame: CGRect(x:posX,y:posY + tHeight*4,width:self.view.bounds.width,height:tbHeight))
        l_freeword  = UILabel(frame: CGRect(x:posX,y:posY + tHeight*6,width:self.view.bounds.width,height:tbHeight))

        fee         = UITextField(frame: CGRect(x:posX,y:posY + tHeight*1,width:tWidth,height:tHeight))
        passenger   = UITextField(frame: CGRect(x:posX,y:posY + tHeight*3,width:tWidth,height:tHeight))
        range       = UITextField(frame: CGRect(x:posX,y:posY + tHeight*5,width:tWidth,height:tHeight))
        freeword    = UITextField(frame: CGRect(x:posX,y:posY + tHeight*7,width:tWidth,height:tHeight))
        
        l_fee.text       = "料金"
        l_passenger.text = "乗車人数"
        l_range.text     = "検索範囲"
        l_freeword.text  = "フリーワード"
        
        // 料金
        fee.placeholder = "料金"
        fee.text = appDelegate._fee
        fee.borderStyle = .roundedRect
        fee.clearButtonMode = .whileEditing

        // Picker settings
        pickerToolBar = UIToolbar(frame: CGRect(x:0,y:0,width:self.view.bounds.width,height:tbHeight))
        pickerToolBar.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        toolBarBtn = UIBarButtonItem(title:"完了",style:.plain,target:self,action: #selector(self.tappedToolBarBtn(sender:)))
        pickerToolBar.items = [toolBarBtn]

        picker = UIPickerView()
        picker.frame = CGRect(x:0,y:0,width:self.view.bounds.width,height:pHeight)
        picker.delegate = self
        picker.dataSource = self

        // 乗車人数
        passenger.placeholder = "乗車人数"
        passenger.text = appDelegate._passenger
        passenger.delegate = self
        passenger.tag = 1
        passenger.borderStyle = .roundedRect
        passenger.clearButtonMode = .whileEditing
        passenger.inputView = picker
        passenger.inputAccessoryView = pickerToolBar

        // 検索範囲
        range.placeholder = "検索範囲"
        range.delegate     = self
        range.tag = 2
        range.borderStyle = .roundedRect
        range.clearButtonMode = .whileEditing
        range.inputView = picker
        range.inputAccessoryView = pickerToolBar
        
        // フリーワード検索
        freeword.placeholder = "フリーワード"
        freeword.borderStyle = .roundedRect
        freeword.clearButtonMode = .whileEditing

        self.view.addSubview(l_fee)
        self.view.addSubview(l_passenger)
        self.view.addSubview(l_range)
        self.view.addSubview(l_freeword)

        self.view.addSubview(fee)
        self.view.addSubview(passenger)
        self.view.addSubview(range)
        self.view.addSubview(freeword)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面をロードする前に呼ばれるメソッド
    override func viewWillAppear(_ animated: Bool){
        // NavigationBarを表示する
        self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    
    internal func onClickButton(sender: UIButton){
        switch(sender.tag){
        case 1:
            self.view.backgroundColor = UIColor.blue
        case 2:
            appDelegate._fee = fee.text!
            appDelegate._passenger = passenger.text!
            let transitViewController: UIViewController = MapViewController()
            self.navigationController?.pushViewController(transitViewController, animated: true)
        default:
            print("error")
        }
    }
    
    // PickerView Setting
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dataList = textField.tag == 1 ? pValues : rValues
        tagValue = textField.tag
        picker.reloadAllComponents()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return pValues.count
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return pValues[row] as? String
        return dataList[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(tagValue) {
        case 1:
            passenger.text = pValues[row] as? String
        case 2:
            range.text = rValues[row] as? String
        default:
            print("error")
        }
    }
    
    // 「完了」ボタン押下時のメソッド
    func tappedToolBarBtn(sender: UIBarButtonItem){
        passenger.resignFirstResponder()
        range.resignFirstResponder()
    }
    
}
