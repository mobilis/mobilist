package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class SyncResponse extends XMPPBean {

	private ListsSync lists = new ListsSync();

	private static final long serialVersionUID = 7135022565298974542L;

	public SyncResponse(ListsSync lists) {
		super();
		this.lists = lists;

		this.setType( XMPPBean.TYPE_RESULT );
	}

	public SyncResponse(){
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
				else if (tagName.equals( "lists" ) ) {
					// TODO implement
					System.out.println("Trying to parse lists element from xml");
					//this.lists = List<MobiList>( parser.nextText() );
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

	public static final String CHILD_ELEMENT = "SyncResponse";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:sync";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		SyncResponse clone = new SyncResponse( lists );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() {
		StringBuilder sb = new StringBuilder();

		sb.append("<lists>")
			.append(this.lists.toString())
			.append("</lists>");

		sb = appendErrorPayload(sb);

		return sb.toString();
	}

	public ListsSync getLists() {
		return this.lists;
	}

	public void setLists(ListsSync lists) {
		this.lists = lists;
	}

}