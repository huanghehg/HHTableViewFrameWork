//
//  HHSectionViewProxy.h
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//
// headerView 或者 footerView 需要实现这个protocol

#import <Foundation/Foundation.h>
#import "HHSectionViewModelProxy.h"

@protocol HHSectionViewProxy <NSObject>
- (void)configViewWithViewModel:(id <HHSectionViewModelProxy>)viewModel;
+ (CGFloat)heightForViewWithViewModel:(id <HHSectionViewModelProxy>)viewModel;

@end
