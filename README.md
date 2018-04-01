# 智慧手套 Smart Gloves

相關連結：

- 程式碼（Github）：[ChiShengChen/2018makeNTU_meowmeow](https://github.com/ChiShengChen/2018makeNTU_meowmeow)

## 簡介

**「智慧手套 Smart Gloves」** 旨在取代鍵盤及滑鼠，成為下個世代的人機介面裝置，希望使用者能透過智慧手套，操控生活中的所有事物，例如：控制智慧家電、作為遊戲控制器、演奏虛擬樂器等。

技術上是在手套上配置了 2 個 **MPU6050 6 軸加速規陀螺儀**來量測手部姿態、及 4 個**電容式觸碰開關**作為客製化輸入，並用 **Linkit7697** 來蒐集sensor資料傳回雲端，在 **Microsoft Azure 雲端**上運算出手勢命令（目前使用 Python 跑 **SVM（支持向量機）演算法**，可匹配當下手勢命令和 training data），再回傳至欲控制的終端裝置（如智慧燈泡）。

這專案是我們參加 **[台大電機創客松 MakeNTU 2018](https://make.ntuee.org/)** ，在24小時兩天一夜內完成的prototype。

## Demo 影片

[![智慧手套 Smart Gloves DEMO for 2018 台大電機創客松 MakeNTU](https://img.youtube.com/vi/IuPLv4no5wM/0.jpg)](https://www.youtube.com/watch?v=IuPLv4no5wM)

[智慧手套 Smart Gloves DEMO for 2018 台大電機創客松 MakeNTU - Youtube](https://youtu.be/IuPLv4no5wM)

## DEMO 簡報

https://www.slideshare.net/ssuser524a9d/smart-gloves-for-2018-makentu

## 應用情境

- 職能治療輔具
- 智慧家庭控制
- 遊戲控制器
- 空氣樂器演奏
- 人機介面操作
- ...

## 系統架構

程式碼（Github）：[ChiShengChen/2018makeNTU_meowmeow](https://github.com/ChiShengChen/2018makeNTU_meowmeow)

內含：
- 各種sensor測試用 Arduino code
- 逐步演進的智慧手套 Arduino code
- Processing 串接、資料視覺化 code
- Python Scikit-learn SVM code（forked from [federico-terzi/gesture-keyboard](https://github.com/federico-terzi/gesture-keyboard)）
- 開發中的code：螢幕滑鼠控制、樹莓派串接等

智慧手套系統架構圖：
![upload successful](https://imgur.com/xcY8aWq.png)

## 實體成品

智慧手套照片（手心），指尖裝有4個電容觸碰開關：
![upload successful](https://imgur.com/TczvrrE.png)


智慧手套照片（手背），食指指尖、手臂共裝2片 MPU6050 6 軸加速規陀螺儀，控制板使用Linkit7697：
![upload successful](https://imgur.com/ffcZ1zw.png)

Sensor資料視覺化（使用Processing寫成），即時呈現 MPU6050 raw data、換算後的姿態、觸碰開關狀態：
![upload successful](https://imgur.com/70Awpa1.png)

## 團隊成員

- 陳麒升、張書鳴、張楹翔、王毓愷
