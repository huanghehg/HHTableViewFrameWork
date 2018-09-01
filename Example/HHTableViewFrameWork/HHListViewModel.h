//
//  HHListViewModel.h
//  HHTableViewFrameWork_Example
//
//  Created by 黄河 on 31/08/2018.
//  Copyright © 2018 huanghehg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HHTableViewFrameWork/HHCellViewModelProxy.h>

@interface HHListViewModel : NSObject<HHCellViewModelProxy>

@property (nonatomic, strong)NSString *title;

@property (nonatomic, strong)NSString *detail;

@property (nonatomic, assign)CGFloat height;

@end
