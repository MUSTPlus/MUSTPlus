//
//  SmartPlaceSet.h
//  
//
//  Created by Cirno on 03/02/2017.
//
//

#import <Foundation/Foundation.h>
#import "SmartPlace.h"
@interface SmartPlaceSet : NSObject
@property (nonatomic,strong) NSMutableArray<SmartPlace*>* places;
@property (nonatomic,strong) NSString* desc;
-(void)addPlace:(SmartPlace*)object;
-(NSInteger)countOfPlaces;
-(instancetype)initWithDic:(NSDictionary*)dic
                    andName:(NSString*)name;
@end
