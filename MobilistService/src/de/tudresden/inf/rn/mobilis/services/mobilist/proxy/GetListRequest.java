package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class GetListRequest extends XMPPBean {

	private String listId;
	
	private static final long serialVersionUID = 5555898058750352953L;

	public GetListRequest(){
		this.setType( XMPPBean.TYPE_GET );
	}

	public String getListId() {
		return listId;
	}

	public void setListId(String id) {
		this.listId = id;
	}

	@Override
	public void fromXML(XmlPullParser parser) throws Exception {
		boolean done = false;
		
		do {
			switch (parser.getEventType()) {
				case XmlPullParser.START_TAG:
					String tagName = parser.getName();
					
					if (tagName.equals(getChildElement())) {
						parser.next();
					} else if (tagName.equals("listId")) {
						this.listId = parser.nextText();
					} else if (tagName.equals("error")) {
						parser = parseErrorAttributes(parser);
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

	public static final String CHILD_ELEMENT = "GetListRequest";

	@Override
	public String getChildElement() {
		return CHILD_ELEMENT;
	}

	public static final String NAMESPACE = "mobilist:iq:getlist";

	@Override
	public String getNamespace() {
		return NAMESPACE;
	}

	@Override
	public XMPPBean clone() {
		GetListRequest clone = new GetListRequest(  );
		clone.cloneBasicAttributes( clone );

		return clone;
	}

	@Override
	public String payloadToXML() { return ""; }

}