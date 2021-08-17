//
//  PriceNode.h
//  TextureExample
//
//  Created by chenghua on 2021/8/17.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CardCellNodeDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PriceNode : ASDisplayNode

- (void)setNode:(id<CardCellNodeDataProtocol>)data;

@end

NS_ASSUME_NONNULL_END
