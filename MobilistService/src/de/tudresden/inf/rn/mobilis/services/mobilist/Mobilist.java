package de.tudresden.inf.rn.mobilis.services.mobilist;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.jivesoftware.smack.PacketListener;
import org.jivesoftware.smack.filter.PacketTypeFilter;
import org.jivesoftware.smack.packet.IQ;
import org.jivesoftware.smack.packet.Packet;

import de.tudresden.inf.rn.mobilis.server.agents.MobilisAgent;
import de.tudresden.inf.rn.mobilis.server.services.MobilisService;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateEntryResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateListResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteEntryResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteListResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditEntryResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditListResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EntryCreatedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EntryDeletedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EntryEditedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.GetListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.GetListResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.ListCreatedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.ListDeletedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.ListEditedInfo;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.ListSync;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.ListsSync;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.MobiList;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.MobiListEntry;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.PingRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.PingResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.SyncRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.SyncResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.store.ListStore;
import de.tudresden.inf.rn.mobilis.xmpp.beans.ProxyBean;
import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;
import de.tudresden.inf.rn.mobilis.xmpp.server.BeanIQAdapter;
import de.tudresden.inf.rn.mobilis.xmpp.server.BeanProviderAdapter;

public class Mobilist extends MobilisService {

	private ListStore listStore = ListStore.getInstance();
	private Set<String> knownClientsJabberIds = new HashSet<String>();
	
	private final String XML_FILENAME = "liststore.xml";
	
	@Override
	protected void registerPacketListener() {
		(new BeanProviderAdapter(new ProxyBean(PingRequest.NAMESPACE, PingRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(SyncRequest.NAMESPACE, SyncRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(CreateEntryRequest.NAMESPACE, CreateEntryRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(CreateListRequest.NAMESPACE, CreateListRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(DeleteListRequest.NAMESPACE, DeleteListRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(DeleteEntryRequest.NAMESPACE, DeleteEntryRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(EditListRequest.NAMESPACE, EditListRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(EditEntryRequest.NAMESPACE, EditEntryRequest.CHILD_ELEMENT))).addToProviderManager();
		(new BeanProviderAdapter(new ProxyBean(GetListRequest.NAMESPACE, GetListRequest.CHILD_ELEMENT))).addToProviderManager();
		
		IQListener listener = new IQListener();
		PacketTypeFilter filter = new PacketTypeFilter(IQ.class);
		
		getAgent().getConnection().addPacketListener(listener, filter);
	}
	
	@Override
	public void startup(MobilisAgent agent) throws Exception {
		super.startup(agent);
		
		try {
			JAXBContext context = JAXBContext.newInstance(ListStore.class);
			Unmarshaller unmarshaller = context.createUnmarshaller();
			listStore = (ListStore) unmarshaller.unmarshal(new FileInputStream(XML_FILENAME));
		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
			listStore = ListStore.getInstance();
		}
	}

	@Override
	public void shutdown() throws Exception {
		super.shutdown();
		
		try {
			JAXBContext context = JAXBContext.newInstance(ListStore.class);
			Marshaller marshaller = context.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "ISO-8859-1");
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
			
			//marshaller.marshal(this, System.out);
			marshaller.marshal(listStore, new FileOutputStream(XML_FILENAME));
		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	class IQListener implements PacketListener {

		@Override
		public void processPacket(Packet packet) {
			System.out.println("Incoming packet: " + packet.toXML());
			
			if (packet instanceof BeanIQAdapter) {
				
				XMPPBean inBean = ((BeanIQAdapter) packet).getBean();
				if (inBean instanceof ProxyBean) {
					
					ProxyBean proxyBean = (ProxyBean) inBean;
					
					String to = proxyBean.getTo();
					String from = proxyBean.getFrom();
					
					if (!knownClientsJabberIds.contains(from)) {
						knownClientsJabberIds.add(from);
					}
					
					// Ping
					if (proxyBean.isTypeOf(PingRequest.NAMESPACE, PingRequest.CHILD_ELEMENT)) {
						PingRequest request = (PingRequest) proxyBean.parsePayload(new PingRequest());
						
						PingResponse response = new PingResponse(request.getContent());
						response.setFrom(request.getTo());
						response.setTo(request.getFrom());
						
						getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
					}
					
					// Sync
					if (proxyBean.isTypeOf(SyncRequest.NAMESPACE, SyncRequest.CHILD_ELEMENT)) {
						SyncRequest request = (SyncRequest) proxyBean.parsePayload(new SyncRequest());
						
						List<ListSync> allListSyncs = new ArrayList<ListSync>();
						
						for (MobiList list : listStore.getAllLists()) {
							allListSyncs.add(new ListSync(list.getListId(), list.hashCode() + ""));
						}
						
						ListsSync listsSync = new ListsSync(allListSyncs);
						
						SyncResponse response = new SyncResponse(listsSync);
						response.setFrom(request.getTo());
						response.setTo(request.getFrom());
						
						getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
					}
					
					// GetList
					if (proxyBean.isTypeOf(GetListRequest.NAMESPACE, GetListRequest.CHILD_ELEMENT)) {
						GetListRequest request = (GetListRequest) proxyBean.parsePayload(new GetListRequest());
						String requestedId = request.getListId();
						
						MobiList requestedList = listStore.getListById(requestedId);
						
						if (requestedList != null) {
							GetListResponse response = new GetListResponse(requestedList);
							response.setFrom(request.getTo());
							response.setTo(request.getFrom());
							
							getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
						} else {
							// TODO handle error case
						}
					}
					
					// CreateList
					if (proxyBean.isTypeOf(CreateListRequest.NAMESPACE, CreateListRequest.CHILD_ELEMENT)) {
						CreateListRequest request = (CreateListRequest) proxyBean.parsePayload(new CreateListRequest());
						MobiList theNewList = request.getList();
						
						ListStore.getInstance().addList(theNewList);
						
						/*try {
							Thread.sleep(2000);
						} catch (InterruptedException e) {
							e.printStackTrace();
						}*/
						
						// Confirm the list creation
						CreateListResponse response = new CreateListResponse();
						response.setListId(theNewList.getListId());
						response.setTo(request.getFrom());
						response.setFrom(request.getTo());
						
						getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
						
						// Inform other clients about the creation
						for (String clientJid : knownClientsJabberIds) {
							if (!clientJid.equals(from)) {
								ListCreatedInfo info = new ListCreatedInfo();
								info.setList(theNewList);
								info.setTo(clientJid);
								info.setFrom(to);
								getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
							}
						}
					}
					
					// DeleteList
					if (proxyBean.isTypeOf(DeleteListRequest.NAMESPACE, DeleteListRequest.CHILD_ELEMENT)) {
						DeleteListRequest request = (DeleteListRequest) proxyBean.parsePayload(new DeleteListRequest());
						String listId = request.getListId();
						
						boolean success = ListStore.getInstance().removeList(listId);
						
						if (success) {
							// Confirm the deletion of the list
							DeleteListResponse response = new DeleteListResponse();
							response.setListId(listId);
							response.setTo(request.getFrom());
							response.setFrom(request.getTo());
							
							getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
							
							// Inform other client about the deletion
							for (String clientJid : knownClientsJabberIds) {
								if (!clientJid.equals(from)) {
									ListDeletedInfo info = new ListDeletedInfo();
									info.setListId(listId);
									info.setTo(clientJid);
									info.setFrom(to);
									getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
								}
							}
						}
					}
					
					// EditList
					if (proxyBean.isTypeOf(EditListRequest.NAMESPACE, EditListRequest.CHILD_ELEMENT)) {
						EditListRequest request = (EditListRequest) proxyBean.parsePayload(new EditListRequest());
						MobiList editedList = request.getList();
						
						MobiList oldList = ListStore.getInstance().getListById(editedList.getListId());
						
						if (oldList != null) {
							oldList.setListName(editedList.getListName());
							oldList.setEntries(editedList.getEntries());
							
							/*try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {
								e.printStackTrace();
							}*/
							
							// Confirm the edit
							EditListResponse response = new EditListResponse();
							response.setListId(oldList.getListId());
							response.setTo(request.getFrom());
							response.setFrom(request.getTo());
							
							getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
							
							// Inform other clients about the edit
							for (String clientJid : knownClientsJabberIds) {
								if (!clientJid.equals(from)) {
									ListEditedInfo info = new ListEditedInfo();
									info.setList(editedList);
									info.setTo(clientJid);
									info.setFrom(to);
									getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
								}
							}
						} else {
							// TODO handle error case
						}
					}
					
					// CreateEntry
					if (proxyBean.isTypeOf(CreateEntryRequest.NAMESPACE, CreateEntryRequest.CHILD_ELEMENT)) {
						CreateEntryRequest request = (CreateEntryRequest) proxyBean.parsePayload(new CreateEntryRequest());
						String listId = request.getListId();
						MobiListEntry entry = request.getEntry();
						
						MobiList parent = listStore.getListById(listId);
						if (parent != null) {
							parent.getEntries().add(entry);
							
							/*try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {
								e.printStackTrace();
							}*/
							
							// Confirm the creation
							CreateEntryResponse response = new CreateEntryResponse();
							response.setEntryId(entry.getEntryId());
							response.setTo(request.getFrom());
							response.setFrom(request.getTo());
							
							getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
							
							// Inform other clients about the creation
							for (String clientJid : knownClientsJabberIds) {
								if (!clientJid.equals(from)) {
									EntryCreatedInfo info = new EntryCreatedInfo();
									info.setEntry(entry);
									info.setListId(listId);
									info.setTo(clientJid);
									info.setFrom(to);
									getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
								}
							}
						} else {
							// TODO handle error case
						}
					}
					
					// EditEntry
					if (proxyBean.isTypeOf(EditEntryRequest.NAMESPACE, EditEntryRequest.CHILD_ELEMENT)) {
						EditEntryRequest request = (EditEntryRequest) proxyBean.parsePayload(new EditEntryRequest());
						String listId = request.getListId();
						MobiListEntry editedEntry = request.getEntry();
						
						MobiList parent = listStore.getListById(listId);
						if (parent != null) {
							MobiListEntry oldEntry = parent.getEntryById(editedEntry.getEntryId());
							
							if (oldEntry != null) {
								oldEntry.setTitle(editedEntry.getTitle());
								oldEntry.setDescription(editedEntry.getDescription());
								oldEntry.setDueDate(editedEntry.getDueDate());
								oldEntry.setDone(editedEntry.isDone());
								
								/*try {
									Thread.sleep(2000);
								} catch (InterruptedException e) {
									e.printStackTrace();
								}*/
								
								// Confirm the editing
								EditEntryResponse response = new EditEntryResponse();
								response.setTo(request.getFrom());
								response.setFrom(request.getTo());
								response.setEntryId(editedEntry.getEntryId());
								
								getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
								
								// Inform other clients about the editing
								for (String clientJid : knownClientsJabberIds) {
									if (!clientJid.equals(from)) {
										EntryEditedInfo info = new EntryEditedInfo();
										info.setListId(listId);
										info.setEntry(editedEntry);
										info.setTo(clientJid);
										info.setFrom(to);
										getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
									}
								}
							} else {
								// TODO handle error case
							}
						} else {
							// TODO handle error case
						}
					}
					
					// DeleteEntry
					if (proxyBean.isTypeOf(DeleteEntryRequest.NAMESPACE, DeleteEntryRequest.CHILD_ELEMENT)) {
						DeleteEntryRequest request = (DeleteEntryRequest) proxyBean.parsePayload(new DeleteEntryRequest());
						String listId = request.getListId();
						String entryId = request.getEntryId();
						
						MobiList parent = listStore.getListById(listId);
						
						if (parent != null) {
							boolean success = parent.removeEntryById(entryId);
							
							if (success) {
								// Confirm the deletion
								DeleteEntryResponse response = new DeleteEntryResponse();
								response.setEntryId(entryId);
								response.setTo(request.getFrom());
								response.setFrom(request.getTo());
								
								getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
								
								// Inform other clients about the deletion
								for (String clientJid : knownClientsJabberIds) {
									if (!clientJid.equals(from)) {
										EntryDeletedInfo info = new EntryDeletedInfo();
										info.setListId(listId);
										info.setEntryId(entryId);
										info.setTo(clientJid);
										info.setFrom(to);
										getAgent().getConnection().sendPacket(new BeanIQAdapter(info));
									}
								}
							} else {
								// TODO handle error case
							}
						} else {
							// TODO handle error case
						}
					}
				}
				
			}
		}
		
	}

}