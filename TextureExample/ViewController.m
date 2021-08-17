//
//  ViewController.m
//  TextureExample
//
//  Created by chenghua on 2021/8/12.
//

#import "ViewController.h"
#import "ExampleViewController.h"
#import "NodeViewController.h"
#import "TableNodeController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSDictionary<NSString *, UIViewController*> *routers;

@property (nonatomic, copy) NSArray<NSString *> *allKeys;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Texture";
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.pageRouters.count;
    return self.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
//    cell.textLabel.text = self.pageRouters.allKeys[indexPath.row];
    cell.textLabel.text = self.allKeys[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIViewController *viewController = self.pageRouters.allValues[indexPath.row];
    NSString *key = self.allKeys[indexPath.row];
    UIViewController *viewController = self.routers[key];
    viewController.title = key;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(self.class)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray<NSString *> *)allKeys {
    if (!_allKeys) {
        _allKeys = [self.routers.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return _allKeys;
}

- (NSDictionary<NSString *,UIViewController *> *)routers {
    return @{
        @"1. UIView": [ExampleViewController new],
        @"2. Node": [NodeViewController new],
        @"3. TableNode": [TableNodeController new],
    };
}


@end
