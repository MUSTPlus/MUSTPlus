//
//  ClassTool.m
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "ClassTool.h"

@implementation ClassTool
-(void)openDB{
    NSString * path =[[NSBundle mainBundle] pathForResource:@"class" ofType:@"db"];
    NSLog(@"path%@",path);
    _db = [FMDatabase databaseWithPath:path];
    assert([_db open]);

}
- (NSMutableArray<Course*>*)search:(NSString*)keyword
                           andPlus:(NSString*)plus{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    if (![_db open])
    {
        [self openDB];
    }
    NSString * query = [[ NSString alloc]init];
    if ([plus length]!=0){

        query = [NSString stringWithFormat:@"SELECT * FROM BaseCourse where %@ AND (CourseCode like \"%@%@%@\"\
                       OR CourseTitle like \"%@%@%@\" OR CourseTitleEn like \"%@%@%@\")",plus,@"%",keyword,@"%",@"%",keyword,@"%",@"%",keyword,@"%"];
    }
    else{
        query = [NSString stringWithFormat:@"SELECT * FROM BaseCourse where CourseCode like \"%@%@%@\"\
                           OR CourseTitle like \"%@%@%@\" OR CourseTitleEn like \"%@%@%@\" OR Faculty like \"%@%@%@\"",@"%",keyword,@"%",@"%",keyword,@"%",@"%",keyword,@"%",@"%",keyword,@"%"];
    }
    NSLog(@"%@",query);
    if ([_db open]){
        FMResultSet * set = [_db executeQuery:query];
        while ([set next]){
            NSString* title =[set objectForColumnName:@"CourseTitle"];
            NSString *code =[set objectForColumnName:@"CourseCode"];
            NSString*titleEn =[set objectForColumnName:@"CourseTitleEn"];
            NSString*credit =[set objectForColumnName:@"Credit"];
            NSString* faculty = NSLocalizedString([set objectForColumnName:@"Faculty"], "");
            Course* course = [[Course alloc]initWithCourseTitle:title
                                                        andCode:code
                                                     andTitleEn:titleEn
                                                      andCredit:credit
                                                     andFaculty:faculty];
            [tmp addObject:course];
        }
    }
    return tmp;
}
- (NSMutableArray<Course*>*)searchCode:(NSString*)courseCode{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    if (![_db open])
    {
        [self openDB];
    }
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM BaseCourse where CourseCode =\"%@\"",courseCode];

    if ([_db open]){
        FMResultSet * set = [_db executeQuery:query];
        while ([set next]){
            NSString* title =[set objectForColumnName:@"CourseTitle"];
            NSString *code =[set objectForColumnName:@"CourseCode"];
            NSString*titleEn =[set objectForColumnName:@"CourseTitleEn"];
            NSString*credit =[set objectForColumnName:@"Credit"];
            NSString* faculty = NSLocalizedString([set objectForColumnName:@"Faculty"], "");
            Course* course = [[Course alloc]initWithCourseTitle:title
                                                        andCode:code
                                                     andTitleEn:titleEn
                                                      andCredit:credit
                                                     andFaculty:faculty];
            [tmp addObject:course];
        }
    }
    return tmp;
}
- (NSMutableArray<Course*>*)searchFaculty:(NSString*)Faculty{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    if (![_db open])
    {
        [self openDB];
    }
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM BaseCourse where Faculty =\"%@\"",Faculty];

    if ([_db open]){
        FMResultSet * set = [_db executeQuery:query];
        while ([set next]){
            NSString* title =[set objectForColumnName:@"CourseTitle"];
            NSString *code =[set objectForColumnName:@"CourseCode"];
            NSString*titleEn =[set objectForColumnName:@"CourseTitleEn"];
            NSString*credit =[set objectForColumnName:@"Credit"];
            NSString* faculty = NSLocalizedString([set objectForColumnName:@"Faculty"], "");
            Course* course = [[Course alloc]initWithCourseTitle:title
                                                        andCode:code
                                                     andTitleEn:titleEn
                                                      andCredit:credit
                                                     andFaculty:faculty];
            [tmp addObject:course];
        }
    }
    return tmp;
}
@end
