package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

public class ListSync {

	private String id, crc;
	
	public ListSync() {}
	
	public ListSync(String id, String crc) {
		this.id = id;
		this.crc = crc;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCrc() {
		return crc;
	}

	public void setCrc(String crc) {
		this.crc = crc;
	}

}