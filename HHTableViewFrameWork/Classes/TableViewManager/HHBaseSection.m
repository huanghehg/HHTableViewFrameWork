//
//  HHBaseSection.m
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//

#import "HHBaseSection.h"

@interface HHBaseSection ()

@property (nonatomic, strong)NSMutableArray *mutableRows;

@end

@implementation HHBaseSection
@synthesize rows, bindHeaderViewModel, bindFootererViewModel;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableRows = [NSMutableArray array];
    }
    return self;
}

- (NSArray<HHCellViewModelProxy> *)rows {
    return [self.mutableRows copy];
}

- (void)addRow:(id<HHCellViewModelProxy>)row {
    NSAssert(row, @"row can not be nil!");
    if (row) [self.mutableRows addObject:row];
}

- (void)addRows:(NSArray<HHCellViewModelProxy> *)rows {
    NSAssert(rows, @"row can not be nil!");
    if (rows) [self.mutableRows addObjectsFromArray:rows];
}

- (void)insertRow:(id<HHCellViewModelProxy>)row beforeRow:(id<HHCellViewModelProxy>)baseRow {
    NSAssert(row, @"row can not be nil!");
    NSAssert(baseRow, @"baseRow can not be nil!");
    NSAssert([self.mutableRows containsObject:baseRow], @"baseRow must be contained in rows");
    if (row && baseRow) {
        NSUInteger index = [self.mutableRows indexOfObject:baseRow];
        [self.mutableRows insertObject:row atIndex:index];
    }
}

- (void)insertRow:(id<HHCellViewModelProxy>)row atIndex:(NSUInteger)index {
    NSAssert(row, @"row can not be nil!");
    if (index <= self.mutableRows.count) {
        [self.mutableRows insertObject:row atIndex:index];
    }
}

- (void)insertRow:(id<HHCellViewModelProxy>)row behindRow:(id<HHCellViewModelProxy>)baseRow {
    NSAssert(row, @"row can not be nil!");
    NSAssert(baseRow, @"baseRow can not be nil!");
    NSAssert([self.mutableRows containsObject:baseRow], @"baseRow must be contained in rows");
    if (row && baseRow) {
        NSUInteger index = [self.mutableRows indexOfObject:baseRow];
        [self.mutableRows insertObject:row atIndex:index + 1];
    }
}

- (void)removeAllRows {
    [self.mutableRows removeAllObjects];
}

- (void)removeRow:(id<HHCellViewModelProxy>)row {
    if (row && [self.mutableRows containsObject:row]) {
        [self.mutableRows removeObject:row];
    }
}

- (void)removeRowAtIndex:(NSUInteger)index {
    if (index < self.mutableRows.count) {
        [self.mutableRows removeObjectAtIndex:index];
    }
}

- (void)removeRows:(NSArray<HHCellViewModelProxy> *)rows {
    __weak typeof(self) weakSelf = self;
    [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.mutableRows containsObject:obj]) {
            [strongSelf.mutableRows removeObject:obj];
        }
    }];
}

@end
