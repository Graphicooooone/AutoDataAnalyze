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

NS_ASSUME_NONNULL_BEGIN

@class NSAnalyzer;
@protocol NSAnalyzerRegistration <NSObject>

+ (void)AnalyzerRegisterInfo:(NSAnalyzer* )analyzer;

@end

typedef void(^AnalyzerActionBlock)(NSString* clsName);

__attribute__((objc_subclassing_restricted))

@interface NSAnalyzer : NSObject

+ (instancetype)shareAnalyzer;
/** Registered the corresponding with the NSAnalyzer instance handle events */
- (void)registerAnalyzerBlocks:(NSDictionary<NSString* , AnalyzerActionBlock>* )blockDic;


///< dynamic Api
/** All update operations in the next runLoop restart to take effect */
- (void)updateAnalyzeContentType:(AnalyzeContentType)analyzeContentType status:(BOOL)isAnalyze;
- (void)closeAllAnalyze;
- (void)openAllAnalyze;

@property (nonatomic,readonly,assign,getter=isAnalyzeApplication) BOOL analyzeApplication;
@property (nonatomic,readonly,assign,getter=isAnalyzeViewController) BOOL analyzeViewController;
@property (nonatomic,readonly,assign,getter=isAnalyzeView) BOOL analyzeView;
@property (nonatomic,readonly,assign,getter=isAnalyzeViewEvent) BOOL analyzeViewEvent;

@end


FOUNDATION_EXTERN NSString* const GAAnalyzerContentInfo;

/** handle key*/
FOUNDATION_EXTERN NSString* const GAAnalyzerAppDelegateHandle;
FOUNDATION_EXTERN NSString* const GAAnalyzerViewControllerHandle;
FOUNDATION_EXTERN NSString* const GAAnalyzerViewHandle;
FOUNDATION_EXTERN NSString* const GAAnalyzerViewEventHandle;

NS_ASSUME_NONNULL_END
