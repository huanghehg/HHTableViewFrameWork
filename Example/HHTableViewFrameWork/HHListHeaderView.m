//
//  HHListHeaderView.m
//  HHTableViewFrameWork_Example
//
//  Created by 黄河 on 01/09/2018.
//  Copyright © 2018 huanghehg. All rights reserved.
//

#import "HHListHeaderView.h"
#import "HHListHeaderViewModel.h"

@implementation HHListHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)configViewWithViewModel:(HHListHeaderViewModel *)viewModel {
    self.backgroundColor = viewModel.type == 1 ? [UIColor redColor] : [UIColor yellowColor];
}

+ (CGFloat)heightForViewWithViewModel:(HHListHeaderViewModel *)viewModel {
    return viewModel.type ==1 ? 200 : 100;
}

@end
