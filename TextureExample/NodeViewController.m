//
//  NodeViewController.m
//  TextureExample
//
//  Created by chenghua on 2021/8/14.
//

#import "NodeViewController.h"
#import "MacroCons.h"
#import "SimpleNode.h"
#import "SpecNode.h"

@interface NodeViewController ()

@property (nonatomic, strong) SimpleNode *simpleNode;
@property (nonatomic, strong) SpecNode *specNode;

@end

@implementation NodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;

    [self node1Example];
    [self node2Example];
}

- (void)node1Example {
    [self.view addSubnode:self.simpleNode];
}

- (void)node2Example {
    [self.view addSubnode:self.specNode];
}

- (SimpleNode *)simpleNode {
    if (!_simpleNode) {
        _simpleNode = [[SimpleNode alloc] init];
        _simpleNode.frame = CGRectMake(16, 16, 200, 90);
        _simpleNode.backgroundColor = UIColor.purpleColor;
    }
    return _simpleNode;
}

- (SpecNode *)specNode {
    if (!_specNode) {
        _specNode = [[SpecNode alloc] init];
        _specNode.frame = CGRectMake(16, 120, ScreenWidth - 2 * 16, 100);
        _specNode.backgroundColor = UIColor.greenColor;
    }
    return _specNode;
}

@end
