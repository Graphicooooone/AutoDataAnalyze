//
//  AppDelegateAnalyze.m
//  Genius_IM
//
//  Created by Peter Gra on 2017/5/8.
//  Copyright © 2017年 Graphic-one. All rights reserved.
//

#import "AppDelegateAnalyze.h"
#import "AppDelegate.h"
#import "NSAnalyzer.h"

static AnalyzerActionBlock _AnalyzerAppDelegateBlock;
@interface AppDelegate (Analyzer)

@end

@implementation AppDelegate (Analyzer)

@end


#pragma mark - AppDelegateAnalyze
@implementation AppDelegateAnalyze
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block{
    _AnalyzerAppDelegateBlock = block;
    
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:GAAnalyzerAppDelegateHandle];
    
    [[NSUserDefaults standardUserDefaults] setBool:!b forKey:GAAnalyzerAppDelegateHandle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
