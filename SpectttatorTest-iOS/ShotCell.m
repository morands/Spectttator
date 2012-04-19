//
//  ShotCell.m
//  SpectttatorTest-iOS
//
//  Created by David Keegan on 6/30/11.
//  Copyright 2011 David Keegan.
//

#import "ShotCell.h"

@implementation ShotCell

@synthesize title = _title;
@synthesize player = _player;
@synthesize views = _views;
@synthesize likes = _likes;
@synthesize comments = _comments;
@synthesize shot = _shot;



- (void)loadShot:(SPShot *)aShot withImage:(UIImage *)image{
    self.title.text = aShot.title;
    self.player.text = aShot.player.name;
    
    self.likes.text = [NSString stringWithFormat:@"%lu", aShot.likesCount];
    self.comments.text = [NSString stringWithFormat:@"%lu", aShot.commentsCount];
    self.views.text = [NSString stringWithFormat:@"%lu", aShot.viewsCount];
    
    self.shot.image = image;
    
}


- (void)dealloc {
    [_title release];
    [_player release];
    [_info release];
    [_shot release];
    [_likes release];
    [_views release];
    [_comments release];
    [super dealloc];
}
@end
