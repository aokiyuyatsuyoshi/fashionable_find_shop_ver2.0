# 仕様書
### 作者
青木優弥
### アプリ名
find_shop

#### コンセプト
お洒落に楽しいあなたの生活

#### こだわったポイント
- とにかくお洒落なデザインに拘りました。
- そして多くの人が使い慣れているGoogleMapを使用することで
使ってもらいやすいデザインにしました。
- 現在地からの半径を指定することによってユーザの移動も考えた
システム設計を目指しました。


### 該当プロジェクトのリポジトリ URL（GitHub,GitLab など Git ホスティングサービスを利用されている場合）
https://github.com/aokiyuyatsuyoshi/fashionable_find_shop_ver2.0

## 開発環境
### 開発環境
Version 11.3.1

### 開発言語
Swift 5.1.3

## 動作対象端末・OS
### 動作対象OS
ios 13.2

## アプリケーション機能

### 機能一覧

- 店舗選択 :　YahooローカルサーチAPIを使用して6つのジャンルから店舗を取得する。
- 距離選択 :　現在地からの距離を選択する。
- マップ上に表示 : GoogleMap上に各店舗の情報を表示する。


### 画面一覧
- 検索画面 ：店を選択し、現在地から表示する半径を選択する。
- 結果画面 ：GoogleMap上に検索条件に当てはまる店舗を表示する。

### 使用しているAPI,SDK,ライブラリなど
- GoogleMaps SDK for ios
- Yahooローカルサーチ API

- UIKit
- GoogleMaps
- Alamofire
- SwiftyJSON
- CoreLocation

### アドバイスして欲しいポイント
各店舗の写真などもタップした際に表示したいこと、さらにViewController内の関数decide_pictureをよりコードが少なく書きたいと考えております。

