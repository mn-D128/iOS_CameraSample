//
//  DLBFace.m
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

#import "DLBFace.h"

@implementation DLBFace

- (instancetype)    initWithArea:(CGRect)area parts:(NSArray<NSValue *> *)parts {
    self = [super init];
    if (self) {
        _area = area;
        _parts = parts;
    }
    
    return self;
}

- (CGFloat) leftEyeOpeningDegree {
    CGFloat degree = MAX(self.parts[41].CGPointValue.y - self.parts[37].CGPointValue.y,
                         self.parts[40].CGPointValue.y - self.parts[38].CGPointValue.y);
    return degree;
}

- (CGFloat) rightEyeOpeningDegree {
    CGFloat degree = MAX(self.parts[47].CGPointValue.y - self.parts[43].CGPointValue.y,
                         self.parts[46].CGPointValue.y - self.parts[44].CGPointValue.y);
    return degree;
}

@end
