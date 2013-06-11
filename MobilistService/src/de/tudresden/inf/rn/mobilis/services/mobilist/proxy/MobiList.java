package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlTransient;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class MobiList extends XMPPBean {

	private static final long serialVersionUID = 2317256615233615530L;
	private List<MobiListEntry> entries = new ArrayList<MobiListEntry>();
	private String listId, listName;
	
	public MobiList() {}
	
	public MobiList(String id, String name, List<MobiListEntry> entries) {
		this.setListId(id);
		this.setListName(name);
		this.setEntries(entries);
	}

	@Override
	public String toString() {
		StringBuilder s = new StringBuilder();
		
		s.append(listName + " (" + entries.get(0));
		for (int i = 1; i < entries.size(); i++) {
			s.append(", " + entries.get(i));
		}
		s.append(")");
		
		return s.toString();
	}
	
	public MobiListEntry getEntryById(String entryId) {
		for (MobiListEntry entry : entries) {
			if (entry.getEntryId().equals(entryId)) {
				return entry;
			}
		}
		
		return null;
	}
	
	public boolean removeEntryById(String entryId) {
		for (int i = 0; i < entries.size(); i++) {
			if (entries.get(i).getEntryId().equals(entryId)) {
				entries.remove(i);
				return true;
			}
		}
		
		return false;
	}

	@XmlElement(name = "listId")
	public String getListId() {
		return listId;
	}

	public void setListId(String id) {
		this.listId = id;
	}

	@XmlElement(name = "listName")
	public String getListName() {
		return listName;
	}

	public void setListName(String name) {
		this.listName = name;
	}

	@XmlElementWrapper(name = "listEntries")
	@XmlElement(name = "entry")
	public List<MobiListEntry> getEntries() {
		return entries;
	}

	public void setEntries(List<MobiListEntry> entries) {
		this.entries = entries;
	}

	@Override
	public void fromXML(XmlPullParser parser) throws Exception {
		boolean done = false;
		
		do {
			switch (parser.getEventType()) {
			case XmlPullParser.START_TAG:
				String tagName = parser.getName();
				
				if (tagName.equals( "listName" ) ) {
					listName = parser.nextText();
					parser.next();
				} else if (tagName.equals("listId")) {
					listId = parser.nextText();
					parser.next();
				} else if (tagName.equals("entry")) {
					MobiListEntry entry = new MobiListEntry();
					entry.fromXML(parser);
					entries.add(entry);
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

	@Override
	@XmlTransient
	public String getChildElement() {
		return null;
	}

	@Override
	@XmlTransient
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
		
		if (entries != null) {
			for (MobiListEntry entry : entries) {
				sb.append("<entry>")
					.append(entry.payloadToXML())
					.append("</entry>");
			}
		}
		
		return sb.toString();
	}
	
}