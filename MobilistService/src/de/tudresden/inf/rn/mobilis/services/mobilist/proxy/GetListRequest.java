package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class GetListRequest extends XMPPBean {

	private String id;
	
	private static final long serialVersionUID = 5555898058750352953L;

	public GetListRequest(){
		this.setType( XMPPBean.TYPE_GET );
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@Override
	public void fromXML(XmlPullParser parser) throws Exception {
		boolean done = false;
		
		do {
			switch (parser.getEventType()) {
				case XmlPullParser.START_TAG:
					String tagName = parser.getName();
					
					if (tagName.equals(getChildElement())) {
						// get the list id out of the attribute
						id = parser.getAttributeValue(null, "id");
						
						parser.next();
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