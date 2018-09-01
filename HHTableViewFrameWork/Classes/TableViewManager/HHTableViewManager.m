//
//  HHTableViewManager.m
//  HHTableViewFrameWork
//
//  Created by 黄河 on 31/08/2018.
//

#import "HHTableViewManager.h"

@interface HHTableViewManager ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<HHSectionProxy> *mutableSections;
@property (nonatomic, strong)NSMutableDictionary<NSNumber *,UIView *> *headerViewsMap;
@property (nonatomic, strong)NSMutableDictionary<NSNumber *,UIView *> *footerViewsMap;
@end

@implementation HHTableViewManager

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        NSAssert(tableView, @"tableView can not be nil!");
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutableSections.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Class cellClass = [self getCurrentRowViewClassWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
        if ([cell respondsToSelector:@selector(cellForInitalized)]) {
            [cell performSelector:@selector(cellForInitalized)];
        }
    }
    if ([cell respondsToSelector:@selector(configCellWithViewModel:)]) {
        [(id <HHCellViewProxy>)cell configCellWithViewModel:[self rowAtIndexPath:indexPath]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.mutableSections.count) {
        id <HHSectionProxy> currectSection = [self.mutableSections objectAtIndex:section];
        return  currectSection.rows.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    Class cellClass = [self getCurrentRowViewClassWithIndexPath:indexPath];
    
    if ([cellClass conformsToProtocol:@protocol(HHCellViewProxy)]) {
        cellHeight = [cellClass heightForCellWithViewModel:[self rowAtIndexPath:indexPath]];
    }
    
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id <HHSectionViewModelProxy> currectSectionViewModel = [self getCurrentSectionHeaderViewModel:section];
    if (currectSectionViewModel) {
        UIView *headerView = self.headerViewsMap[@(section)];
        if (!headerView) {
            NSAssert([currectSectionViewModel bindViewClassString], @"bindViewClassString can not be nil!");
            Class headerViewClass = NSClassFromString([currectSectionViewModel bindViewClassString]);
            if (!headerViewClass) {
                return nil;
            }
            headerView = [[headerViewClass alloc] init];
            self.headerViewsMap[@(section)] = headerView;
        }
        if ([headerView respondsToSelector:@selector(configViewWithViewModel:)]) {
            [(id <HHSectionViewProxy>)headerView configViewWithViewModel:currectSectionViewModel];
        }
        return headerView;
    }else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id <HHSectionViewModelProxy> currectSectionViewModel = [self getCurrentSectionHeaderViewModel:section];
    if (currectSectionViewModel) {
        NSAssert([currectSectionViewModel bindViewClassString], @"bindViewClassString can not be nil!");
        Class headerViewClass = NSClassFromString([currectSectionViewModel bindViewClassString]);
        if (headerViewClass && [headerViewClass conformsToProtocol:@protocol(HHSectionViewProxy)]) {
            return [headerViewClass heightForViewWithViewModel:currectSectionViewModel];
        }
        return 0;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id <HHSectionViewModelProxy> currectFooterViewModel = [self getCurrentFooterViewModel:section];
    if (currectFooterViewModel) {
        UIView *footerView = self.footerViewsMap[@(section)];
        if (!footerView) {
            NSAssert([currectFooterViewModel bindViewClassString], @"bindViewClassString can not be nil!");
            Class footerViewClass = NSClassFromString([currectFooterViewModel bindViewClassString]);
            if (!footerViewClass) {
                return nil;
            }
            footerView = [[footerViewClass alloc] init];
            self.footerViewsMap[@(section)] = footerView;
        }
        if ([footerView respondsToSelector:@selector(configViewWithViewModel:)]) {
            [(id <HHSectionViewProxy>)footerView configViewWithViewModel:currectFooterViewModel];
        }
        return footerView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id <HHSectionViewModelProxy> currectFooterViewModel = [self getCurrentFooterViewModel:section];
    if (currectFooterViewModel) {
        NSAssert([currectFooterViewModel bindViewClassString], @"bindViewClassString can not be nil!");
        Class footerViewClass = NSClassFromString([currectFooterViewModel bindViewClassString]);
        if (footerViewClass && [footerViewClass conformsToProtocol:@protocol(HHSectionViewProxy)]) {
            return [footerViewClass heightForViewWithViewModel:currectFooterViewModel];
        }
    }
    return 0;
}


#pragma mark -- public method

- (void)addSection:(id<HHSectionProxy>)section {
    [self.mutableSections addObject:section];
}

- (void)addSections:(NSArray<HHSectionProxy> *)sections {
    if (sections) [self.mutableSections addObjectsFromArray:sections];
}

- (void)insertSection:(id<HHSectionProxy>)section atIndex:(NSInteger)index {
    NSAssert(section, @"section can not be nil!");
    if (index <= self.mutableSections.count) {
        [self.mutableSections insertObject:section atIndex:index];
    }
}

- (void)insertSection:(id<HHSectionProxy>)section beforeSection:(id<HHSectionProxy>)baseSection {
    NSAssert(section, @"section can not be nil!");
    NSAssert(baseSection, @"baseSection can not be nil!");
    NSAssert([self.mutableSections containsObject:baseSection], @"baseSection must be contained in sections");
    if (section && baseSection) {
        NSUInteger index = [self.mutableSections indexOfObject:baseSection];
        [self.mutableSections insertObject:section atIndex:index];
    }
}

- (void)insertSection:(id<HHSectionProxy>)section behindSection:(id<HHSectionProxy>)baseSection {
    NSAssert(section, @"section can not be nil!");
    NSAssert(baseSection, @"baseSection can not be nil!");
    NSAssert([self.mutableSections containsObject:baseSection], @"baseSection must be contained in sections");
    if (section && baseSection) {
        NSUInteger index = [self.mutableSections indexOfObject:baseSection];
        [self.mutableSections insertObject:section atIndex:index + 1];
    }
}

- (void)removeSection:(id<HHSectionProxy>)section {
    if (section && [self.mutableSections containsObject:section]) {
        [self.mutableSections removeObject:section];
    }
}
- (void)removeSections:(NSArray<HHSectionProxy> *)sections {
    __weak typeof(self) weakSelf = self;
    [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.mutableSections containsObject:obj]) {
            [strongSelf.mutableSections removeObject:obj];
        }
    }];
}
- (void)removeSectionAtIndex:(NSUInteger)index {
    if (index < self.mutableSections.count) [self.mutableSections removeObjectAtIndex:index];
}
- (void)removeAllSection {
    [self.mutableSections removeAllObjects];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)reloadSection:(id<HHSectionProxy>)section {
    NSAssert(section, @"section can not be nil");
    [self reloadSection:section animation:UITableViewRowAnimationNone];
}
- (void)reloadSection:(id<HHSectionProxy>)section animation:(UITableViewRowAnimation)animation {
    NSAssert(section, @"section can not be nil");
    if ([self.mutableSections containsObject:section]) {
        [self reloadIndexOfSection:[self.mutableSections indexOfObject:section] animation:animation];
    }
}

- (void)reloadSections:(NSArray <HHSectionProxy>*)sections animation:(UITableViewRowAnimation)animation {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (id <HHSectionProxy> section in self.mutableSections) {
        if ([self.mutableSections containsObject:section]) {
            [indexSet addIndex:[self.mutableSections indexOfObject:section]];
        }
    }
    [self reloadIndexsOfSections:indexSet animation:animation];
}

- (void)reloadIndexOfSection:(NSInteger)index {
    [self reloadIndexOfSection:index animation:UITableViewRowAnimationNone];
}
- (void)reloadIndexOfSection:(NSInteger)index animation:(UITableViewRowAnimation)animation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self reloadIndexsOfSections:indexSet animation:animation];
}

- (void)reloadIndexsOfSections:(NSIndexSet *)indexSet animation:(UITableViewRowAnimation)animation {
    [self.tableView reloadSections:indexSet withRowAnimation:animation];
}


#pragma mark -- private method

- (id<HHSectionProxy>)getCurrentSectionViewModel:(NSInteger)section {
    if (section < self.mutableSections.count) {
        id <HHSectionProxy> currectSection = [self.mutableSections objectAtIndex:section];
        return currectSection;
    }
    return nil;
}

- (id<HHSectionViewModelProxy>)getCurrentSectionHeaderViewModel:(NSInteger)section {
    id <HHSectionProxy> currectSection = [self getCurrentSectionViewModel:section];
    return [currectSection bindHeaderViewModel];
}

- (id<HHSectionViewModelProxy>)getCurrentFooterViewModel:(NSInteger)section {
    id <HHSectionProxy> currectSection = [self getCurrentSectionViewModel:section];
    return [currectSection bindFootererViewModel];
}

- (Class)getCurrentRowViewClassWithIndexPath:(NSIndexPath *)indexPath {
    
    id <HHCellViewModelProxy> row = [self rowAtIndexPath:indexPath];
    Class cellClass = NSClassFromString([row bindClassString]);
    NSAssert(cellClass, @"cellClass can be nil!");
    return cellClass;
}

- (id<HHCellViewModelProxy>)rowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count > indexPath.section) {
        id <HHSectionProxy> section = self.mutableSections[indexPath.section];
        if ([section.rows count] > indexPath.row) {
            return section.rows[indexPath.row];
        }
    }
    return nil;
}

#pragma mark -- setter && getter

- (NSMutableArray<HHSectionProxy> *)mutableSections {
    if (!_mutableSections) {
        _mutableSections = (NSMutableArray <HHSectionProxy>*)[NSMutableArray array];
    }
    return _mutableSections;
}

- (NSMutableDictionary<NSNumber *,UIView *> *)headerViewsMap {
    if (!_headerViewsMap) {
        _headerViewsMap = [NSMutableDictionary dictionary];
    }
    return _headerViewsMap;
}

- (NSMutableDictionary<NSNumber *,UIView *> *)footerViewsMap {
    if (!_footerViewsMap) {
        _footerViewsMap = [NSMutableDictionary dictionary];
    }
    return _footerViewsMap;
}
@end
