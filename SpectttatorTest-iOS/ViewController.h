//
//  ViewController.h
//  SpectttatorTest
//
//  Created by Edoardo Morandotti on 17/04/12.
//

#import <UIKit/UIKit.h>
#import "ShotCell.h"

@interface ViewController : UIViewController {
	IBOutlet UIWebView *webView;
    
	NSString *indirizzo;
}

@property (nonatomic, retain) NSString *indirizzo;

@end
