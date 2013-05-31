package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class EntryCreatedInfo extends XMPPBean {

	private MobiListEntry entry = new MobiListEntry();

	private static final long serialVersionUID = 6365656680286516810L;

	public EntryCreatedInfo( MobiListEntry entry ) {
		super();
		this.entry = entry;

		this.setType( XMPPBean.TYPE_SET );
	}

	public EntryCreatedInfo(){
		this.setType( XMPPBean.TYPE_SET );
	}


	@Override
	public void fromXML( XmlPullParser parser ) throws Exception {
		boolean done = false;
			
		do {
			switch (parser.getEventType()) {
			case XmlPullParser.START_TAG:
				String tagName = parser.getName();
				
				if (tagName.equals(getChildElement())) {
					parser.next();
				}
				else if (tagName.equals( "entry" ) ) {
					this.entry.fromXML(parser);
				}
				else if (tagName.equals("error")) {
					parser = parseErrorAttributes(parser);
				}
				else
					parser.next();
				break;
			case XmlPullParser.END_TAG:
				if (parser.getName().equals(getChildElement()))
					done = true;
				else
					parser.next();
				break;
			case XmlPullParser.END_DOCUMENT:
				done = true;
				break;
			default:
				parser.next();
			}
		} while (!done);
	}

	public static final String CHILD_ELEMENT = "EntryCreatedInfo";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:entrycreated";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		EntryCreatedInfo clone = new EntryCreatedInfo( entry );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append( "<entry>" )
			.append( this.entry )
			.append( "</entry>" );

		sb = appendErrorPayload(sb);

		return sb.toString();
	}


	public MobiListEntry getEntry() {
		return this.entry;
	}

	public void setEntry( MobiListEntry entry ) {
		this.entry = entry;
	}

}