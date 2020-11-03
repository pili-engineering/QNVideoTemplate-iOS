#import "QNVTListVC.h"

#import "QNVTListCell.h"
#import "QNVTModel.h"
#import "QNVTProfileVC.h"
#import "WSLWaterFlowLayout.h"

@interface QNVTListVC () <WSLWaterFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray<QNVTModel*>* dataSource;
@property(nonatomic, strong) UICollectionView* collectionView;
@property(nonatomic, strong) WSLWaterFlowLayout* layout;

@end

@implementation QNVTListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模板库";
    self.dataSource = [NSMutableArray new];

    [self loadData];
    [self setupCollectionView];
    [self.collectionView reloadData];
}

- (void)setupCollectionView {
    _layout = [[WSLWaterFlowLayout alloc] init];
    _layout.delegate = self;
    _layout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[QNVTListCell class] forCellWithReuseIdentifier:NSStringFromClass([QNVTListCell class])];

    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* buildNo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CGFloat top = self.view.safeAreaInsets.top;
    UILabel* buildNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -100 + top, SCREENWIDTH, 100)];
    buildNoLabel.text = [NSString stringWithFormat:@"version: %@  build: %@", version, buildNo];
    buildNoLabel.textColor = UIColor.whiteColor;
    buildNoLabel.textAlignment = NSTextAlignmentCenter;
    buildNoLabel.tag = 2362736;
    [_collectionView addSubview:buildNoLabel];

    [self.view addSubview:_collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIView* header = [_collectionView viewWithTag:2362736];
    CGFloat top = self.view.safeAreaInsets.top;
    header.frame = CGRectMake(0, -100 + top, SCREENWIDTH, 100);
}

- (void)loadData {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [NSString pathWithComponents:@[ [bundle resourcePath], @"data" ]];
    NSArray* sorted = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString* filename in sorted) {
        NSString* jsonPath = [NSString pathWithComponents:@[ path, filename, @"config.json" ]];
        NSData* data = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        QNVTModel* model = [QNVTModel new];
        model.dimension = CGSizeMake([dic[@"width"] floatValue], [dic[@"height"] floatValue]);
        model.name = dic[@"name"];
        model.path = [NSString pathWithComponents:@[ path, filename ]];
        [self.dataSource addObject:model];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

#pragma mark - UIProtocol

#pragma mark - Flowlayout delegate

- (CGSize)waterFlowLayout:(WSLWaterFlowLayout*)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    QNVTModel* model = _dataSource[indexPath.row];
    if (model.layoutSize.height == 0) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 48) / 2.0;
        model.layoutSize = CGSizeMake(width, width / model.dimension.width * model.dimension.height);
    }
    return model.layoutSize;
}

- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout*)waterFlowLayout {
    return UIEdgeInsetsMake(self.view.safeAreaInsets.top + 24, 17, self.view.safeAreaInsets.bottom + 20, 17);
}

- (CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout*)waterFlowLayout {
    return 2;
}

- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout*)waterFlowLayout {
    return 17;
}

- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout*)waterFlowLayout {
    return 14;
}

#pragma - mark UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell*)collectionView:(nonnull UICollectionView*)collectionView
                                  cellForItemAtIndexPath:(nonnull NSIndexPath*)indexPath {
    QNVTListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([QNVTListCell class]) forIndexPath:indexPath];

    QNVTModel* model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    QNVTModel* model = self.dataSource[indexPath.row];
    QNVTProfileVC* viewController = [[QNVTProfileVC alloc] initWithModel:model];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
