//
//  DisplayLyricView.h
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/27.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayLyricView : UIView

@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, assign) NSInteger currentRow;


- (void)reloadTableView;
- (void)reloadTableViewWithCurrentRow;

@end


