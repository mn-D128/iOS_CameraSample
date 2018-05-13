//
//  DLBWrapper.h
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "DLBFace.h"

@interface DLBWrapper : NSObject

+ (instancetype)    shared;

- (void)    setShapePredictor:(NSString *)path;
- (NSArray<DLBFace *> *) detectFaces:(UIImage *)image
                 metadataFaceObjects:(NSArray<AVMetadataFaceObject *> *)metadataFaceObject;

@end
