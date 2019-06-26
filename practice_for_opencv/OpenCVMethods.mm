//
//  OpenCVMethods.mm
//  practice_for_opencv
//
//  Created by 黃麒安 on 2019/6/25.
//  Copyright © 2019 黃麒安. All rights reserved.
//


#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "practice_for_opencv-Bridging-Header.h"
@implementation ImageConverter : NSObject

//Parameters
//https://docs.opencv.org/master/d7/d1b/group__imgproc__misc.html#gae8a4a146d1ca78c626a53577199e9c57
//src    input array (multiple-channel, 8-bit or 32-bit floating point).
//dst    output array of the same size and type and the same number of channels as src.
//thresh    threshold value.
//maxval    maximum value to use with the THRESH_BINARY and THRESH_BINARY_INV thresholding types.
//type    thresholding type (see ThresholdTypes).
+(UIImage *)getBinaryImage:(UIImage *)image thresh:(float)thresh maxval:(float)maxval thresholdtype:(int)thresholdtype algorithmtype:(int)algorithmtype{
    
    cv::ThresholdTypes thresholdtype1;
    cv::ThresholdTypes thresholdtype2;
    switch (thresholdtype) {
        case 0:
            thresholdtype1 = cv::THRESH_BINARY;
            break;
        case 1:
            thresholdtype1 = cv::THRESH_BINARY_INV;
            break;
        case 2:
            thresholdtype1 = cv::THRESH_TRUNC;
            break;
        case 3:
            thresholdtype1 = cv::THRESH_TOZERO;
            break;
        case 4:
            thresholdtype1 = cv::THRESH_TOZERO_INV;
            break;
        case 7:
            thresholdtype1 = cv::THRESH_MASK;
            break;
        default:
            thresholdtype1 = cv::THRESH_BINARY;
            break;
    }
    switch (algorithmtype) {
        case 1:
            thresholdtype2 = cv::THRESH_OTSU;
            break;
        case 2:
            thresholdtype2 = cv::THRESH_TRIANGLE;
            break;
        default:
            break;
    }
    
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    cv::Mat gray;
    cv::cvtColor(mat, gray, cv::COLOR_RGB2GRAY);
    
    cv::Mat bin;
    if (algorithmtype == 0) {
        cv::threshold(gray, bin, thresh, maxval, thresholdtype1);
    }else{
        cv::threshold(gray, bin, thresh, maxval, thresholdtype1 | thresholdtype2);
    }
    
    UIImage *binImg = MatToUIImage(bin);
    return binImg;
}
@end

