//
//  TableNodeController.m
//  TextureExample
//
//  Created by chenghua on 2021/8/16.
//

#import "TableNodeController.h"
#import "CardCellNode.h"

@interface TableNodeController () <ASTableDataSource, ASTableDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, copy) NSArray<id<CardCellNodeDataProtocol>> *dataSource;
@property (nonatomic, copy) void(^onSelectedBlock)(NSString *);

@end

@implementation TableNodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    __weak typeof(self) weakSelf = self;
    self.onSelectedBlock = ^(NSString *message) {
        __strong typeof(weakSelf) self = weakSelf;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
//    [self.view addSubnode:self.node];
//    self.tableNode.view.tableFooterView = [UIView new];
    [self.view addSubnode:self.tableNode];
//    [self.node addSubnode:self.tableNode];
    
    // Observer
//    [self.tableNode addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [self.tableNode.view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@ %@ %@",NSStringFromClass([object class]), keyPath, change[NSKeyValueChangeNewKey]);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableNode.frame = self.view.bounds;
}

#pragma mark - ASTableDataSource

//- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
//    return 1;
//}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

/// This will be called on the main thread
//- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
//    id<CardCellNodeDataProtocol> data = self.dataSource[indexPath.item];
//    NSLog(@"-----%@%@------", NSStringFromSelector(_cmd), [NSThread currentThread]);
//    CardCellNode *cellNode = [CardCellNode new];
//    [cellNode setCardCellNode:data];
//    return cellNode;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/// ASCellNodeBlock must be thread-safe (can be called on the main thread or a background queue
- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<CardCellNodeDataProtocol> data = self.dataSource[indexPath.item];
    return ^ASCellNode *() {
        NSLog(@"-----%@%@------", NSStringFromSelector(_cmd), [NSThread currentThread]);
        CardCellNode *cellNode = [CardCellNode new];
        [cellNode setCardCellNode:data];
        return cellNode;
    };
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    id<CardCellNodeDataProtocol> data = self.dataSource[indexPath.item];
    
    if (data.onSelected) {
        data.onSelected(data.title.string);
    }
}

#pragma mark - properties

- (ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.dataSource = self;
        _tableNode.delegate = self;
    }
    return _tableNode;
}

- (NSArray<id<CardCellNodeDataProtocol>> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
            [CardCellNodeData dataWithImageUrl:@"https://img13.360buyimg.com/mobilecms/s220x220_jfs/t1/198506/1/2638/127706/61136759E5e61aa4d/0ae4b9022d1c282d.jpg!cc_220x220!q70.dpg.webp"
                                         title:@"让你受益一生的6本书"
                                          desc:@"前500名立减1元"
                                          tags:@[@"立减", @"满减"]
                                  sellingPrice:@"¥19.8"
                                 originalPrice:@"¥39.9"
                                    onSelected:self.onSelectedBlock],
            [CardCellNodeData dataWithImageUrl:@"https://img14.360buyimg.com/mobilecms/s220x220_jfs/t1/181658/36/16916/77206/61053dd1Ef6ea064b/37b33a00f8321d58.jpg!cc_220x220!q70.dpg.webp"
                                         title:@"轻松自救不伤手 汽车破窗逃生器"
                                          desc:@"水下逃生 1秒破窗"
                                          tags:@[@"促销"]
                                  sellingPrice:@"¥19.9"
                                 originalPrice:@"¥59.9"
                                    onSelected:self.onSelectedBlock],
            [CardCellNodeData dataWithImageUrl:@"https://img13.360buyimg.com/mobilecms/s220x220_jfs/t1/172378/15/11866/90202/60b0dd41Eecd3c8cf/bfdbe63c1c53ecea.jpg!cc_220x220!q70.dpg.webp"
                                         title:@"汰渍净白洗衣粉5kg"
                                          desc:@"爆款惊爆价"
                                          tags:@[@"京东自营"]
                                  sellingPrice:@"¥29.9"
                                 originalPrice:@"39.9"
                                    onSelected:self.onSelectedBlock],
        ];
    }
    return _dataSource;
}

@end
