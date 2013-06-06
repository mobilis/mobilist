package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class MobiListEntry extends XMPPBean {

	private static final long serialVersionUID = -7632223960179120287L;
	private String entryId, title, description;
	private long dueDate;
	private boolean done;
	
	public MobiListEntry() {}
	
	public MobiListEntry(String id, String title, String description,
			long dueDate, boolean done) {
		this.entryId = id;
		this.title = title;
		this.description = description;
		this.dueDate = dueDate;
		this.done = done;
	}

	@Override
	public String toString() {
		return title;
	}

	public String getEntryId() {
		return entryId;
	}

	public void setEntryId(String id) {
		this.entryId = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getDueDate() {
		return dueDate;
	}

	public void setDueDate(long dueDate) {
		this.dueDate = dueDate;
	}

	public boolean isDone() {
		return done;
	}

	public void setDone(boolean done) {
		this.done = done;
	}

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
		
		sb.append("<entryId>").append(entryId).append("</entryId>")
			.append("<title>").append(title).append("</title>")
			.append("<description>").append(description).append("</description>")
			.append("<dueDate>").append(dueDate).append("</dueDate>")
			.append("<done>").append(done).append("</done>");
			
		return sb.toString();
	}
	
}