package com.kiy.wcms.order.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.order.entity.OrderAtta;

public interface OrderAttaMapper {
	/**
	 * 保存订单附件
	 * @param orderId
	 * @param path
	 */
	public void save(@Param("orderId")String orderId, @Param("path")String path, @Param("fileName")String fileName);
	/**
	 * 获取订单附件列表
	 * @param orderId
	 * @return
	 */
	public List<OrderAtta> getAll(String orderId);
	/**
	 * 删除订单附件
	 * @param attaId
	 */
	public void delete(String attaId);
	/**
	 * 获取订单路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId);
	/**
	 * 删除指定订单的所有附件
	 * @param id
	 */
	public void deleteByOrderId(String id);

}
