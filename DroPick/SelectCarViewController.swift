//
//  SelectCarViewController.swift
//  DroPick
//
//  Created by y-okada on 2017/02/25.
//  Copyright © 2017年 dhythm. All rights reserved.
//

import UIKit

class SelectCarViewController: UIViewController {
    
    // Selected Car Image
    let ciWidth: CGFloat  = 150
    let ciHeight: CGFloat = 150
    
    // Car Information
    private var carName: UILabel!
    private var carPassenger: UILabel!
    private var carFee: UILabel!
    private var carLoadage: UILabel!
    private var carEquipment: UILabel!
    private var distanceOfEmpty: UILabel!
    let clWidth: CGFloat  = 300
    let clHeight: CGFloat = 50
    let cdHeight: CGFloat = 100
    
    // pickButton
    private var pickButton: UIButton!
    let pbWidth: CGFloat  = 200
    let pbHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:240/255,green:248/255,blue:255/255,alpha:1)
        
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        // navigation view
        self.title = "車の情報"

        // Car Image
        // 選択した車の画像を表示
        let imageView: UIImageView = UIImageView(frame:CGRect(x:0,y:statusBarHeight + navBarHeight!,width:ciWidth,height:ciHeight))
        let carImage: UIImage = UIImage(named:"vitz")!
        imageView.image = carImage
        
        // Detail Information
        carName         = UILabel(frame:CGRect(x:ciWidth + 20,y:statusBarHeight + navBarHeight!             ,width:clWidth,height:clHeight))
        carPassenger    = UILabel(frame:CGRect(x:ciWidth + 20,y:statusBarHeight + navBarHeight! + 1*clHeight,width:clWidth,height:clHeight))
        carFee          = UILabel(frame:CGRect(x:ciWidth + 20,y:statusBarHeight + navBarHeight! + 2*clHeight,width:clWidth,height:clHeight))
        carLoadage      = UILabel(frame:CGRect(x:          20,y:statusBarHeight + navBarHeight! + 3*clHeight,width:clWidth,height:cdHeight))
        carEquipment    = UILabel(frame:CGRect(x:          20,y:statusBarHeight + navBarHeight! + 3*clHeight + 1*cdHeight,width:clWidth,height:cdHeight))
        distanceOfEmpty = UILabel(frame:CGRect(x:          20,y:statusBarHeight + navBarHeight! + 3*clHeight + 2*cdHeight,width:clWidth,height:cdHeight))
        carName.text            = "車種　：Vitz"
        carPassenger.text       = "人数　：５人乗り"
        carFee.text             = "料金　：10円/分"
        
        carLoadage.numberOfLines      = 2
        carLoadage.text               = "積載量\nスーツケース５個分"
        carEquipment.numberOfLines    = 4
        carEquipment.text             = "装備\nETC\niPhone充電器\nドライブレコーダー"
        distanceOfEmpty.numberOfLines = 2
        distanceOfEmpty.text          = "移動可能距離\n200km"
        
        // Pick Button
        pickButton = UIButton()
        pickButton.frame = CGRect(x:(self.view.bounds.width - pbWidth)/2.0,y:self.view.bounds.height - 2.0*pbHeight,width:pbWidth,height:pbHeight)
        pickButton.backgroundColor = UIColor.red
        pickButton.layer.masksToBounds = true
        pickButton.layer.cornerRadius  = 20.0
        
        pickButton.setTitle("Pick", for: .normal)
        pickButton.setTitleColor(UIColor.white, for: .normal)
        pickButton.setTitle("Pick", for: .highlighted)
        pickButton.setTitleColor(UIColor.black, for: .highlighted)
        pickButton.tag = 2
        //pickButton.addTarget(self, action: #selector(onClickButton(sender:)), for: .touchUpInside)

        self.view.addSubview(imageView)
        self.view.addSubview(carName)
        self.view.addSubview(carPassenger)
        self.view.addSubview(carFee)
        self.view.addSubview(carLoadage)
        self.view.addSubview(carEquipment)
        self.view.addSubview(distanceOfEmpty)

        self.view.addSubview(pickButton)
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
    
}

