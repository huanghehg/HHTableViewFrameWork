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
        return 0;
    }else {
        return 0;
    }
}


#pragma mark -- public method

- (void)addSection:(id<HHSectionProxy>)section {
    [self.mutableSections addObject:section];
}

- (void)reloadData {
    [self.tableView reloadData];
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
