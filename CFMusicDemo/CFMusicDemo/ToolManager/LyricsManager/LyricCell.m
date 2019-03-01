//
//  LyricCell.m
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/27.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "LyricCell.h"

@implementation LyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _text.textAlignment = NSTextAlignmentCenter;
        _text.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_text];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
