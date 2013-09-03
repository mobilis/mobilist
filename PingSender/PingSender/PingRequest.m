#import "PingRequest.h"

@implementation PingRequest

@synthesize content;

- (id)init {
	self = [super initWithBeanType:GET];
	
	return self;
}

- (NSXMLElement* )toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* contentElement = [NSXMLElement elementWithName:@"content"];
	[contentElement setStringValue:[self content]];
	[beanElement addChild:contentElement];
	
	return beanElement;
}

+ (NSString* )elementName {
	return @"PingRequest";
}

+ (NSString* )iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de#services/MobilistService";
}

@end