
#import <UIKit/UIKit.h>
#import "CourseCellTableViewCell.h"
#import "Course.h"
#import "ClassTool.h"
#import "REMenu.h"
#import "BasicHead.h"
#import "XGSim2Tra.h"
@interface CourseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UISearchBar* searchBar;
@property (nonatomic,strong) NSMutableArray<Course*>* tableData;
@property (strong, nonatomic) REMenu *menu;
@property (nonatomic,strong) UIView* shadowView;
@property (nonatomic,strong) NSString* basic;
@property (nonatomic,strong) NSString*str;
@property (nonatomic,strong) dispatch_group_t group;
-(NSString*)keywords;
@end
