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

@end
