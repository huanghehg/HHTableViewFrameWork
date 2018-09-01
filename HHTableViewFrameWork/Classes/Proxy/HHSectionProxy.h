//
//  HHSectionViewModelProxy.h
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//

#import <Foundation/Foundation.h>
#import "HHCellViewModelProxy.h"
#import "HHSectionViewModelProxy.h"

@protocol HHSectionProxy <NSObject>

@required
@property (nonatomic, strong, readonly)NSArray<HHCellViewModelProxy> *rows;

@property (nonatomic, strong)id<HHSectionViewModelProxy> bindHeaderViewModel;
@property (nonatomic, strong)id<HHSectionViewModelProxy> bindFootererViewModel;

- (void)addRow:(id<HHCellViewModelProxy>)row;
- (void)addRows:(NSArray<HHCellViewModelProxy> *)rows;
- (void)insertRow:(id<HHCellViewModelProxy>)row atIndex:(NSUInteger)index;

- (void)insertRow:(id<HHCellViewModelProxy>)row beforeRow:(id<HHCellViewModelProxy>)baseRow;
- (void)insertRow:(id<HHCellViewModelProxy>)row behindRow:(id<HHCellViewModelProxy>)baseRow;

- (void)removeRow:(id<HHCellViewModelProxy>)row;
- (void)removeRows:(NSArray<HHCellViewModelProxy> *)rows;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;


@end
