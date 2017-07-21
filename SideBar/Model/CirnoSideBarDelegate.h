

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum CirnoSideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;
@protocol CirnoSideBarDelegate <NSObject>
- (void)leftSideBarSelectWithController:(UIViewController *)controller;
- (void)rightSideBarSelectWithController:(UIViewController *)controller;
- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction;
@end
