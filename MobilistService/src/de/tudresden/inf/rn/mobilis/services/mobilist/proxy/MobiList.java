package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import java.util.List;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class MobiList extends XMPPBean {

	private static final long serialVersionUID = 2317256615233615530L;
	private List<MobiListEntry> entries;
	private String id, name;
	
	public MobiList() {}
	
	public MobiList(String id, String name, List<MobiListEntry> entries) {
		this.setId(id);
		this.setName(name);
		this.setEntries(entries);
	}

	@Override
	public String toString() {
		StringBuilder s = new StringBuilder();
		
		s.append(name + " (" + entries.get(0));
		for (int i = 1; i < entries.size(); i++) {
			s.append(", " + entries.get(i));
		}
		s.append(")");
		
		return s.toString();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
		StringBuilder sb = new StringBuilder();
		
		for (MobiListEntry entry : entries) {
			sb.append("<entry>")
				.append(entry.payloadToXML())
				.append("</entry>");
		}
		
		return sb.toString();
	}
	
}