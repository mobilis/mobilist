package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import java.util.List;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class MobiList extends XMPPBean {

	private static final long serialVersionUID = 2317256615233615530L;
	private List<MobiListEntry> entries;
	
	public MobiList() {}
	
	public MobiList(List<MobiListEntry> entries) {
		this.setEntries(entries);
	}

	public List<MobiListEntry> getEntries() {
		return entries;
	}

	public void setEntries(List<MobiListEntry> entries) {
		this.entries = entries;
	}

	// TODO implement
	
	@Override
	public void fromXML(XmlPullParser parser) throws Exception {
	}

	@Override
	public String getChildElement() {
		return null;
	}

	@Override
	public String getNamespace() {
		return null;
	}

	@Override
	public XMPPBean clone() {
		return null;
	}

	@Override
	public String payloadToXML() {
		return null;
	}
	
}