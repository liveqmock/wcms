package com.kiy.wcms.gather.mapper;

import java.util.List;

import com.kiy.wcms.gather.entity.Logistics;

public interface LogisticsMapper {
	/**
	 * 保存物流情况
	 * @param logistics
	 */
	public void save(Logistics logistics);
	
	/**
	 * 获取物流情况 
	 * @param deliveryId
	 * @return
	 */
	public List<Logistics> getLogisticsList(String deliveryId);
	
}
