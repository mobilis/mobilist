package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import org.xmlpull.v1.XmlPullParser;

import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;

public class MobiListEntry extends XMPPBean {

	private static final long serialVersionUID = -7632223960179120287L;
	private String id, title, description;
	private long dueDate;
	private boolean done;
	
	public MobiListEntry() {}
	
	public MobiListEntry(String id, String title, String description,
			long dueDate, boolean done) {
		this.id = id;
		this.title = title;
		this.description = description;
		this.dueDate = dueDate;
		this.done = done;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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