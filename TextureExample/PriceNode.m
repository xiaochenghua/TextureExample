//
//  PriceNode.m
//  TextureExample
//
//  Created by chenghua on 2021/8/17.
//

#import "PriceNode.h"
#import "UIImage+Additions.h"

@interface PriceNode ()

@property (nonatomic, strong) ASTextNode2 *sellingPriceNode;
@property (nonatomic, strong) ASTextNode *originalPriceNode;
@property (nonatomic, strong) ASButtonNode *addInNode;
@property (nonatomic, copy) void(^addInTouchedBlock)(NSString *);

@end

@implementation PriceNode

- (instancetype)init {
    if (self = [super init]) {
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)addInDidTouched:(ASButtonNode *)sender {
    if (self.addInTouchedBlock) {
        self.addInTouchedBlock(self.sellingPriceNode.attributedText.string);
    }
}

- (void)setNode:(id<CardCellNodeDataProtocol>)data {
    self.sellingPriceNode.attributedText = data.sellingPrice;
    self.originalPriceNode.attributedText = data.originalPrice;
    self.originalPriceNode.hidden = data.originalPrice.string.length == 0;
    self.addInTouchedBlock = data.onSelected;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSMutableArray<id<ASLayoutElement>> *children = [NSMutableArray array];
    [children addObject:self.sellingPriceNode];
    self.sellingPriceNode.style.flexShrink = 1;
    
    if (!self.originalPriceNode.hidden) {
        [children addObject:self.originalPriceNode];
        
        self.originalPriceNode.style.flexGrow = 1;
        self.originalPriceNode.style.flexShrink = 1;
    } else {
        self.sellingPriceNode.style.flexGrow = 1;
    }
    
    [children addObject:self.addInNode];
    
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                   spacing:6
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsCenter
                                                  children:children];
}

- (void)layoutDidFinish {
    [super layoutDidFinish];
    
    
    CGSize addInSize = [self.addInNode calculatedSize];
    UIImage *addInImage = [[UIImage imageWithColor:[UIColor redColor] size:addInSize] imageWithCornerRadius:addInSize.height/2];
    [self.addInNode setBackgroundImage:addInImage forState:UIControlStateNormal];
}

- (ASTextNode2 *)sellingPriceNode {
    if (!_sellingPriceNode) {
        _sellingPriceNode = [ASTextNode2 new];
        _sellingPriceNode.maximumNumberOfLines = 1;
        _sellingPriceNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return _sellingPriceNode;
}

- (ASTextNode *)originalPriceNode {
    if (!_originalPriceNode) {
        _originalPriceNode = [ASTextNode new];
        _originalPriceNode.maximumNumberOfLines = 1;
        _originalPriceNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return _originalPriceNode;
}

- (ASButtonNode *)addInNode {
    if (!_addInNode) {
        _addInNode = [ASButtonNode new];
        [_addInNode setAttributedTitle:[[NSAttributedString alloc] initWithString:@"加入购物车" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName: [UIColor whiteColor],
        }] forState:UIControlStateNormal];
        _addInNode.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [_addInNode addTarget:self action:@selector(addInDidTouched:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _addInNode;
}

@end
