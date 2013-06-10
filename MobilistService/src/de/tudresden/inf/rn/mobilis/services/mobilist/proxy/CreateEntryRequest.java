package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class CreateEntryRequest extends XMPPBean {

	private static final long serialVersionUID = 1936014091017441326L;
	
	private String listId;
	private MobiListEntry entry = new MobiListEntry();

	public CreateEntryRequest(MobiListEntry entry) {
		super();
		this.entry = entry;

		this.setType( XMPPBean.TYPE_SET );
	}

	public CreateEntryRequest(){
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
				} else if (tagName.equals( "entry" ) ) {
					this.entry.fromXML(parser);
				} else if (tagName.equals("error")) {
					parser = parseErrorAttributes(parser);
				} else if (tagName.equals("listId")) {
					setListId(parser.nextText());
					parser.next();
				} else {
					parser.next();
				}
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

	public static final String CHILD_ELEMENT = "CreateEntryRequest";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:createentry";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		CreateEntryRequest clone = new CreateEntryRequest( entry );
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

	public void setEntry(MobiListEntry entry) {
		this.entry = entry;
	}

	public String getListId() {
		return listId;
	}

	public void setListId(String listId) {
		this.listId = listId;
	}

}