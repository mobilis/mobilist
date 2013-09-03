#import "PingResponse.h"

@implementation PingResponse

@synthesize content;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement* )xml {
	NSXMLElement* contentElement = [xml elementForName:@"content"];
	[self setContent:[contentElement stringValue]];
}

+ (NSString* )elementName {
	return @"PingResponse";
}

+ (NSString* )iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de#services/MobilistService";
}

@end