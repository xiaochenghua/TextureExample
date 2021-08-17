//
//  SpecNode.m
//  TextureExample
//
//  Created by chenghua on 2021/8/14.
//

#import "SpecNode.h"
#import "UIImage+Additions.h"

@interface SpecNode ()

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode2 *nickNode;
@property (nonatomic, strong) ASTextNode2 *descNode;

@end

@implementation SpecNode

#pragma mark - initialization

- (instancetype)init {
    if (self = [super init]) {
        [self addSubnode:self.avatarNode];
        [self addSubnode:self.nickNode];
        [self addSubnode:self.descNode];
    }
    return self;
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSLog(@"%@-constrainedSize: %@ - %@", NSStringFromSelector(_cmd), NSStringFromCGSize(constrainedSize.min), NSStringFromCGSize(constrainedSize.max));
    
    self.avatarNode.style.preferredSize = CGSizeMake(40, 40);
    
    ASStackLayoutSpec *textSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                          spacing:6
                                                                   justifyContent:ASStackLayoutJustifyContentStart
                                                                       alignItems:ASStackLayoutAlignItemsStart
                                                                         children:@[self.nickNode, self.descNode]];
    
//    textSpec.style.flexGrow = 1;
    textSpec.style.flexShrink = 1;
    
    ASStackLayoutSpec *avatarSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:10
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsCenter
                                                                           children:@[self.avatarNode, textSpec]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 16, 0, 16) child:avatarSpec];
}

#pragma mark - lazy-properties

- (ASNetworkImageNode *)avatarNode {
    if (!_avatarNode) {
        _avatarNode = [[ASNetworkImageNode alloc] init];
        _avatarNode.URL = [NSURL URLWithString:@"https://img12.360buyimg.com/mobilecms/s220x220_jfs/t1/178981/32/5982/85420/60adeb6cE737e447c/96bb2ca6d30a999f.jpg!cc_220x220!q70.dpg.webp"];
        _avatarNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image, ASPrimitiveTraitCollection traitCollection) {
            return [image imageWithCornerRadius:image.size.height/2];
        };
    }
    return _avatarNode;
}

- (ASTextNode2 *)nickNode {
    if (!_nickNode) {
        _nickNode = [[ASTextNode2 alloc] init];
        _nickNode.maximumNumberOfLines = 1;
        _nickNode.truncationMode = NSLineBreakByTruncatingTail;
        _nickNode.attributedText = [[NSAttributedString alloc] initWithString:@"这是一个昵称" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightBold],
            NSForegroundColorAttributeName: [UIColor darkGrayColor],
        }];
    }
    return _nickNode;
}

- (ASTextNode2 *)descNode {
    if (!_descNode) {
        _descNode = [[ASTextNode2 alloc] init];
        _descNode.maximumNumberOfLines = 2;
        _descNode.truncationMode = NSLineBreakByTruncatingTail;
        _descNode.attributedText = [[NSAttributedString alloc] initWithString:@"城市套路深，我要回农村～城市套路深，我要回农村～超长文案" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
    }
    return _descNode;
}

@end
