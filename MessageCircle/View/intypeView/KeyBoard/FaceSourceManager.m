
#import "FaceSourceManager.h"

@implementation FaceSourceManager

+ (NSArray *)loadFaceSource
{
    NSMutableArray *subjectArray = [[NSMutableArray alloc]init];

    NSArray *sources = @[@"systemEmoji",@"food",@"gesture",@"realnature",@"sport",@"symbol"];

    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        //  NSArray *allkeys = faceDic.allKeys;

        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
//
//        if ([plistName isEqualToString:@"face"]) {
//            themeM.themeStyle = FaceThemeStyleCustomEmoji;
//            themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
//            themeM.themeIcon = @"section0_emotion0";
//        }else if ([plistName isEqualToString:@"systemEmoji"]){
            themeM.themeStyle = FaceThemeStyleSystemEmoji;
            themeM.themeDecribe = NSLocalizedString(plistName, "");
            themeM.themeIcon = @"";
//        }
//        else {
//            themeM.themeStyle = FaceThemeStyleGif;
//            themeM.themeDecribe = [NSString stringWithFormat:@"e%d", i];
//            themeM.themeIcon = @"f_static_000";
//        }


        NSMutableArray *modelsArr = [NSMutableArray array];

        NSArray *keys = [faceDic allKeys];
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

            return [obj1 compare:obj2];
        }];
        for (int i = (int)[sortedArray count]-1; i > 0; i--) {
            NSString *name = sortedArray[i];
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
        }
        themeM.faceModels = modelsArr;

        [subjectArray addObject:themeM];
      //  NSLog(@"plistname=%@",plistName);
    }

 //   NSLog(@"sucess");
    return subjectArray;
}


@end
