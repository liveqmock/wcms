package com.kiy.wcms.order.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderParam;

public interface OrderMapper {
	/**
	 * 获取订单列表
	 * @param param
	 * @return
	 */
	public List<Order> getOrderList(OrderParam param);

	/**
	 * 获取记录总条数
	 * @param param
	 * @return
	 */
	public int getTotal(OrderParam param);
	/**
	 * 保存订单
	 * @param order
	 */
	public void save(Order order);
	
	/**
	 * 获取订单号下一个流水号
	 * @return
	 */
	public Integer getNextNo();
	
	/**
	 * 更新订单
	 * @param order
	 */
	public void updateOrder(Order order);
	
	/**
	 * 提交订单
	 * @param id
	 */
	public void submitOrder(String id);

	/**
	 * 订单审批
	 * @param params
	 */
	public void auditOrder(Map<String, Object> params);
	/**
	 * 删除订单
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 获取订单审批列表
	 * @param orderParam
	 * @return
	 */
	public List<Order> getAuditList(OrderParam orderParam);
	
	/**
	 * 获取订单审批列表总数
	 * @param orderParam
	 * @return
	 */
	public int getAuditTotal(OrderParam orderParam);
	
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	public int getBackTotal();
}
