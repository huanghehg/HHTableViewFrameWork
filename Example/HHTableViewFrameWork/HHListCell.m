//
//  HHListCell.m
//  HHTableViewFrameWork_Example
//
//  Created by 黄河 on 31/08/2018.
//  Copyright © 2018 huanghehg. All rights reserved.
//

#import "HHListCell.h"
#import "HHListViewModel.h"

@implementation HHListCell

- (void)cellForInitalized {
    
}

- (void)configCellWithViewModel:(HHListViewModel *)viewModel {
    self.textLabel.text = viewModel.title;
    self.detailTextLabel.text = viewModel.detail;
}

+ (CGFloat)heightForCellWithViewModel:(HHListViewModel *)viewModel {
    return viewModel.height;
}

@end
