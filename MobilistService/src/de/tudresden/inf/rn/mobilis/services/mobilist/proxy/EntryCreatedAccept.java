package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class EntryCreatedAccept extends XMPPBean {

	private static final long serialVersionUID = -656659135833981260L;
	private String entryId = null;

	public EntryCreatedAccept( String id ) {
		super();
		this.entryId = id;

		this.setType( XMPPBean.TYPE_RESULT );
	}

	public EntryCreatedAccept(){
		this.setType( XMPPBean.TYPE_RESULT );
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
				else if (tagName.equals( "entryId" ) ) {
					this.entryId = parser.nextText();
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

	public static final String CHILD_ELEMENT = "EntryCreatedAccept";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "http://mobilis.inf.tu-dresden.de/Mobilist";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		EntryCreatedAccept clone = new EntryCreatedAccept( entryId );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append( "<entryId>" )
			.append( this.entryId )
			.append( "</entryId>" );

		sb = appendErrorPayload(sb);

		return sb.toString();
	}


	public String getEntryId() {
		return this.entryId;
	}

	public void setEntryId( String id ) {
		this.entryId = id;
	}

}