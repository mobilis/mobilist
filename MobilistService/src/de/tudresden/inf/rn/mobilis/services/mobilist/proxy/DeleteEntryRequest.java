package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class DeleteEntryRequest extends XMPPBean {

	private static final long serialVersionUID = -3646243040003950301L;
	private String listId;
	private String entryId = null;

	public DeleteEntryRequest( String id ) {
		super();
		this.entryId = id;

		this.setType( XMPPBean.TYPE_SET );
	}

	public DeleteEntryRequest(){
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
				else if (tagName.equals( "entryId" ) ) {
					this.entryId = parser.nextText();
					parser.next();
				}
				else if (tagName.equals("listId")) {
					listId = parser.nextText();
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

	public static final String CHILD_ELEMENT = "DeleteEntryRequest";

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
		DeleteEntryRequest clone = new DeleteEntryRequest( entryId );
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

	public String getListId() {
		return listId;
	}

	public void setListId(String listId) {
		this.listId = listId;
	}

}