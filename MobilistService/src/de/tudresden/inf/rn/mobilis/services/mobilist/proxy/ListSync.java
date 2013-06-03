package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

public class ListSync {

	private String listId, listCrc;
	
	public ListSync() {}
	
	public ListSync(String id, String crc) {
		this.listId = id;
		this.listCrc = crc;
	}
	
	public String getListId() {
		return listId;
	}

	public void setListId(String id) {
		this.listId = id;
	}

	public String getListCrc() {
		return listCrc;
	}

	public void setListCrc(String crc) {
		this.listCrc = crc;
	}

}