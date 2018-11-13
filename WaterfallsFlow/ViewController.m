//
//  ViewController.m
//  WaterfallsFlow
//
//  Created by zhifu360 on 2018/11/13.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ViewController.h"
#import "ZZJWaterfallsFlowLayout.h"
#import "ImageModel.h"

static NSString * CELLID = @"cellID";

//随机颜色
#define RandomColor [UIColor colorWithRed:(arc4random()%256)/255.0f green:(arc4random()%256)/255.0f blue:(arc4random()%256)/255.0f alpha:1]

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getData];
    
    [self.view addSubview:self.collectionView];
}

///get data
- (void)getData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        ImageModel *model = [ImageModel new];
        [model setValuesForKeysWithDictionary:dic];
        
        [self.dataArray addObject:model];
    }
    NSLog(@"%@",array);
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了===%@",indexPath);
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ZZJWaterfallsFlowLayout *flowLayout = [ZZJWaterfallsFlowLayout new];
        flowLayout.columnCount = 3;
        flowLayout.rowSpacing = 10;
        flowLayout.columnSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [flowLayout setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath * _Nonnull indexPath) {
           //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
            ImageModel *model = self.dataArray[indexPath.item];
            return model.h.floatValue / model.w.floatValue * itemWidth;
        }];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
