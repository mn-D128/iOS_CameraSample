//
//  DLBWrapper.m
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

#include <opencv2/opencv.hpp>

#include "dlib/opencv.h"
#include "dlib/image_processing/frontal_face_detector.h"
#include "dlib/image_processing.h"
//#import "dlib/image_transforms/segment_image.h"
//#import "dlib/image_transforms/segment_image_abstract.h"
//#import "dlib/matrix/matrix_exp_abstract.h"

#import "DLBWrapper.h"

using namespace std;

static DLBWrapper *sDLBWrapperInstance = nil;

@implementation DLBWrapper {
    dlib::frontal_face_detector detector;
    dlib::shape_predictor predictor;
}

+ (instancetype)    shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDLBWrapperInstance = [[DLBWrapper alloc] init];
    });

    return sDLBWrapperInstance;
}

- (instancetype)    init {
    self = [super init];
    if (self) {
        detector = dlib::get_frontal_face_detector();
    }

    return self;
}

// MARK: - Public

- (void)    setShapePredictor:(NSString *)path {
    const char *cPath = path.UTF8String;
    dlib::deserialize(cPath) >> predictor;
}

- (cv::Mat) createCVMat:(UIImage *)image {
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width * image.scale;
    CGFloat rows = image.size.height * image.scale;
    
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    cvMat.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (NSArray<DLBFace *> *) detectFaces:(UIImage *)image
                 metadataFaceObjects:(NSArray<AVMetadataFaceObject *> *)metadataFaceObjects {
    CGFloat w = image.size.width * image.scale;
    CGFloat h = image.size.height * image.scale;

    cv::Mat rgbaMat = [self createCVMat:image];
    cv::Mat rgbMat = cv::Mat(w, h, CV_8UC3);
    cv::cvtColor(rgbaMat, rgbMat, CV_RGBA2RGB, 3);

    dlib::cv_image<dlib::bgr_pixel> cvImage(rgbMat);

//    vector<dlib::rectangle> faces = detector(cvImage);
    
    NSMutableArray<DLBFace *> *result = [NSMutableArray array];
    
    for (AVMetadataFaceObject *faceObject in metadataFaceObjects) {
        CGRect rect = faceObject.bounds;
        CGRect area = CGRectMake(rect.origin.y * w,
                                 rect.origin.x * h,
                                 rect.size.height * w,
                                 rect.size.width * h);
//        CGRect area = CGRectMake(rect.origin.x * w,
//                                 rect.origin.y * h,
//                                 rect.size.width * w,
//                                 rect.size.height * h);
        
        long left = (long)roundf(area.origin.x);
        long top = (long)roundf(area.origin.y);
        long right = (long)roundf(CGRectGetMaxX(area));
        long bottom = (long)roundf(CGRectGetMaxY(area));
        
        // l t r b
        dlib::rectangle face = dlib::rectangle(left, top, right, bottom);
        
        auto shape = predictor(cvImage, face);

        // facial shape
        NSMutableArray<NSValue *> *parts = [NSMutableArray array];
        for (auto i = 0; i < shape.num_parts(); i++) {
            auto r = shape.part(i);
            [parts addObject:[NSValue valueWithCGPoint:CGPointMake(r.x(), r.y())]];
        }

        DLBFace *dlbFace = [[DLBFace alloc] initWithArea:area
                                                   parts:parts];
        [result addObject:dlbFace];
    }

//    for (auto face: faces) {
//        // facial rect
//        auto shape = predictor(cvImage, face);
//        auto r = shape.get_rect();
//        CGRect area = CGRectMake(r.left(), r.top(), r.width(), r.height());
//
//        // facial shape
//        NSMutableArray<NSValue *> *parts = [NSMutableArray array];
//        for (auto i = 0; i < shape.num_parts(); i++) {
//            auto r = shape.part(i);
//            [parts addObject:[NSValue valueWithCGPoint:CGPointMake(r.x(), r.y())]];
//        }
//
//        DLBFace *dlbFace = [[DLBFace alloc] initWithArea:area
//                                                   parts:parts];
//        [result addObject:dlbFace];
//    }
    
    return result;
}

@end
