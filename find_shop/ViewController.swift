//
//  ViewController.swift
//  find_shop
//
//  Created by Yuya Aoki on 2020/03/23.
//  Copyright © 2020 Yuya Aoki. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate{
    var locationManager: CLLocationManager!
    var mapView: GMSMapView!
    //エラーが起きた際にメッセージを表示するラベル
    @IBOutlet weak var Error_title: UILabel!
    //選択された店を表示
    @IBOutlet weak var shop_label: UILabel!
    //選択された距離を表示
    @IBOutlet weak var select_distance_label: UILabel!
    //結果画面に配置する画像
    @IBOutlet weak var shop1_picture: UIImageView!
    @IBOutlet weak var shop2_picture: UIImageView!
    @IBOutlet weak var shop3_picture: UIImageView!
    //店名の入った配列（日本語）
    var japanese_shop_array = ["スターバックス","コンビニ","ガソリンスタンド","バー","ラーメン","タリーズコーヒー"]
    //店名の入った配列（英語　見栄えのために配置）
    var English_shop_array = ["Starbucks","Convenience Store","Gas Station","Bar","Ramen","Tullys coffee"]
    //距離の入った配列
    var distance_array = [2,5,8,10,20]
    //初期値の写真を指定する配列
    var first_array = ["staba1","bar2","tullys3"]
    //スターバックスの写真を指定する配列
    var starbucks_array = ["staba1","starbacks","staba2"]
    //ガソリンスタンドの写真を指定する配列
    var gas_array = ["gas1","gas2","gas3"]
    //バーの写真を指定する配列
    var bar_array = ["bar1","bar2","bar3"]
    //ラーメンの写真を指定する配列
    var ramen_array = ["ramen1","ramen2","ramen3"]
    //タリーズコーヒーの写真を指定する配列
    var tullys_array = ["tullys1","tullys2","tullys3"]
    //コンビニの写真を指定する配列
    var convenience_array = ["convenience1","convenience2","convenience3"]
    //Top_ViewControllerから代入される変数
    var selected_shop : String = ""
    //全画面のpickerが選択した列番号
    var picker_selected_distance : Int = 0
    //上記の配列から距離を代入する
    var selected_distance : Int = 0
    //https://qiita.com/wadaaaan/items/0de9bc4ee40c8fbf38f1参考
    func shop_list(shop : String){
        let urlString : String =  shop.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        selected_shop = urlString
    }
    
    //https://qiita.com/polunga/items/8cf8d10c5a9544091548参考
    let myFrameSize:CGSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        //結果画面に配置する画像を決める。
        decide_picture()
        //下記に記載　selected_shopとselected_distanceの値を決める。
        decide_shop_distance()
        //店が選択されていない場合必ずHTTP通信が失敗するようにする。
        if(selected_shop==""){
            selected_shop = "%%&"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            //公式ドキュメントより　現在の位置にカメラを合わせる
            let yourlocation = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13.0)
            let mapView = GMSMapView.map(withFrame: CGRect(x:0,y:0,width:myFrameSize.width,height:myFrameSize.height/2),camera:yourlocation)
            view.addSubview(mapView)
            //最背面でマップを表示
            self.view.sendSubviewToBack(mapView)
            //現在位置にアイコンを表示
            mapView.isMyLocationEnabled = true
            //ヤフーローカルサーチAPI
            let url="https://map.yahooapis.jp/search/local/V1/localSearch?cid=d8a23e9e64a4c817227ab09858bc1330&lat=" + String(latitude)+"&lon="+String(longitude)+"&dist="+String(selected_distance)+"&query="+selected_shop+"&appid=dj00aiZpPXlhZnRwSWY4TE8wbiZzPWNvbnN1bWVyc2VjcmV0Jng9NDU-&output=json&results=100"
            //Http通信を行います
            AF.request(url).responseJSON{ response in
                switch response.result{
                case .success(let value):
                    let get_json = JSON(value)
                    let get_feature = get_json["Feature"]
                    for (_,subJson):(String, JSON) in get_feature {
                        //ここから店名住所を取り出します。
                        let name = subJson["Name"].stringValue
                        let address = subJson["Property"]["Address"].stringValue
                        let coordinates = subJson["Geometry"]["Coordinates"].stringValue
                        let array = coordinates.split(separator: ",")
                        let real_ido = Double(array[1])
                        let real_keido = Double(array[0])
                        //取り出した緯度経度をマーカーにセットします。
                        let position = CLLocationCoordinate2D(latitude: real_ido!, longitude: real_keido!)
                        let marker = GMSMarker(position: position)
                        marker.title = name
                        marker.snippet = address
                        marker.map = mapView
                    }
                case .failure(_):
                    //失敗した際にラベルにエラーメッセージを表示する。
                    self.Error_title.text = "Error is occured.perhaps you didn't select any shop."
                    self.Error_title.backgroundColor = UIColor.green
                    self.select_distance_label.text = "Error!"
                    self.shop_label.text = "Error!"
                    
                }
            }
        }
    }
    //選択した店
    func decide_shop_distance(){
        //店を設定
        var i : Int = 0
        while i < japanese_shop_array.count{
            if(selected_shop == japanese_shop_array[i]){
                shop_list(shop: japanese_shop_array[i])
                shop_label.text = English_shop_array[i]
            }
            i = i + 1
        }
        //距離を設定
        var j : Int = 0
        while j < distance_array.count{
            if(picker_selected_distance == j){
                selected_distance = distance_array[j]
                select_distance_label.text = String(distance_array[j]) + "km"
            }
            j = j + 1
        }
    }
    //選択した店舗の画像を表示
    func decide_picture(){
        //初期値に設定する。
        var image1 = UIImage(named: first_array[0])
        var image2 = UIImage(named: first_array[1])
        var image3 = UIImage(named: first_array[2])
        //スターバックスが選択されたとき
        if(selected_shop == japanese_shop_array[0]){
            image1 = UIImage(named: starbucks_array[0])
            image2 = UIImage(named: starbucks_array[1])
            image3 = UIImage(named: starbucks_array[2])
        }
        //コンビニが選択されたとき
        else if(selected_shop == japanese_shop_array[1]){
            image1 = UIImage(named: convenience_array[0])
            image2 = UIImage(named: convenience_array[1])
            image3 = UIImage(named: convenience_array[2])
        }
        //ガソリンスタンドが選択されたとき
        else if(selected_shop == japanese_shop_array[2]){
            image1 = UIImage(named: gas_array[0])
            image2 = UIImage(named: gas_array[1])
            image3 = UIImage(named: gas_array[2])
        }
        //バーが選択されたとき
        else if(selected_shop == japanese_shop_array[3]){
            image1 = UIImage(named: bar_array[0])
            image2 = UIImage(named: bar_array[1])
            image3 = UIImage(named: bar_array[2])
        }
        //ラーメンが選択されたとき
        else if(selected_shop == japanese_shop_array[4]){
            image1 = UIImage(named: ramen_array[0])
            image2 = UIImage(named: ramen_array[1])
            image3 = UIImage(named: ramen_array[2])
        }
        //タリーズコーヒーが選択されたとき
        else if(selected_shop == japanese_shop_array[5]){
            image1 = UIImage(named: tullys_array[0])
            image2 = UIImage(named: tullys_array[1])
            image3 = UIImage(named: tullys_array[2])
        }
        //画像を配置
        shop1_picture.image = image1
        shop2_picture.image = image2
        shop3_picture.image = image3
    }
    
}

