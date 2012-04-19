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
@synthesize likes = _likes;
@synthesize views = _views;
@synthesize comments = _comments;

- (void)loadShot:(SPShot *)aShot withImage:(UIImage *)image{
    self.title.text = aShot.title;
    self.player.text = aShot.player.name;
    self.likes.text = aShot.likesCount;
    self.comments.text = aShot.commentsCount;
    self.views.text = aShot.viewsCount;
    
    
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
