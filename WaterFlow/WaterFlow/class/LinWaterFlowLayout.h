//
//  LinWaterFlowLayout.h
//  WaterFlow
//
//  Created by lin on 14-11-20.
//  Copyright (c) 2014年 linshaolie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LinWaterFlowLayout;
@protocol LinWaterFlowLayoutDelegate <UICollectionViewDelegate>

/*! @description 返回每一item的高度
 *  @param collectionView
 *  @param layout 瀑布流布局
 *  @param indexPath item的索引
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(LinWaterFlowLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/*! @description 返回每一列开始的Y坐标
 *  @param collectionView
 *  @param layout 瀑布流布局
 *  @param column 列的索引
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LinWaterFlowLayout *)collectionViewLayout eachColumnStartingY:(NSUInteger)column;
@end

@interface LinWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) id<LinWaterFlowLayoutDelegate>delegate;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat itemWidth;        //宽度item的宽度
@property (nonatomic) UIEdgeInsets sectionInset;    

@end
