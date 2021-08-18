//
//  CardCellNode.m
//  TextureExample
//
//  Created by chenghua on 2021/8/16.
//

#import "CardCellNode.h"
#import "PriceNode.h"
#import "UIImage+Additions.h"

@interface CardCellNodeData ()

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSAttributedString *title;
@property (nonatomic, copy, nullable) NSAttributedString *desc;
@property (nonatomic, copy, nullable) NSArray<NSString *> *tags;
@property (nonatomic, copy) NSAttributedString *sellingPrice;
@property (nonatomic, copy, nullable) NSAttributedString *originalPrice;
@property (nonatomic, copy) void(^onSelected)(NSString *);

@end

@implementation CardCellNodeData

+ (instancetype)dataWithImageUrl:(NSString *)imageUrl title:(NSString *)title desc:(NSString *)desc tags:(NSArray<NSString *> *)tags sellingPrice:(NSString *)sellingPrice originalPrice:(NSString *)originalPrice onSelected:(void (^)(NSString * _Nonnull))onSelected {
    CardCellNodeData *data = [[self alloc] init];
    data.imageUrl = imageUrl;
    data.title = [[NSAttributedString alloc] initWithString:title attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightBold],
        NSForegroundColorAttributeName: [UIColor darkTextColor],
    }];
    
    if (desc.length) {
        data.desc = [[NSAttributedString alloc] initWithString:desc attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightLight],
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
    }
    
    data.tags = tags;
    data.sellingPrice = [[NSAttributedString alloc] initWithString:sellingPrice attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor redColor],
    }];
    
    if (originalPrice.length) {
        data.originalPrice = [[NSAttributedString alloc] initWithString:originalPrice attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium],
            NSForegroundColorAttributeName: [UIColor grayColor],
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
            NSStrikethroughColorAttributeName: [UIColor grayColor],
        }];
    }
    
    data.onSelected = onSelected;
    return data;
}

@end

@interface CardCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode2 *titleNode;
@property (nonatomic, strong) ASTextNode2 *subTitleNode;
@property (nonatomic, strong) NSMutableArray<ASButtonNode *> *tags;
@property (nonatomic, strong) PriceNode *priceNode;

@end

@implementation CardCellNode

- (instancetype)init {
    if (self = [super init]) {
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)setCardCellNode:(id<CardCellNodeDataProtocol>)data {
    // normal setting
    self.imageNode.URL = [NSURL URLWithString:data.imageUrl];
    self.titleNode.attributedText = data.title;
    self.subTitleNode.attributedText = data.desc;

    // nullable
    self.subTitleNode.hidden = data.desc.length == 0;
    
    // tags
    [self setUpTags:data.tags];
    
    // sub node
    [self.priceNode setNode:data];
}

- (void)setUpTags:(NSArray<NSString *> *)tags {
    if (!tags.count) return;
    for (NSString *tag in tags) {
        ASButtonNode *tagNode = [ASButtonNode new];
        [tagNode setAttributedTitle:[[NSAttributedString alloc] initWithString:tag attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:10 weight:UIFontWeightRegular],
            NSForegroundColorAttributeName: UIColor.whiteColor,
        }] forState:UIControlStateNormal];
        tagNode.contentEdgeInsets = UIEdgeInsetsMake(1, 2, 1, 2);
        [self addSubnode:tagNode];
        [self.tags addObject:tagNode];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSMutableArray<id<ASLayoutElement>> *children = [NSMutableArray arrayWithArray:@[self.titleNode]];
    
    if (!self.subTitleNode.hidden) {
        [children addObject:self.subTitleNode];
    }
    
    if (self.tags.count) {
        NSArray *tags = self.tags.count <= 3 ? self.tags : [self.tags subarrayWithRange:NSMakeRange(0, 3)];
        [children addObject:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                    spacing:4
                                                             justifyContent:ASStackLayoutJustifyContentStart
                                                                 alignItems:ASStackLayoutAlignItemsCenter
                                                                   children:tags]];
    }
    
    ASStackLayoutSpec *rightTopSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:5
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsStart
                                                                             children:children];
    
    ASStackLayoutSpec *rightSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:25
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[rightTopSpec, self.priceNode]];
    
    CGSize imageSize = CGSizeMake(110, 110);
    UIEdgeInsets rightInsets = UIEdgeInsetsMake(20, 0, 20, 0);
    UIEdgeInsets overInsets = UIEdgeInsetsMake(10, 16, 10, 16);
    CGFloat spacing = 12;
    
    CGFloat width = constrainedSize.max.width - imageSize.width - overInsets.left - overInsets.right - rightInsets.left - rightInsets.right - spacing;
    if (width > 0) {
        self.priceNode.style.width = ASDimensionMake(width);
    }
    
    self.imageNode.style.preferredSize = imageSize;
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:rightInsets child:rightSpec];
    
    insetSpec.style.flexGrow = 1.0;
    insetSpec.style.flexShrink = 1.0;
    
    ASStackLayoutSpec *imageSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:spacing
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[self.imageNode, insetSpec]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:overInsets child:imageSpec];
}

- (void)layoutDidFinish {
    [super layoutDidFinish];
    
    for (ASButtonNode *tagNode in self.tags) {
        CGSize tagSize = [tagNode calculatedSize];
        UIImage *tagImage = [[UIImage imageWithColor:[UIColor redColor] size:tagSize] imageWithCornerRadius:2.5];
        [tagNode setBackgroundImage:tagImage forState:UIControlStateNormal];
    }
}

- (ASNetworkImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [ASNetworkImageNode new];
    }
    return _imageNode;
}

- (ASTextNode2 *)titleNode {
    if (!_titleNode) {
        _titleNode = [ASTextNode2 new];
        _titleNode.maximumNumberOfLines = 1;
        _titleNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return _titleNode;
}

- (ASTextNode2 *)subTitleNode {
    if (!_subTitleNode) {
        _subTitleNode = [ASTextNode2 new];
        _subTitleNode.maximumNumberOfLines = 1;
        _subTitleNode.truncationMode = NSLineBreakByTruncatingTail;
    }
    return _subTitleNode;
}

- (NSMutableArray<ASButtonNode *> *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (PriceNode *)priceNode {
    if (!_priceNode) {
        _priceNode = [PriceNode new];
    }
    return _priceNode;
}

@end
