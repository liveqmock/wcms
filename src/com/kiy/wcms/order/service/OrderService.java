package com.kiy.wcms.order.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderAtta;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.order.entity.OrderParam;
import com.kiy.wcms.order.mapper.OrderAttaMapper;
import com.kiy.wcms.order.mapper.OrderDetailMapper;
import com.kiy.wcms.order.mapper.OrderMapper;
import com.kiy.wcms.producplan.mapper.ProducPlanMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("orderService")
public class OrderService {
	@Autowired
	private OrderMapper orderMapper;
	@Autowired
	private OrderAttaMapper orderAttaMapper;
	@Autowired
	private OrderDetailMapper orderDetailMapper;
	@Autowired
	private ProducPlanMapper producPlanMapper;
	@Autowired
	private AuditService auditService;
	
	/**
	 * 获取订单列表
	 * @param param
	 * @return
	 */
	public JSONObject getOrderList(OrderParam param) {
		List<Order> orders = orderMapper.getOrderList(param);
		int total = orderMapper.getTotal(param);
		PageView pageView = new PageView(total, orders);
		return JSONObject.fromObject(pageView);
	}

	/**
	 * 保存订单
	 * @param order
	 * @return
	 */
	public int saveOrder(Order order) {
		String orderNo = getNextNo();
		order.setNo(orderNo);
		orderMapper.save(order);
		return order.getId();
	}
	
	/**
	 * 获取下一个订单流水号
	 * @return
	 */
	private String getNextNo() {
		Integer nextNo = orderMapper.getNextNo();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String orderNo = "W-" + new SimpleDateFormat("yyyy").format(new Date());
		
		for(int i=noStr.length();i<4;i++){
			orderNo += "0";
		}
		
		orderNo += noStr;
		return orderNo;
	}
	
	/**
	 * 更新订单
	 * @param order
	 * @return
	 */
	public boolean updateOrder(Order order) {
		orderMapper.updateOrder(order);
		return true;
	}
	
	/**
	 * 保存订单明细
	 * @param detail
	 * @return
	 */
	public boolean saveOrderDetail(OrderDetail detail) {
		orderDetailMapper.save(detail);
		return true;
	}
	
	/**
	 * 获取订单详情 产品列表
	 * @return
	 */
	public JSONArray getOrderDetailList(String orderId) {
		List<OrderDetail> list = orderDetailMapper.getOrderDetailList(orderId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 删除产品明细
	 * @param detailId
	 * @return
	 */
	public boolean deleteOrderDetail(String detailId) {
		orderDetailMapper.delete(detailId);
		return true;
	}
	
	/**
	 * 更新订单明细
	 * @param orderDetail
	 * @return
	 */
	public boolean updateOrderDetail(OrderDetail orderDetail) {
		orderDetailMapper.update(orderDetail);
		return true;
	}
	
	/**
	 * 保存订单附件
	 * @param orderId
	 * @param path
	 * @return
	 */
	public boolean saveOrderAtta(String orderId, String path, String fileName) {
		orderAttaMapper.save(orderId, path, fileName);
		return true;
	}
	
	/**
	 * 获取订单附件列表
	 * @param orderId
	 * @return
	 */
	public JSONArray getOrderAttaList(String orderId) {
		List<OrderAtta> list = orderAttaMapper.getAll(orderId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 删除订单附件
	 * @param attaId
	 * @return
	 */
	public boolean deleteOrderAtta(String attaId) {
		orderAttaMapper.delete(attaId);
		return true;
	}
	
	/**
	 * 获取订单附件路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId) {
		return orderAttaMapper.getAttaPath(attaId);
	}
	
	/**
	 * 提交订单
	 * @param id
	 * @return
	 */
	public boolean submitOrder(String id) {
		
		orderMapper.submitOrder(id);
		return true;
	}
	
	/**
	 * 删除订单
	 * @param id
	 * @return
	 */
	public boolean deleteOrder(String id) {
		//删除订单明细
		orderDetailMapper.deleteByOrderId(id);
		//上传订单附件
		orderAttaMapper.deleteByOrderId(id);
		//上传订单
		orderMapper.delete(id);
		return true;
	}
	
	/**
	 * 获取订单审批列表
	 * @param orderParam
	 * @param seeStatus
	 * @param auditStatus
	 * @return
	 */
	public JSONObject getOrderAuditList(OrderParam orderParam,
			String seeStatus, Integer auditStatus) {
		orderParam.setSeeStatus(seeStatus);
		orderParam.setAuditStatus(auditStatus);
		List<Order> list = orderMapper.getAuditList(orderParam);
		int total = orderMapper.getAuditTotal(orderParam);
		PageView vew = new PageView(total, list);
		return JSONObject.fromObject(vew);
	}
	
	/**
	 * 获取待审批数量
	 * @return
	 */
	public int getToAuditCount(String seeStatus){
		OrderParam param = new OrderParam();
		param.setSeeStatus(seeStatus);
		param.setAuditStatus(0);
		int total = orderMapper.getAuditTotal(param);
		return total;
	}
	
	/**
	 * 保存审批信息
	 * @param id
	 * @param option
	 * @param status
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status, String comment,
			SysUser user) {
		orderMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_ORDER);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		if(status == 30){//审批通过， 生产生产计划
			producPlanMapper.save(id);
		}
		
		return true;
	}
	
	/**
	 * 获取被退回的订单总数
	 * @return
	 */
	public int getBackTotal() {
		return orderMapper.getBackTotal();
	}
	

}
