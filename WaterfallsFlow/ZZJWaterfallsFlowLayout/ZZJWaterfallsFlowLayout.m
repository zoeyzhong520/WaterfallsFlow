//
//  ZZJWaterfallsFlowLayout.m
//  WaterfallsFlow
//
//  Created by zhifu360 on 2018/11/13.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ZZJWaterfallsFlowLayout.h"

@implementation ZZJWaterfallsFlowLayout

#pragma mark - Rewrite Void
- (void)prepareLayout {
    
    for (int i = 0; i < self.columnCount; i ++) {
        //初始化字典，有几列就有几个键值对，key为第几列，value为列的最大y值，初始值为上内边距
        self.maxYDic[@(i)] = @(self.sectionInset.top);
    }
    
    //根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //为每一个item创建一个attributes并存入数组
    for (int i = 0; i < itemCount; i ++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    
    //假设第0列是最长的那列
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *  _Nonnull key, NSNumber *  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //如果maxColumn列的最大y值小于obj，则让maxColumn等于obj所属的列
        if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
        
    }];
    
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    //self.sectionInset.left：左边距    self.sectionInset.right：右边距
    //(self.columnCount - 1) * columnSpacing：一行中所有的列边距
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1)*self.columnSpacing)/self.columnCount;
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *  _Nonnull key, NSNumber *  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
        
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (itemWidth + self.columnSpacing) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    CGFloat itemHeight = 0.0f;
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    }
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最短列的最大y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributesArray;
}

#pragma mark - Lazy
- (NSMutableDictionary *)maxYDic {
    if (!_maxYDic) {
        _maxYDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _maxYDic;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attributesArray;
}

@end
