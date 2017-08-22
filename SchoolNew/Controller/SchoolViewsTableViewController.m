//
//  SchoolViewsTableViewController.m
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolViewsTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SchoolViewsTableViewController ()

@end

@implementation SchoolViewsTableViewController{
    NSMutableArray<SchoolNewModel  *> *newsArray;
    NSMutableArray<SchoolNewModel  *> *showNewsArray;
    MJRefreshAutoGifFooter *footer;
    NSString *toURL;
    int tag;
    UINib *nib;
}

#define BannerHeight 200
#define PageControl 160
#define navigationHeight 45
#define sectionHeadViewHeight 70
#define CellHeight 90

int pageNum = 0;//tableHeaderView消失时记录banner翻到第几页

- (void)viewDidLoad {
    [super viewDidLoad];
    tag = 0;
    [SDImageCache sharedImageCache].shouldDecompressImages = NO;
    [SDWebImageDownloader sharedDownloader].shouldDecompressImages =NO;
    self.navigationItem.title = NSLocalizedString(@"资讯", "");

    //[SchoolNewsLogic deleteALL];
    newsArray = [[NSMutableArray alloc] init];
    newsArray = [SchoolNewsLogic getNewsFromCoreData];
    //初始化cellnumber
    self.cellNumber = 10;

    //    self.tableView.frame = CGRectMake(-14,0,self.tableView.frame.size.width,self.tableView.frame.size.height);

    //tarbar遮挡问题用下面3行代码解决
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(-20.f, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;

    [self initView]; //初始化
    [self addTableHeadView]; //把headerView加进去

    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //取消滚动条
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    //上拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];


    //下拉刷新
    footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];
    [footer setTitle:@"下拉或点击刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;

    //添加手势让手指点击headerView时不执行代码
    UIPanGestureRecognizer *panTap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:NULL];
    panTap.delegate = self;
    [self.tableView addGestureRecognizer:panTap];
//    
    
    //如果数据为0就刷新
    if([newsArray count]==0){
        [self loadNewData];
    }

    showNewsArray = [[NSMutableArray alloc] init];
}
-(void)didReceiveMemoryWarning{
    CirnoLog(@"memory警告！");
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDWebImageManager sharedManager]cancelAll];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
    showNewsArray = [self addNewsByTag];

}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString* page = @"News";
    [MTA trackPageViewBegin:page];
    //banner显示时开始滚动
    [_bannerView bannerStartScroll];

    //隐藏Navigation
    self.navigationController.navigationBarHidden=YES;

    //关闭滑动
//    CirnoSideBarViewController * sideBar = [CirnoSideBarViewController share];
//    sideBar.diabled = YES;
}



-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_bannerView bannerEndScroll];
}


//initView
-(void)initView{
    //这个是海报
    _bannerView = [[ZBCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BannerHeight)];
    //这个是page
    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, PageControl , self.view.frame.size.width, 30)];
    //这个是导航条
    _navigation = [[ZBCNavigationScrollView alloc] initWithFrame:CGRectMake(0, BannerHeight ,self.view.frame.size.width,navigationHeight)];
    _navigation.schoolNavigationViewDelegate = self;
    //这个先初始化，sectionHeaderView
    _head = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, StatusBarAndNavigationBarHeight)];
    
    [_head drawHeadViewWithTtile:NSLocalizedString(@"资讯","")  buttonImage:nil];
}

//这个是添加tableHeaderView
-(void) addTableHeadView{
    [self resetBanner];
    UIView *tableHeaderView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BannerHeight+navigationHeight)];
    //Banner
    [tableHeaderView addSubview:_bannerView];
    //delegate 委托
    _bannerView.BannerDeleage = self;
    //pageControl
    
    [self getInfoFromWeb];
    
    [tableHeaderView addSubview:_pageControl];
    //导航条界面
    _navigation.frame = CGRectMake(0, BannerHeight ,self.view.frame.size.width,navigationHeight);
    [tableHeaderView addSubview:_navigation];
    self.tableView.tableHeaderView = tableHeaderView;
}


//tableHeaderView显示时恢复原来的page
-(void)resetBanner{
    _pageControl.currentPage = pageNum;
    _bannerView.contentOffset = CGPointMake(self.view.frame.size.width * pageNum, 0);
}

//这里是添加sectionHeadView
-(UIView *) addSectionHeadView{
    UIView *SectionHeadView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, sectionHeadViewHeight+navigationHeight)];
    [SectionHeadView addSubview:_head];
    _navigation.frame = CGRectMake(0, StatusBarAndNavigationBarHeight ,self.view.frame.size.width,navigationHeight);
    _navigation.schoolNavigationViewDelegate = self;
    [SectionHeadView addSubview:_navigation];
    return SectionHeadView;
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSString* page = @"News";
    [MTA trackPageViewEnd:page];
    [super viewWillDisappear:animated];
    [JPUSHService stopLogPageView:@"新闻页"];
}

//=============================这边属于刷新===========================================================
//下拉刷新
-(void) loadNewData{
    NSString *pushNum;
    NSLog(@"下拉刷新");
    pushNum = @"0";


    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1015",
                        @"RecentNewsID":pushNum};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];

    NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);
    NSLog(@"%@",data);


    //POST数据
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];

        if (data!=nil){
        @try {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            newsArray = [SchoolNewsLogic pullDownToRefresh:newsArray reciveNews:json];
            showNewsArray = [self addNewsByTag];
            [self.tableView reloadData];
        }
        @catch (NSException *exception) {
            CirnoLog(@"捕捉异常：%@,%@",exception.name,exception.reason);
        }
        @finally {
            [self.tableView.mj_header endRefreshing];
        }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [self.tableView.mj_header endRefreshing];
    }];
}



//上拉加载
-(void) pullUpToRefresh{

    NSLog(@"%ld",(long)footer.state);
    NSString *pushNum;

    if([newsArray count] == 0){
        pushNum = @"0";
    }
    else{
        pushNum = newsArray[[newsArray count] - 1].schoolNews_ID;
    }


    //数据流加密
    NSDictionary *o1 =@{@"ec":@"1016",
                        @"OldestNewsID":pushNum};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];

    NSLog(@"%@",[data AES256_Decrypt:[HeiHei toeknNew_key]]);

    //POST数据
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",result);

        //刷完了
        if([json[@"news"][@"isEmpty"] intValue] == 0){
            [footer endRefreshingWithNoMoreData];
        }

        newsArray = [SchoolNewsLogic pullUpToRefresh:newsArray reciveNews:json];
        [footer endRefreshing];
        showNewsArray = [self addNewsByTag];
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [CirnoError ShowErrorWithText:[error localizedDescription]];
        [footer endRefreshing];
    }];

}
//=============================这边属于刷新===========================================================




//=============================这边属于骚操作，为了让界面变成英雄联盟那样===========================================================
bool needToShow = false;
bool aaa = false;
//手势的delegate，reture ture表示执行，false表示让tableView去执行就是抛弃
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:gestureRecognizer.view];
    if(p.y<230 && needToShow == false){
        return true;
    }
    return false;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > 126){
        
        if(aaa){
            
        }
        else{
            needToShow = true;
            [self.tableView reloadData];
        }
        
        aaa = true;
    
    }
    else if(needToShow == true && scrollView.contentOffset.y < 126){
        
        if(aaa){
            needToShow=false;
            //banner显示时开始滚动
            [_bannerView bannerStartScroll];
            [self addTableHeadView];
            [self.tableView reloadData];
        }
        
        aaa = false;
     
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(needToShow){
        return 147;//147不要问我为什么：）凑的
    }
    else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(needToShow){
        //当tableView消失时记录所在的页面
        pageNum = (int)_pageControl.currentPage;
        self.tableView.tableHeaderView = nil;
        //banner消失时取消滚动
        [_bannerView bannerEndScroll];
        return [self addSectionHeadView];
    }
    else{
        return nil;
    }
}

//============================================================================



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [showNewsArray count];
    CirnoLog(@"count=%lu",(unsigned long)[showNewsArray count]);

    //return 100;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identy = @"MyCell";
    if (!nib) {
        nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identy];
        NSLog(@"我是从nib过来的，%ld",(long)indexPath.row);
    }
    SchoolNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    SchoolNewModel *a = [[SchoolNewModel alloc] init];
    a = [showNewsArray objectAtIndex:indexPath.row];
    [cell initWithTitle:a.schoolNew_title andtime:a.schoolNew_time andimageurl:a.schoolNew_imageUrl];
    cell.url = a.schoolNew_url;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f){
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
        {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    cell.opaque =YES;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    toURL = [showNewsArray objectAtIndex:indexPath.row].schoolNew_url;
    //    NewsViewController * new = [[NewsViewController alloc]initWithURL:[NSURL URLWithString:toURL]];
    //    new.url = [NSURL URLWithString:toURL];
    //    new.ToUrl =toURL;
    //    new.urlString = toURL;
    //    new.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    SFSafariViewController *new = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:toURL]];
    new.delegate = self;
    // UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:new];

    [self presentViewController:new animated:YES completion:^{
    }];
    // [self performSegueWithIdentifier:@"viewDetail" sender:self];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

#pragma mark - banner view delegate

-(void)Page:(int)num{
    _pageControl.currentPage = num;
    NSLog(@"%d",num);
}

-(void) BannerViewDidClick:(NSString *)url needToRedirect:(bool)needToRedirect{
    SFSafariViewController *new = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:url]];
    [self presentViewController:new animated:YES completion:^{
    }];
}


-(NSMutableArray *) addNewsByTag{
    NSMutableArray *showArray = [[NSMutableArray alloc] init];
    if (tag == 0){
        for(SchoolNewModel *schoolNew in newsArray)
            [showArray addObject:schoolNew];
        return showArray;
    }
    for(SchoolNewModel *schoolNew in newsArray){
        if([schoolNew.schoolNew_Tag intValue] == tag){
            [showArray addObject:schoolNew];
        }
    }
    return showArray;
}



#pragma mark - navigation view delegate
-(void) ClickNavigationButton:(int)num{
    NSLog(@"%d",num);
    tag = num;
    showNewsArray = [self addNewsByTag];
    [self.tableView reloadData];
}


#pragma mark - segue delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"viewDetail"])
    {
        UINavigationController *a = segue.destinationViewController;
        NewsViewController *b = (NewsViewController *)a.topViewController;
        b.ToUrl = toURL;
    }
}
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    SchoolNewTableViewCell* cell =  (SchoolNewTableViewCell*)[previewingContext sourceView];
    NSURL * url = [NSURL URLWithString:cell.url];
    //    NewsViewController *b = [[NewsViewController alloc]initWithURL:url];
    //    b.ToUrl = cell.url;
    SFSafariViewController *svc = [[SFSafariViewController alloc]initWithURL:url];
    svc.delegate = self;
    return svc;
    //    CGPoint p = [showNewsArray convertPoint:location fromView:self.view];
    //
    //    /** 通过坐标活的当前cell indexPath */
    //    NSIndexPath *indexPath = [mainTable indexPathForRowAtPoint:p];
    //
    //    /** 获得当前cell */
    //    UITableViewCell *cell = [mainTable cellForRowAtIndexPath:indexPath];
    //    WKWebView

}
-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void) safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{

}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}




-(void) getInfoFromWeb{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:@"https://must.plus/banner.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(json == nil){
            
        }
        else{
            [self handleJson:json];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(void) handleJson:(id)json{
    NSArray *aa = json[@"banner"];
    _bannerView.bArray = aa;
    [_bannerView addContent];
    _pageControl.numberOfPages = [aa count];

}







@end
