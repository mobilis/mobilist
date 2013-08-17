package de.tudresden.inf.rn.mobilis.services.mobilist.proxy;

import java.util.ArrayList;
import java.util.List;

public class ListsSync {

	private List<ListSync> listSyncs = new ArrayList<ListSync>();
	
	public ListsSync() {}
	
	public ListsSync(List<ListSync> listSyncs) {
		this.setListSyncs(listSyncs);
	}

	public List<ListSync> getListSyncs() {
		return listSyncs;
	}

	public void setListSyncs(List<ListSync> listSyncs) {
		this.listSyncs = listSyncs;
	}

	@Override
	public String toString() {
		StringBuilder s = new StringBuilder();
		
		for (ListSync list : listSyncs) {
			s.append("<list>");
			s.append("<listId>" + list.getListId() + "</listId>");
			s.append("<listCrc>" + list.getListCrc() + "</listCrc>");
			s.append("</list>");
		}
		
		return s.toString();
	}

}