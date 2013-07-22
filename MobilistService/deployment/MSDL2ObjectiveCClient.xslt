<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
		version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:fn="http://www.w3.org/2005/xpath-functions" 
		xmlns:msdl="http://mobilis.inf.tu-dresden.de/msdl/"
		xmlns:xmpp="http://mobilis.inf.tu-dresden.de/xmpp/">

	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- User defined variables -->
	<xsl:variable name="outputFolder" select="'client/'" />
	<xsl:variable name="serviceXMLNS" select="'mns'" />
	
	<!-- Internal variables - do not edit these unless you know exactly what you're doing -->
	<xsl:variable name="space" select="' '" />
	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>
	<xsl:variable name="stringType" select="'NSString*'" />
	<xsl:variable name="intType" select="'NSInteger'" />
	<xsl:variable name="longType" select="'NSInteger'" />
	<xsl:variable name="booleanType" select="'BOOL'" />
	<xsl:variable name="listType" select="'NSMutableArray*'" />

	<xsl:template match="/msdl:description/msdl:binding/msdl:operation">
		
		<xsl:variable name="fullOperation" select="./@ref" />
		<xsl:variable name="operationName" select="substring-after(./@ref, ':')" />
		
		<xsl:for-each select="/msdl:description/msdl:interface/msdl:operation[@name=$operationName]/*">
		
			<xsl:variable name="className" select="substring-after(./@element, ':')" />
			<xsl:variable name="headerFileName" select="concat($outputFolder, $className, '.h')" />
			<xsl:variable name="implFileName" select="concat($outputFolder, $className, '.m')" />
			<xsl:variable name="direction" select="local-name()" />
			
			<!-- Header file -->
			<xsl:result-document href="{$headerFileName}">
<xsl:text>#import &lt;MXi/MXi.h&gt;

@interface </xsl:text>
				<xsl:value-of select="$className" />
<xsl:text> : MXiBean &lt;</xsl:text>
				<xsl:if test="$direction = 'input'">MXiOutgoingBean</xsl:if>
				<xsl:if test="$direction = 'output'">MXiIncomingBean</xsl:if>
<xsl:text>&gt;

</xsl:text>
				<xsl:for-each select="/msdl:description/msdl:types/xs:schema/xs:element[@name=$className]/xs:complexType/xs:sequence/xs:element">
<xsl:text>@property (nonatomic</xsl:text>
					<xsl:choose>
						<xsl:when test="./@type = 'xs:string'">
							<xsl:text>, strong) </xsl:text><xsl:value-of select="$stringType" />
						</xsl:when>
						<xsl:when test="./@type = 'xs:int'">
							<xsl:text>) </xsl:text><xsl:value-of select="$intType" />
						</xsl:when>
						<xsl:when test="./@type = 'xs:long'">
							<xsl:text>) </xsl:text><xsl:value-of select="$longType" />
						</xsl:when>
						<xsl:when test="./@type = 'xs:boolean'">
							<xsl:text>) </xsl:text><xsl:value-of select="$booleanType" />
						</xsl:when>
						<xsl:when test="starts-with(./@type, $serviceXMLNS)">
							<xsl:text>, strong) </xsl:text><xsl:value-of select="substring-after(./@type, ':')" /><xsl:text>*</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>, strong) </xsl:text><xsl:text>&lt;unknown&gt;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="$space" />
					<xsl:value-of select="./@name" />
					<xsl:text>;</xsl:text>
					<xsl:value-of select="$newline" />
				</xsl:for-each>
<xsl:text>
- (id)init;

@end</xsl:text>
			</xsl:result-document>
			
			<!-- Implementation file -->
			<xsl:result-document href="{$implFileName}">
<xsl:text>#import "</xsl:text><xsl:value-of select="substring-after($headerFileName, '/')" /><xsl:text>"

@implementation </xsl:text><xsl:value-of select="$className" /><xsl:text>

@synthesize </xsl:text>
				<xsl:for-each select="/msdl:description/msdl:types/xs:schema/xs:element[@name=$className]/xs:complexType/xs:sequence/xs:element">
					<xsl:value-of select="./@name" />
					<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
<xsl:text>;

- (id)init {
	self = [super initWithBeanType:</xsl:text>
				<xsl:variable name="fullDirection" select="concat('msdl:', $direction)" />
				<xsl:variable name="iqType" select="/msdl:description/msdl:binding/msdl:operation[@ref=$fullOperation]/*[name()=$fullDirection]/@xmpp:type" />
				
				<xsl:if test="$iqType = 'get'">
					<xsl:text>GET</xsl:text>
				</xsl:if>
				<xsl:if test="$iqType = 'set'">
					<xsl:text>SET</xsl:text>
				</xsl:if>
				<xsl:if test="$iqType = 'result'">
					<xsl:text>RESULT</xsl:text>
				</xsl:if>
				<xsl:if test="$iqType = 'error'">
					<xsl:text>ERROR</xsl:text>
				</xsl:if>
<xsl:text>];
	
	return self;
}

- (NSXMLElement* )toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	
	[listIdElement setStringValue:[self listId]];
	[beanElement addChild:listIdElement];
	
	return beanElement;
}

+ (NSString* )elementName {
	return @"</xsl:text><xsl:value-of select="$className" /><xsl:text>";
}

+ (NSString* )iqNamespace {
	return @"</xsl:text><xsl:value-of select="/msdl:description/msdl:binding/msdl:operation[@ref=$fullOperation]/@xmpp:ident" /><xsl:text>";
}

@end</xsl:text>	
			</xsl:result-document>
			
		</xsl:for-each>
		
	</xsl:template>
</xsl:stylesheet>