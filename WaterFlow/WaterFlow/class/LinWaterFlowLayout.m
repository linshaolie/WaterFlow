//
//  LinWaterFlowLayout.m
//  WaterFlow
//
//  Created by lin on 14-11-20.
//  Copyright (c) 2014年 linshaolie. All rights reserved.
//

#import "LinWaterFlowLayout.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define WIDTH (self.collectionView.bounds.size.width)
#define HEIGHT (self.collectionView.bounds.size.height)

@interface LinWaterFlowLayout ()

@property(nonatomic) NSUInteger itemCount;
@property(nonatomic, strong) NSMutableArray *columnHeights;     //每一列的高度
@property(nonatomic, strong) NSMutableArray *itemAttributes;    //每个item的attribute

@property(nonatomic) NSUInteger columnCount;       //列数
@end


@implementation LinWaterFlowLayout

#pragma mark -memory manager
- (void)dealloc
{
    [_columnHeights removeAllObjects];
    _columnHeights = nil;
    
    [_itemAttributes removeAllObjects];
    _columnHeights = nil;
}

//default
- (void)defaultInit
{
    _minimumInteritemSpacing = 0;
    _sectionInset = UIEdgeInsetsZero;
    _itemWidth = SCREENWIDTH/2;
    _columnCount = 2;
}

#pragma mark -init
- (instancetype)init
{
    self = [super init];
    if( self )
    {
        [self defaultInit];
    }
    return self;
}

#pragma mark -prepare
- (void)prepareLayout
{
    [super prepareLayout];
    
    //获取cell个数
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    NSAssert(_columnCount >= 1, @"列数必须大于1");
    
    //根据itemCount初始化_itemAttributes
    _itemAttributes = [NSMutableArray arrayWithCapacity:_itemCount];
    //根据_columnCount初始化_columnHeights
    _columnHeights = [NSMutableArray arrayWithCapacity:_columnCount];
    
    //加上顶部偏移值
    for (NSUInteger idx = 0; idx < _columnCount; idx++) {
        CGFloat columnStartingY = [self.delegate collectionView:self.collectionView layout:self eachColumnStartingY:idx];
        [self.columnHeights addObject:@(_sectionInset.top+columnStartingY)];
    }
    
    //元素将会加到最短的列上面
    for (NSUInteger idx = 0; idx < _itemCount; idx++) {
        //创建indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        //代理方法回调，获得cell的高
        CGFloat height = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
        
        //计算cell绘制的位置
        NSUInteger shortestColumnIdx = [self shortestColumnIndex];
        CGFloat offsexX = _sectionInset.left + (_itemWidth + _minimumInteritemSpacing) * shortestColumnIdx;
        CGFloat offsetY = [_columnHeights[shortestColumnIdx] floatValue];
        
        //为cell创建一个
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(offsexX, offsetY, _itemWidth, height);
        [_itemAttributes addObject:attributes];
        
        _columnHeights[shortestColumnIdx] = @(offsetY + height + _minimumInteritemSpacing);
    }
}

#pragma mark -setter
- (void)setItemWidth:(CGFloat)itemWidth
{
    if( _itemWidth != itemWidth )
    {
        _itemWidth = itemWidth;
    }
    NSUInteger columnCount = WIDTH/(itemWidth+_minimumInteritemSpacing);
    if( _columnCount != columnCount )
    {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if( !UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset) )
    {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (CGSize)collectionViewContentSize
{
    if (self.itemCount == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat height = [self.columnHeights[columnIndex] floatValue];
    contentSize.height = height - self.minimumInteritemSpacing + self.sectionInset.bottom;
    return contentSize;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.itemAttributes objectAtIndex:indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}


#pragma mark -private methor
//获取最长列的索引
- (NSUInteger)longestColumnIndex
{
    __block CGFloat longestHeigh = 0;
    __block NSUInteger longestIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if( longestHeigh < [obj floatValue] )
        {
            longestHeigh = [obj floatValue];
            longestIndex = idx;
        }
    }];
    return longestIndex;
}

//获取最短列的索引
- (NSUInteger)shortestColumnIndex
{
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    __block NSUInteger shortestIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if( shortestHeight > [obj floatValue] )
        {
            shortestHeight = [obj floatValue];
            shortestIndex = idx;
        }
    }];
    return shortestIndex;
}

@end
