//
//  UIImage+Additions.h
//  TextureExample
//
//  Created by chenghua on 2021/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
