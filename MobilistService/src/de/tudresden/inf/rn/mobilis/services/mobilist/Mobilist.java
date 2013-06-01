package de.tudresden.inf.rn.mobilis.services.mobilist;

import java.util.ArrayList;
import java.util.List;

import org.jivesoftware.smack.PacketListener;
import org.jivesoftware.smack.filter.PacketTypeFilter;
import org.jivesoftware.smack.packet.IQ;
import org.jivesoftware.smack.packet.Packet;

import de.tudresden.inf.rn.mobilis.server.agents.MobilisAgent;
import de.tudresden.inf.rn.mobilis.server.services.MobilisService;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.CreateListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.DeleteListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditEntryRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.EditListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.GetListRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.GetListResponse;
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
		
		MobiListEntry entry1 = new MobiListEntry(
			"entry1", "Eier", "Eier kaufen", 1372158001, false
		);
		MobiListEntry entry2 = new MobiListEntry(
			"entry2", "Mehl", "Mehl kaufen", 1372158001, true
		);
		MobiListEntry entry3 = new MobiListEntry(
			"entry3", "Milch", "Milch kaufen", 1372158001, false
		);
		List<MobiListEntry> entries1 = new ArrayList<MobiListEntry>();
		entries1.add(entry1);
		entries1.add(entry2);
		entries1.add(entry3);
		MobiList list1 = new MobiList("shopping_list", "Einkaufsliste", entries1);
		
		MobiListEntry entry4 = new MobiListEntry(
			"entry1", "Schreiben", "Beleg schreiben", 1372158001, false
		);
		MobiListEntry entry5 = new MobiListEntry(
			"entry2", "Implementieren", "Library implementieren", 1372158001, false
		);
		List<MobiListEntry> entries2 = new ArrayList<MobiListEntry>();
		entries2.add(entry4);
		entries2.add(entry5);
		MobiList list2 = new MobiList("thesis_list", "Großer Beleg", entries2);
		
		listStore.addList(list1);
		listStore.addList(list2);
	}

	class IQListener implements PacketListener {

		@Override
		public void processPacket(Packet packet) {
			System.out.println("Incoming packet: " + packet.toXML());
			
			if (packet instanceof BeanIQAdapter) {
				
				XMPPBean inBean = ((BeanIQAdapter) packet).getBean();
				if (inBean instanceof ProxyBean) {
					
					ProxyBean proxyBean = (ProxyBean) inBean;
					
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
							allListSyncs.add(new ListSync(list.getId(), list.hashCode() + ""));
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
						String requestedId = request.getId();
						
						MobiList requestedList = listStore.getListById(requestedId);
						
						if (requestedList != null) {
							GetListResponse response = new GetListResponse(requestedList);
							response.setFrom(request.getTo());
							response.setTo(request.getFrom());
							
							getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
						}
					}
					
				}
				
			}
		}
		
	}

}