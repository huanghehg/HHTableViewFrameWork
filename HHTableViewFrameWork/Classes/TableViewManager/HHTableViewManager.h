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
- (void)addSections:(NSArray<HHSectionProxy> *)sections;
- (void)insertSection:(id<HHSectionProxy>)section atIndex:(NSInteger)index;


- (void)insertSection:(id<HHSectionProxy>)section beforeSection:(id<HHSectionProxy>)baseSection;
- (void)insertSection:(id<HHSectionProxy>)section behindSection:(id<HHSectionProxy>)baseSection;

- (void)removeSection:(id<HHSectionProxy>)section;
- (void)removeSections:(NSArray<HHSectionProxy> *)sections;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeAllSection;


- (void)reloadData;

- (void)reloadSection:(id<HHSectionProxy>)section;
- (void)reloadSection:(id<HHSectionProxy>)section animation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSArray <HHSectionProxy>*)sections animation:(UITableViewRowAnimation)animation;

- (void)reloadIndexOfSection:(NSInteger)index;
- (void)reloadIndexOfSection:(NSInteger)index animation:(UITableViewRowAnimation)animation;
- (void)reloadIndexsOfSections:(NSIndexSet *)indexSet animation:(UITableViewRowAnimation)animation;

@end
