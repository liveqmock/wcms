package com.kiy.wcms.order.mapper;

import java.util.List;

import com.kiy.wcms.order.entity.OrderDetail;

public interface OrderDetailMapper {
	/**
	 * 保存订单明细
	 * @param detail
	 */
	public void save(OrderDetail detail);
	
	/**
	 * 获取订单详情 产品清单
	 * @param orderId
	 * @return
	 */
	public List<OrderDetail> getOrderDetailList(String orderId);
	
	/**
	 * 删除订单明细
	 * @param detailId
	 */
	public void delete(String detailId);
	
	/**
	 * 更新订单明细
	 * @param orderDetail
	 */
	public void update(OrderDetail orderDetail);
	
	/**
	 * 删除指定订单的所有明细
	 * @param id
	 */
	public void deleteByOrderId(String id);

}
