//
//  HHTableViewManager.h
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//

#import <Foundation/Foundation.h>
#import "HHCellViewModelProxy.h"
#import "HHSectionProxy.h"
#import "HHSectionViewProxy.h"
#import "HHCellViewProxy.h"

@interface HHTableViewManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)addSection:(id<HHSectionProxy>)section;

- (void)reloadData;
@end
