//
//  HHCellViewProxy.h
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//
// cell 实现此protocol

#import <Foundation/Foundation.h>
#import "HHCellViewModelProxy.h"

@protocol HHCellViewProxy <NSObject>

/**
 cell 初始化
 */
- (void)cellForInitalized;
/**
 cell 填充数据

 @param 对应的ViewModel Cell 可以持有ViewModel
 */
- (void)configCellWithViewModel:(id <HHCellViewModelProxy>)viewModel;

/**
 cell 高度

 @param viewModel
 @return 高度
 */
+ (CGFloat)heightForCellWithViewModel:(id <HHCellViewModelProxy>)viewModel;

@end
