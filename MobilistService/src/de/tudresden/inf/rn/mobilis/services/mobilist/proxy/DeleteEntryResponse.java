package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class DeleteEntryResponse extends XMPPBean {

	private static final long serialVersionUID = -5357286828001365759L;
	private String entryId = null;

	public DeleteEntryResponse( String id ) {
		super();
		this.entryId = id;

		this.setType( XMPPBean.TYPE_RESULT );
	}

	public DeleteEntryResponse(){
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
					parser.next();
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

	public static final String CHILD_ELEMENT = "DeleteEntryResponse";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:deleteentry";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		DeleteEntryResponse clone = new DeleteEntryResponse( entryId );
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