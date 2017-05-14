//
//  UIViewAnalyze.m
//  Genius_IM
//
//  Created by Peter Gra on 2017/5/8.
//  Copyright © 2017年 Graphic-one. All rights reserved.
//

#import "UIViewAnalyze.h"
#import "NSAnalyzer.h"

static AnalyzerActionBlock _AnalyzerViewBlock;
static AnalyzerActionBlock _AnalyzerViewEventBlock;

@interface UIView (Analyzer)

@end

@implementation UIView (Analyzer)

@end


#pragma mark - UIViewAnalyze
@implementation UIViewAnalyze
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block{
    _AnalyzerViewBlock = block;
    
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:GAAnalyzerViewHandle];
    
    [[NSUserDefaults standardUserDefaults] setBool:!b forKey:GAAnalyzerViewHandle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)_changeViewEventAnalyzerStatus:(AnalyzerActionBlock)block{
    _AnalyzerViewEventBlock = block;
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:GAAnalyzerViewEventHandle];
    
    [[NSUserDefaults standardUserDefaults] setBool:!b forKey:GAAnalyzerViewEventHandle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
