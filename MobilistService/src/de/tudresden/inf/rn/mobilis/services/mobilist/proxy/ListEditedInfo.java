package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class ListEditedInfo extends XMPPBean {

	private MobiList list = new MobiList();

	private static final long serialVersionUID = 7074172343742279453L;

	public ListEditedInfo( MobiList list ) {
		super();
		this.list = list;

		this.setType( XMPPBean.TYPE_SET );
	}

	public ListEditedInfo(){
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
				else if (tagName.equals( "list" ) ) {
					this.list.fromXML(parser);
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

	public static final String CHILD_ELEMENT = "ListEditedInfo";

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
		ListEditedInfo clone = new ListEditedInfo( list );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append("<list>")
			.append("<listName>")
			.append(list.getListName())
			.append("</listName><listId>")
			.append(list.getListId())
			.append("</listId>")
			.append("<entries>")
			.append(list.payloadToXML())
			.append("</entries>")
			.append("</list>");

		sb = appendErrorPayload(sb);

		return sb.toString();
	}


	public MobiList getList() {
		return this.list;
	}

	public void setList( MobiList list ) {
		this.list = list;
	}

}