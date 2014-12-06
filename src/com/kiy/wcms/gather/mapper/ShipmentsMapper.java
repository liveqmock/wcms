package com.kiy.wcms.gather.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.gather.entity.GatherParam;
import com.kiy.wcms.gather.entity.ShipOrder;
import com.kiy.wcms.gather.entity.Shipments;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;

public interface ShipmentsMapper {
	
	/**
	 * 获取发货订单列表
	 * @param param
	 * @return
	 */
	public List<ShipOrder> getShipOrderList(GatherParam param);
	
	/**
	 * 获取可发货订单总数
	 * @param param
	 * @return
	 */
	public List<Integer> getShipOrderTotal(GatherParam param);
	
	/**
	 * 根据订单获取发货申请单列表
	 * @param orderId
	 * @return
	 */
	public List<Shipments> getShipmentsByOrderId(String orderId);
	
	/**
	 * 获取下一个号码
	 * @return
	 */
	public Integer getNextNo();
	
	/**
	 * 获取订单信息
	 * @param orderId
	 * @return
	 */
	public Order getOrderById(String orderId);
	
	/**
	 * 保存发货申请单
	 * @param ship
	 */
	public void saveShipments(Shipments ship);
	
	/**
	 * 获取发货申请单信息
	 * @param id
	 * @return
	 */
	public Shipments getShipmentsById(String id);
	
	/**
	 * 更新发货申请单
	 * @param ship
	 */
	public void updateShipments(Shipments ship);
	
	/**
	 * 根据订单获取订单明细
	 * @param orderId
	 * @return
	 */
	public List<OrderDetail> getOrderDetailList(String orderId);
	
	/**
	 * 删除发货申请单
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 提交发货申请单
	 * @param id
	 */
	public void submitShipments(String id);
	
	/**
	 * 获取发货申请单审批列表
	 * @param param
	 * @return
	 */
	public List<Shipments> getAuditList(GatherParam param);
	
	/**
	 * 获取审批列表总数
	 * @param param
	 * @return
	 */
	public int getAuditTotal(GatherParam param);
	
	/**
	 * 提交审批信息
	 * @param id
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取被退回发货申请单总数
	 * @return
	 */
	public int getBackShipmentTotal();
	
	/**
	 * 获取订单待发货总数
	 * @return
	 */
	public int getUnShipmentTotal();
	
	/**
	 * 获取订单收款情况
	 * @param id
	 * @return
	 */
	public Shipments getGatherTotal(String id);

}
