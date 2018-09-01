//
//  HHViewModelProxy.h
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//
// cell 的 viewModel 需要实现这个协议

#import <Foundation/Foundation.h>

@protocol HHCellViewModelProxy <NSObject>

@required

/**
 返回当前viewModel 对应的类名

 @return string
 */
- (NSString *)bindClassString;

@end
