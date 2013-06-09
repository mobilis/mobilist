package de.tudresden.inf.rn.mobilis.services.mobilist.store;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.MobiList;

@XmlRootElement(name = "listStore")
@XmlType(factoryMethod = "getInstance")
public class ListStore {

	/*
	 * Singleton
	 */
	//private ListStore() {}
	
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
	
	@XmlElementWrapper(name = "lists")
	@XmlElement(name = "list")
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
			if (list.getListId().equals(id)) {
				return allLists.remove(list);
			}
		}
		
		return false;
	}
	
	public MobiList getListById(String listId) {
		for (MobiList list : allLists) {
			if (listId.equals(list.getListId()))
				return list;
		}
		
		return null;
	}
	
}