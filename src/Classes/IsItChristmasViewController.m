//
//  IsItChristmasViewController.m
//  IsItChristmas
//
//  Created by Brandon Jones on 11/21/09.
//  Copyright 2009 Brandon Jones. All rights reserved.
//

#import "IsItChristmasViewController.h"

@implementation IsItChristmasViewController
@synthesize resultLabel, selectedLanguage, selectedCountry, portraitFrame, landscapeFrame, languageYesDict, languageNoDict;
static int padding = 10;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	//load the language dictionaries
	NSBundle *mainBundle = [NSBundle mainBundle];
	self.languageYesDict = [mainBundle objectForInfoDictionaryKey:@"LANGUAGE_YES"];
	self.languageNoDict = [mainBundle objectForInfoDictionaryKey:@"LANGUAGE_NO"];
	
	//use the whole screen minus the padding for the resultLabel frame
	self.portraitFrame = CGRectMake(padding, padding, 320 - (padding * 2), 480 - (padding * 2));
	self.landscapeFrame = CGRectMake(padding, padding, 480 - (padding * 2), 320 - (padding * 2));
	
	//get the languages array and get the selected language
	//the preferred language code is always the first item in the array
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	self.selectedLanguage = [languages objectAtIndex:0];
	
	//get the country code
	NSString *currentLocale = [defaults objectForKey:@"AppleLocale"];
	self.selectedCountry = [currentLocale substringFromIndex:[currentLocale rangeOfString:@"_"].location+1];
	
	//if the country code is canada, use the special language code
	if ([[self.selectedCountry uppercaseString] isEqualToString:@"CA"]) {
		self.selectedLanguage = @"ca";
	}
}

//returns yes/no as a string in the localized language
- (NSString *)isItChristmas {
	
	//we default to no
	BOOL isChristmas = NO;
	
	//get the current date
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:[NSDate date]];
	
	//check to see if it is christmas
	if ([dateComponents month] == 12 && [dateComponents day] == 25) {
		isChristmas = YES;
	}
	
	//if the preferred language is in our list, return yes/no
	NSString *answer = (isChristmas) ? [self.languageYesDict objectForKey:self.selectedLanguage] : [self.languageNoDict objectForKey:self.selectedLanguage];
	if (answer) {
		return answer;
	}
	
	//if the selected language isn't in our list, return english
	return (isChristmas) ? @"yes" : @"no";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//initialize the resultLabel and use the whole screen
	UILabel *tmpLabel = [[UILabel alloc] initWithFrame:portraitFrame];
	self.resultLabel = tmpLabel;
	[tmpLabel release];
	
	//set the font, etc
	self.resultLabel.font = [UIFont fontWithName:@"ArialMT" size:180.0];
	self.resultLabel.adjustsFontSizeToFitWidth = YES;
	self.resultLabel.textAlignment = UITextAlignmentCenter;
	
	//add the results label to the screen
	[self.view addSubview:self.resultLabel];
	
	//set the result label for the first time
	//then every 5 seconds check to see if it is christmas
	[self setResultLabel];
	[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setResultLabel) userInfo:nil repeats:YES];
	
    [super viewDidLoad];
}

//this just sets the label test by calling isItChristmas
//this is in its own method so we can call in a timer every five seconds
- (void)setResultLabel {
	self.resultLabel.text = [[self isItChristmas] uppercaseString];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//resize/reposition the label if the phone is rotated
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.resultLabel.frame = portraitFrame;
	} else {
		self.resultLabel.frame = landscapeFrame;
	}
}

//release memory
- (void)dealloc {
	[self.resultLabel removeFromSuperview];
	[self.resultLabel release];
	[self.selectedLanguage release];
	[self.selectedCountry release];
	[self.languageYesDict release];
	[self.languageYesDict release];
    [super dealloc];
}

@end