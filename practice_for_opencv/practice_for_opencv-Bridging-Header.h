//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageConverter : NSObject
+(UIImage *)getBinaryImage:(UIImage *)image thresh:(float)thresh maxval:(float)maxval thresholdtype:(int)thresholdtype algorithmtype:(int)algorithmtype;
@end
