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
    DLBPartPositionJawStart = 0,
    DLBPartPositionJawEnd = 16,
    // 左の眉毛
    DLBPartPositionLeftEyebrowsStart = 17,
    DLBPartPositionLeftEyebrowsEnd = 21,
    // 右の眉毛
    DLBPartPositionRightEyebrowsStart = 22,
    DLBPartPositionRightEyebrowsEnd = 26,
    // 鼻
    DLBPartPositionNoseStart = 27,
    DLBPartPositionNoseEnd = 35,
    // 左の目
    DLBPartPositionLeftEyeStart = 36,
    DLBPartPositionLeftEyeEnd = 41,
    // 右の目
    DLBPartPositionRightEyeStart = 42,
    DLBPartPositionRightEyeEnd = 47,
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

@property (nonatomic, readonly) CGFloat leftEyeOpeningDegree;
@property (nonatomic, readonly) CGFloat rightEyeOpeningDegree;

- (instancetype)    initWithArea:(CGRect)area parts:(NSArray<NSValue *> *)parts;

@end
