//
//  CardCellNode.h
//  TextureExample
//
//  Created by chenghua on 2021/8/16.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CardCellNodeDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCellNodeData : NSObject <CardCellNodeDataProtocol>

+ (instancetype)dataWithImageUrl:(NSString *)imageUrl
                           title:(NSString *)title
                            desc:(nullable NSString *)desc
                            tags:(nullable NSArray<NSString *> *)tags
                    sellingPrice:(NSString *)sellingPrice
                   originalPrice:(nullable NSString *)originalPrice
                      onSelected:(void(^)(NSString *))onSelected;

@end

@interface CardCellNode : ASCellNode

- (void)setCardCellNode:(id<CardCellNodeDataProtocol>)data;

@end

NS_ASSUME_NONNULL_END
