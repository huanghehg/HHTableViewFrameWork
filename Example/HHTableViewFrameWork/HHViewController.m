//
//  HHViewController.m
//  HHTableViewFrameWork
//
//  Created by huanghehg on 08/31/2018.
//  Copyright (c) 2018 huanghehg. All rights reserved.
//

#import "HHViewController.h"
#import <HHTableViewFrameWork/HHTableViewManager.h>
#import <HHTableViewFrameWork/HHBaseSection.h>
#import "HHListViewModel.h"
#import "HHListHeaderViewModel.h"

@interface HHViewController ()

@property (nonatomic, strong)HHTableViewManager *manager;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    NSArray *array = @[
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(30)
                        },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(50)
                        },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(80)
                        },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                        },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           },
                       @{
                           @"title":@"test1",
                           @"detail":@"asjhdsfhdshhfshf",
                           @"height":@(100)
                           }
                       ];
    
    HHBaseSection *section = [[HHBaseSection alloc] init];
    HHListHeaderViewModel *headerViewModel = [[HHListHeaderViewModel alloc] init];
    headerViewModel.type = 1;
    section.bindHeaderViewModel = headerViewModel;
    
    HHListHeaderViewModel *footerViewModel = [[HHListHeaderViewModel alloc] init];
    footerViewModel.type = 2;
    section.bindFootererViewModel = footerViewModel;
    
    HHBaseSection *section2 = [[HHBaseSection alloc] init];
    
    for (NSDictionary *dic in array) {
        HHListViewModel *viewModel = [[HHListViewModel alloc] init];
        viewModel.title = dic[@"title"];
        viewModel.detail = dic[@"detail"];
        viewModel.height = [dic[@"height"] floatValue];
        [section2 addRow:viewModel];
    }
    [self.manager addSection:section];
    [self.manager addSection:section2];
    [self.manager reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.frame;
    }
    return _tableView;
}

- (HHTableViewManager *)manager {
    if (!_manager) {
        _manager = [[HHTableViewManager alloc] initWithTableView:self.tableView];
    }
    return _manager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
