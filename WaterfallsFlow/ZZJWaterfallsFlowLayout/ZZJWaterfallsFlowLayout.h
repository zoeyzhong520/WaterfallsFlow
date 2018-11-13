//
//  ZZJWaterfallsFlowLayout.h
//  WaterfallsFlow
//
//  Created by zhifu360 on 2018/11/13.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 定制waterfallsFlow布局类

@interface ZZJWaterfallsFlowLayout : UICollectionViewLayout

///总列数
@property (nonatomic, assign) NSInteger columnCount;
///列间距
@property (nonatomic, assign) NSInteger columnSpacing;
///行间距
@property (nonatomic, assign) NSInteger rowSpacing;
///section到collectionView的边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
///保存每一列最大y值的数组
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
///保存每一个item的attributes的数组
@property (nonatomic, strong) NSMutableArray *attributesArray;
///等比例缩放来计算高度
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemWidth, NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
