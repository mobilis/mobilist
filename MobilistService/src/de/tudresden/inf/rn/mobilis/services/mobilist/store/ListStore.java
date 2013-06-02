package de.tudresden.inf.rn.mobilis.services.mobilist.store;

import java.util.ArrayList;
import java.util.List;

import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.MobiList;

public class ListStore {

	/*
	 * Singleton
	 */
	private ListStore() {}
	
	private static ListStore instance;
	
	public static synchronized ListStore getInstance() {
		if (instance == null) {
			instance = new ListStore();
		}
		
		return instance;
	}
	/*
	 * End singleton
	 */
	
	private List<MobiList> allLists = new ArrayList<MobiList>();
	
	public List<MobiList> getAllLists() {
		return allLists;
	}

	public void setAllLists(List<MobiList> allLists) {
		this.allLists = allLists;
	}
	
	public boolean addList(MobiList list) {
		return allLists.add(list);
	}
	
	public boolean removeList(String id) {
		for (MobiList list : allLists) {
			if (list.getId().equals(id)) {
				return allLists.remove(list);
			}
		}
		
		return false;
	}
	
	public MobiList getListById(String listId) {
		for (MobiList list : allLists) {
			if (listId.equals(list.getId()))
				return list;
		}
		
		return null;
	}
	
	public void persist() {
		
	}
	
	public void load() {
		
	}
	
}