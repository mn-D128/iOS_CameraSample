//
//  DLBFace.h
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLBPartPosition) {
    // 顔の輪郭
    DLBPartPositionContourStart = 0,
    DLBPartPositionContourEnd = 16,
    // 左の眉毛
    DLBPartPositionEyebrowsLeftStart = 17,
    DLBPartPositionEyebrowsLeftEnd = 21,
    // 右の眉毛
    DLBPartPositionEyebrowsRightStart = 22,
    DLBPartPositionEyebrowsRightEnd = 26,
    // 鼻
    DLBPartPositionNoseStart = 27,
    DLBPartPositionNoseEnd = 35,
    // 左の目
    DLBPartPositionEyeLeftStart = 36,
    DLBPartPositionEyeLeftEnd = 41,
    // 右の目
    DLBPartPositionEyeRightStart = 42,
    DLBPartPositionEyeRightEnd = 47,
    // 上唇
//    DLBPartPositionUpperLipUpStart = 48,
//    DLBPartPositionUpperLipUpEnd = 54,
//    DLBPartPositionUpperLipDownStart = 48,
//    DLBPartPositionUpperLipDownEnd = 47,
    // 下唇
};

@interface DLBFace : NSObject

@property (nonatomic, readonly) CGRect area;
@property (nonatomic, strong, readonly) NSArray<NSValue *> *parts;

- (instancetype)    initWithArea:(CGRect)area parts:(NSArray<NSValue *> *)parts;

@end
