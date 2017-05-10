//
//  NSAnalyzer.h
//  Genius_IM
//
//  Created by Peter Gra on 2017/5/7.
//  Copyright © 2017年 Graphic-one. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AnalyzeContentType){
    AnalyzeContentTypeApplication       = 1 << 0 ,
    AnalyzeContentTypeViewController    = 1 << 1 ,
    AnalyzeContentTypeView              = 1 << 2 ,
    AnalyzeContentTypeViewEvent         = 1 << 3 ,
    
    AnalyzeContentTypeAll               = NSUIntegerMax,
};

/**
 You only need to do the following things :
 
 In GA_AnalyzeConfiguration.plist file , find 'Configuration' .
 setting 'FileSize'         : Specify the maximum size of the statistical file ///< 指定单个统计数据文件的最大大小
 setting 'ReportCycle'      : Specify the statistics report period             ///< 指定统计文件上报周期(多久上传一次)
 setting 'ReportAddress'    : Specify the data sending address                 ///< 指定统计文件上报地址
 setting 'WhenReportedClean': Specify when reported clean the source file      ///< 指定是否在上报完成后自动删除
 
 */
__attribute__((objc_subclassing_restricted))

@interface NSAnalyzer : NSObject

+ (instancetype)shareAnalyzer;

- (void)updateAnalyzeContentType:(AnalyzeContentType)analyzeContentType status:(BOOL)isAnalyze;

@property (nonatomic,readonly,assign,getter=isAnalyzeApplication) BOOL analyzeApplication;
@property (nonatomic,readonly,assign,getter=isAnalyzeViewController) BOOL analyzeViewController;
@property (nonatomic,readonly,assign,getter=isAnalyzeView) BOOL analyzeView;
@property (nonatomic,readonly,assign,getter=isAnalyzeViewEvent) BOOL analyzeViewEvent;

- (void)closeAllAnalyze;
- (void)openAllAnalyze;

@end
