package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class DeleteListResponse extends XMPPBean {

	private static final long serialVersionUID = -5357286828001365759L;
	private String listId = null;


	public DeleteListResponse( String id ) {
		super();
		this.listId = id;

		this.setType( XMPPBean.TYPE_RESULT );
	}

	public DeleteListResponse(){
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
				else if (tagName.equals( "listId" ) ) {
					this.listId = parser.nextText();
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

	public static final String CHILD_ELEMENT = "DeleteListResponse";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:deletelist";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		DeleteListResponse clone = new DeleteListResponse( listId );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append( "<listId>" )
			.append( this.listId )
			.append( "</listId>" );

		sb = appendErrorPayload(sb);

		return sb.toString();
	}

	public String getListId() {
		return this.listId;
	}

	public void setListId( String id ) {
		this.listId = id;
	}

}