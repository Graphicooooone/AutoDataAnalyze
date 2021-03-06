//
//  UIViewControllerAnalyze.m
//  Genius_IM
//
//  Created by Peter Gra on 2017/5/8.
//  Copyright © 2017年 Graphic-one. All rights reserved.
//

#import "UIViewControllerAnalyze.h"
#import "NSAnalyzer.h"

static AnalyzerActionBlock _AnalyzerCtrBlock;
@interface UIViewController (Analyzer)

@end

@implementation UIViewController (Analyzer)
- (void)analyzer_viewDidAppear:(BOOL)animated{
    
    [self analyzer_viewDidAppear:YES];
}

- (void)analyzer_viewDidDisappear:(BOOL)animated{
    
    [self analyzer_viewDidDisappear:YES];
}

- (void)analyzer_dealloc{
    
    [self analyzer_dealloc];
}
@end


#pragma mark - UIViewControllerAnalyze
@implementation UIViewControllerAnalyze
+ (void)_changeAnalyzerStatus:(AnalyzerActionBlock)block{
    _AnalyzerCtrBlock = block;
 
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:GAAnalyzerViewControllerHandle];
    
    [[NSUserDefaults standardUserDefaults] setBool:!b forKey:GAAnalyzerViewControllerHandle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
