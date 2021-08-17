//
//  CardCellNodeDataProtocol.h
//  TextureExample
//
//  Created by chenghua on 2021/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardCellNodeDataProtocol <NSObject>

@required
@property (nonatomic, copy, readonly) NSString *imageUrl;
@property (nonatomic, copy, readonly) NSAttributedString *title;
@property (nonatomic, copy, nullable, readonly) NSAttributedString *desc;
@property (nonatomic, copy, nullable, readonly) NSArray<NSString *> *tags;
@property (nonatomic, copy, readonly) NSAttributedString *sellingPrice;
@property (nonatomic, copy, nullable, readonly) NSAttributedString *originalPrice;
@property (nonatomic, copy, readonly) void(^onSelected)(NSString *);

@end

NS_ASSUME_NONNULL_END
