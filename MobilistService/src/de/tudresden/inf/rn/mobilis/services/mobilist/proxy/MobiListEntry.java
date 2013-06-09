package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;

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

	@XmlElement(name = "entryId")
	public String getEntryId() {
		return entryId;
	}

	public void setEntryId(String id) {
		this.entryId = id;
	}

	@XmlElement(name = "title")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@XmlElement(name = "description")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@XmlElement(name = "dueDate")
	public long getDueDate() {
		return dueDate;
	}

	public void setDueDate(long dueDate) {
		this.dueDate = dueDate;
	}

	@XmlElement(name = "done")
	public boolean isDone() {
		return done;
	}

	public void setDone(boolean done) {
		this.done = done;
	}

	@Override
	public void fromXML(XmlPullParser parser) throws Exception {
		boolean done = false;
		
		do {
			switch (parser.getEventType()) {
			case XmlPullParser.START_TAG:
				String tagName = parser.getName();
				
				if (tagName.equals("entryId")) {
					entryId = parser.nextText();
					parser.next();
				} else if (tagName.equals("title")) {
					title = parser.nextText();
					parser.next();
				} else if (tagName.equals("description")) {
					description = parser.nextText();
					parser.next();
				} else if (tagName.equals("dueDate")) {
					dueDate = Long.parseLong(parser.nextText());
					parser.next();
				} else if (tagName.equals("done")) {
					String doneString = parser.nextText();
					if ("true".equals(doneString)) {
						done = true;
					} else {
						done = false;
					}
					parser.next();
				} else if (tagName.equals("error")) {
					parser = parseErrorAttributes(parser);
				} else {
					parser.next();
				}
				break;
			case XmlPullParser.END_TAG:
				if (parser.getName().equals(getChildElement())) {
					done = true;
				} else {
					parser.next();
				}
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
		return "entry";
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
		
		sb.append("<entryId>").append(entryId).append("</entryId>")
			.append("<title>").append(title).append("</title>")
			.append("<description>").append(description).append("</description>")
			.append("<dueDate>").append(dueDate).append("</dueDate>")
			.append("<done>").append(done).append("</done>");
			
		return sb.toString();
	}
	
}