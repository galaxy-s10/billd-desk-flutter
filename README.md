<p align="center">
  <a href="https://live.hsslive.cn" target="_blank">
    <img
      width="200"
      src="https://resource.hsslive.cn/billd-live/image/240160ddbc14367f7e0126c1f5b09b69.svg"
      alt="logo"
    />
  </a>
</p>

<h1 align="center">
  Billd-Live-Flutter
</h1>

<p align="center">
  基于Flutter + WebRTC搭建的直播间
</p>

## 简介

billd 直播间，可以看直播和发布直播。

## 功能

- [x] 看直播
- [x] 开直播（前/后摄像头、录屏）
- [x] 用户模块

## 预览

### 首页

<img
  src="https://resource.hsslive.cn/billd-live/image/96638e70dc4c827debed39e3b30e2c3a.webp" 
  style="width:400px"
/>

### 我的

<img
  src="https://resource.hsslive.cn/billd-live/image/3a777718d31f94e6d25071d29f5e5185.webp" 
  style="width:300px"
/> <img
  src="https://resource.hsslive.cn/billd-live/image/e785bc308c2d24460baf36f65aa39c5e.webp" 
  style="width:300px"
/>

### 直播中心

<img
  src="https://resource.hsslive.cn/billd-live/image/5c4a77047bb154b0071ad6d8368ae26c.webp" 
  style="width:300px"
/> <img
  src="https://resource.hsslive.cn/billd-live/image/0403ca61c28330282f8d8db9da9b9f06.webp" 
  style="width:300px"
/>

## 环境

```sh
➜  billd-live-flutter git:(master) ✗ flutter --version
Flutter 3.19.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ba39319843 (2 weeks ago) • 2024-03-07 15:22:21 -0600
Engine • revision 2e4ba9c6fb
Tools • Dart 3.3.1 • DevTools 2.31.1
➜  billd-live-flutter git:(master) ✗ dart --version
Dart SDK version: 3.3.1 (stable) (Wed Mar 6 13:09:19 2024 +0000) on "macos_arm64"
➜  billd-live-flutter git:(master) ✗
```

## 接口

[https://live-api.hsslive.cn](https://live-api.hsslive.cn)

## 调试

```sh
flutter pub get
```

## 打包

### 安卓

```sh
flutter build apk --release
```

### 苹果（TODO）

```sh
flutter build ipa --release
```
