//
//  MapViewController.swift
//  DroPick
//
//  Created by y-okada on 2017/02/18.
//  Copyright © 2017年 dhythm. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import ObjectMapper
import MapKit

final class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    let margin: CGFloat  = 200
    
    // area
    var marginT: CGFloat!
    var marginR: CGFloat!
    var marginB: CGFloat!
    var marginL: CGFloat!
    
    // GoogleMap
    var lm = CLLocationManager()
    var currentDisplayedPosition: GMSCameraPosition?
    var latitude:   CLLocationDegrees!
    var longitude:  CLLocationDegrees!
    var center:     CLLocationCoordinate2D!
    var googleMap:  GMSMapView!
   
    // User icon
    let uiWidth: CGFloat  = 80
    let uiHeight: CGFloat = 80
    
    // Search Condtion
    let clMarginL: CGFloat = 20
    let clWidth: CGFloat   = 200
    let clHeight: CGFloat  = 30
    
    // settingButton
    private var settingButton: UIButton!
    let sbWidth: CGFloat  = 60
    let sbHeight: CGFloat = 60
    let sbMarginR: CGFloat = 10
    let sbMarginB: CGFloat = 10

    // comment label
    private var comment: UILabel!
    
    // Selected Car Image
    private var imageView: UIImageView!
    let ciWidth: CGFloat  = 100
    let ciHeight: CGFloat = 100
    
    // nextButton
    private var nextButton: UIButton!
    let nbWidth: CGFloat  = 200
    let nbHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor(red:240/255,green:248/255,blue:255/255,alpha:1)

        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        // 位置情報サービスを開始するかの確認
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
            lm.requestAlwaysAuthorization()
        }
        
        // 初期化
        initLocationManager()
        latitude  = CLLocationDegrees()
        longitude = CLLocationDegrees()
        print("lat:\(latitude), lng:\(longitude)")
        
        // set value to variable
        marginT = appDelegate._marginTop
        
        // Get Maps from GoogleMap
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: appDelegate.zoom)
        googleMap = GMSMapView(frame:CGRect(x:0,y:margin/2.0,width:self.view.bounds.width,height:self.view.bounds.height - margin))
        googleMap.camera = camera
        googleMap.isMyLocationEnabled = true
        //googleMap.settings.myLocationButton = true
        self.view.addSubview(googleMap)

        // タップイベントを検知するために必要
        self.googleMap.delegate = self

        
        let iconView: UIImageView = UIImageView(frame:CGRect(x:0,y:statusBarHeight,width:uiWidth,height:uiHeight))
        let userImage: UIImage = UIImage(named:"icon")!
        let c1Label: UILabel = UILabel(frame:CGRect(x:uiWidth + clMarginL,y:statusBarHeight + 10,width:clWidth,height:clHeight))
        let c2Label: UILabel = UILabel(frame:CGRect(x:uiWidth + clMarginL,y:statusBarHeight + 10 + clHeight,width:clWidth,height:clHeight))
        settingButton = UIButton()
        settingButton.frame = CGRect(x:self.view.bounds.width - sbWidth - sbMarginR,y:margin/2.0 - sbHeight - sbMarginB,width:sbWidth,height:sbHeight)
        comment = UILabel(frame:CGRect(x: 0,y:self.view.bounds.height - ciHeight,width:self.view.bounds.width,height:ciHeight))
        
        // ユーザーのアイコンを表示
        iconView.image = userImage
        
        // 検索条件ラベル
        c1Label.text = "料金：" + appDelegate._fee! + "円/分 以下"
        c2Label.text = "人数：" + appDelegate._passenger! + " 以上"

        // 設定ボタン
        settingButton.setImage(UIImage(named:"gear")!, for: .normal)
        settingButton.tag = 1
        settingButton.addTarget(self, action: #selector(onClickButton(sender:)), for: .touchUpInside)
        
        // 選択推奨コメント
        comment.text = "車を選択してください"
        comment.textAlignment = NSTextAlignment.center
        
        // 選択した車の画像を表示
        imageView = UIImageView(frame:CGRect(x:0,y:self.view.bounds.height - ciHeight,width:ciWidth,height:ciHeight))
        let carImage: UIImage = UIImage(named:"vitz")!
        imageView.image = carImage
        
        // 決定ボタン
        nextButton = UIButton()
        nextButton.frame = CGRect(x:(self.view.bounds.width + ciWidth - nbWidth)/2.0,y:self.view.bounds.height - (ciHeight + nbHeight)/2.0,width:nbWidth,height:nbHeight)
        //nextButton.backgroundColor = UIColor(red:192/255,green:192/255,blue:192/255,alpha:1)
        nextButton.backgroundColor = UIColor.red
        
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius  = 20.0
        
        nextButton.setTitle("次へ", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle("次へ", for: .highlighted)
        nextButton.setTitleColor(UIColor.black, for: .highlighted)
        nextButton.tag = 2
        nextButton.addTarget(self, action: #selector(onClickButton(sender:)), for: .touchUpInside)

        
        comment.isHidden = false; imageView.isHidden = true; nextButton.isHidden = true;
        self.view.addSubview(iconView)
        self.view.addSubview(c1Label)
        self.view.addSubview(c2Label)
        self.view.addSubview(settingButton)
        self.view.addSubview(comment)
        self.view.addSubview(imageView)
        self.view.addSubview(nextButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面をロードする前に呼ばれるメソッド
    override func viewWillAppear(_ animated: Bool){
        // NavigationBarを隠す
        self.navigationController?.setNavigationBarHidden(true,animated: true)
    }
    
    func initLocationManager(){
        print("--- initialize LocationManager.")
        /* Background周りの処理はあとまわし
        if #available(iOS 9.0, *){
            lm.allowsBackgroundLocationUpdates = true
        }
        */
        lm.delegate = self
        lm.distanceFilter = appDelegate.distancefilter
        // NSLocationAlwaysUsageDescriptionをinfo.plistに追加
        lm.startUpdatingLocation()
    }
    // 座標取得に失敗時の処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("--- Error: getting Location failed.")
    }
    // 座標取得時の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("--- Success: getting Location succeeded.")
        latitude  = locations.first?.coordinate.latitude
        longitude = locations.first?.coordinate.longitude
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: appDelegate.zoom)
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        self.googleMap.animate(to: camera)
        //googleMap.clear()
        
        // ダミーマーカーのセット
        putDummyMarker(latitude: latitude, longitude: longitude)
        
    }
    
    // ボタン押下時の遷移処理
    internal func onClickButton(sender: UIButton){
        switch (sender.tag) {
        case 1:
            let transitViewController: UIViewController = SettingViewController()
            // 遷移アニメーション:.coverVertical/.crossDissolve/.flipHorizontal/.partialCurl
            //transitViewController.modalTransitionStyle = .partialCurl
            //self.present(transitViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(transitViewController, animated: true)
        case 2:
            let transitViewController: UIViewController = SelectCarViewController()
            self.navigationController?.pushViewController(transitViewController, animated: true)
        default:
            print("error")
        }
    }

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("--- Catch the event of marker tapping.")
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        
        comment.isHidden = true; imageView.isHidden = false; nextButton.isHidden = false;
        
        return true
    }
    
    // dummy marker
    private func putDummyMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        print("--- Start putDummyMarker.")
        let r: Double = 6378150
        var dt_lat = 360/(2*M_PI*r)
        var dt_lng = 360/(2*M_PI*r*cos(M_PI*longitude/180))
    
        let dm1 = GMSMarker()
        let dm2 = GMSMarker()
        let dm3 = GMSMarker()
        dm1.position = CLLocationCoordinate2D(latitude: latitude + 100*dt_lat, longitude: longitude + 150*dt_lng)
        dm2.position = CLLocationCoordinate2D(latitude: latitude - 170*dt_lat, longitude: longitude + 120*dt_lng)
        dm3.position = CLLocationCoordinate2D(latitude: latitude - 220*dt_lat, longitude: longitude - 150*dt_lng)
        dm1.map = self.googleMap; dm2.map = self.googleMap; dm3.map = self.googleMap;
    }
    
}

