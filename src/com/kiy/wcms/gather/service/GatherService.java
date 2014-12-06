package com.kiy.wcms.gather.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.gather.entity.Delivery;
import com.kiy.wcms.gather.entity.Gather;
import com.kiy.wcms.gather.entity.GatherAtta;
import com.kiy.wcms.gather.entity.GatherOrder;
import com.kiy.wcms.gather.entity.GatherParam;
import com.kiy.wcms.gather.entity.Logistics;
import com.kiy.wcms.gather.entity.ShipOrder;
import com.kiy.wcms.gather.entity.Shipments;
import com.kiy.wcms.gather.entity.ShipmentsAtta;
import com.kiy.wcms.gather.entity.ShipmentsDetail;
import com.kiy.wcms.gather.mapper.DeliveryMapper;
import com.kiy.wcms.gather.mapper.GatherAttaMapper;
import com.kiy.wcms.gather.mapper.GatherMapper;
import com.kiy.wcms.gather.mapper.LogisticsMapper;
import com.kiy.wcms.gather.mapper.ShipmentsAttaMapper;
import com.kiy.wcms.gather.mapper.ShipmentsDetailMapper;
import com.kiy.wcms.gather.mapper.ShipmentsMapper;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("gatherService")
public class GatherService {
	@Autowired
	private GatherMapper gatherMapper;
	@Autowired
	private GatherAttaMapper gatherAttaMapper;
	@Autowired
	private ShipmentsMapper shipmentsMapper;
	@Autowired
	private ShipmentsAttaMapper shipmentsAttaMapper;
	@Autowired
	private ShipmentsDetailMapper shipmentsDetailMapper;
	@Autowired
	private AuditService auditService;
	@Autowired
	private DeliveryMapper deliveryMapper;
	@Autowired
	private LogisticsMapper logisticsMapper;
	
	/**
	 * 展示订单
	 * @param param
	 * @return
	 */
	public JSONObject showOrders(GatherParam param) {
		List<GatherOrder> list = gatherMapper.showOrders(param);
		int total = gatherMapper.showTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 根据订单号获取收款单
	 * @param orderId
	 * @param begin
	 * @param rows
	 * @return
	 */
	public JSONObject getGatherList(String orderId, int begin, Integer rows) {
		List<Gather> list = gatherMapper.getGatherList(orderId, begin, rows);
		int total = gatherMapper.getGatherTotal(orderId);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 保存收款单
	 * @param gather
	 * @param user
	 * @return
	 */
	public boolean saveGather(Gather gather, SysUser user) {
		gather.setCreateUser(user.getId());
		gather.setCode(getNextCode());
		gatherMapper.saveGather(gather);
		return true;
	}
	
	/**
	 * 获取下一个收款单号
	 * @return
	 */
	private String getNextCode() {
		Integer nextNo = gatherMapper.getNextNo();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String gatherNo = "G-" + new SimpleDateFormat("yyyy").format(new Date());
		
		for(int i=noStr.length();i<4;i++){
			gatherNo += "0";
		}
		
		gatherNo += noStr;
		return gatherNo;
	}
	
	/**
	 * 更新收款单
	 * @param gather
	 * @return
	 */
	public boolean updateGather(Gather gather) {
		gatherMapper.updateGather(gather);
		return true;
	}
	
	/**
	 * 删除收款单
	 * @param id
	 * @return
	 */
	public boolean deleteGather(int id) {
		gatherMapper.deleteGather(id);
		return true;
	}
	
	/**
	 * 提交收款单
	 * @param id
	 * @return
	 */
	public boolean submitGather(int id) {
		gatherMapper.submitGather(id);
		return true;
	}
	
	/**
	 * 上传收款单附件
	 * @param gatherId
	 * @param path
	 * @param name
	 * @return
	 */
	public boolean saveGatherAtta(String gatherId, String path, String name) {
		gatherAttaMapper.saveGatherAtta(gatherId, path, name);
		return true;
	}
	
	/**
	 * 获取收款单附件列表
	 * @param id
	 * @return
	 */
	public JSONArray getGatherAttaList(String id) {
		List<GatherAtta> list = gatherAttaMapper.getGatherAttaList(id);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取附件路径
	 * @param id
	 * @return
	 */
	public String getAttaPath(String id) {
		return gatherAttaMapper.getAttaPath(id);
	}
	
	/**
	 * 删除收款单附件
	 * @param id
	 * @return
	 */
	public boolean deleteGatherAtta(String id) {
		gatherAttaMapper.deleteGatherAtta(id);
		return true;
	}
	
	/**
	 * 获取收款单审批列表
	 * @param param
	 * @return
	 */
	public JSONObject getAuditGather(GatherParam param) {
		List<Gather> list = gatherMapper.getAuditGatherList(param);
		int total = gatherMapper.getTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取收款单历史
	 * @param id
	 * @return
	 */
	public JSONArray getHisGatherList(String id) {
		List<Gather> list = gatherMapper.getHisGatherList(id);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 提交审批信息
	 * @param id
	 * @param option
	 * @param status
	 * @param comment
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status,
			String comment, SysUser user) {
		gatherMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_GATHER);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		return true;
	}
	
	/**
	 * 获取发货订单列表
	 * @param param
	 * @return
	 */
	public JSONObject getShipOrderList(GatherParam param) {
		List<ShipOrder> list = shipmentsMapper.getShipOrderList(param);
		List<Integer> nums = shipmentsMapper.getShipOrderTotal(param);
		int total = nums==null?0:nums.size();
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取订单详细信息及收款情况
	 * @param orderId
	 * @return
	 */
	public JSONObject getGatherOrderById(String orderId) {
		GatherOrder order = gatherMapper.getGatherOrderById(orderId);
		return JSONObject.fromObject(order);
	}
	
	/**
	 * 根据订单获取发货申请单列表
	 * @param orderId
	 * @return
	 */
	public JSONArray getShipmentsByOrderId(String orderId) {
		List<Shipments> list = shipmentsMapper.getShipmentsByOrderId(orderId);
		return JSONArray.fromObject(list);
	}

	/**
	 * 创建发货申请单
	 * @param orderId
	 * @param user
	 * @return
	 */
	public JSONObject createShipment(String orderId, SysUser user) {
		Order order = shipmentsMapper.getOrderById(orderId);
		Shipments ship = new Shipments();
		ship.setOrderId(order.getId());
		ship.setCode(getNextShipCode());
		ship.setApplyUser(user.getId());
		ship.setCreateUser(user.getId());
		ship.setOrderNo(order.getNo());
		ship.setOrderName(order.getName());
		ship.setSignUserName(order.getSignerName());
		ship.setTotal(order.getTotal());
		ship.setSignDate(order.getSignDate());
		ship.setClientName(order.getClientName());
		ship.setPayPlace(order.getPayPlace());
		ship.setPayDate(order.getPayDate());
		ship.setWarningDate(order.getWarrantee());
		shipmentsMapper.saveShipments(ship);
		JSONObject json = JSONObject.fromObject(order);
		json.put("shipCode", ship.getCode());
		json.put("shipmentId", ship.getId());
		return json;
	}
	
	/**
	 * 获取下一个发货申请单编号
	 * @return
	 */
	private String getNextShipCode() {
		Integer nextNo = shipmentsMapper.getNextNo();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String shipmentsNo = "S-" + new SimpleDateFormat("yyyy").format(new Date());
		
		for(int i=noStr.length();i<4;i++){
			shipmentsNo += "0";
		}
		
		shipmentsNo += noStr;
		return shipmentsNo;
	}
	
	/**
	 * 获取发货申请单
	 * @param id
	 * @return
	 */
	public JSONObject getShipmentById(String id) {
		Shipments ship = shipmentsMapper.getShipmentsById(id);
		Shipments ship2 = shipmentsMapper.getGatherTotal(id);
		ship.setOrderTotal(ship2.getOrderTotal());
		ship.setGatherTotal(ship2.getGatherTotal());
		return JSONObject.fromObject(ship);
	}
	
	/**
	 * 更新发货申请单
	 * @param ship
	 * @return
	 */
	public boolean updateShipments(Shipments ship) {
		shipmentsMapper.updateShipments(ship);
		return true;
	}

	/**
	 * 根据订单获取订单明细
	 * @param orderId
	 * @return
	 */
	public JSONArray getOrderDetailByOrderId(String orderId) {
		List<OrderDetail> list = shipmentsMapper.getOrderDetailList(orderId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 保存发货申请单明细
	 * @param detail
	 * @return
	 */
	public boolean saveShipmentsDetail(ShipmentsDetail detail) {
		shipmentsDetailMapper.save(detail);
		return true;
	}
	
	/**
	 * 获取发货申请单明细
	 * @param shipmentsId
	 * @return
	 */
	public JSONArray getShipmentsDetails(String shipmentsId) {
		List<ShipmentsDetail> list = shipmentsDetailMapper.getShipmentsDetails(shipmentsId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	public boolean deleteShipmentsDetail(String id) {
		shipmentsDetailMapper.deleteShipmentsDetail(id);
		return true;
	}
	
	/**
	 * 保存发货申请单附件
	 * @param shipmentsId
	 * @param path
	 * @param name
	 * @return
	 */
	public boolean saveShipmentsAtta(String shipmentsId, String path,
			String name) {
		ShipmentsAtta ship = new ShipmentsAtta();
		ship.setShipmentsId(Integer.parseInt(shipmentsId));
		ship.setFilePath(path);
		ship.setFileName(name);
		shipmentsAttaMapper.save(ship);
		return true;
	}
	
	/**
	 * 获取发货申请单附件列表
	 * @param id
	 * @return
	 */
	public JSONArray getShipmentsAttaList(String id) {
		List<ShipmentsAtta> list = shipmentsAttaMapper.getList(id);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取发货申请单附件路径
	 * @param id
	 * @return
	 */
	public String getShipmentsAttaPath(String id) {
		return shipmentsAttaMapper.getPath(id);
	}
	
	/**
	 * 删除发货申请单附件
	 * @param id
	 * @return
	 */
	public boolean deleteShipmentsAtta(String id) {
		shipmentsAttaMapper.delete(id);
		return true;
	}
	
	/**
	 * 删除发货申请单
	 * @param id
	 * @return
	 */
	public boolean deleteShipments(String id) {
		//删除附件信息
		shipmentsAttaMapper.deleteByShipId(id);
		//删除明细信息
		shipmentsDetailMapper.deleteByShipId(id);
		//删除发货申请单
		shipmentsMapper.delete(id);
		return true;
	}
	
	/**
	 * 提交发货申请单
	 * @param id
	 * @return
	 */
	public boolean submitShipments(String id) {
		shipmentsMapper.submitShipments(id);
		return true;
	}
	
	/**
	 * 获取发货申请单列表
	 * @param param
	 * @return
	 */
	public JSONObject getAuditShipments(GatherParam param) {
		List<Shipments> list = shipmentsMapper.getAuditList(param);
		int total = shipmentsMapper.getAuditTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 提交审批信息
	 * @param id
	 * @param option
	 * @param status
	 * @param comment
	 * @param user
	 * @return
	 */
	public boolean submitShipmentsAudit(String id, String option, int status,
			String comment, SysUser user) {
		shipmentsMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_SHIPMENTS);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		if(status == 30){//审批完成,生成送货单
			Delivery delivery = new Delivery();
			delivery.setCode(getNextDeliveryCode());
			delivery.setShipmentId(Integer.parseInt(id));
			deliveryMapper.save(delivery);
		}
		return true;
	}
	
	/**
	 * 获取下一个发货单编号
	 * @return
	 */
	private String getNextDeliveryCode() {
		Integer nextNo = deliveryMapper.getNextNo();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String deliveryNo = "XSD-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "-";
		
		for(int i=noStr.length();i<3;i++){
			deliveryNo += "0";
		}
		
		deliveryNo += noStr;
		return deliveryNo;
	}
	
	/**
	 * 获取送货单列表
	 * @param param
	 * @return
	 */
	public JSONObject getDeliveryList(GatherParam param) {
		List<Delivery> list = deliveryMapper.getList(param);
		int total = deliveryMapper.getTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 更新送货单
	 * @param delivery
	 * @return
	 */
	public boolean updateDelivery(Delivery delivery) {
		deliveryMapper.update(delivery);
		return true;
	}
	
	/**
	 * 生效送货单
	 * @param id
	 * @return
	 */
	public boolean effectDelivery(String id) {
		deliveryMapper.effectDelivery(id);
		return true;
	}
	
	/**
	 * 新增物流情况
	 * @param logistics
	 * @return
	 */
	public boolean addLogistics(Logistics logistics) {
		logisticsMapper.save(logistics);
		return true;
	}
	
	/**
	 * 获取物流情况列表
	 * @param deliveryId
	 * @return
	 */
	public JSONArray getLogisticsList(String deliveryId) {
		List<Logistics> list = logisticsMapper.getLogisticsList(deliveryId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 订单待收款
	 * @return
	 */
	public int getUnGatherTotal() {
		
		return gatherMapper.getUnGatherTotal();
	}
	
	/**
	 * 收款单被退回
	 * @return
	 */
	public int getBackGatherTotal() {
		
		return gatherMapper.getBackGatherTotal();
	}
	
	/**
	 * 收款单待审批
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditGatherTotal(String seeStatus) {
		return gatherMapper.getUnAuditGatherTotal(seeStatus);
	}
	
	/**
	 * 获取发货申请单被退回总数
	 * @return
	 */
	public int getBackShipmentTotal() {
		
		return shipmentsMapper.getBackShipmentTotal();
	}
	
	/**
	 * 获取待发货总数
	 * @return
	 */
	public int getUnShipmentTotal() {
		
		return shipmentsMapper.getUnShipmentTotal();
	}
	
	/**
	 * 获取待审批总数
	 * @return
	 */
	public int getUnAuditShipmentTotal(String seeStatus) {
		GatherParam param = new GatherParam();
		param.setAuditStatus(0);
		param.setSeeStatus(seeStatus);
		return shipmentsMapper.getAuditTotal(param);
	}
	
	/**
	 * 获取未录入送货单总数
	 * @return
	 */
	public int getUnPayDeliveryTotal() {
		return deliveryMapper.getUnPayTotal();
	}
	
	/**
	 * 根据订单获取收款单列表
	 * @param orderId
	 * @return
	 */
	public JSONArray getGathersByOrder(String orderId) {
		List<Gather> list = gatherMapper.getGathersByOrder(orderId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 根据ID获取送货单基础数据
	 * @param id
	 * @return
	 */
	public Delivery getDeliveryById(String id) {
		return deliveryMapper.getDeliveryById(id);
	}
	
	/**
	 * 根据送货单ID获取送货物品清单
	 * @param id
	 * @return
	 */
	public List<ShipmentsDetail> getShipDetailsByDeliId(String id) {
		return deliveryMapper.getShipDetailsByDeliId(id);
	}
}
