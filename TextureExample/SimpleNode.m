//
//  SimpleNode.m
//  TextureExample
//
//  Created by chenghua on 2021/8/14.
//

#import "SimpleNode.h"

@interface SimpleNode ()

@property (nonatomic, strong) ASDisplayNode *subNode;

@end

@implementation SimpleNode

/// 使用 nodeBlocks 时，在后台线程上调用此方法。
/// 但由于 -init 方法完成前不能执行其他方法，因此在此方法中永远不需要使用锁。
/// 要记住的最重要的事情是 -init 方法必须能够在任何队列上被调用。这意味着绝不能初始化任何UIKit对象、接触 node 的 view 或 layer。
/// 例如：node.layer.X或node.view.X。也不能添加任何手势识别器。这些应在 -didLoad 方法中执行。
- (instancetype)init {
    if (self = [super init]) {
        [self setUpSubnodes];
    }
    return self;
}


/// 此方法在概念上类似于UIViewController的 -viewDidLoad，只调用一次，且在 backing view 加载后调用。
/// 该方法在主线程中调用，适合于执行对UIKit的操作。例如：添加手势识别器，触摸视图、图层，初始化UIKit对象。
- (void)didLoad {
    [super didLoad];
//    self.subNode.frame = CGRectMake(0, 0, 100, 30);
    self.subNode.view.frame = CGRectMake(0, 0, 75, 30);
}

- (void)setUpSubnodes {
//    [self addSubnode:self.subNode];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ASDisplayNode *node = self.subNode;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self addSubnode:node];
        });
    });
}

- (ASDisplayNode *)subNode {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
    if (!_subNode) {
        _subNode = [ASDisplayNode new];
//        _subNode.frame = CGRectMake(0, 0, 100, 30);
        _subNode.backgroundColor = UIColor.orangeColor;
    }
    return _subNode;
}

@end
