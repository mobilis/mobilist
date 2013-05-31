package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class EntryDeletedAccept extends XMPPBean {

	private static final long serialVersionUID = -1251791693553167603L;
	private String id = null;

	public EntryDeletedAccept( String id ) {
		super();
		this.id = id;

		this.setType( XMPPBean.TYPE_RESULT );
	}

	public EntryDeletedAccept(){
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
				else if (tagName.equals( "id" ) ) {
					this.id = parser.nextText();
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

	public static final String CHILD_ELEMENT = "EntryDeletedAccept";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:entrydeleted";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		EntryDeletedAccept clone = new EntryDeletedAccept( id );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append( "<id>" )
			.append( this.id )
			.append( "</id>" );

		sb = appendErrorPayload(sb);

		return sb.toString();
	}


	public String getId() {
		return this.id;
	}

	public void setId( String id ) {
		this.id = id;
	}

}