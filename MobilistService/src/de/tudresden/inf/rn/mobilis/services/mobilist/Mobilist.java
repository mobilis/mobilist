package de.tudresden.inf.rn.mobilis.services.mobilist;

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
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.PingRequest;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.PingResponse;
import de.tudresden.inf.rn.mobilis.services.mobilist.proxy.SyncRequest;
import de.tudresden.inf.rn.mobilis.xmpp.beans.ProxyBean;
import de.tudresden.inf.rn.mobilis.xmpp.beans.XMPPBean;
import de.tudresden.inf.rn.mobilis.xmpp.server.BeanIQAdapter;
import de.tudresden.inf.rn.mobilis.xmpp.server.BeanProviderAdapter;

public class Mobilist extends MobilisService {

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
	}

	class IQListener implements PacketListener {

		@Override
		public void processPacket(Packet packet) {
			System.out.println("Incoming packet: " + packet.toXML());
			
			if (packet instanceof BeanIQAdapter) {
				
				XMPPBean inBean = ((BeanIQAdapter) packet).getBean();
				if (inBean instanceof ProxyBean) {
					
					ProxyBean proxyBean = (ProxyBean) inBean;
					if (proxyBean.isTypeOf(PingRequest.NAMESPACE, PingRequest.CHILD_ELEMENT)) {
						
						PingRequest request = (PingRequest) proxyBean.parsePayload(new PingRequest());
						
						PingResponse response = new PingResponse(request.getContent());
						response.setFrom(request.getTo());
						response.setTo(request.getFrom());
						
						getAgent().getConnection().sendPacket(new BeanIQAdapter(response));
						
					}
					
				}
				
			}
		}
		
	}

}