package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class EditEntryRequest extends XMPPBean {

	private static final long serialVersionUID = 8039539533948206770L;
	private String listId;
	private MobiListEntry entry = new MobiListEntry();

	public EditEntryRequest( MobiListEntry list ) {
		super();
		this.entry = list;

		this.setType( XMPPBean.TYPE_SET );
	}

	public EditEntryRequest(){
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
				} else if (tagName.equals("listId")) {
					this.setListId(parser.nextText());
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

	public static final String CHILD_ELEMENT = "EditEntryRequest";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:editentry";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		EditEntryRequest clone = new EditEntryRequest( entry );
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

	public String getListId() {
		return listId;
	}

	public void setListId(String listId) {
		this.listId = listId;
	}

}