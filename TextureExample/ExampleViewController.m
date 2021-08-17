//
//  ExampleViewController.m
//  TextureExample
//
//  Created by chenghua on 2021/8/14.
//

#import "ExampleViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ExampleViewController ()

@property (nonatomic, strong) ASDisplayNode *displayNode;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self view1Example];
//    [self view2Example];
    
    [self node1Example];
    [self node2Example];
}

- (void)view1Example {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
    UIView *view = [UIView new];
    view.frame = CGRectMake(10, 10, 150, 45);
    view.backgroundColor = UIColor.redColor;
    [self.view addSubview:view];
}

- (void)view2Example {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@: %@ - init", NSStringFromSelector(_cmd), [NSThread currentThread]);
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(170, 10, 150, 45);
        view.backgroundColor = UIColor.yellowColor;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@: %@ - add", NSStringFromSelector(_cmd), [NSThread currentThread]);
            [self.view addSubview:view];
        });
    });
}

- (void)node1Example {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), [NSThread currentThread]);
    ASDisplayNode *node = [ASDisplayNode new];
    node.frame = CGRectMake(10, 70, 150, 60);
    node.backgroundColor = UIColor.greenColor;
    [self.view addSubnode:node];
}

- (void)node2Example {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@: %@ - init", NSStringFromSelector(_cmd), [NSThread currentThread]);
        ASDisplayNode *node = [[ASDisplayNode alloc] init];
        node.frame = CGRectMake(170, 70, 150, 60);
        node.backgroundColor = UIColor.grayColor; // backend
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@: %@ - add", NSStringFromSelector(_cmd), [NSThread currentThread]);
            [self.view addSubnode:node]; // main
        });
    });
}

@end
